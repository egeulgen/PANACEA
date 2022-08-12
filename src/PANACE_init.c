#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME: 
   Check these declarations against the C/Fortran source code.
*/

/* .C calls */
extern void norm_lapl_graph(void *, void *, void *);

static const R_CMethodDef CEntries[] = {
    {"norm_lapl_graph", (DL_FUNC) &norm_lapl_graph, 3},
    {NULL, NULL, 0}
};

void R_init_PANACEA(DllInfo *dll)
{
    R_registerRoutines(dll, CEntries, NULL, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}