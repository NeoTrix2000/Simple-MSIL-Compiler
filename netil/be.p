#ifdef __cplusplus
extern "C" {
#endif

/* Protogen Version 2.1.1.17Friday October 28, 2005  17:44:50 */

                                /* Gen.c */

void compile_start(char *name);
void include_start(char *name, int num);
void flush_peep(SYMBOL *funcsp, QUAD *list);
void precolor(QUAD *head);			/* precolor an instruction */
int preRegAlloc(QUAD *ins, BRIGGS_SET *globals, BRIGGS_SET *eobGlobals, int pass);
int examine_icode(QUAD *head);
void cg_internal_conflict(QUAD *head);
void asm_expressiontag(QUAD *q)               ;
void asm_tag(QUAD *q)               ;
void asm_line(QUAD *q)               ;
void asm_blockstart(QUAD *q)         ;
void asm_blockend(QUAD *q)           ;
void asm_varstart(QUAD *q)           ;
void asm_func(QUAD *q)               ;
void asm_passthrough(QUAD *q)        ;
void asm_datapassthrough(QUAD *q)    ;
void asm_label(QUAD *q)              ;
void asm_goto(QUAD *q)               ;
void asm_gosubprelude(QUAD *q)       ;
void asm_gosub(QUAD *q)              ;
void asm_gosubpostlude(QUAD *q)      ;
void asm_fargosub(QUAD *q)           ;
void asm_trap(QUAD *q)               ;
void asm_int(QUAD *q)                ;
void asm_ret(QUAD *q)                ;
void asm_fret(QUAD *q)                ;
void asm_rett(QUAD *q)               ;
void asm_add(QUAD *q)                ;
void asm_sub(QUAD *q)                ;
void asm_udiv(QUAD *q)               ;
void asm_umod(QUAD *q)               ;
void asm_sdiv(QUAD *q)               ;
void asm_smod(QUAD *q)               ;
void asm_muluh(QUAD *q)               ;
void asm_mulsh(QUAD *q)               ;
void asm_mul(QUAD *q)               ;
void asm_lsl(QUAD *q)                ;
void asm_lsr(QUAD *q)                ;
void asm_asr(QUAD *q)                ;
void asm_neg(QUAD *q)                ;
void asm_not(QUAD *q)                ;
void asm_and(QUAD *q)                ;
void asm_or(QUAD *q)                 ;
void asm_eor(QUAD *q)                ;
void asm_setne(QUAD *q)              ;
void asm_sete(QUAD *q)               ;
void asm_setc(QUAD *q)               ;
void asm_seta(QUAD *q)               ;
void asm_setnc(QUAD *q)              ;
void asm_setbe(QUAD *q)              ;
void asm_setl(QUAD *q)               ;
void asm_setg(QUAD *q)               ;
void asm_setle(QUAD *q)              ;
void asm_setge(QUAD *q)              ;
void asm_assn(QUAD *q)               ;
void asm_genword(QUAD *q)            ;
void asm_coswitch(QUAD *q)           ;
void asm_swbranch(QUAD *q)           ;
void asm_dc(QUAD *q)                 ;
void asm_assnblock(QUAD *q)          ;
void asm_clrblock(QUAD *q)           ;
void asm_jc(QUAD *q)                 ;
void asm_ja(QUAD *q)                 ;
void asm_je(QUAD *q)                 ;
void asm_jnc(QUAD *q)                ;
void asm_jbe(QUAD *q)                ;
void asm_jne(QUAD *q)                ;
void asm_jl(QUAD *q)                 ;
void asm_jg(QUAD *q)                 ;
void asm_jle(QUAD *q)                ;
void asm_jge(QUAD *q)                ;
void asm_parm(QUAD *q)               ;
void asm_parmadj(QUAD *q)            ;
void asm_parmblock(QUAD *q)          ;
void asm_cppini(QUAD *q)             ;
void asm_prologue(QUAD *q)           ;
void asm_epilogue(QUAD *q)           ;
void asm_pushcontext(QUAD *q)        ;
void asm_popcontext(QUAD *q)         ;
void asm_loadcontext(QUAD *q)        ;
void asm_unloadcontext(QUAD *q)        ;
void asm_tryblock(QUAD *q)			 ;
void asm_stackalloc(QUAD *q)         ;
void asm_loadstack(QUAD *q)			;
void asm_savestack(QUAD *q)			;
void asm_blockstart(QUAD *q)         ;
void asm_blockend(QUAD *q)           ;
void asm_seh(QUAD *q);              ;
void asm_functail(QUAD *q, int begin, int size);
void asm_atomic(QUAD *q);
                              /* Invoke.c */

int InsertExternalFile(char *name);
void InsertOutputFileName(char *name);
int RunExternalFiles(char *);

                              /* Outasm.c */

void oa_ini(void);
void oa_nl(void);
void outop(char *name);
void oa_putconst(int sz, EXPRESSION *offset, BOOLEAN doSign);
void oa_putlen(int l);
void putsizedreg(char *string, int reg, int size);
void pointersize(int size);
void putseg(int seg, int usecolon);
int islabeled(EXPRESSION *n);
void oa_gen_strlab(SYMBOL *sp);
void oa_put_label(int lab);
void oa_put_string_label(int lab, int type);
void oa_genfloat(enum e_gt type, FPF *val);
void oa_genstring(LCHAR *str, int len);
void oa_genint(enum e_gt type, LLONG_TYPE val);
void oa_genaddress(ULLONG_TYPE val);
void oa_gensrref(SYMBOL *sp, int val, int type);
void oa_genref(SYMBOL *sp, int offset);
void oa_genlabref(int label, int offset);
void oa_genpcref(SYMBOL *sp, int offset);
void oa_genstorage(int nbytes);
void oa_gen_labref(int n);
void oa_gen_labdifref(int n1, int n2);
void oa_exitseg();
void oa_enterseg();
void oa_gen_virtual(SYMBOL *sp, int data);
void oa_gen_endvirtual(SYMBOL *sp);
void oa_gen_vtt(VTABENTRY *entry, SYMBOL *func);
void oa_gen_vc1(SYMBOL *func);
void oa_gen_importThunk(SYMBOL *func);
void oa_align(int size);
long queue_muldivval(long number);
long queue_floatval(FPF *number, int size);
void dump_muldivval(void);
void dump_browsedata(BROWSEINFO *bri);
void dump_browsefile(BROWSEFILE *brf);
void oa_enter_type(SYMBOL *sp);
void oa_trailer(void);
void oa_adjust_codelab(void *select, int offset);
void oa_globaldef(SYMBOL *sp);
void oa_localdef(SYMBOL *sp);
void oa_localstaticdef(SYMBOL *sp);
void oa_output_alias(char *name, char *alias);
void oa_put_extern(SYMBOL *sp, int code);
void oa_put_impfunc(SYMBOL *sp, char *file);
void oa_put_expfunc(SYMBOL *sp);
void oa_output_includelib(char *name);
void oa_header(char *filename, char *compiler_version);
void oa_end_generation(void);
TYPE *oa_get_boxed(TYPE *);
TYPE *oa_get_unboxed(TYPE *);
BOOLEAN _using_(char *);
void _using_init();
void _add_global_using(char *str);
void _apply_global_using(void);
BOOLEAN msil_managed(SYMBOL *sp);
void msil_create_property(SYMBOL *property, SYMBOL *getter, SYMBOL *setter);
BOOLEAN oa_main_preprocess(void);
void oa_main_postprocess(BOOLEAN errors);
void GetOutputFileName(char *name, char *temp, BOOLEAN obj);
void NextOutputFileName();
void *msil_alloc(size_t size);
char *msil_strdup(char *s);
TYPE * clonetp(TYPE *tp, BOOLEAN shallow);
SYMBOL * clonesp(SYMBOL *sp, BOOLEAN shallow);
void oa_load_funcs(void);
TYPE * LookupGlobalArrayType(char *name);
INITLIST *cloneInitListTypes(INITLIST *in);
#ifdef __cplusplus
}
#endif
