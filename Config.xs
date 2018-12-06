/*
*
* Copyright (c) 2018, cPanel, LLC.
* All rights reserved.
* http://cpanel.net
*
* This is free software; you can redistribute it and/or modify it under the
* same terms as Perl itself.
*
*/

#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>
#include <embed.h>

/* prototypes */
SV* _parse_string(const char *str);


/* functions */
SV* _parse_string(const char *str) {
  char *ptr = (char *) str; /* todo: preserve the const state of the pointer */
  AV   *av;
  char *start_key, *end_key;
  char *start_val, *end_val;

  av = newAV();

  char eol      = '\n';
  char sep      = ':'; /* customize it later */
  char comment  = '#';

  start_key = ptr;
  end_key   = 0;
  start_val = 0;
  end_val   = 0;

  int found_eol = 1;
  int found_comment = 0;
  int found_sep  = 0;


  for ( ; *ptr ; ++ptr ) {
    //PerlIO_printf( PerlIO_stderr(), "# C %c\n", *ptr );
    //printf("# char %c\n", *ptr );

    /* skip all characters in a comment block */
    if ( found_comment ) {
      if ( *ptr == eol )
        found_comment = 0;
      continue;
    }

    if ( found_sep ) {
      if ( *ptr == ' ' || *ptr == '\t' )
        continue;
      found_sep = 0;
      end_val = start_val = ptr;
    }

    /* get to the first valuable char of the line */
    if ( found_eol ) { /* starting a line */
      /* spaces at the beginning of a line */
      if ( *ptr == ' ' || *ptr == '\t' ) {
        continue;
      }
      if ( *ptr == comment ) {
          found_comment = 1;
          continue;
      }
      /* we have a real character to start the line */
      found_eol = 0;
      start_key = ptr;
      end_key   = 0;
    }

    if ( *ptr == sep ) {
        //printf ("# separator key/value\n" );
        if ( !end_key  ) {
          end_key = ptr - 1;
          found_sep = 1;
        }
    } else if ( *ptr == eol ) {
        end_val = ptr - 1;
        found_eol = 1;

        /* check if we got a key */
        if ( end_key > start_key ) {
          /* we got a key */
          av_push(av, newSVpv( start_key, (int) (end_key - start_key) + 1 ));

          /* only add the value if we have a key */
          if ( end_val > start_val ) {
            av_push(av, newSVpv( start_val, (int) (end_val - start_val) + 1 ));
          } else {
            av_push(av, &PL_sv_undef);
          }
        }

        start_key = 0;
    }

  } /* end main for loop for *ptr */

  /* handle the last entry */
  if ( start_key ) {
        end_val = ptr - 1;

        /* check if we got a key */
        if ( end_key > start_key ) {
          /* we got a key */
          av_push(av, newSVpv( start_key, (int) (end_key - start_key) + 1 ));

          /* only add the value if we have a key */
          if ( end_val > start_val ) {
            av_push(av, newSVpv( start_val, (int) (end_val - start_val) + 1 ));
          } else {
            av_push(av, &PL_sv_undef);
          }
        }
  }


  // av_push(av, newSVpv("END",3));
  // av_push(av, newSVpv("END",3));

  return (SV*) (newRV_noinc((SV*) av));
  //return (SV*) sv_2mortal(newRV_noinc((SV*) av));
}


MODULE = Colon__Config       PACKAGE = Colon::Config

SV*
get_basetime()
CODE:
  RETVAL = newSViv(PL_basetime);
OUTPUT:
  RETVAL

SV*
read(content)
  SV *content;
CODE:
  if ( content && SvPOK(content) ) {
    RETVAL = _parse_string( SvPVX_const( content ) );
  } else {
    RETVAL = &PL_sv_undef;
  }
OUTPUT:
  RETVAL