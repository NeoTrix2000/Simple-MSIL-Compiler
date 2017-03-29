#include "compiler.h"
#include "DotNetPELib.h"
#include <string>

using namespace DotNetPELib;

extern "C" PELib *peLib;

struct data
{
    char *name;
    char *dllName;
};
#define HASHLEN 2048
static LIST *_global_using_list;
static char *DIR_SEP = "\\";
extern "C" void _using_init()
{
}
extern "C" BOOLEAN _using_(char *file)
{
    char name[260], *p;
    strcpy(name, file);
    p = strrchr(name, '.');
    if (p && p[1] != '\\')
        *p = 0;
    if (!peLib->LoadAssembly(name))
        return true;
    return !peLib->LoadUnmanaged(file);
}
extern "C" std::string _dll_name(char *name)
{
    return peLib->FindUnmanagedName(name);
}
// usually from the command line
extern "C" void _add_global_using(char *str)
{
    while (*str)
    {
        char buf[260], *q = buf;
        while (*str && *str != ';')
            *q ++ = *str++;
        *q = 0;
        if (*str)
            str++;
        // using standard C allocators since this crosses multiple input files
        LIST *lst = (LIST *)calloc(sizeof(LIST), 1), **find = & _global_using_list;
        lst->data = strdup(buf);
        while (*find)
            find = &(*find)->next;
        (*find) = lst;
    }
}
extern "C" void _apply_global_using(void)
{
    _using_("msvcrt");
    _using_("occmsil");
    LIST *lst = _global_using_list;
    while (lst)
    {
        _using_((char *)lst->data);
        lst = lst->next;
    }
}
extern "C" BOOLEAN msil_managed(SYMBOL *sp)
{
    if (sp->linkage2 == lk_msil_rtl)
        return TRUE;
    return !_dll_name(sp->name).size();
}