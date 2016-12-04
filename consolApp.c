/* Processed by ecpg (4.8.0) */
/* These include files are added by the preprocessor */
#include <ecpglib.h>
#include <ecpgerrno.h>
#include <sqlca.h>
/* End of automatic include section */

#line 1 "consolApp.pgc"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ecpgtype.h>
#include <ecpglib.h>
#include <sqlda.h>
/* exec sql whenever sqlerror  call print_sqlca ( ) ; */
#line 7 "consolApp.pgc"


/* exec sql begin declare section */
 
    
    
    

#line 10 "consolApp.pgc"
 char query [ 1000 ] ;
 
#line 11 "consolApp.pgc"
 const char * target = "201401409@10.100.71.21" ;
 
#line 12 "consolApp.pgc"
 const char * user = "201401409" ;
 
#line 13 "consolApp.pgc"
 const char * password = "201401409" ;
/* exec sql end declare section */
#line 14 "consolApp.pgc"


void print_sqlca()
{
    fprintf(stderr, "==== sqlca ====\n");
    fprintf(stderr, "sqlcode: %ld\n", sqlca.sqlcode);
    fprintf(stderr, "sqlerrm.sqlerrml: %d\n", sqlca.sqlerrm.sqlerrml);
    fprintf(stderr, "sqlerrm.sqlerrmc: %s\n", sqlca.sqlerrm.sqlerrmc);
    fprintf(stderr, "sqlerrd: %ld %ld %ld %ld %ld %ld\n", sqlca.sqlerrd[0],sqlca.sqlerrd[1],sqlca.sqlerrd[2],
                                                          sqlca.sqlerrd[3],sqlca.sqlerrd[4],sqlca.sqlerrd[5]);
    fprintf(stderr, "sqlwarn: %d %d %d %d %d %d %d %d\n", sqlca.sqlwarn[0], sqlca.sqlwarn[1], sqlca.sqlwarn[2],
                                                          sqlca.sqlwarn[3], sqlca.sqlwarn[4], sqlca.sqlwarn[5],
                                                          sqlca.sqlwarn[6], sqlca.sqlwarn[7]);
    fprintf(stderr, "sqlstate: %5s\n", sqlca.sqlstate);
    fprintf(stderr, "===============\n");
}

void ExecuteQuery() 
{ 
//Executes SELECT type of sql statement and displays 
//returned rows one row on a line on "stdout" if no error, 
//otherwise displays error details */ 
    sqlda_t *outdesc = (sqlda_t *) malloc(sizeof(sqlda_t) + sizeof(sqlvar_t)); /* an output descriptor */

    { ECPGprepare(__LINE__, NULL, 0, "query_prep", query);
#line 38 "consolApp.pgc"

if (sqlca.sqlcode < 0) print_sqlca ( );}
#line 38 "consolApp.pgc"

    /* declare mycur cursor for $1 */
#line 39 "consolApp.pgc"

    { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "declare mycur cursor for $1", 
	ECPGt_char_variable,(ECPGprepared_statement(NULL, "query_prep", __LINE__)),(long)1,(long)1,(1)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EOIT, ECPGt_EORT);
#line 40 "consolApp.pgc"

if (sqlca.sqlcode < 0) print_sqlca ( );}
#line 40 "consolApp.pgc"


    { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "fetch from mycur", ECPGt_EOIT, 
	ECPGt_sqlda, &outdesc, 0L, 0L, 0L, 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EORT);
#line 42 "consolApp.pgc"

if (sqlca.sqlcode < 0) print_sqlca ( );}
#line 42 "consolApp.pgc"


    int i;
    printf("   ");
    for (i = 0; i < outdesc->sqld; i++)
    {
        sqlvar_t v = outdesc->sqlvar[i];
        printf("|%-15s ",v.sqlname.data);
    }
    printf("\n");
    int j = 1; 
    while ( sqlca.sqlcode == 0 ) {
  
           printf("%3d",j++);
           for (i = 0; i < outdesc->sqld; i++)
           {
                sqlvar_t v = outdesc->sqlvar[i];
                short sqllen  = v.sqllen;
                if(v.sqltype==ECPGt_int)
                {
                    int intval;
                    memcpy(&intval, v.sqldata, sqllen);
                    printf("|%d ",intval);
                }
                else
                {
                    printf("|%s ",v.sqldata);   
                }
           }
           printf("\n");
        { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "fetch next from mycur", ECPGt_EOIT, 
	ECPGt_sqlda, &outdesc, 0L, 0L, 0L, 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EORT);
#line 72 "consolApp.pgc"

if (sqlca.sqlcode < 0) print_sqlca ( );}
#line 72 "consolApp.pgc"

     }
     
} 
void ExecuteUpdate()
{  
//Executes INSERT/UPDATE/DELETE type of sql statement 
//and displays "successful" on stdout if no error, 
//otherwise displays error details. 
    { ECPGprepare(__LINE__, NULL, 0, "query_prep", query);
#line 81 "consolApp.pgc"

if (sqlca.sqlcode < 0) print_sqlca ( );}
#line 81 "consolApp.pgc"

    { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_execute, "query_prep", ECPGt_EOIT, ECPGt_EORT);
#line 82 "consolApp.pgc"

if (sqlca.sqlcode < 0) print_sqlca ( );}
#line 82 "consolApp.pgc"

    { ECPGtrans(__LINE__, NULL, "commit");
#line 83 "consolApp.pgc"

if (sqlca.sqlcode < 0) print_sqlca ( );}
#line 83 "consolApp.pgc"

    //printf("here\n");
} 
int main()
{
   
    { ECPGconnect(__LINE__, 0, target , user , password , NULL, 0); 
#line 89 "consolApp.pgc"

if (sqlca.sqlcode < 0) print_sqlca ( );}
#line 89 "consolApp.pgc"

    { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "set search_path to event", ECPGt_EOIT, ECPGt_EORT);
#line 90 "consolApp.pgc"

if (sqlca.sqlcode < 0) print_sqlca ( );}
#line 90 "consolApp.pgc"


    printf ("Enter your query : \n");
    scanf("%[^\n]*c",query);

    if(query[0]=='S' || query[0]=='s')
        ExecuteQuery();
    else
        ExecuteUpdate();
    

}
