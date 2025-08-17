%let pgm=utl-avoid-macro-klingon-code-when-quoting-all-comma-separated-words-in-a-sentence;

%stop_submission;

Avoid macro klingon code when quoting all comma separated words in a sentence

Avoid code like this  (8 %s and 7 functions)
%let new=%unquote(%str(%')%qsysfunc(tranwrd(%superq(rep_run),%str(,),','))%str(%'));

PROBLEM: Using macro code create macro variable ans from macro variable rep_run

  %let rep_run=closing run insurance,insurance,secondary closing run insurance,business insurance,RI_BCT;
  OUTPUT
  NEW="CLOSING RUN INSURANCE" , "INSURANCE" , "SECONDARY CLOSING RUN INSURANCE" , "BUSINESS INSURANCE" , "RI_BCT"

TWO SOLUTIONS (More maintainable and flexible code?)

   1 double quote words
   2 single quote words;


github
https://tinyurl.com/37zyndt2
https://github.com/rogerjdeangelis/utl-avoid-macro-klingon-code-when-quoting-all-comma-separated-words-in-a-sentence

communities.sas
https://tinyurl.com/bk3wkr2s
https://communities.sas.com/t5/SAS-Programming/Macro-Variable-values-to-enclose-with-single-quote/m-p/765291#M242390


RELATED REPOS

https://tinyurl.com/jr2r8uuk
https://github.com/rogerjdeangelis/utl-avoid-klingon-code-create-macro-variable-from-string-with-mismatched-quotes-and-many-commas

https://tinyurl.com/4u8vc4hv
https://github.com/rogerjdeangelis/utl-creating-the-quoted-sql-like-clause-with-resolved-embedde-macro-variable-reduce-macro-trigger

Be skeptical (not sure I always deleted persistent macro variables)
https://github.com/rogerjdeangelis/utl-avoiding-klingon-macro-triggers-at-macro-execution-time
https://github.com/rogerjdeangelis/utl-macro-klingon-solution-or-simple-dosubl-you-decide
https://github.com/rogerjdeangelis/utl-using-dosubl-to-avoid-klingon-obsucated-macro-coding
https://github.com/rogerjdeangelis/utl_using_dosubl_to_avoid_klingon_macro_quoting_functions

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/
INPUT
 %let rep_run=closing run insurance,insurance,secondary closing run insurance,business insurance,RI_BCT;

/*       _             _     _                          _
/ |   __| | ___  _   _| |__ | | ___    __ _ _   _  ___ | |_ ___
| |  / _` |/ _ \| | | | `_ \| |/ _ \  / _` | | | |/ _ \| __/ _ \
| | | (_| | (_) | |_| | |_) | |  __/ | (_| | |_| | (_) | ||  __/
|_|  \__,_|\___/ \__,_|_.__/|_|\___|  \__, |\__,_|\___/ \__\___|
                                         |_|
*/

/*--- optional clear macro vars - just for testing and development ---*/
%deletesasmacn;
%symdel new / nowarn;
%arraydelete(_lst);

/*--- process---*/
%array(_lst,values=%qupcase(&rep_run),delim=",")
%let new=%do_over(_lst,phrase="?",between=comma);

/*--- optional cleanup ---*/
%arraydelete(_lst);

%put &=new;

OUTPUT

NEW="CLOSING RUN INSURANCE" , "INSURANCE" , "SECONDARY CLOSING RUN INSURANCE" , "BUSINESS INSURANCE" , "RI_BCT"

/*___        _             _                          _
|___ \   ___(_)_ __   __ _| | ___    __ _ _   _  ___ | |_ ___
  __) | / __| | `_ \ / _` | |/ _ \  / _` | | | |/ _ \| __/ _ \
 / __/  \__ \ | | | | (_| | |  __/ | (_| | |_| | (_) | ||  __/
|_____| |___/_|_| |_|\__, |_|\___|  \__, |\__,_|\___/ \__\___|
                     |___/             |_|
*/

/*--- although longer- I think this is more maintainable  ---*/
/*--- clear macro vars - just for testing and development ---*/
%deletesasmacn;
%symdel new res / nowarn;
%arraydelete(_lst);

%array(_lst,values=%qupcase(&rep_run),delim=",")
%let new=%do_over(_lst,phrase=%str(`?`),between=comma);
%put &=new;

/*--- note the "''" which resolves to one single quote        ---*/
/*--- wanted to limit the number of single quotes in datastep ---*/
%dosubl('
data _null_;
    from_datastep = translate(symget("new"), "''", "`");
    put from_datastep=;
    call symputx("res",from_datastep);
run;
')

/*--- optional cleanup ---*/
%arraydelete(_lst);

%put &=res;

OUTPUT

RES='CLOSING RUN INSURANCE' , 'INSURANCE' , 'SECONDARY CLOSING RUN INSURANCE' , 'BUSINESS INSURANCE' , 'RI_BCT'

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
