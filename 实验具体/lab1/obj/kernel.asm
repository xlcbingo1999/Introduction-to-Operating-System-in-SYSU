
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 40 fd 10 00       	mov    $0x10fd40,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 cb 32 00 00       	call   1032f7 <memset>

    cons_init();                // init the console
  10002c:	e8 32 15 00 00       	call   101563 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 80 34 10 00 	movl   $0x103480,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 9c 34 10 00 	movl   $0x10349c,(%esp)
  100046:	e8 c7 02 00 00       	call   100312 <cprintf>

    print_kerninfo();
  10004b:	e8 f6 07 00 00       	call   100846 <print_kerninfo>

    grade_backtrace();
  100050:	e8 86 00 00 00       	call   1000db <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 e3 28 00 00       	call   10293d <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 47 16 00 00       	call   1016a6 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 99 17 00 00       	call   1017fd <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 ed 0c 00 00       	call   100d56 <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 a6 15 00 00       	call   101614 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10007d:	00 
  10007e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100085:	00 
  100086:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10008d:	e8 f6 0b 00 00       	call   100c88 <mon_backtrace>
}
  100092:	c9                   	leave  
  100093:	c3                   	ret    

00100094 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100094:	55                   	push   %ebp
  100095:	89 e5                	mov    %esp,%ebp
  100097:	53                   	push   %ebx
  100098:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10009b:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  10009e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a1:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000af:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b3:	89 04 24             	mov    %eax,(%esp)
  1000b6:	e8 b5 ff ff ff       	call   100070 <grade_backtrace2>
}
  1000bb:	83 c4 14             	add    $0x14,%esp
  1000be:	5b                   	pop    %ebx
  1000bf:	5d                   	pop    %ebp
  1000c0:	c3                   	ret    

001000c1 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c1:	55                   	push   %ebp
  1000c2:	89 e5                	mov    %esp,%ebp
  1000c4:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1000ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 04 24             	mov    %eax,(%esp)
  1000d4:	e8 bb ff ff ff       	call   100094 <grade_backtrace1>
}
  1000d9:	c9                   	leave  
  1000da:	c3                   	ret    

001000db <grade_backtrace>:

void
grade_backtrace(void) {
  1000db:	55                   	push   %ebp
  1000dc:	89 e5                	mov    %esp,%ebp
  1000de:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e1:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000e6:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000ed:	ff 
  1000ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000f9:	e8 c3 ff ff ff       	call   1000c1 <grade_backtrace0>
}
  1000fe:	c9                   	leave  
  1000ff:	c3                   	ret    

00100100 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100100:	55                   	push   %ebp
  100101:	89 e5                	mov    %esp,%ebp
  100103:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100106:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100109:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10010c:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10010f:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100112:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100116:	0f b7 c0             	movzwl %ax,%eax
  100119:	83 e0 03             	and    $0x3,%eax
  10011c:	89 c2                	mov    %eax,%edx
  10011e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100123:	89 54 24 08          	mov    %edx,0x8(%esp)
  100127:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012b:	c7 04 24 a1 34 10 00 	movl   $0x1034a1,(%esp)
  100132:	e8 db 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100137:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10013b:	0f b7 d0             	movzwl %ax,%edx
  10013e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100143:	89 54 24 08          	mov    %edx,0x8(%esp)
  100147:	89 44 24 04          	mov    %eax,0x4(%esp)
  10014b:	c7 04 24 af 34 10 00 	movl   $0x1034af,(%esp)
  100152:	e8 bb 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100157:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10015b:	0f b7 d0             	movzwl %ax,%edx
  10015e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100163:	89 54 24 08          	mov    %edx,0x8(%esp)
  100167:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016b:	c7 04 24 bd 34 10 00 	movl   $0x1034bd,(%esp)
  100172:	e8 9b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100177:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017b:	0f b7 d0             	movzwl %ax,%edx
  10017e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100183:	89 54 24 08          	mov    %edx,0x8(%esp)
  100187:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018b:	c7 04 24 cb 34 10 00 	movl   $0x1034cb,(%esp)
  100192:	e8 7b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  100197:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019b:	0f b7 d0             	movzwl %ax,%edx
  10019e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ab:	c7 04 24 d9 34 10 00 	movl   $0x1034d9,(%esp)
  1001b2:	e8 5b 01 00 00       	call   100312 <cprintf>
    round ++;
  1001b7:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001bc:	83 c0 01             	add    $0x1,%eax
  1001bf:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c4:	c9                   	leave  
  1001c5:	c3                   	ret    

001001c6 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c6:	55                   	push   %ebp
  1001c7:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001c9:	5d                   	pop    %ebp
  1001ca:	c3                   	ret    

001001cb <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001cb:	55                   	push   %ebp
  1001cc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001ce:	5d                   	pop    %ebp
  1001cf:	c3                   	ret    

001001d0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d0:	55                   	push   %ebp
  1001d1:	89 e5                	mov    %esp,%ebp
  1001d3:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001d6:	e8 25 ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001db:	c7 04 24 e8 34 10 00 	movl   $0x1034e8,(%esp)
  1001e2:	e8 2b 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_user();
  1001e7:	e8 da ff ff ff       	call   1001c6 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ec:	e8 0f ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f1:	c7 04 24 08 35 10 00 	movl   $0x103508,(%esp)
  1001f8:	e8 15 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_kernel();
  1001fd:	e8 c9 ff ff ff       	call   1001cb <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100202:	e8 f9 fe ff ff       	call   100100 <lab1_print_cur_status>
}
  100207:	c9                   	leave  
  100208:	c3                   	ret    

00100209 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100209:	55                   	push   %ebp
  10020a:	89 e5                	mov    %esp,%ebp
  10020c:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10020f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100213:	74 13                	je     100228 <readline+0x1f>
        cprintf("%s", prompt);
  100215:	8b 45 08             	mov    0x8(%ebp),%eax
  100218:	89 44 24 04          	mov    %eax,0x4(%esp)
  10021c:	c7 04 24 27 35 10 00 	movl   $0x103527,(%esp)
  100223:	e8 ea 00 00 00       	call   100312 <cprintf>
    }
    int i = 0, c;
  100228:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10022f:	e8 66 01 00 00       	call   10039a <getchar>
  100234:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100237:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10023b:	79 07                	jns    100244 <readline+0x3b>
            return NULL;
  10023d:	b8 00 00 00 00       	mov    $0x0,%eax
  100242:	eb 79                	jmp    1002bd <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100244:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100248:	7e 28                	jle    100272 <readline+0x69>
  10024a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100251:	7f 1f                	jg     100272 <readline+0x69>
            cputchar(c);
  100253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100256:	89 04 24             	mov    %eax,(%esp)
  100259:	e8 da 00 00 00       	call   100338 <cputchar>
            buf[i ++] = c;
  10025e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100261:	8d 50 01             	lea    0x1(%eax),%edx
  100264:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100267:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10026a:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100270:	eb 46                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100272:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100276:	75 17                	jne    10028f <readline+0x86>
  100278:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10027c:	7e 11                	jle    10028f <readline+0x86>
            cputchar(c);
  10027e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100281:	89 04 24             	mov    %eax,(%esp)
  100284:	e8 af 00 00 00       	call   100338 <cputchar>
            i --;
  100289:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10028d:	eb 29                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  10028f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100293:	74 06                	je     10029b <readline+0x92>
  100295:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100299:	75 1d                	jne    1002b8 <readline+0xaf>
            cputchar(c);
  10029b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10029e:	89 04 24             	mov    %eax,(%esp)
  1002a1:	e8 92 00 00 00       	call   100338 <cputchar>
            buf[i] = '\0';
  1002a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002a9:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002ae:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002b1:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002b6:	eb 05                	jmp    1002bd <readline+0xb4>
        }
    }
  1002b8:	e9 72 ff ff ff       	jmp    10022f <readline+0x26>
}
  1002bd:	c9                   	leave  
  1002be:	c3                   	ret    

001002bf <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002bf:	55                   	push   %ebp
  1002c0:	89 e5                	mov    %esp,%ebp
  1002c2:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 bf 12 00 00       	call   10158f <cons_putc>
    (*cnt) ++;
  1002d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002d3:	8b 00                	mov    (%eax),%eax
  1002d5:	8d 50 01             	lea    0x1(%eax),%edx
  1002d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002db:	89 10                	mov    %edx,(%eax)
}
  1002dd:	c9                   	leave  
  1002de:	c3                   	ret    

001002df <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002df:	55                   	push   %ebp
  1002e0:	89 e5                	mov    %esp,%ebp
  1002e2:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100301:	c7 04 24 bf 02 10 00 	movl   $0x1002bf,(%esp)
  100308:	e8 03 28 00 00       	call   102b10 <vprintfmt>
    return cnt;
  10030d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100310:	c9                   	leave  
  100311:	c3                   	ret    

00100312 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100312:	55                   	push   %ebp
  100313:	89 e5                	mov    %esp,%ebp
  100315:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100318:	8d 45 0c             	lea    0xc(%ebp),%eax
  10031b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10031e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100321:	89 44 24 04          	mov    %eax,0x4(%esp)
  100325:	8b 45 08             	mov    0x8(%ebp),%eax
  100328:	89 04 24             	mov    %eax,(%esp)
  10032b:	e8 af ff ff ff       	call   1002df <vcprintf>
  100330:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100333:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100336:	c9                   	leave  
  100337:	c3                   	ret    

00100338 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100338:	55                   	push   %ebp
  100339:	89 e5                	mov    %esp,%ebp
  10033b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10033e:	8b 45 08             	mov    0x8(%ebp),%eax
  100341:	89 04 24             	mov    %eax,(%esp)
  100344:	e8 46 12 00 00       	call   10158f <cons_putc>
}
  100349:	c9                   	leave  
  10034a:	c3                   	ret    

0010034b <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10034b:	55                   	push   %ebp
  10034c:	89 e5                	mov    %esp,%ebp
  10034e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100351:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100358:	eb 13                	jmp    10036d <cputs+0x22>
        cputch(c, &cnt);
  10035a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10035e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100361:	89 54 24 04          	mov    %edx,0x4(%esp)
  100365:	89 04 24             	mov    %eax,(%esp)
  100368:	e8 52 ff ff ff       	call   1002bf <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10036d:	8b 45 08             	mov    0x8(%ebp),%eax
  100370:	8d 50 01             	lea    0x1(%eax),%edx
  100373:	89 55 08             	mov    %edx,0x8(%ebp)
  100376:	0f b6 00             	movzbl (%eax),%eax
  100379:	88 45 f7             	mov    %al,-0x9(%ebp)
  10037c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100380:	75 d8                	jne    10035a <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100382:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100385:	89 44 24 04          	mov    %eax,0x4(%esp)
  100389:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100390:	e8 2a ff ff ff       	call   1002bf <cputch>
    return cnt;
  100395:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100398:	c9                   	leave  
  100399:	c3                   	ret    

0010039a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10039a:	55                   	push   %ebp
  10039b:	89 e5                	mov    %esp,%ebp
  10039d:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003a0:	e8 13 12 00 00       	call   1015b8 <cons_getc>
  1003a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003ac:	74 f2                	je     1003a0 <getchar+0x6>
        /* do nothing */;
    return c;
  1003ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003b1:	c9                   	leave  
  1003b2:	c3                   	ret    

001003b3 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003b3:	55                   	push   %ebp
  1003b4:	89 e5                	mov    %esp,%ebp
  1003b6:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003bc:	8b 00                	mov    (%eax),%eax
  1003be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1003c4:	8b 00                	mov    (%eax),%eax
  1003c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003d0:	e9 d2 00 00 00       	jmp    1004a7 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003db:	01 d0                	add    %edx,%eax
  1003dd:	89 c2                	mov    %eax,%edx
  1003df:	c1 ea 1f             	shr    $0x1f,%edx
  1003e2:	01 d0                	add    %edx,%eax
  1003e4:	d1 f8                	sar    %eax
  1003e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003ec:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003ef:	eb 04                	jmp    1003f5 <stab_binsearch+0x42>
            m --;
  1003f1:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1003fb:	7c 1f                	jl     10041c <stab_binsearch+0x69>
  1003fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100400:	89 d0                	mov    %edx,%eax
  100402:	01 c0                	add    %eax,%eax
  100404:	01 d0                	add    %edx,%eax
  100406:	c1 e0 02             	shl    $0x2,%eax
  100409:	89 c2                	mov    %eax,%edx
  10040b:	8b 45 08             	mov    0x8(%ebp),%eax
  10040e:	01 d0                	add    %edx,%eax
  100410:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100414:	0f b6 c0             	movzbl %al,%eax
  100417:	3b 45 14             	cmp    0x14(%ebp),%eax
  10041a:	75 d5                	jne    1003f1 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  10041c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10041f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100422:	7d 0b                	jge    10042f <stab_binsearch+0x7c>
            l = true_m + 1;
  100424:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100427:	83 c0 01             	add    $0x1,%eax
  10042a:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10042d:	eb 78                	jmp    1004a7 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10042f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100436:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100439:	89 d0                	mov    %edx,%eax
  10043b:	01 c0                	add    %eax,%eax
  10043d:	01 d0                	add    %edx,%eax
  10043f:	c1 e0 02             	shl    $0x2,%eax
  100442:	89 c2                	mov    %eax,%edx
  100444:	8b 45 08             	mov    0x8(%ebp),%eax
  100447:	01 d0                	add    %edx,%eax
  100449:	8b 40 08             	mov    0x8(%eax),%eax
  10044c:	3b 45 18             	cmp    0x18(%ebp),%eax
  10044f:	73 13                	jae    100464 <stab_binsearch+0xb1>
            *region_left = m;
  100451:	8b 45 0c             	mov    0xc(%ebp),%eax
  100454:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100457:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10045c:	83 c0 01             	add    $0x1,%eax
  10045f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100462:	eb 43                	jmp    1004a7 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100467:	89 d0                	mov    %edx,%eax
  100469:	01 c0                	add    %eax,%eax
  10046b:	01 d0                	add    %edx,%eax
  10046d:	c1 e0 02             	shl    $0x2,%eax
  100470:	89 c2                	mov    %eax,%edx
  100472:	8b 45 08             	mov    0x8(%ebp),%eax
  100475:	01 d0                	add    %edx,%eax
  100477:	8b 40 08             	mov    0x8(%eax),%eax
  10047a:	3b 45 18             	cmp    0x18(%ebp),%eax
  10047d:	76 16                	jbe    100495 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10047f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100482:	8d 50 ff             	lea    -0x1(%eax),%edx
  100485:	8b 45 10             	mov    0x10(%ebp),%eax
  100488:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10048d:	83 e8 01             	sub    $0x1,%eax
  100490:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100493:	eb 12                	jmp    1004a7 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100495:	8b 45 0c             	mov    0xc(%ebp),%eax
  100498:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10049b:	89 10                	mov    %edx,(%eax)
            l = m;
  10049d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004a3:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004ad:	0f 8e 22 ff ff ff    	jle    1003d5 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004b7:	75 0f                	jne    1004c8 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004bc:	8b 00                	mov    (%eax),%eax
  1004be:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c4:	89 10                	mov    %edx,(%eax)
  1004c6:	eb 3f                	jmp    100507 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004c8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004cb:	8b 00                	mov    (%eax),%eax
  1004cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004d0:	eb 04                	jmp    1004d6 <stab_binsearch+0x123>
  1004d2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004d9:	8b 00                	mov    (%eax),%eax
  1004db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004de:	7d 1f                	jge    1004ff <stab_binsearch+0x14c>
  1004e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004e3:	89 d0                	mov    %edx,%eax
  1004e5:	01 c0                	add    %eax,%eax
  1004e7:	01 d0                	add    %edx,%eax
  1004e9:	c1 e0 02             	shl    $0x2,%eax
  1004ec:	89 c2                	mov    %eax,%edx
  1004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f1:	01 d0                	add    %edx,%eax
  1004f3:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f7:	0f b6 c0             	movzbl %al,%eax
  1004fa:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004fd:	75 d3                	jne    1004d2 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100502:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100505:	89 10                	mov    %edx,(%eax)
    }
}
  100507:	c9                   	leave  
  100508:	c3                   	ret    

00100509 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100509:	55                   	push   %ebp
  10050a:	89 e5                	mov    %esp,%ebp
  10050c:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10050f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100512:	c7 00 2c 35 10 00    	movl   $0x10352c,(%eax)
    info->eip_line = 0;
  100518:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100522:	8b 45 0c             	mov    0xc(%ebp),%eax
  100525:	c7 40 08 2c 35 10 00 	movl   $0x10352c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10052c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052f:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100536:	8b 45 0c             	mov    0xc(%ebp),%eax
  100539:	8b 55 08             	mov    0x8(%ebp),%edx
  10053c:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10053f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100542:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100549:	c7 45 f4 8c 3d 10 00 	movl   $0x103d8c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100550:	c7 45 f0 c0 b4 10 00 	movl   $0x10b4c0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100557:	c7 45 ec c1 b4 10 00 	movl   $0x10b4c1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10055e:	c7 45 e8 c5 d4 10 00 	movl   $0x10d4c5,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100565:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100568:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10056b:	76 0d                	jbe    10057a <debuginfo_eip+0x71>
  10056d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100570:	83 e8 01             	sub    $0x1,%eax
  100573:	0f b6 00             	movzbl (%eax),%eax
  100576:	84 c0                	test   %al,%al
  100578:	74 0a                	je     100584 <debuginfo_eip+0x7b>
        return -1;
  10057a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10057f:	e9 c0 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100584:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10058b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100591:	29 c2                	sub    %eax,%edx
  100593:	89 d0                	mov    %edx,%eax
  100595:	c1 f8 02             	sar    $0x2,%eax
  100598:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10059e:	83 e8 01             	sub    $0x1,%eax
  1005a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005ab:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005b2:	00 
  1005b3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c4:	89 04 24             	mov    %eax,(%esp)
  1005c7:	e8 e7 fd ff ff       	call   1003b3 <stab_binsearch>
    if (lfile == 0)
  1005cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005cf:	85 c0                	test   %eax,%eax
  1005d1:	75 0a                	jne    1005dd <debuginfo_eip+0xd4>
        return -1;
  1005d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005d8:	e9 67 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005f0:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1005f7:	00 
  1005f8:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1005fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ff:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100602:	89 44 24 04          	mov    %eax,0x4(%esp)
  100606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100609:	89 04 24             	mov    %eax,(%esp)
  10060c:	e8 a2 fd ff ff       	call   1003b3 <stab_binsearch>

    if (lfun <= rfun) {
  100611:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100614:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100617:	39 c2                	cmp    %eax,%edx
  100619:	7f 7c                	jg     100697 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10061b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10061e:	89 c2                	mov    %eax,%edx
  100620:	89 d0                	mov    %edx,%eax
  100622:	01 c0                	add    %eax,%eax
  100624:	01 d0                	add    %edx,%eax
  100626:	c1 e0 02             	shl    $0x2,%eax
  100629:	89 c2                	mov    %eax,%edx
  10062b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10062e:	01 d0                	add    %edx,%eax
  100630:	8b 10                	mov    (%eax),%edx
  100632:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100638:	29 c1                	sub    %eax,%ecx
  10063a:	89 c8                	mov    %ecx,%eax
  10063c:	39 c2                	cmp    %eax,%edx
  10063e:	73 22                	jae    100662 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100640:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100643:	89 c2                	mov    %eax,%edx
  100645:	89 d0                	mov    %edx,%eax
  100647:	01 c0                	add    %eax,%eax
  100649:	01 d0                	add    %edx,%eax
  10064b:	c1 e0 02             	shl    $0x2,%eax
  10064e:	89 c2                	mov    %eax,%edx
  100650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100653:	01 d0                	add    %edx,%eax
  100655:	8b 10                	mov    (%eax),%edx
  100657:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10065a:	01 c2                	add    %eax,%edx
  10065c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10065f:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100662:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100665:	89 c2                	mov    %eax,%edx
  100667:	89 d0                	mov    %edx,%eax
  100669:	01 c0                	add    %eax,%eax
  10066b:	01 d0                	add    %edx,%eax
  10066d:	c1 e0 02             	shl    $0x2,%eax
  100670:	89 c2                	mov    %eax,%edx
  100672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100675:	01 d0                	add    %edx,%eax
  100677:	8b 50 08             	mov    0x8(%eax),%edx
  10067a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10067d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100680:	8b 45 0c             	mov    0xc(%ebp),%eax
  100683:	8b 40 10             	mov    0x10(%eax),%eax
  100686:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100689:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10068f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100692:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100695:	eb 15                	jmp    1006ac <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100697:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069a:	8b 55 08             	mov    0x8(%ebp),%edx
  10069d:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006af:	8b 40 08             	mov    0x8(%eax),%eax
  1006b2:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006b9:	00 
  1006ba:	89 04 24             	mov    %eax,(%esp)
  1006bd:	e8 a9 2a 00 00       	call   10316b <strfind>
  1006c2:	89 c2                	mov    %eax,%edx
  1006c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c7:	8b 40 08             	mov    0x8(%eax),%eax
  1006ca:	29 c2                	sub    %eax,%edx
  1006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006cf:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006d9:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006e0:	00 
  1006e1:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006e8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f2:	89 04 24             	mov    %eax,(%esp)
  1006f5:	e8 b9 fc ff ff       	call   1003b3 <stab_binsearch>
    if (lline <= rline) {
  1006fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1006fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100700:	39 c2                	cmp    %eax,%edx
  100702:	7f 24                	jg     100728 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100704:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100707:	89 c2                	mov    %eax,%edx
  100709:	89 d0                	mov    %edx,%eax
  10070b:	01 c0                	add    %eax,%eax
  10070d:	01 d0                	add    %edx,%eax
  10070f:	c1 e0 02             	shl    $0x2,%eax
  100712:	89 c2                	mov    %eax,%edx
  100714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100717:	01 d0                	add    %edx,%eax
  100719:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10071d:	0f b7 d0             	movzwl %ax,%edx
  100720:	8b 45 0c             	mov    0xc(%ebp),%eax
  100723:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100726:	eb 13                	jmp    10073b <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10072d:	e9 12 01 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100732:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100735:	83 e8 01             	sub    $0x1,%eax
  100738:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10073b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10073e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100741:	39 c2                	cmp    %eax,%edx
  100743:	7c 56                	jl     10079b <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100745:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100748:	89 c2                	mov    %eax,%edx
  10074a:	89 d0                	mov    %edx,%eax
  10074c:	01 c0                	add    %eax,%eax
  10074e:	01 d0                	add    %edx,%eax
  100750:	c1 e0 02             	shl    $0x2,%eax
  100753:	89 c2                	mov    %eax,%edx
  100755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100758:	01 d0                	add    %edx,%eax
  10075a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10075e:	3c 84                	cmp    $0x84,%al
  100760:	74 39                	je     10079b <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100762:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100765:	89 c2                	mov    %eax,%edx
  100767:	89 d0                	mov    %edx,%eax
  100769:	01 c0                	add    %eax,%eax
  10076b:	01 d0                	add    %edx,%eax
  10076d:	c1 e0 02             	shl    $0x2,%eax
  100770:	89 c2                	mov    %eax,%edx
  100772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100775:	01 d0                	add    %edx,%eax
  100777:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10077b:	3c 64                	cmp    $0x64,%al
  10077d:	75 b3                	jne    100732 <debuginfo_eip+0x229>
  10077f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100782:	89 c2                	mov    %eax,%edx
  100784:	89 d0                	mov    %edx,%eax
  100786:	01 c0                	add    %eax,%eax
  100788:	01 d0                	add    %edx,%eax
  10078a:	c1 e0 02             	shl    $0x2,%eax
  10078d:	89 c2                	mov    %eax,%edx
  10078f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100792:	01 d0                	add    %edx,%eax
  100794:	8b 40 08             	mov    0x8(%eax),%eax
  100797:	85 c0                	test   %eax,%eax
  100799:	74 97                	je     100732 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10079b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10079e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007a1:	39 c2                	cmp    %eax,%edx
  1007a3:	7c 46                	jl     1007eb <debuginfo_eip+0x2e2>
  1007a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007a8:	89 c2                	mov    %eax,%edx
  1007aa:	89 d0                	mov    %edx,%eax
  1007ac:	01 c0                	add    %eax,%eax
  1007ae:	01 d0                	add    %edx,%eax
  1007b0:	c1 e0 02             	shl    $0x2,%eax
  1007b3:	89 c2                	mov    %eax,%edx
  1007b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b8:	01 d0                	add    %edx,%eax
  1007ba:	8b 10                	mov    (%eax),%edx
  1007bc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007c2:	29 c1                	sub    %eax,%ecx
  1007c4:	89 c8                	mov    %ecx,%eax
  1007c6:	39 c2                	cmp    %eax,%edx
  1007c8:	73 21                	jae    1007eb <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007cd:	89 c2                	mov    %eax,%edx
  1007cf:	89 d0                	mov    %edx,%eax
  1007d1:	01 c0                	add    %eax,%eax
  1007d3:	01 d0                	add    %edx,%eax
  1007d5:	c1 e0 02             	shl    $0x2,%eax
  1007d8:	89 c2                	mov    %eax,%edx
  1007da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007dd:	01 d0                	add    %edx,%eax
  1007df:	8b 10                	mov    (%eax),%edx
  1007e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007e4:	01 c2                	add    %eax,%edx
  1007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007f1:	39 c2                	cmp    %eax,%edx
  1007f3:	7d 4a                	jge    10083f <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1007f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007f8:	83 c0 01             	add    $0x1,%eax
  1007fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007fe:	eb 18                	jmp    100818 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100800:	8b 45 0c             	mov    0xc(%ebp),%eax
  100803:	8b 40 14             	mov    0x14(%eax),%eax
  100806:	8d 50 01             	lea    0x1(%eax),%edx
  100809:	8b 45 0c             	mov    0xc(%ebp),%eax
  10080c:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  10080f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100812:	83 c0 01             	add    $0x1,%eax
  100815:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100818:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10081b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10081e:	39 c2                	cmp    %eax,%edx
  100820:	7d 1d                	jge    10083f <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100822:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100825:	89 c2                	mov    %eax,%edx
  100827:	89 d0                	mov    %edx,%eax
  100829:	01 c0                	add    %eax,%eax
  10082b:	01 d0                	add    %edx,%eax
  10082d:	c1 e0 02             	shl    $0x2,%eax
  100830:	89 c2                	mov    %eax,%edx
  100832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100835:	01 d0                	add    %edx,%eax
  100837:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10083b:	3c a0                	cmp    $0xa0,%al
  10083d:	74 c1                	je     100800 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  10083f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100844:	c9                   	leave  
  100845:	c3                   	ret    

00100846 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100846:	55                   	push   %ebp
  100847:	89 e5                	mov    %esp,%ebp
  100849:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10084c:	c7 04 24 36 35 10 00 	movl   $0x103536,(%esp)
  100853:	e8 ba fa ff ff       	call   100312 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100858:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10085f:	00 
  100860:	c7 04 24 4f 35 10 00 	movl   $0x10354f,(%esp)
  100867:	e8 a6 fa ff ff       	call   100312 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10086c:	c7 44 24 04 80 34 10 	movl   $0x103480,0x4(%esp)
  100873:	00 
  100874:	c7 04 24 67 35 10 00 	movl   $0x103567,(%esp)
  10087b:	e8 92 fa ff ff       	call   100312 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100880:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100887:	00 
  100888:	c7 04 24 7f 35 10 00 	movl   $0x10357f,(%esp)
  10088f:	e8 7e fa ff ff       	call   100312 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100894:	c7 44 24 04 40 fd 10 	movl   $0x10fd40,0x4(%esp)
  10089b:	00 
  10089c:	c7 04 24 97 35 10 00 	movl   $0x103597,(%esp)
  1008a3:	e8 6a fa ff ff       	call   100312 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008a8:	b8 40 fd 10 00       	mov    $0x10fd40,%eax
  1008ad:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008b3:	b8 00 00 10 00       	mov    $0x100000,%eax
  1008b8:	29 c2                	sub    %eax,%edx
  1008ba:	89 d0                	mov    %edx,%eax
  1008bc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008c2:	85 c0                	test   %eax,%eax
  1008c4:	0f 48 c2             	cmovs  %edx,%eax
  1008c7:	c1 f8 0a             	sar    $0xa,%eax
  1008ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ce:	c7 04 24 b0 35 10 00 	movl   $0x1035b0,(%esp)
  1008d5:	e8 38 fa ff ff       	call   100312 <cprintf>
}
  1008da:	c9                   	leave  
  1008db:	c3                   	ret    

001008dc <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008dc:	55                   	push   %ebp
  1008dd:	89 e5                	mov    %esp,%ebp
  1008df:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008e5:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1008ef:	89 04 24             	mov    %eax,(%esp)
  1008f2:	e8 12 fc ff ff       	call   100509 <debuginfo_eip>
  1008f7:	85 c0                	test   %eax,%eax
  1008f9:	74 15                	je     100910 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1008fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100902:	c7 04 24 da 35 10 00 	movl   $0x1035da,(%esp)
  100909:	e8 04 fa ff ff       	call   100312 <cprintf>
  10090e:	eb 6d                	jmp    10097d <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100917:	eb 1c                	jmp    100935 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100919:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10091c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10091f:	01 d0                	add    %edx,%eax
  100921:	0f b6 00             	movzbl (%eax),%eax
  100924:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10092a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10092d:	01 ca                	add    %ecx,%edx
  10092f:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100931:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100935:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100938:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10093b:	7f dc                	jg     100919 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  10093d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100946:	01 d0                	add    %edx,%eax
  100948:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  10094b:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10094e:	8b 55 08             	mov    0x8(%ebp),%edx
  100951:	89 d1                	mov    %edx,%ecx
  100953:	29 c1                	sub    %eax,%ecx
  100955:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100958:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10095b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10095f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100965:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100969:	89 54 24 08          	mov    %edx,0x8(%esp)
  10096d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100971:	c7 04 24 f6 35 10 00 	movl   $0x1035f6,(%esp)
  100978:	e8 95 f9 ff ff       	call   100312 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  10097d:	c9                   	leave  
  10097e:	c3                   	ret    

0010097f <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10097f:	55                   	push   %ebp
  100980:	89 e5                	mov    %esp,%ebp
  100982:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100985:	8b 45 04             	mov    0x4(%ebp),%eax
  100988:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  10098b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10098e:	c9                   	leave  
  10098f:	c3                   	ret    

00100990 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100990:	55                   	push   %ebp
  100991:	89 e5                	mov    %esp,%ebp
  100993:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100996:	89 e8                	mov    %ebp,%eax
  100998:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  10099b:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp;
	uint32_t eip;
	ebp = read_ebp();
  10099e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	eip = read_eip();
  1009a1:	e8 d9 ff ff ff       	call   10097f <read_eip>
  1009a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i;
	int j;
	for(i = 0; i < STACKFRAME_DEPTH && ebp ; ++i){
  1009a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009b0:	e9 86 00 00 00       	jmp    100a3b <print_stackframe+0xab>
		cprintf("ebp:0x%08x eip:0x%08x args:",ebp,eip);
  1009b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009c3:	c7 04 24 08 36 10 00 	movl   $0x103608,(%esp)
  1009ca:	e8 43 f9 ff ff       	call   100312 <cprintf>
		uint32_t *ebp_pointer = (uint32_t*)ebp;
  1009cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for(j = 0; j < 4; ++j){
  1009d5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1009dc:	eb 28                	jmp    100a06 <print_stackframe+0x76>
			cprintf("0x%08x ",ebp_pointer[j+2]);
  1009de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009e1:	83 c0 02             	add    $0x2,%eax
  1009e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1009eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1009ee:	01 d0                	add    %edx,%eax
  1009f0:	8b 00                	mov    (%eax),%eax
  1009f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f6:	c7 04 24 24 36 10 00 	movl   $0x103624,(%esp)
  1009fd:	e8 10 f9 ff ff       	call   100312 <cprintf>
	int i;
	int j;
	for(i = 0; i < STACKFRAME_DEPTH && ebp ; ++i){
		cprintf("ebp:0x%08x eip:0x%08x args:",ebp,eip);
		uint32_t *ebp_pointer = (uint32_t*)ebp;
		for(j = 0; j < 4; ++j){
  100a02:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a06:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a0a:	7e d2                	jle    1009de <print_stackframe+0x4e>
			cprintf("0x%08x ",ebp_pointer[j+2]);
		}
		cprintf("\n");
  100a0c:	c7 04 24 2c 36 10 00 	movl   $0x10362c,(%esp)
  100a13:	e8 fa f8 ff ff       	call   100312 <cprintf>
		print_debuginfo(eip-1);
  100a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a1b:	83 e8 01             	sub    $0x1,%eax
  100a1e:	89 04 24             	mov    %eax,(%esp)
  100a21:	e8 b6 fe ff ff       	call   1008dc <print_debuginfo>
		eip = ebp_pointer[1];
  100a26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a29:	8b 40 04             	mov    0x4(%eax),%eax
  100a2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = ebp_pointer[0];
  100a2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a32:	8b 00                	mov    (%eax),%eax
  100a34:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip;
	ebp = read_ebp();
	eip = read_eip();
	int i;
	int j;
	for(i = 0; i < STACKFRAME_DEPTH && ebp ; ++i){
  100a37:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a3b:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a3f:	7f 0a                	jg     100a4b <print_stackframe+0xbb>
  100a41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a45:	0f 85 6a ff ff ff    	jne    1009b5 <print_stackframe+0x25>
		cprintf("\n");
		print_debuginfo(eip-1);
		eip = ebp_pointer[1];
		ebp = ebp_pointer[0];
	}
}
  100a4b:	c9                   	leave  
  100a4c:	c3                   	ret    

00100a4d <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a4d:	55                   	push   %ebp
  100a4e:	89 e5                	mov    %esp,%ebp
  100a50:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a5a:	eb 0c                	jmp    100a68 <parse+0x1b>
            *buf ++ = '\0';
  100a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  100a5f:	8d 50 01             	lea    0x1(%eax),%edx
  100a62:	89 55 08             	mov    %edx,0x8(%ebp)
  100a65:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a68:	8b 45 08             	mov    0x8(%ebp),%eax
  100a6b:	0f b6 00             	movzbl (%eax),%eax
  100a6e:	84 c0                	test   %al,%al
  100a70:	74 1d                	je     100a8f <parse+0x42>
  100a72:	8b 45 08             	mov    0x8(%ebp),%eax
  100a75:	0f b6 00             	movzbl (%eax),%eax
  100a78:	0f be c0             	movsbl %al,%eax
  100a7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a7f:	c7 04 24 b0 36 10 00 	movl   $0x1036b0,(%esp)
  100a86:	e8 ad 26 00 00       	call   103138 <strchr>
  100a8b:	85 c0                	test   %eax,%eax
  100a8d:	75 cd                	jne    100a5c <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  100a92:	0f b6 00             	movzbl (%eax),%eax
  100a95:	84 c0                	test   %al,%al
  100a97:	75 02                	jne    100a9b <parse+0x4e>
            break;
  100a99:	eb 67                	jmp    100b02 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100a9b:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100a9f:	75 14                	jne    100ab5 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100aa1:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100aa8:	00 
  100aa9:	c7 04 24 b5 36 10 00 	movl   $0x1036b5,(%esp)
  100ab0:	e8 5d f8 ff ff       	call   100312 <cprintf>
        }
        argv[argc ++] = buf;
  100ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ab8:	8d 50 01             	lea    0x1(%eax),%edx
  100abb:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100abe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ac5:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ac8:	01 c2                	add    %eax,%edx
  100aca:	8b 45 08             	mov    0x8(%ebp),%eax
  100acd:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100acf:	eb 04                	jmp    100ad5 <parse+0x88>
            buf ++;
  100ad1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  100ad8:	0f b6 00             	movzbl (%eax),%eax
  100adb:	84 c0                	test   %al,%al
  100add:	74 1d                	je     100afc <parse+0xaf>
  100adf:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae2:	0f b6 00             	movzbl (%eax),%eax
  100ae5:	0f be c0             	movsbl %al,%eax
  100ae8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aec:	c7 04 24 b0 36 10 00 	movl   $0x1036b0,(%esp)
  100af3:	e8 40 26 00 00       	call   103138 <strchr>
  100af8:	85 c0                	test   %eax,%eax
  100afa:	74 d5                	je     100ad1 <parse+0x84>
            buf ++;
        }
    }
  100afc:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100afd:	e9 66 ff ff ff       	jmp    100a68 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b05:	c9                   	leave  
  100b06:	c3                   	ret    

00100b07 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b07:	55                   	push   %ebp
  100b08:	89 e5                	mov    %esp,%ebp
  100b0a:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b0d:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b10:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b14:	8b 45 08             	mov    0x8(%ebp),%eax
  100b17:	89 04 24             	mov    %eax,(%esp)
  100b1a:	e8 2e ff ff ff       	call   100a4d <parse>
  100b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b22:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b26:	75 0a                	jne    100b32 <runcmd+0x2b>
        return 0;
  100b28:	b8 00 00 00 00       	mov    $0x0,%eax
  100b2d:	e9 85 00 00 00       	jmp    100bb7 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b39:	eb 5c                	jmp    100b97 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b3b:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b41:	89 d0                	mov    %edx,%eax
  100b43:	01 c0                	add    %eax,%eax
  100b45:	01 d0                	add    %edx,%eax
  100b47:	c1 e0 02             	shl    $0x2,%eax
  100b4a:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b4f:	8b 00                	mov    (%eax),%eax
  100b51:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b55:	89 04 24             	mov    %eax,(%esp)
  100b58:	e8 3c 25 00 00       	call   103099 <strcmp>
  100b5d:	85 c0                	test   %eax,%eax
  100b5f:	75 32                	jne    100b93 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b64:	89 d0                	mov    %edx,%eax
  100b66:	01 c0                	add    %eax,%eax
  100b68:	01 d0                	add    %edx,%eax
  100b6a:	c1 e0 02             	shl    $0x2,%eax
  100b6d:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b72:	8b 40 08             	mov    0x8(%eax),%eax
  100b75:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b78:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100b7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  100b7e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b82:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100b85:	83 c2 04             	add    $0x4,%edx
  100b88:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b8c:	89 0c 24             	mov    %ecx,(%esp)
  100b8f:	ff d0                	call   *%eax
  100b91:	eb 24                	jmp    100bb7 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b93:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b9a:	83 f8 02             	cmp    $0x2,%eax
  100b9d:	76 9c                	jbe    100b3b <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100b9f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100ba2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ba6:	c7 04 24 d3 36 10 00 	movl   $0x1036d3,(%esp)
  100bad:	e8 60 f7 ff ff       	call   100312 <cprintf>
    return 0;
  100bb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bb7:	c9                   	leave  
  100bb8:	c3                   	ret    

00100bb9 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bb9:	55                   	push   %ebp
  100bba:	89 e5                	mov    %esp,%ebp
  100bbc:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bbf:	c7 04 24 ec 36 10 00 	movl   $0x1036ec,(%esp)
  100bc6:	e8 47 f7 ff ff       	call   100312 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bcb:	c7 04 24 14 37 10 00 	movl   $0x103714,(%esp)
  100bd2:	e8 3b f7 ff ff       	call   100312 <cprintf>

    if (tf != NULL) {
  100bd7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bdb:	74 0b                	je     100be8 <kmonitor+0x2f>
        print_trapframe(tf);
  100bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  100be0:	89 04 24             	mov    %eax,(%esp)
  100be3:	e8 cd 0d 00 00       	call   1019b5 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100be8:	c7 04 24 39 37 10 00 	movl   $0x103739,(%esp)
  100bef:	e8 15 f6 ff ff       	call   100209 <readline>
  100bf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100bf7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100bfb:	74 18                	je     100c15 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  100c00:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c07:	89 04 24             	mov    %eax,(%esp)
  100c0a:	e8 f8 fe ff ff       	call   100b07 <runcmd>
  100c0f:	85 c0                	test   %eax,%eax
  100c11:	79 02                	jns    100c15 <kmonitor+0x5c>
                break;
  100c13:	eb 02                	jmp    100c17 <kmonitor+0x5e>
            }
        }
    }
  100c15:	eb d1                	jmp    100be8 <kmonitor+0x2f>
}
  100c17:	c9                   	leave  
  100c18:	c3                   	ret    

00100c19 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c19:	55                   	push   %ebp
  100c1a:	89 e5                	mov    %esp,%ebp
  100c1c:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c26:	eb 3f                	jmp    100c67 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c2b:	89 d0                	mov    %edx,%eax
  100c2d:	01 c0                	add    %eax,%eax
  100c2f:	01 d0                	add    %edx,%eax
  100c31:	c1 e0 02             	shl    $0x2,%eax
  100c34:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c39:	8b 48 04             	mov    0x4(%eax),%ecx
  100c3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c3f:	89 d0                	mov    %edx,%eax
  100c41:	01 c0                	add    %eax,%eax
  100c43:	01 d0                	add    %edx,%eax
  100c45:	c1 e0 02             	shl    $0x2,%eax
  100c48:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c4d:	8b 00                	mov    (%eax),%eax
  100c4f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c53:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c57:	c7 04 24 3d 37 10 00 	movl   $0x10373d,(%esp)
  100c5e:	e8 af f6 ff ff       	call   100312 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c63:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c6a:	83 f8 02             	cmp    $0x2,%eax
  100c6d:	76 b9                	jbe    100c28 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c74:	c9                   	leave  
  100c75:	c3                   	ret    

00100c76 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c76:	55                   	push   %ebp
  100c77:	89 e5                	mov    %esp,%ebp
  100c79:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c7c:	e8 c5 fb ff ff       	call   100846 <print_kerninfo>
    return 0;
  100c81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c86:	c9                   	leave  
  100c87:	c3                   	ret    

00100c88 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c88:	55                   	push   %ebp
  100c89:	89 e5                	mov    %esp,%ebp
  100c8b:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c8e:	e8 fd fc ff ff       	call   100990 <print_stackframe>
    return 0;
  100c93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c98:	c9                   	leave  
  100c99:	c3                   	ret    

00100c9a <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100c9a:	55                   	push   %ebp
  100c9b:	89 e5                	mov    %esp,%ebp
  100c9d:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100ca0:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100ca5:	85 c0                	test   %eax,%eax
  100ca7:	74 02                	je     100cab <__panic+0x11>
        goto panic_dead;
  100ca9:	eb 48                	jmp    100cf3 <__panic+0x59>
    }
    is_panic = 1;
  100cab:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100cb2:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cb5:	8d 45 14             	lea    0x14(%ebp),%eax
  100cb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cbe:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  100cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cc9:	c7 04 24 46 37 10 00 	movl   $0x103746,(%esp)
  100cd0:	e8 3d f6 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cdc:	8b 45 10             	mov    0x10(%ebp),%eax
  100cdf:	89 04 24             	mov    %eax,(%esp)
  100ce2:	e8 f8 f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100ce7:	c7 04 24 62 37 10 00 	movl   $0x103762,(%esp)
  100cee:	e8 1f f6 ff ff       	call   100312 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100cf3:	e8 22 09 00 00       	call   10161a <intr_disable>
    while (1) {
        kmonitor(NULL);
  100cf8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100cff:	e8 b5 fe ff ff       	call   100bb9 <kmonitor>
    }
  100d04:	eb f2                	jmp    100cf8 <__panic+0x5e>

00100d06 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d06:	55                   	push   %ebp
  100d07:	89 e5                	mov    %esp,%ebp
  100d09:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d0c:	8d 45 14             	lea    0x14(%ebp),%eax
  100d0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d12:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d15:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d19:	8b 45 08             	mov    0x8(%ebp),%eax
  100d1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d20:	c7 04 24 64 37 10 00 	movl   $0x103764,(%esp)
  100d27:	e8 e6 f5 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d33:	8b 45 10             	mov    0x10(%ebp),%eax
  100d36:	89 04 24             	mov    %eax,(%esp)
  100d39:	e8 a1 f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100d3e:	c7 04 24 62 37 10 00 	movl   $0x103762,(%esp)
  100d45:	e8 c8 f5 ff ff       	call   100312 <cprintf>
    va_end(ap);
}
  100d4a:	c9                   	leave  
  100d4b:	c3                   	ret    

00100d4c <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d4c:	55                   	push   %ebp
  100d4d:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d4f:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d54:	5d                   	pop    %ebp
  100d55:	c3                   	ret    

00100d56 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d56:	55                   	push   %ebp
  100d57:	89 e5                	mov    %esp,%ebp
  100d59:	83 ec 28             	sub    $0x28,%esp
  100d5c:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d62:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d66:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d6a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d6e:	ee                   	out    %al,(%dx)
  100d6f:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d75:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d79:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d7d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d81:	ee                   	out    %al,(%dx)
  100d82:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100d88:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100d8c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d90:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d94:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d95:	c7 05 28 f9 10 00 00 	movl   $0x0,0x10f928
  100d9c:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d9f:	c7 04 24 82 37 10 00 	movl   $0x103782,(%esp)
  100da6:	e8 67 f5 ff ff       	call   100312 <cprintf>
    pic_enable(IRQ_TIMER);
  100dab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100db2:	e8 c1 08 00 00       	call   101678 <pic_enable>
}
  100db7:	c9                   	leave  
  100db8:	c3                   	ret    

00100db9 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100db9:	55                   	push   %ebp
  100dba:	89 e5                	mov    %esp,%ebp
  100dbc:	83 ec 10             	sub    $0x10,%esp
  100dbf:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dc5:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dc9:	89 c2                	mov    %eax,%edx
  100dcb:	ec                   	in     (%dx),%al
  100dcc:	88 45 fd             	mov    %al,-0x3(%ebp)
  100dcf:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dd5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dd9:	89 c2                	mov    %eax,%edx
  100ddb:	ec                   	in     (%dx),%al
  100ddc:	88 45 f9             	mov    %al,-0x7(%ebp)
  100ddf:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100de5:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100de9:	89 c2                	mov    %eax,%edx
  100deb:	ec                   	in     (%dx),%al
  100dec:	88 45 f5             	mov    %al,-0xb(%ebp)
  100def:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100df5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100df9:	89 c2                	mov    %eax,%edx
  100dfb:	ec                   	in     (%dx),%al
  100dfc:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100dff:	c9                   	leave  
  100e00:	c3                   	ret    

00100e01 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e01:	55                   	push   %ebp
  100e02:	89 e5                	mov    %esp,%ebp
  100e04:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  100e07:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e11:	0f b7 00             	movzwl (%eax),%eax
  100e14:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e1b:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e23:	0f b7 00             	movzwl (%eax),%eax
  100e26:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e2a:	74 12                	je     100e3e <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;
  100e2c:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e33:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e3a:	b4 03 
  100e3c:	eb 13                	jmp    100e51 <cga_init+0x50>
    } else {
        *cp = was;
  100e3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e41:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e45:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e48:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e4f:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e51:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e58:	0f b7 c0             	movzwl %ax,%eax
  100e5b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e5f:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e63:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e67:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e6b:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100e6c:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e73:	83 c0 01             	add    $0x1,%eax
  100e76:	0f b7 c0             	movzwl %ax,%eax
  100e79:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e7d:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e81:	89 c2                	mov    %eax,%edx
  100e83:	ec                   	in     (%dx),%al
  100e84:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e87:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e8b:	0f b6 c0             	movzbl %al,%eax
  100e8e:	c1 e0 08             	shl    $0x8,%eax
  100e91:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e94:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e9b:	0f b7 c0             	movzwl %ax,%eax
  100e9e:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100ea2:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ea6:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100eaa:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100eae:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100eaf:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eb6:	83 c0 01             	add    $0x1,%eax
  100eb9:	0f b7 c0             	movzwl %ax,%eax
  100ebc:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ec0:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100ec4:	89 c2                	mov    %eax,%edx
  100ec6:	ec                   	in     (%dx),%al
  100ec7:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100eca:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ece:	0f b6 c0             	movzbl %al,%eax
  100ed1:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100ed4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ed7:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;
  100edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100edf:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ee5:	c9                   	leave  
  100ee6:	c3                   	ret    

00100ee7 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ee7:	55                   	push   %ebp
  100ee8:	89 e5                	mov    %esp,%ebp
  100eea:	83 ec 48             	sub    $0x48,%esp
  100eed:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100ef3:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ef7:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100efb:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100eff:	ee                   	out    %al,(%dx)
  100f00:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f06:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f0a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f0e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f12:	ee                   	out    %al,(%dx)
  100f13:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f19:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f1d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f21:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f25:	ee                   	out    %al,(%dx)
  100f26:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f2c:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f30:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f34:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f38:	ee                   	out    %al,(%dx)
  100f39:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f3f:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f43:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f47:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f4b:	ee                   	out    %al,(%dx)
  100f4c:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f52:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f56:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f5a:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f5e:	ee                   	out    %al,(%dx)
  100f5f:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f65:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f69:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f6d:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f71:	ee                   	out    %al,(%dx)
  100f72:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f78:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f7c:	89 c2                	mov    %eax,%edx
  100f7e:	ec                   	in     (%dx),%al
  100f7f:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f82:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f86:	3c ff                	cmp    $0xff,%al
  100f88:	0f 95 c0             	setne  %al
  100f8b:	0f b6 c0             	movzbl %al,%eax
  100f8e:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f93:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f99:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100f9d:	89 c2                	mov    %eax,%edx
  100f9f:	ec                   	in     (%dx),%al
  100fa0:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100fa3:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100fa9:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100fad:	89 c2                	mov    %eax,%edx
  100faf:	ec                   	in     (%dx),%al
  100fb0:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fb3:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fb8:	85 c0                	test   %eax,%eax
  100fba:	74 0c                	je     100fc8 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fbc:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fc3:	e8 b0 06 00 00       	call   101678 <pic_enable>
    }
}
  100fc8:	c9                   	leave  
  100fc9:	c3                   	ret    

00100fca <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fca:	55                   	push   %ebp
  100fcb:	89 e5                	mov    %esp,%ebp
  100fcd:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fd0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fd7:	eb 09                	jmp    100fe2 <lpt_putc_sub+0x18>
        delay();
  100fd9:	e8 db fd ff ff       	call   100db9 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fde:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fe2:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fe8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fec:	89 c2                	mov    %eax,%edx
  100fee:	ec                   	in     (%dx),%al
  100fef:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100ff2:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100ff6:	84 c0                	test   %al,%al
  100ff8:	78 09                	js     101003 <lpt_putc_sub+0x39>
  100ffa:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101001:	7e d6                	jle    100fd9 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101003:	8b 45 08             	mov    0x8(%ebp),%eax
  101006:	0f b6 c0             	movzbl %al,%eax
  101009:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  10100f:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101012:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101016:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10101a:	ee                   	out    %al,(%dx)
  10101b:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101021:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101025:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101029:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10102d:	ee                   	out    %al,(%dx)
  10102e:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101034:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  101038:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10103c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101040:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101041:	c9                   	leave  
  101042:	c3                   	ret    

00101043 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101043:	55                   	push   %ebp
  101044:	89 e5                	mov    %esp,%ebp
  101046:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101049:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10104d:	74 0d                	je     10105c <lpt_putc+0x19>
        lpt_putc_sub(c);
  10104f:	8b 45 08             	mov    0x8(%ebp),%eax
  101052:	89 04 24             	mov    %eax,(%esp)
  101055:	e8 70 ff ff ff       	call   100fca <lpt_putc_sub>
  10105a:	eb 24                	jmp    101080 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  10105c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101063:	e8 62 ff ff ff       	call   100fca <lpt_putc_sub>
        lpt_putc_sub(' ');
  101068:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10106f:	e8 56 ff ff ff       	call   100fca <lpt_putc_sub>
        lpt_putc_sub('\b');
  101074:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10107b:	e8 4a ff ff ff       	call   100fca <lpt_putc_sub>
    }
}
  101080:	c9                   	leave  
  101081:	c3                   	ret    

00101082 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101082:	55                   	push   %ebp
  101083:	89 e5                	mov    %esp,%ebp
  101085:	53                   	push   %ebx
  101086:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101089:	8b 45 08             	mov    0x8(%ebp),%eax
  10108c:	b0 00                	mov    $0x0,%al
  10108e:	85 c0                	test   %eax,%eax
  101090:	75 07                	jne    101099 <cga_putc+0x17>
        c |= 0x0700;
  101092:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101099:	8b 45 08             	mov    0x8(%ebp),%eax
  10109c:	0f b6 c0             	movzbl %al,%eax
  10109f:	83 f8 0a             	cmp    $0xa,%eax
  1010a2:	74 4c                	je     1010f0 <cga_putc+0x6e>
  1010a4:	83 f8 0d             	cmp    $0xd,%eax
  1010a7:	74 57                	je     101100 <cga_putc+0x7e>
  1010a9:	83 f8 08             	cmp    $0x8,%eax
  1010ac:	0f 85 88 00 00 00    	jne    10113a <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010b2:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010b9:	66 85 c0             	test   %ax,%ax
  1010bc:	74 30                	je     1010ee <cga_putc+0x6c>
            crt_pos --;
  1010be:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010c5:	83 e8 01             	sub    $0x1,%eax
  1010c8:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010ce:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010d3:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010da:	0f b7 d2             	movzwl %dx,%edx
  1010dd:	01 d2                	add    %edx,%edx
  1010df:	01 c2                	add    %eax,%edx
  1010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1010e4:	b0 00                	mov    $0x0,%al
  1010e6:	83 c8 20             	or     $0x20,%eax
  1010e9:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1010ec:	eb 72                	jmp    101160 <cga_putc+0xde>
  1010ee:	eb 70                	jmp    101160 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  1010f0:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010f7:	83 c0 50             	add    $0x50,%eax
  1010fa:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101100:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101107:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  10110e:	0f b7 c1             	movzwl %cx,%eax
  101111:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101117:	c1 e8 10             	shr    $0x10,%eax
  10111a:	89 c2                	mov    %eax,%edx
  10111c:	66 c1 ea 06          	shr    $0x6,%dx
  101120:	89 d0                	mov    %edx,%eax
  101122:	c1 e0 02             	shl    $0x2,%eax
  101125:	01 d0                	add    %edx,%eax
  101127:	c1 e0 04             	shl    $0x4,%eax
  10112a:	29 c1                	sub    %eax,%ecx
  10112c:	89 ca                	mov    %ecx,%edx
  10112e:	89 d8                	mov    %ebx,%eax
  101130:	29 d0                	sub    %edx,%eax
  101132:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101138:	eb 26                	jmp    101160 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10113a:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101140:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101147:	8d 50 01             	lea    0x1(%eax),%edx
  10114a:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101151:	0f b7 c0             	movzwl %ax,%eax
  101154:	01 c0                	add    %eax,%eax
  101156:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101159:	8b 45 08             	mov    0x8(%ebp),%eax
  10115c:	66 89 02             	mov    %ax,(%edx)
        break;
  10115f:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101160:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101167:	66 3d cf 07          	cmp    $0x7cf,%ax
  10116b:	76 5b                	jbe    1011c8 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10116d:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101172:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101178:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10117d:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101184:	00 
  101185:	89 54 24 04          	mov    %edx,0x4(%esp)
  101189:	89 04 24             	mov    %eax,(%esp)
  10118c:	e8 a5 21 00 00       	call   103336 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101191:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101198:	eb 15                	jmp    1011af <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  10119a:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10119f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011a2:	01 d2                	add    %edx,%edx
  1011a4:	01 d0                	add    %edx,%eax
  1011a6:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011ab:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011af:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011b6:	7e e2                	jle    10119a <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011b8:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011bf:	83 e8 50             	sub    $0x50,%eax
  1011c2:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011c8:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011cf:	0f b7 c0             	movzwl %ax,%eax
  1011d2:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011d6:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011da:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011de:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011e2:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011e3:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011ea:	66 c1 e8 08          	shr    $0x8,%ax
  1011ee:	0f b6 c0             	movzbl %al,%eax
  1011f1:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011f8:	83 c2 01             	add    $0x1,%edx
  1011fb:	0f b7 d2             	movzwl %dx,%edx
  1011fe:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101202:	88 45 ed             	mov    %al,-0x13(%ebp)
  101205:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101209:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10120d:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10120e:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101215:	0f b7 c0             	movzwl %ax,%eax
  101218:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  10121c:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101220:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101224:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101228:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101229:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101230:	0f b6 c0             	movzbl %al,%eax
  101233:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10123a:	83 c2 01             	add    $0x1,%edx
  10123d:	0f b7 d2             	movzwl %dx,%edx
  101240:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101244:	88 45 e5             	mov    %al,-0x1b(%ebp)
  101247:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10124b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10124f:	ee                   	out    %al,(%dx)
}
  101250:	83 c4 34             	add    $0x34,%esp
  101253:	5b                   	pop    %ebx
  101254:	5d                   	pop    %ebp
  101255:	c3                   	ret    

00101256 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101256:	55                   	push   %ebp
  101257:	89 e5                	mov    %esp,%ebp
  101259:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10125c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101263:	eb 09                	jmp    10126e <serial_putc_sub+0x18>
        delay();
  101265:	e8 4f fb ff ff       	call   100db9 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10126a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10126e:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101274:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101278:	89 c2                	mov    %eax,%edx
  10127a:	ec                   	in     (%dx),%al
  10127b:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10127e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101282:	0f b6 c0             	movzbl %al,%eax
  101285:	83 e0 20             	and    $0x20,%eax
  101288:	85 c0                	test   %eax,%eax
  10128a:	75 09                	jne    101295 <serial_putc_sub+0x3f>
  10128c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101293:	7e d0                	jle    101265 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101295:	8b 45 08             	mov    0x8(%ebp),%eax
  101298:	0f b6 c0             	movzbl %al,%eax
  10129b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012a1:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012a4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012a8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012ac:	ee                   	out    %al,(%dx)
}
  1012ad:	c9                   	leave  
  1012ae:	c3                   	ret    

001012af <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012af:	55                   	push   %ebp
  1012b0:	89 e5                	mov    %esp,%ebp
  1012b2:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012b5:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012b9:	74 0d                	je     1012c8 <serial_putc+0x19>
        serial_putc_sub(c);
  1012bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1012be:	89 04 24             	mov    %eax,(%esp)
  1012c1:	e8 90 ff ff ff       	call   101256 <serial_putc_sub>
  1012c6:	eb 24                	jmp    1012ec <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012c8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012cf:	e8 82 ff ff ff       	call   101256 <serial_putc_sub>
        serial_putc_sub(' ');
  1012d4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012db:	e8 76 ff ff ff       	call   101256 <serial_putc_sub>
        serial_putc_sub('\b');
  1012e0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012e7:	e8 6a ff ff ff       	call   101256 <serial_putc_sub>
    }
}
  1012ec:	c9                   	leave  
  1012ed:	c3                   	ret    

001012ee <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012ee:	55                   	push   %ebp
  1012ef:	89 e5                	mov    %esp,%ebp
  1012f1:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012f4:	eb 33                	jmp    101329 <cons_intr+0x3b>
        if (c != 0) {
  1012f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012fa:	74 2d                	je     101329 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012fc:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101301:	8d 50 01             	lea    0x1(%eax),%edx
  101304:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  10130a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10130d:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101313:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101318:	3d 00 02 00 00       	cmp    $0x200,%eax
  10131d:	75 0a                	jne    101329 <cons_intr+0x3b>
                cons.wpos = 0;
  10131f:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101326:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101329:	8b 45 08             	mov    0x8(%ebp),%eax
  10132c:	ff d0                	call   *%eax
  10132e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101331:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101335:	75 bf                	jne    1012f6 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101337:	c9                   	leave  
  101338:	c3                   	ret    

00101339 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101339:	55                   	push   %ebp
  10133a:	89 e5                	mov    %esp,%ebp
  10133c:	83 ec 10             	sub    $0x10,%esp
  10133f:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101345:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101349:	89 c2                	mov    %eax,%edx
  10134b:	ec                   	in     (%dx),%al
  10134c:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10134f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101353:	0f b6 c0             	movzbl %al,%eax
  101356:	83 e0 01             	and    $0x1,%eax
  101359:	85 c0                	test   %eax,%eax
  10135b:	75 07                	jne    101364 <serial_proc_data+0x2b>
        return -1;
  10135d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101362:	eb 2a                	jmp    10138e <serial_proc_data+0x55>
  101364:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10136a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10136e:	89 c2                	mov    %eax,%edx
  101370:	ec                   	in     (%dx),%al
  101371:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101374:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101378:	0f b6 c0             	movzbl %al,%eax
  10137b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10137e:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101382:	75 07                	jne    10138b <serial_proc_data+0x52>
        c = '\b';
  101384:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10138b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10138e:	c9                   	leave  
  10138f:	c3                   	ret    

00101390 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101390:	55                   	push   %ebp
  101391:	89 e5                	mov    %esp,%ebp
  101393:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101396:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10139b:	85 c0                	test   %eax,%eax
  10139d:	74 0c                	je     1013ab <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10139f:	c7 04 24 39 13 10 00 	movl   $0x101339,(%esp)
  1013a6:	e8 43 ff ff ff       	call   1012ee <cons_intr>
    }
}
  1013ab:	c9                   	leave  
  1013ac:	c3                   	ret    

001013ad <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013ad:	55                   	push   %ebp
  1013ae:	89 e5                	mov    %esp,%ebp
  1013b0:	83 ec 38             	sub    $0x38,%esp
  1013b3:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013b9:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013bd:	89 c2                	mov    %eax,%edx
  1013bf:	ec                   	in     (%dx),%al
  1013c0:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013c3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013c7:	0f b6 c0             	movzbl %al,%eax
  1013ca:	83 e0 01             	and    $0x1,%eax
  1013cd:	85 c0                	test   %eax,%eax
  1013cf:	75 0a                	jne    1013db <kbd_proc_data+0x2e>
        return -1;
  1013d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013d6:	e9 59 01 00 00       	jmp    101534 <kbd_proc_data+0x187>
  1013db:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013e5:	89 c2                	mov    %eax,%edx
  1013e7:	ec                   	in     (%dx),%al
  1013e8:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013eb:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013ef:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013f2:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013f6:	75 17                	jne    10140f <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013f8:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013fd:	83 c8 40             	or     $0x40,%eax
  101400:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101405:	b8 00 00 00 00       	mov    $0x0,%eax
  10140a:	e9 25 01 00 00       	jmp    101534 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  10140f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101413:	84 c0                	test   %al,%al
  101415:	79 47                	jns    10145e <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101417:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10141c:	83 e0 40             	and    $0x40,%eax
  10141f:	85 c0                	test   %eax,%eax
  101421:	75 09                	jne    10142c <kbd_proc_data+0x7f>
  101423:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101427:	83 e0 7f             	and    $0x7f,%eax
  10142a:	eb 04                	jmp    101430 <kbd_proc_data+0x83>
  10142c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101430:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101433:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101437:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10143e:	83 c8 40             	or     $0x40,%eax
  101441:	0f b6 c0             	movzbl %al,%eax
  101444:	f7 d0                	not    %eax
  101446:	89 c2                	mov    %eax,%edx
  101448:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10144d:	21 d0                	and    %edx,%eax
  10144f:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101454:	b8 00 00 00 00       	mov    $0x0,%eax
  101459:	e9 d6 00 00 00       	jmp    101534 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  10145e:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101463:	83 e0 40             	and    $0x40,%eax
  101466:	85 c0                	test   %eax,%eax
  101468:	74 11                	je     10147b <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10146a:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10146e:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101473:	83 e0 bf             	and    $0xffffffbf,%eax
  101476:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  10147b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147f:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101486:	0f b6 d0             	movzbl %al,%edx
  101489:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10148e:	09 d0                	or     %edx,%eax
  101490:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101499:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014a0:	0f b6 d0             	movzbl %al,%edx
  1014a3:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014a8:	31 d0                	xor    %edx,%eax
  1014aa:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014af:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014b4:	83 e0 03             	and    $0x3,%eax
  1014b7:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014be:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014c2:	01 d0                	add    %edx,%eax
  1014c4:	0f b6 00             	movzbl (%eax),%eax
  1014c7:	0f b6 c0             	movzbl %al,%eax
  1014ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014cd:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014d2:	83 e0 08             	and    $0x8,%eax
  1014d5:	85 c0                	test   %eax,%eax
  1014d7:	74 22                	je     1014fb <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014d9:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014dd:	7e 0c                	jle    1014eb <kbd_proc_data+0x13e>
  1014df:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014e3:	7f 06                	jg     1014eb <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014e5:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014e9:	eb 10                	jmp    1014fb <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014eb:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014ef:	7e 0a                	jle    1014fb <kbd_proc_data+0x14e>
  1014f1:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014f5:	7f 04                	jg     1014fb <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014f7:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014fb:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101500:	f7 d0                	not    %eax
  101502:	83 e0 06             	and    $0x6,%eax
  101505:	85 c0                	test   %eax,%eax
  101507:	75 28                	jne    101531 <kbd_proc_data+0x184>
  101509:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101510:	75 1f                	jne    101531 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101512:	c7 04 24 9d 37 10 00 	movl   $0x10379d,(%esp)
  101519:	e8 f4 ed ff ff       	call   100312 <cprintf>
  10151e:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101524:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101528:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10152c:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101530:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101531:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101534:	c9                   	leave  
  101535:	c3                   	ret    

00101536 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101536:	55                   	push   %ebp
  101537:	89 e5                	mov    %esp,%ebp
  101539:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10153c:	c7 04 24 ad 13 10 00 	movl   $0x1013ad,(%esp)
  101543:	e8 a6 fd ff ff       	call   1012ee <cons_intr>
}
  101548:	c9                   	leave  
  101549:	c3                   	ret    

0010154a <kbd_init>:

static void
kbd_init(void) {
  10154a:	55                   	push   %ebp
  10154b:	89 e5                	mov    %esp,%ebp
  10154d:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101550:	e8 e1 ff ff ff       	call   101536 <kbd_intr>
    pic_enable(IRQ_KBD);
  101555:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10155c:	e8 17 01 00 00       	call   101678 <pic_enable>
}
  101561:	c9                   	leave  
  101562:	c3                   	ret    

00101563 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101563:	55                   	push   %ebp
  101564:	89 e5                	mov    %esp,%ebp
  101566:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101569:	e8 93 f8 ff ff       	call   100e01 <cga_init>
    serial_init();
  10156e:	e8 74 f9 ff ff       	call   100ee7 <serial_init>
    kbd_init();
  101573:	e8 d2 ff ff ff       	call   10154a <kbd_init>
    if (!serial_exists) {
  101578:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10157d:	85 c0                	test   %eax,%eax
  10157f:	75 0c                	jne    10158d <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101581:	c7 04 24 a9 37 10 00 	movl   $0x1037a9,(%esp)
  101588:	e8 85 ed ff ff       	call   100312 <cprintf>
    }
}
  10158d:	c9                   	leave  
  10158e:	c3                   	ret    

0010158f <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10158f:	55                   	push   %ebp
  101590:	89 e5                	mov    %esp,%ebp
  101592:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  101595:	8b 45 08             	mov    0x8(%ebp),%eax
  101598:	89 04 24             	mov    %eax,(%esp)
  10159b:	e8 a3 fa ff ff       	call   101043 <lpt_putc>
    cga_putc(c);
  1015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1015a3:	89 04 24             	mov    %eax,(%esp)
  1015a6:	e8 d7 fa ff ff       	call   101082 <cga_putc>
    serial_putc(c);
  1015ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1015ae:	89 04 24             	mov    %eax,(%esp)
  1015b1:	e8 f9 fc ff ff       	call   1012af <serial_putc>
}
  1015b6:	c9                   	leave  
  1015b7:	c3                   	ret    

001015b8 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015b8:	55                   	push   %ebp
  1015b9:	89 e5                	mov    %esp,%ebp
  1015bb:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015be:	e8 cd fd ff ff       	call   101390 <serial_intr>
    kbd_intr();
  1015c3:	e8 6e ff ff ff       	call   101536 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015c8:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015ce:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015d3:	39 c2                	cmp    %eax,%edx
  1015d5:	74 36                	je     10160d <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015d7:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015dc:	8d 50 01             	lea    0x1(%eax),%edx
  1015df:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015e5:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015ec:	0f b6 c0             	movzbl %al,%eax
  1015ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015f2:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015f7:	3d 00 02 00 00       	cmp    $0x200,%eax
  1015fc:	75 0a                	jne    101608 <cons_getc+0x50>
            cons.rpos = 0;
  1015fe:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101605:	00 00 00 
        }
        return c;
  101608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10160b:	eb 05                	jmp    101612 <cons_getc+0x5a>
    }
    return 0;
  10160d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101612:	c9                   	leave  
  101613:	c3                   	ret    

00101614 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101614:	55                   	push   %ebp
  101615:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  101617:	fb                   	sti    
    sti();
}
  101618:	5d                   	pop    %ebp
  101619:	c3                   	ret    

0010161a <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10161a:	55                   	push   %ebp
  10161b:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  10161d:	fa                   	cli    
    cli();
}
  10161e:	5d                   	pop    %ebp
  10161f:	c3                   	ret    

00101620 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101620:	55                   	push   %ebp
  101621:	89 e5                	mov    %esp,%ebp
  101623:	83 ec 14             	sub    $0x14,%esp
  101626:	8b 45 08             	mov    0x8(%ebp),%eax
  101629:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  10162d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101631:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101637:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  10163c:	85 c0                	test   %eax,%eax
  10163e:	74 36                	je     101676 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101640:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101644:	0f b6 c0             	movzbl %al,%eax
  101647:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10164d:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101650:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101654:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101658:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101659:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10165d:	66 c1 e8 08          	shr    $0x8,%ax
  101661:	0f b6 c0             	movzbl %al,%eax
  101664:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10166a:	88 45 f9             	mov    %al,-0x7(%ebp)
  10166d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101671:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101675:	ee                   	out    %al,(%dx)
    }
}
  101676:	c9                   	leave  
  101677:	c3                   	ret    

00101678 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101678:	55                   	push   %ebp
  101679:	89 e5                	mov    %esp,%ebp
  10167b:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10167e:	8b 45 08             	mov    0x8(%ebp),%eax
  101681:	ba 01 00 00 00       	mov    $0x1,%edx
  101686:	89 c1                	mov    %eax,%ecx
  101688:	d3 e2                	shl    %cl,%edx
  10168a:	89 d0                	mov    %edx,%eax
  10168c:	f7 d0                	not    %eax
  10168e:	89 c2                	mov    %eax,%edx
  101690:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  101697:	21 d0                	and    %edx,%eax
  101699:	0f b7 c0             	movzwl %ax,%eax
  10169c:	89 04 24             	mov    %eax,(%esp)
  10169f:	e8 7c ff ff ff       	call   101620 <pic_setmask>
}
  1016a4:	c9                   	leave  
  1016a5:	c3                   	ret    

001016a6 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016a6:	55                   	push   %ebp
  1016a7:	89 e5                	mov    %esp,%ebp
  1016a9:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016ac:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016b3:	00 00 00 
  1016b6:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016bc:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016c0:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016c4:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016c8:	ee                   	out    %al,(%dx)
  1016c9:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016cf:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016d3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016d7:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016db:	ee                   	out    %al,(%dx)
  1016dc:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016e2:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016e6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1016ea:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1016ee:	ee                   	out    %al,(%dx)
  1016ef:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  1016f5:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  1016f9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1016fd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101701:	ee                   	out    %al,(%dx)
  101702:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  101708:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  10170c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101710:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101714:	ee                   	out    %al,(%dx)
  101715:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  10171b:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  10171f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101723:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101727:	ee                   	out    %al,(%dx)
  101728:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  10172e:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101732:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101736:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10173a:	ee                   	out    %al,(%dx)
  10173b:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101741:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  101745:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101749:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10174d:	ee                   	out    %al,(%dx)
  10174e:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101754:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  101758:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10175c:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101760:	ee                   	out    %al,(%dx)
  101761:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101767:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  10176b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10176f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101773:	ee                   	out    %al,(%dx)
  101774:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  10177a:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  10177e:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101782:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101786:	ee                   	out    %al,(%dx)
  101787:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10178d:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101791:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101795:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101799:	ee                   	out    %al,(%dx)
  10179a:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1017a0:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1017a4:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017a8:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017ac:	ee                   	out    %al,(%dx)
  1017ad:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017b3:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017b7:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017bb:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017bf:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017c0:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017c7:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017cb:	74 12                	je     1017df <pic_init+0x139>
        pic_setmask(irq_mask);
  1017cd:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017d4:	0f b7 c0             	movzwl %ax,%eax
  1017d7:	89 04 24             	mov    %eax,(%esp)
  1017da:	e8 41 fe ff ff       	call   101620 <pic_setmask>
    }
}
  1017df:	c9                   	leave  
  1017e0:	c3                   	ret    

001017e1 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017e1:	55                   	push   %ebp
  1017e2:	89 e5                	mov    %esp,%ebp
  1017e4:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017e7:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1017ee:	00 
  1017ef:	c7 04 24 e0 37 10 00 	movl   $0x1037e0,(%esp)
  1017f6:	e8 17 eb ff ff       	call   100312 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1017fb:	c9                   	leave  
  1017fc:	c3                   	ret    

001017fd <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1017fd:	55                   	push   %ebp
  1017fe:	89 e5                	mov    %esp,%ebp
  101800:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i;
	for(i = 0; i < sizeof(idt) / sizeof(struct gatedesc); ++i){
  101803:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10180a:	e9 c3 00 00 00       	jmp    1018d2 <idt_init+0xd5>
		SETGATE(idt[i],0,GD_KTEXT,__vectors[i],0);
  10180f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101812:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101819:	89 c2                	mov    %eax,%edx
  10181b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10181e:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101825:	00 
  101826:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101829:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101830:	00 08 00 
  101833:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101836:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10183d:	00 
  10183e:	83 e2 e0             	and    $0xffffffe0,%edx
  101841:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101848:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10184b:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101852:	00 
  101853:	83 e2 1f             	and    $0x1f,%edx
  101856:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10185d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101860:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101867:	00 
  101868:	83 e2 f0             	and    $0xfffffff0,%edx
  10186b:	83 ca 0e             	or     $0xe,%edx
  10186e:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101875:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101878:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10187f:	00 
  101880:	83 e2 ef             	and    $0xffffffef,%edx
  101883:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10188a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10188d:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101894:	00 
  101895:	83 e2 9f             	and    $0xffffff9f,%edx
  101898:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10189f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a2:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018a9:	00 
  1018aa:	83 ca 80             	or     $0xffffff80,%edx
  1018ad:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b7:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018be:	c1 e8 10             	shr    $0x10,%eax
  1018c1:	89 c2                	mov    %eax,%edx
  1018c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c6:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018cd:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i;
	for(i = 0; i < sizeof(idt) / sizeof(struct gatedesc); ++i){
  1018ce:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1018d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d5:	3d ff 00 00 00       	cmp    $0xff,%eax
  1018da:	0f 86 2f ff ff ff    	jbe    10180f <idt_init+0x12>
		SETGATE(idt[i],0,GD_KTEXT,__vectors[i],0);
	}
	SETGATE(idt[T_SWITCH_TOK],0,GD_KTEXT,__vectors[T_SWITCH_TOK],3);
  1018e0:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  1018e5:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  1018eb:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  1018f2:	08 00 
  1018f4:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  1018fb:	83 e0 e0             	and    $0xffffffe0,%eax
  1018fe:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101903:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  10190a:	83 e0 1f             	and    $0x1f,%eax
  10190d:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101912:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101919:	83 e0 f0             	and    $0xfffffff0,%eax
  10191c:	83 c8 0e             	or     $0xe,%eax
  10191f:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101924:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10192b:	83 e0 ef             	and    $0xffffffef,%eax
  10192e:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101933:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10193a:	83 c8 60             	or     $0x60,%eax
  10193d:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101942:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101949:	83 c8 80             	or     $0xffffff80,%eax
  10194c:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101951:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101956:	c1 e8 10             	shr    $0x10,%eax
  101959:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  10195f:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  101966:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101969:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
  10196c:	c9                   	leave  
  10196d:	c3                   	ret    

0010196e <trapname>:

static const char *
trapname(int trapno) {
  10196e:	55                   	push   %ebp
  10196f:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101971:	8b 45 08             	mov    0x8(%ebp),%eax
  101974:	83 f8 13             	cmp    $0x13,%eax
  101977:	77 0c                	ja     101985 <trapname+0x17>
        return excnames[trapno];
  101979:	8b 45 08             	mov    0x8(%ebp),%eax
  10197c:	8b 04 85 40 3b 10 00 	mov    0x103b40(,%eax,4),%eax
  101983:	eb 18                	jmp    10199d <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101985:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101989:	7e 0d                	jle    101998 <trapname+0x2a>
  10198b:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  10198f:	7f 07                	jg     101998 <trapname+0x2a>
        return "Hardware Interrupt";
  101991:	b8 ea 37 10 00       	mov    $0x1037ea,%eax
  101996:	eb 05                	jmp    10199d <trapname+0x2f>
    }
    return "(unknown trap)";
  101998:	b8 fd 37 10 00       	mov    $0x1037fd,%eax
}
  10199d:	5d                   	pop    %ebp
  10199e:	c3                   	ret    

0010199f <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  10199f:	55                   	push   %ebp
  1019a0:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1019a5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019a9:	66 83 f8 08          	cmp    $0x8,%ax
  1019ad:	0f 94 c0             	sete   %al
  1019b0:	0f b6 c0             	movzbl %al,%eax
}
  1019b3:	5d                   	pop    %ebp
  1019b4:	c3                   	ret    

001019b5 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019b5:	55                   	push   %ebp
  1019b6:	89 e5                	mov    %esp,%ebp
  1019b8:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1019be:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019c2:	c7 04 24 3e 38 10 00 	movl   $0x10383e,(%esp)
  1019c9:	e8 44 e9 ff ff       	call   100312 <cprintf>
    print_regs(&tf->tf_regs);
  1019ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1019d1:	89 04 24             	mov    %eax,(%esp)
  1019d4:	e8 a1 01 00 00       	call   101b7a <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  1019d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1019dc:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  1019e0:	0f b7 c0             	movzwl %ax,%eax
  1019e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019e7:	c7 04 24 4f 38 10 00 	movl   $0x10384f,(%esp)
  1019ee:	e8 1f e9 ff ff       	call   100312 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  1019f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f6:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  1019fa:	0f b7 c0             	movzwl %ax,%eax
  1019fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a01:	c7 04 24 62 38 10 00 	movl   $0x103862,(%esp)
  101a08:	e8 05 e9 ff ff       	call   100312 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a10:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a14:	0f b7 c0             	movzwl %ax,%eax
  101a17:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a1b:	c7 04 24 75 38 10 00 	movl   $0x103875,(%esp)
  101a22:	e8 eb e8 ff ff       	call   100312 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a27:	8b 45 08             	mov    0x8(%ebp),%eax
  101a2a:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a2e:	0f b7 c0             	movzwl %ax,%eax
  101a31:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a35:	c7 04 24 88 38 10 00 	movl   $0x103888,(%esp)
  101a3c:	e8 d1 e8 ff ff       	call   100312 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a41:	8b 45 08             	mov    0x8(%ebp),%eax
  101a44:	8b 40 30             	mov    0x30(%eax),%eax
  101a47:	89 04 24             	mov    %eax,(%esp)
  101a4a:	e8 1f ff ff ff       	call   10196e <trapname>
  101a4f:	8b 55 08             	mov    0x8(%ebp),%edx
  101a52:	8b 52 30             	mov    0x30(%edx),%edx
  101a55:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a59:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a5d:	c7 04 24 9b 38 10 00 	movl   $0x10389b,(%esp)
  101a64:	e8 a9 e8 ff ff       	call   100312 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a69:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6c:	8b 40 34             	mov    0x34(%eax),%eax
  101a6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a73:	c7 04 24 ad 38 10 00 	movl   $0x1038ad,(%esp)
  101a7a:	e8 93 e8 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a82:	8b 40 38             	mov    0x38(%eax),%eax
  101a85:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a89:	c7 04 24 bc 38 10 00 	movl   $0x1038bc,(%esp)
  101a90:	e8 7d e8 ff ff       	call   100312 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101a95:	8b 45 08             	mov    0x8(%ebp),%eax
  101a98:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a9c:	0f b7 c0             	movzwl %ax,%eax
  101a9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa3:	c7 04 24 cb 38 10 00 	movl   $0x1038cb,(%esp)
  101aaa:	e8 63 e8 ff ff       	call   100312 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab2:	8b 40 40             	mov    0x40(%eax),%eax
  101ab5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab9:	c7 04 24 de 38 10 00 	movl   $0x1038de,(%esp)
  101ac0:	e8 4d e8 ff ff       	call   100312 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ac5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101acc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ad3:	eb 3e                	jmp    101b13 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad8:	8b 50 40             	mov    0x40(%eax),%edx
  101adb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101ade:	21 d0                	and    %edx,%eax
  101ae0:	85 c0                	test   %eax,%eax
  101ae2:	74 28                	je     101b0c <print_trapframe+0x157>
  101ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ae7:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101aee:	85 c0                	test   %eax,%eax
  101af0:	74 1a                	je     101b0c <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101af5:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101afc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b00:	c7 04 24 ed 38 10 00 	movl   $0x1038ed,(%esp)
  101b07:	e8 06 e8 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b0c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b10:	d1 65 f0             	shll   -0x10(%ebp)
  101b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b16:	83 f8 17             	cmp    $0x17,%eax
  101b19:	76 ba                	jbe    101ad5 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1e:	8b 40 40             	mov    0x40(%eax),%eax
  101b21:	25 00 30 00 00       	and    $0x3000,%eax
  101b26:	c1 e8 0c             	shr    $0xc,%eax
  101b29:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b2d:	c7 04 24 f1 38 10 00 	movl   $0x1038f1,(%esp)
  101b34:	e8 d9 e7 ff ff       	call   100312 <cprintf>

    if (!trap_in_kernel(tf)) {
  101b39:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3c:	89 04 24             	mov    %eax,(%esp)
  101b3f:	e8 5b fe ff ff       	call   10199f <trap_in_kernel>
  101b44:	85 c0                	test   %eax,%eax
  101b46:	75 30                	jne    101b78 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b48:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4b:	8b 40 44             	mov    0x44(%eax),%eax
  101b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b52:	c7 04 24 fa 38 10 00 	movl   $0x1038fa,(%esp)
  101b59:	e8 b4 e7 ff ff       	call   100312 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b61:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b65:	0f b7 c0             	movzwl %ax,%eax
  101b68:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b6c:	c7 04 24 09 39 10 00 	movl   $0x103909,(%esp)
  101b73:	e8 9a e7 ff ff       	call   100312 <cprintf>
    }
}
  101b78:	c9                   	leave  
  101b79:	c3                   	ret    

00101b7a <print_regs>:

void
print_regs(struct pushregs *regs) {
  101b7a:	55                   	push   %ebp
  101b7b:	89 e5                	mov    %esp,%ebp
  101b7d:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101b80:	8b 45 08             	mov    0x8(%ebp),%eax
  101b83:	8b 00                	mov    (%eax),%eax
  101b85:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b89:	c7 04 24 1c 39 10 00 	movl   $0x10391c,(%esp)
  101b90:	e8 7d e7 ff ff       	call   100312 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101b95:	8b 45 08             	mov    0x8(%ebp),%eax
  101b98:	8b 40 04             	mov    0x4(%eax),%eax
  101b9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b9f:	c7 04 24 2b 39 10 00 	movl   $0x10392b,(%esp)
  101ba6:	e8 67 e7 ff ff       	call   100312 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bab:	8b 45 08             	mov    0x8(%ebp),%eax
  101bae:	8b 40 08             	mov    0x8(%eax),%eax
  101bb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb5:	c7 04 24 3a 39 10 00 	movl   $0x10393a,(%esp)
  101bbc:	e8 51 e7 ff ff       	call   100312 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc4:	8b 40 0c             	mov    0xc(%eax),%eax
  101bc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bcb:	c7 04 24 49 39 10 00 	movl   $0x103949,(%esp)
  101bd2:	e8 3b e7 ff ff       	call   100312 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bda:	8b 40 10             	mov    0x10(%eax),%eax
  101bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be1:	c7 04 24 58 39 10 00 	movl   $0x103958,(%esp)
  101be8:	e8 25 e7 ff ff       	call   100312 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101bed:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf0:	8b 40 14             	mov    0x14(%eax),%eax
  101bf3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf7:	c7 04 24 67 39 10 00 	movl   $0x103967,(%esp)
  101bfe:	e8 0f e7 ff ff       	call   100312 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c03:	8b 45 08             	mov    0x8(%ebp),%eax
  101c06:	8b 40 18             	mov    0x18(%eax),%eax
  101c09:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0d:	c7 04 24 76 39 10 00 	movl   $0x103976,(%esp)
  101c14:	e8 f9 e6 ff ff       	call   100312 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c19:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1c:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c23:	c7 04 24 85 39 10 00 	movl   $0x103985,(%esp)
  101c2a:	e8 e3 e6 ff ff       	call   100312 <cprintf>
}
  101c2f:	c9                   	leave  
  101c30:	c3                   	ret    

00101c31 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c31:	55                   	push   %ebp
  101c32:	89 e5                	mov    %esp,%ebp
  101c34:	83 ec 28             	sub    $0x28,%esp
    char c;
    static int tick_count = 0;
    switch (tf->tf_trapno) {
  101c37:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3a:	8b 40 30             	mov    0x30(%eax),%eax
  101c3d:	83 f8 2f             	cmp    $0x2f,%eax
  101c40:	77 21                	ja     101c63 <trap_dispatch+0x32>
  101c42:	83 f8 2e             	cmp    $0x2e,%eax
  101c45:	0f 83 15 01 00 00    	jae    101d60 <trap_dispatch+0x12f>
  101c4b:	83 f8 21             	cmp    $0x21,%eax
  101c4e:	0f 84 92 00 00 00    	je     101ce6 <trap_dispatch+0xb5>
  101c54:	83 f8 24             	cmp    $0x24,%eax
  101c57:	74 67                	je     101cc0 <trap_dispatch+0x8f>
  101c59:	83 f8 20             	cmp    $0x20,%eax
  101c5c:	74 16                	je     101c74 <trap_dispatch+0x43>
  101c5e:	e9 c5 00 00 00       	jmp    101d28 <trap_dispatch+0xf7>
  101c63:	83 e8 78             	sub    $0x78,%eax
  101c66:	83 f8 01             	cmp    $0x1,%eax
  101c69:	0f 87 b9 00 00 00    	ja     101d28 <trap_dispatch+0xf7>
  101c6f:	e9 98 00 00 00       	jmp    101d0c <trap_dispatch+0xdb>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    	if((++tick_count) % TICK_NUM == 0){
  101c74:	a1 a0 f8 10 00       	mov    0x10f8a0,%eax
  101c79:	83 c0 01             	add    $0x1,%eax
  101c7c:	a3 a0 f8 10 00       	mov    %eax,0x10f8a0
  101c81:	8b 0d a0 f8 10 00    	mov    0x10f8a0,%ecx
  101c87:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101c8c:	89 c8                	mov    %ecx,%eax
  101c8e:	f7 ea                	imul   %edx
  101c90:	c1 fa 05             	sar    $0x5,%edx
  101c93:	89 c8                	mov    %ecx,%eax
  101c95:	c1 f8 1f             	sar    $0x1f,%eax
  101c98:	29 c2                	sub    %eax,%edx
  101c9a:	89 d0                	mov    %edx,%eax
  101c9c:	6b c0 64             	imul   $0x64,%eax,%eax
  101c9f:	29 c1                	sub    %eax,%ecx
  101ca1:	89 c8                	mov    %ecx,%eax
  101ca3:	85 c0                	test   %eax,%eax
  101ca5:	75 14                	jne    101cbb <trap_dispatch+0x8a>
    		print_ticks();
  101ca7:	e8 35 fb ff ff       	call   1017e1 <print_ticks>
    		tick_count = 0;
  101cac:	c7 05 a0 f8 10 00 00 	movl   $0x0,0x10f8a0
  101cb3:	00 00 00 
    	}
        break;
  101cb6:	e9 a6 00 00 00       	jmp    101d61 <trap_dispatch+0x130>
  101cbb:	e9 a1 00 00 00       	jmp    101d61 <trap_dispatch+0x130>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101cc0:	e8 f3 f8 ff ff       	call   1015b8 <cons_getc>
  101cc5:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101cc8:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101ccc:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cd0:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd8:	c7 04 24 94 39 10 00 	movl   $0x103994,(%esp)
  101cdf:	e8 2e e6 ff ff       	call   100312 <cprintf>
        break;
  101ce4:	eb 7b                	jmp    101d61 <trap_dispatch+0x130>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101ce6:	e8 cd f8 ff ff       	call   1015b8 <cons_getc>
  101ceb:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101cee:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cf2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cf6:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cfa:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cfe:	c7 04 24 a6 39 10 00 	movl   $0x1039a6,(%esp)
  101d05:	e8 08 e6 ff ff       	call   100312 <cprintf>
        break;
  101d0a:	eb 55                	jmp    101d61 <trap_dispatch+0x130>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101d0c:	c7 44 24 08 b5 39 10 	movl   $0x1039b5,0x8(%esp)
  101d13:	00 
  101d14:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
  101d1b:	00 
  101d1c:	c7 04 24 c5 39 10 00 	movl   $0x1039c5,(%esp)
  101d23:	e8 72 ef ff ff       	call   100c9a <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d28:	8b 45 08             	mov    0x8(%ebp),%eax
  101d2b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d2f:	0f b7 c0             	movzwl %ax,%eax
  101d32:	83 e0 03             	and    $0x3,%eax
  101d35:	85 c0                	test   %eax,%eax
  101d37:	75 28                	jne    101d61 <trap_dispatch+0x130>
            print_trapframe(tf);
  101d39:	8b 45 08             	mov    0x8(%ebp),%eax
  101d3c:	89 04 24             	mov    %eax,(%esp)
  101d3f:	e8 71 fc ff ff       	call   1019b5 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101d44:	c7 44 24 08 d6 39 10 	movl   $0x1039d6,0x8(%esp)
  101d4b:	00 
  101d4c:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  101d53:	00 
  101d54:	c7 04 24 c5 39 10 00 	movl   $0x1039c5,(%esp)
  101d5b:	e8 3a ef ff ff       	call   100c9a <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101d60:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101d61:	c9                   	leave  
  101d62:	c3                   	ret    

00101d63 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101d63:	55                   	push   %ebp
  101d64:	89 e5                	mov    %esp,%ebp
  101d66:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101d69:	8b 45 08             	mov    0x8(%ebp),%eax
  101d6c:	89 04 24             	mov    %eax,(%esp)
  101d6f:	e8 bd fe ff ff       	call   101c31 <trap_dispatch>
}
  101d74:	c9                   	leave  
  101d75:	c3                   	ret    

00101d76 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101d76:	1e                   	push   %ds
    pushl %es
  101d77:	06                   	push   %es
    pushl %fs
  101d78:	0f a0                	push   %fs
    pushl %gs
  101d7a:	0f a8                	push   %gs
    pushal
  101d7c:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101d7d:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101d82:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101d84:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101d86:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101d87:	e8 d7 ff ff ff       	call   101d63 <trap>

    # pop the pushed stack pointer
    popl %esp
  101d8c:	5c                   	pop    %esp

00101d8d <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101d8d:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101d8e:	0f a9                	pop    %gs
    popl %fs
  101d90:	0f a1                	pop    %fs
    popl %es
  101d92:	07                   	pop    %es
    popl %ds
  101d93:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101d94:	83 c4 08             	add    $0x8,%esp
    iret
  101d97:	cf                   	iret   

00101d98 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101d98:	6a 00                	push   $0x0
  pushl $0
  101d9a:	6a 00                	push   $0x0
  jmp __alltraps
  101d9c:	e9 d5 ff ff ff       	jmp    101d76 <__alltraps>

00101da1 <vector1>:
.globl vector1
vector1:
  pushl $0
  101da1:	6a 00                	push   $0x0
  pushl $1
  101da3:	6a 01                	push   $0x1
  jmp __alltraps
  101da5:	e9 cc ff ff ff       	jmp    101d76 <__alltraps>

00101daa <vector2>:
.globl vector2
vector2:
  pushl $0
  101daa:	6a 00                	push   $0x0
  pushl $2
  101dac:	6a 02                	push   $0x2
  jmp __alltraps
  101dae:	e9 c3 ff ff ff       	jmp    101d76 <__alltraps>

00101db3 <vector3>:
.globl vector3
vector3:
  pushl $0
  101db3:	6a 00                	push   $0x0
  pushl $3
  101db5:	6a 03                	push   $0x3
  jmp __alltraps
  101db7:	e9 ba ff ff ff       	jmp    101d76 <__alltraps>

00101dbc <vector4>:
.globl vector4
vector4:
  pushl $0
  101dbc:	6a 00                	push   $0x0
  pushl $4
  101dbe:	6a 04                	push   $0x4
  jmp __alltraps
  101dc0:	e9 b1 ff ff ff       	jmp    101d76 <__alltraps>

00101dc5 <vector5>:
.globl vector5
vector5:
  pushl $0
  101dc5:	6a 00                	push   $0x0
  pushl $5
  101dc7:	6a 05                	push   $0x5
  jmp __alltraps
  101dc9:	e9 a8 ff ff ff       	jmp    101d76 <__alltraps>

00101dce <vector6>:
.globl vector6
vector6:
  pushl $0
  101dce:	6a 00                	push   $0x0
  pushl $6
  101dd0:	6a 06                	push   $0x6
  jmp __alltraps
  101dd2:	e9 9f ff ff ff       	jmp    101d76 <__alltraps>

00101dd7 <vector7>:
.globl vector7
vector7:
  pushl $0
  101dd7:	6a 00                	push   $0x0
  pushl $7
  101dd9:	6a 07                	push   $0x7
  jmp __alltraps
  101ddb:	e9 96 ff ff ff       	jmp    101d76 <__alltraps>

00101de0 <vector8>:
.globl vector8
vector8:
  pushl $8
  101de0:	6a 08                	push   $0x8
  jmp __alltraps
  101de2:	e9 8f ff ff ff       	jmp    101d76 <__alltraps>

00101de7 <vector9>:
.globl vector9
vector9:
  pushl $9
  101de7:	6a 09                	push   $0x9
  jmp __alltraps
  101de9:	e9 88 ff ff ff       	jmp    101d76 <__alltraps>

00101dee <vector10>:
.globl vector10
vector10:
  pushl $10
  101dee:	6a 0a                	push   $0xa
  jmp __alltraps
  101df0:	e9 81 ff ff ff       	jmp    101d76 <__alltraps>

00101df5 <vector11>:
.globl vector11
vector11:
  pushl $11
  101df5:	6a 0b                	push   $0xb
  jmp __alltraps
  101df7:	e9 7a ff ff ff       	jmp    101d76 <__alltraps>

00101dfc <vector12>:
.globl vector12
vector12:
  pushl $12
  101dfc:	6a 0c                	push   $0xc
  jmp __alltraps
  101dfe:	e9 73 ff ff ff       	jmp    101d76 <__alltraps>

00101e03 <vector13>:
.globl vector13
vector13:
  pushl $13
  101e03:	6a 0d                	push   $0xd
  jmp __alltraps
  101e05:	e9 6c ff ff ff       	jmp    101d76 <__alltraps>

00101e0a <vector14>:
.globl vector14
vector14:
  pushl $14
  101e0a:	6a 0e                	push   $0xe
  jmp __alltraps
  101e0c:	e9 65 ff ff ff       	jmp    101d76 <__alltraps>

00101e11 <vector15>:
.globl vector15
vector15:
  pushl $0
  101e11:	6a 00                	push   $0x0
  pushl $15
  101e13:	6a 0f                	push   $0xf
  jmp __alltraps
  101e15:	e9 5c ff ff ff       	jmp    101d76 <__alltraps>

00101e1a <vector16>:
.globl vector16
vector16:
  pushl $0
  101e1a:	6a 00                	push   $0x0
  pushl $16
  101e1c:	6a 10                	push   $0x10
  jmp __alltraps
  101e1e:	e9 53 ff ff ff       	jmp    101d76 <__alltraps>

00101e23 <vector17>:
.globl vector17
vector17:
  pushl $17
  101e23:	6a 11                	push   $0x11
  jmp __alltraps
  101e25:	e9 4c ff ff ff       	jmp    101d76 <__alltraps>

00101e2a <vector18>:
.globl vector18
vector18:
  pushl $0
  101e2a:	6a 00                	push   $0x0
  pushl $18
  101e2c:	6a 12                	push   $0x12
  jmp __alltraps
  101e2e:	e9 43 ff ff ff       	jmp    101d76 <__alltraps>

00101e33 <vector19>:
.globl vector19
vector19:
  pushl $0
  101e33:	6a 00                	push   $0x0
  pushl $19
  101e35:	6a 13                	push   $0x13
  jmp __alltraps
  101e37:	e9 3a ff ff ff       	jmp    101d76 <__alltraps>

00101e3c <vector20>:
.globl vector20
vector20:
  pushl $0
  101e3c:	6a 00                	push   $0x0
  pushl $20
  101e3e:	6a 14                	push   $0x14
  jmp __alltraps
  101e40:	e9 31 ff ff ff       	jmp    101d76 <__alltraps>

00101e45 <vector21>:
.globl vector21
vector21:
  pushl $0
  101e45:	6a 00                	push   $0x0
  pushl $21
  101e47:	6a 15                	push   $0x15
  jmp __alltraps
  101e49:	e9 28 ff ff ff       	jmp    101d76 <__alltraps>

00101e4e <vector22>:
.globl vector22
vector22:
  pushl $0
  101e4e:	6a 00                	push   $0x0
  pushl $22
  101e50:	6a 16                	push   $0x16
  jmp __alltraps
  101e52:	e9 1f ff ff ff       	jmp    101d76 <__alltraps>

00101e57 <vector23>:
.globl vector23
vector23:
  pushl $0
  101e57:	6a 00                	push   $0x0
  pushl $23
  101e59:	6a 17                	push   $0x17
  jmp __alltraps
  101e5b:	e9 16 ff ff ff       	jmp    101d76 <__alltraps>

00101e60 <vector24>:
.globl vector24
vector24:
  pushl $0
  101e60:	6a 00                	push   $0x0
  pushl $24
  101e62:	6a 18                	push   $0x18
  jmp __alltraps
  101e64:	e9 0d ff ff ff       	jmp    101d76 <__alltraps>

00101e69 <vector25>:
.globl vector25
vector25:
  pushl $0
  101e69:	6a 00                	push   $0x0
  pushl $25
  101e6b:	6a 19                	push   $0x19
  jmp __alltraps
  101e6d:	e9 04 ff ff ff       	jmp    101d76 <__alltraps>

00101e72 <vector26>:
.globl vector26
vector26:
  pushl $0
  101e72:	6a 00                	push   $0x0
  pushl $26
  101e74:	6a 1a                	push   $0x1a
  jmp __alltraps
  101e76:	e9 fb fe ff ff       	jmp    101d76 <__alltraps>

00101e7b <vector27>:
.globl vector27
vector27:
  pushl $0
  101e7b:	6a 00                	push   $0x0
  pushl $27
  101e7d:	6a 1b                	push   $0x1b
  jmp __alltraps
  101e7f:	e9 f2 fe ff ff       	jmp    101d76 <__alltraps>

00101e84 <vector28>:
.globl vector28
vector28:
  pushl $0
  101e84:	6a 00                	push   $0x0
  pushl $28
  101e86:	6a 1c                	push   $0x1c
  jmp __alltraps
  101e88:	e9 e9 fe ff ff       	jmp    101d76 <__alltraps>

00101e8d <vector29>:
.globl vector29
vector29:
  pushl $0
  101e8d:	6a 00                	push   $0x0
  pushl $29
  101e8f:	6a 1d                	push   $0x1d
  jmp __alltraps
  101e91:	e9 e0 fe ff ff       	jmp    101d76 <__alltraps>

00101e96 <vector30>:
.globl vector30
vector30:
  pushl $0
  101e96:	6a 00                	push   $0x0
  pushl $30
  101e98:	6a 1e                	push   $0x1e
  jmp __alltraps
  101e9a:	e9 d7 fe ff ff       	jmp    101d76 <__alltraps>

00101e9f <vector31>:
.globl vector31
vector31:
  pushl $0
  101e9f:	6a 00                	push   $0x0
  pushl $31
  101ea1:	6a 1f                	push   $0x1f
  jmp __alltraps
  101ea3:	e9 ce fe ff ff       	jmp    101d76 <__alltraps>

00101ea8 <vector32>:
.globl vector32
vector32:
  pushl $0
  101ea8:	6a 00                	push   $0x0
  pushl $32
  101eaa:	6a 20                	push   $0x20
  jmp __alltraps
  101eac:	e9 c5 fe ff ff       	jmp    101d76 <__alltraps>

00101eb1 <vector33>:
.globl vector33
vector33:
  pushl $0
  101eb1:	6a 00                	push   $0x0
  pushl $33
  101eb3:	6a 21                	push   $0x21
  jmp __alltraps
  101eb5:	e9 bc fe ff ff       	jmp    101d76 <__alltraps>

00101eba <vector34>:
.globl vector34
vector34:
  pushl $0
  101eba:	6a 00                	push   $0x0
  pushl $34
  101ebc:	6a 22                	push   $0x22
  jmp __alltraps
  101ebe:	e9 b3 fe ff ff       	jmp    101d76 <__alltraps>

00101ec3 <vector35>:
.globl vector35
vector35:
  pushl $0
  101ec3:	6a 00                	push   $0x0
  pushl $35
  101ec5:	6a 23                	push   $0x23
  jmp __alltraps
  101ec7:	e9 aa fe ff ff       	jmp    101d76 <__alltraps>

00101ecc <vector36>:
.globl vector36
vector36:
  pushl $0
  101ecc:	6a 00                	push   $0x0
  pushl $36
  101ece:	6a 24                	push   $0x24
  jmp __alltraps
  101ed0:	e9 a1 fe ff ff       	jmp    101d76 <__alltraps>

00101ed5 <vector37>:
.globl vector37
vector37:
  pushl $0
  101ed5:	6a 00                	push   $0x0
  pushl $37
  101ed7:	6a 25                	push   $0x25
  jmp __alltraps
  101ed9:	e9 98 fe ff ff       	jmp    101d76 <__alltraps>

00101ede <vector38>:
.globl vector38
vector38:
  pushl $0
  101ede:	6a 00                	push   $0x0
  pushl $38
  101ee0:	6a 26                	push   $0x26
  jmp __alltraps
  101ee2:	e9 8f fe ff ff       	jmp    101d76 <__alltraps>

00101ee7 <vector39>:
.globl vector39
vector39:
  pushl $0
  101ee7:	6a 00                	push   $0x0
  pushl $39
  101ee9:	6a 27                	push   $0x27
  jmp __alltraps
  101eeb:	e9 86 fe ff ff       	jmp    101d76 <__alltraps>

00101ef0 <vector40>:
.globl vector40
vector40:
  pushl $0
  101ef0:	6a 00                	push   $0x0
  pushl $40
  101ef2:	6a 28                	push   $0x28
  jmp __alltraps
  101ef4:	e9 7d fe ff ff       	jmp    101d76 <__alltraps>

00101ef9 <vector41>:
.globl vector41
vector41:
  pushl $0
  101ef9:	6a 00                	push   $0x0
  pushl $41
  101efb:	6a 29                	push   $0x29
  jmp __alltraps
  101efd:	e9 74 fe ff ff       	jmp    101d76 <__alltraps>

00101f02 <vector42>:
.globl vector42
vector42:
  pushl $0
  101f02:	6a 00                	push   $0x0
  pushl $42
  101f04:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f06:	e9 6b fe ff ff       	jmp    101d76 <__alltraps>

00101f0b <vector43>:
.globl vector43
vector43:
  pushl $0
  101f0b:	6a 00                	push   $0x0
  pushl $43
  101f0d:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f0f:	e9 62 fe ff ff       	jmp    101d76 <__alltraps>

00101f14 <vector44>:
.globl vector44
vector44:
  pushl $0
  101f14:	6a 00                	push   $0x0
  pushl $44
  101f16:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f18:	e9 59 fe ff ff       	jmp    101d76 <__alltraps>

00101f1d <vector45>:
.globl vector45
vector45:
  pushl $0
  101f1d:	6a 00                	push   $0x0
  pushl $45
  101f1f:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f21:	e9 50 fe ff ff       	jmp    101d76 <__alltraps>

00101f26 <vector46>:
.globl vector46
vector46:
  pushl $0
  101f26:	6a 00                	push   $0x0
  pushl $46
  101f28:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f2a:	e9 47 fe ff ff       	jmp    101d76 <__alltraps>

00101f2f <vector47>:
.globl vector47
vector47:
  pushl $0
  101f2f:	6a 00                	push   $0x0
  pushl $47
  101f31:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f33:	e9 3e fe ff ff       	jmp    101d76 <__alltraps>

00101f38 <vector48>:
.globl vector48
vector48:
  pushl $0
  101f38:	6a 00                	push   $0x0
  pushl $48
  101f3a:	6a 30                	push   $0x30
  jmp __alltraps
  101f3c:	e9 35 fe ff ff       	jmp    101d76 <__alltraps>

00101f41 <vector49>:
.globl vector49
vector49:
  pushl $0
  101f41:	6a 00                	push   $0x0
  pushl $49
  101f43:	6a 31                	push   $0x31
  jmp __alltraps
  101f45:	e9 2c fe ff ff       	jmp    101d76 <__alltraps>

00101f4a <vector50>:
.globl vector50
vector50:
  pushl $0
  101f4a:	6a 00                	push   $0x0
  pushl $50
  101f4c:	6a 32                	push   $0x32
  jmp __alltraps
  101f4e:	e9 23 fe ff ff       	jmp    101d76 <__alltraps>

00101f53 <vector51>:
.globl vector51
vector51:
  pushl $0
  101f53:	6a 00                	push   $0x0
  pushl $51
  101f55:	6a 33                	push   $0x33
  jmp __alltraps
  101f57:	e9 1a fe ff ff       	jmp    101d76 <__alltraps>

00101f5c <vector52>:
.globl vector52
vector52:
  pushl $0
  101f5c:	6a 00                	push   $0x0
  pushl $52
  101f5e:	6a 34                	push   $0x34
  jmp __alltraps
  101f60:	e9 11 fe ff ff       	jmp    101d76 <__alltraps>

00101f65 <vector53>:
.globl vector53
vector53:
  pushl $0
  101f65:	6a 00                	push   $0x0
  pushl $53
  101f67:	6a 35                	push   $0x35
  jmp __alltraps
  101f69:	e9 08 fe ff ff       	jmp    101d76 <__alltraps>

00101f6e <vector54>:
.globl vector54
vector54:
  pushl $0
  101f6e:	6a 00                	push   $0x0
  pushl $54
  101f70:	6a 36                	push   $0x36
  jmp __alltraps
  101f72:	e9 ff fd ff ff       	jmp    101d76 <__alltraps>

00101f77 <vector55>:
.globl vector55
vector55:
  pushl $0
  101f77:	6a 00                	push   $0x0
  pushl $55
  101f79:	6a 37                	push   $0x37
  jmp __alltraps
  101f7b:	e9 f6 fd ff ff       	jmp    101d76 <__alltraps>

00101f80 <vector56>:
.globl vector56
vector56:
  pushl $0
  101f80:	6a 00                	push   $0x0
  pushl $56
  101f82:	6a 38                	push   $0x38
  jmp __alltraps
  101f84:	e9 ed fd ff ff       	jmp    101d76 <__alltraps>

00101f89 <vector57>:
.globl vector57
vector57:
  pushl $0
  101f89:	6a 00                	push   $0x0
  pushl $57
  101f8b:	6a 39                	push   $0x39
  jmp __alltraps
  101f8d:	e9 e4 fd ff ff       	jmp    101d76 <__alltraps>

00101f92 <vector58>:
.globl vector58
vector58:
  pushl $0
  101f92:	6a 00                	push   $0x0
  pushl $58
  101f94:	6a 3a                	push   $0x3a
  jmp __alltraps
  101f96:	e9 db fd ff ff       	jmp    101d76 <__alltraps>

00101f9b <vector59>:
.globl vector59
vector59:
  pushl $0
  101f9b:	6a 00                	push   $0x0
  pushl $59
  101f9d:	6a 3b                	push   $0x3b
  jmp __alltraps
  101f9f:	e9 d2 fd ff ff       	jmp    101d76 <__alltraps>

00101fa4 <vector60>:
.globl vector60
vector60:
  pushl $0
  101fa4:	6a 00                	push   $0x0
  pushl $60
  101fa6:	6a 3c                	push   $0x3c
  jmp __alltraps
  101fa8:	e9 c9 fd ff ff       	jmp    101d76 <__alltraps>

00101fad <vector61>:
.globl vector61
vector61:
  pushl $0
  101fad:	6a 00                	push   $0x0
  pushl $61
  101faf:	6a 3d                	push   $0x3d
  jmp __alltraps
  101fb1:	e9 c0 fd ff ff       	jmp    101d76 <__alltraps>

00101fb6 <vector62>:
.globl vector62
vector62:
  pushl $0
  101fb6:	6a 00                	push   $0x0
  pushl $62
  101fb8:	6a 3e                	push   $0x3e
  jmp __alltraps
  101fba:	e9 b7 fd ff ff       	jmp    101d76 <__alltraps>

00101fbf <vector63>:
.globl vector63
vector63:
  pushl $0
  101fbf:	6a 00                	push   $0x0
  pushl $63
  101fc1:	6a 3f                	push   $0x3f
  jmp __alltraps
  101fc3:	e9 ae fd ff ff       	jmp    101d76 <__alltraps>

00101fc8 <vector64>:
.globl vector64
vector64:
  pushl $0
  101fc8:	6a 00                	push   $0x0
  pushl $64
  101fca:	6a 40                	push   $0x40
  jmp __alltraps
  101fcc:	e9 a5 fd ff ff       	jmp    101d76 <__alltraps>

00101fd1 <vector65>:
.globl vector65
vector65:
  pushl $0
  101fd1:	6a 00                	push   $0x0
  pushl $65
  101fd3:	6a 41                	push   $0x41
  jmp __alltraps
  101fd5:	e9 9c fd ff ff       	jmp    101d76 <__alltraps>

00101fda <vector66>:
.globl vector66
vector66:
  pushl $0
  101fda:	6a 00                	push   $0x0
  pushl $66
  101fdc:	6a 42                	push   $0x42
  jmp __alltraps
  101fde:	e9 93 fd ff ff       	jmp    101d76 <__alltraps>

00101fe3 <vector67>:
.globl vector67
vector67:
  pushl $0
  101fe3:	6a 00                	push   $0x0
  pushl $67
  101fe5:	6a 43                	push   $0x43
  jmp __alltraps
  101fe7:	e9 8a fd ff ff       	jmp    101d76 <__alltraps>

00101fec <vector68>:
.globl vector68
vector68:
  pushl $0
  101fec:	6a 00                	push   $0x0
  pushl $68
  101fee:	6a 44                	push   $0x44
  jmp __alltraps
  101ff0:	e9 81 fd ff ff       	jmp    101d76 <__alltraps>

00101ff5 <vector69>:
.globl vector69
vector69:
  pushl $0
  101ff5:	6a 00                	push   $0x0
  pushl $69
  101ff7:	6a 45                	push   $0x45
  jmp __alltraps
  101ff9:	e9 78 fd ff ff       	jmp    101d76 <__alltraps>

00101ffe <vector70>:
.globl vector70
vector70:
  pushl $0
  101ffe:	6a 00                	push   $0x0
  pushl $70
  102000:	6a 46                	push   $0x46
  jmp __alltraps
  102002:	e9 6f fd ff ff       	jmp    101d76 <__alltraps>

00102007 <vector71>:
.globl vector71
vector71:
  pushl $0
  102007:	6a 00                	push   $0x0
  pushl $71
  102009:	6a 47                	push   $0x47
  jmp __alltraps
  10200b:	e9 66 fd ff ff       	jmp    101d76 <__alltraps>

00102010 <vector72>:
.globl vector72
vector72:
  pushl $0
  102010:	6a 00                	push   $0x0
  pushl $72
  102012:	6a 48                	push   $0x48
  jmp __alltraps
  102014:	e9 5d fd ff ff       	jmp    101d76 <__alltraps>

00102019 <vector73>:
.globl vector73
vector73:
  pushl $0
  102019:	6a 00                	push   $0x0
  pushl $73
  10201b:	6a 49                	push   $0x49
  jmp __alltraps
  10201d:	e9 54 fd ff ff       	jmp    101d76 <__alltraps>

00102022 <vector74>:
.globl vector74
vector74:
  pushl $0
  102022:	6a 00                	push   $0x0
  pushl $74
  102024:	6a 4a                	push   $0x4a
  jmp __alltraps
  102026:	e9 4b fd ff ff       	jmp    101d76 <__alltraps>

0010202b <vector75>:
.globl vector75
vector75:
  pushl $0
  10202b:	6a 00                	push   $0x0
  pushl $75
  10202d:	6a 4b                	push   $0x4b
  jmp __alltraps
  10202f:	e9 42 fd ff ff       	jmp    101d76 <__alltraps>

00102034 <vector76>:
.globl vector76
vector76:
  pushl $0
  102034:	6a 00                	push   $0x0
  pushl $76
  102036:	6a 4c                	push   $0x4c
  jmp __alltraps
  102038:	e9 39 fd ff ff       	jmp    101d76 <__alltraps>

0010203d <vector77>:
.globl vector77
vector77:
  pushl $0
  10203d:	6a 00                	push   $0x0
  pushl $77
  10203f:	6a 4d                	push   $0x4d
  jmp __alltraps
  102041:	e9 30 fd ff ff       	jmp    101d76 <__alltraps>

00102046 <vector78>:
.globl vector78
vector78:
  pushl $0
  102046:	6a 00                	push   $0x0
  pushl $78
  102048:	6a 4e                	push   $0x4e
  jmp __alltraps
  10204a:	e9 27 fd ff ff       	jmp    101d76 <__alltraps>

0010204f <vector79>:
.globl vector79
vector79:
  pushl $0
  10204f:	6a 00                	push   $0x0
  pushl $79
  102051:	6a 4f                	push   $0x4f
  jmp __alltraps
  102053:	e9 1e fd ff ff       	jmp    101d76 <__alltraps>

00102058 <vector80>:
.globl vector80
vector80:
  pushl $0
  102058:	6a 00                	push   $0x0
  pushl $80
  10205a:	6a 50                	push   $0x50
  jmp __alltraps
  10205c:	e9 15 fd ff ff       	jmp    101d76 <__alltraps>

00102061 <vector81>:
.globl vector81
vector81:
  pushl $0
  102061:	6a 00                	push   $0x0
  pushl $81
  102063:	6a 51                	push   $0x51
  jmp __alltraps
  102065:	e9 0c fd ff ff       	jmp    101d76 <__alltraps>

0010206a <vector82>:
.globl vector82
vector82:
  pushl $0
  10206a:	6a 00                	push   $0x0
  pushl $82
  10206c:	6a 52                	push   $0x52
  jmp __alltraps
  10206e:	e9 03 fd ff ff       	jmp    101d76 <__alltraps>

00102073 <vector83>:
.globl vector83
vector83:
  pushl $0
  102073:	6a 00                	push   $0x0
  pushl $83
  102075:	6a 53                	push   $0x53
  jmp __alltraps
  102077:	e9 fa fc ff ff       	jmp    101d76 <__alltraps>

0010207c <vector84>:
.globl vector84
vector84:
  pushl $0
  10207c:	6a 00                	push   $0x0
  pushl $84
  10207e:	6a 54                	push   $0x54
  jmp __alltraps
  102080:	e9 f1 fc ff ff       	jmp    101d76 <__alltraps>

00102085 <vector85>:
.globl vector85
vector85:
  pushl $0
  102085:	6a 00                	push   $0x0
  pushl $85
  102087:	6a 55                	push   $0x55
  jmp __alltraps
  102089:	e9 e8 fc ff ff       	jmp    101d76 <__alltraps>

0010208e <vector86>:
.globl vector86
vector86:
  pushl $0
  10208e:	6a 00                	push   $0x0
  pushl $86
  102090:	6a 56                	push   $0x56
  jmp __alltraps
  102092:	e9 df fc ff ff       	jmp    101d76 <__alltraps>

00102097 <vector87>:
.globl vector87
vector87:
  pushl $0
  102097:	6a 00                	push   $0x0
  pushl $87
  102099:	6a 57                	push   $0x57
  jmp __alltraps
  10209b:	e9 d6 fc ff ff       	jmp    101d76 <__alltraps>

001020a0 <vector88>:
.globl vector88
vector88:
  pushl $0
  1020a0:	6a 00                	push   $0x0
  pushl $88
  1020a2:	6a 58                	push   $0x58
  jmp __alltraps
  1020a4:	e9 cd fc ff ff       	jmp    101d76 <__alltraps>

001020a9 <vector89>:
.globl vector89
vector89:
  pushl $0
  1020a9:	6a 00                	push   $0x0
  pushl $89
  1020ab:	6a 59                	push   $0x59
  jmp __alltraps
  1020ad:	e9 c4 fc ff ff       	jmp    101d76 <__alltraps>

001020b2 <vector90>:
.globl vector90
vector90:
  pushl $0
  1020b2:	6a 00                	push   $0x0
  pushl $90
  1020b4:	6a 5a                	push   $0x5a
  jmp __alltraps
  1020b6:	e9 bb fc ff ff       	jmp    101d76 <__alltraps>

001020bb <vector91>:
.globl vector91
vector91:
  pushl $0
  1020bb:	6a 00                	push   $0x0
  pushl $91
  1020bd:	6a 5b                	push   $0x5b
  jmp __alltraps
  1020bf:	e9 b2 fc ff ff       	jmp    101d76 <__alltraps>

001020c4 <vector92>:
.globl vector92
vector92:
  pushl $0
  1020c4:	6a 00                	push   $0x0
  pushl $92
  1020c6:	6a 5c                	push   $0x5c
  jmp __alltraps
  1020c8:	e9 a9 fc ff ff       	jmp    101d76 <__alltraps>

001020cd <vector93>:
.globl vector93
vector93:
  pushl $0
  1020cd:	6a 00                	push   $0x0
  pushl $93
  1020cf:	6a 5d                	push   $0x5d
  jmp __alltraps
  1020d1:	e9 a0 fc ff ff       	jmp    101d76 <__alltraps>

001020d6 <vector94>:
.globl vector94
vector94:
  pushl $0
  1020d6:	6a 00                	push   $0x0
  pushl $94
  1020d8:	6a 5e                	push   $0x5e
  jmp __alltraps
  1020da:	e9 97 fc ff ff       	jmp    101d76 <__alltraps>

001020df <vector95>:
.globl vector95
vector95:
  pushl $0
  1020df:	6a 00                	push   $0x0
  pushl $95
  1020e1:	6a 5f                	push   $0x5f
  jmp __alltraps
  1020e3:	e9 8e fc ff ff       	jmp    101d76 <__alltraps>

001020e8 <vector96>:
.globl vector96
vector96:
  pushl $0
  1020e8:	6a 00                	push   $0x0
  pushl $96
  1020ea:	6a 60                	push   $0x60
  jmp __alltraps
  1020ec:	e9 85 fc ff ff       	jmp    101d76 <__alltraps>

001020f1 <vector97>:
.globl vector97
vector97:
  pushl $0
  1020f1:	6a 00                	push   $0x0
  pushl $97
  1020f3:	6a 61                	push   $0x61
  jmp __alltraps
  1020f5:	e9 7c fc ff ff       	jmp    101d76 <__alltraps>

001020fa <vector98>:
.globl vector98
vector98:
  pushl $0
  1020fa:	6a 00                	push   $0x0
  pushl $98
  1020fc:	6a 62                	push   $0x62
  jmp __alltraps
  1020fe:	e9 73 fc ff ff       	jmp    101d76 <__alltraps>

00102103 <vector99>:
.globl vector99
vector99:
  pushl $0
  102103:	6a 00                	push   $0x0
  pushl $99
  102105:	6a 63                	push   $0x63
  jmp __alltraps
  102107:	e9 6a fc ff ff       	jmp    101d76 <__alltraps>

0010210c <vector100>:
.globl vector100
vector100:
  pushl $0
  10210c:	6a 00                	push   $0x0
  pushl $100
  10210e:	6a 64                	push   $0x64
  jmp __alltraps
  102110:	e9 61 fc ff ff       	jmp    101d76 <__alltraps>

00102115 <vector101>:
.globl vector101
vector101:
  pushl $0
  102115:	6a 00                	push   $0x0
  pushl $101
  102117:	6a 65                	push   $0x65
  jmp __alltraps
  102119:	e9 58 fc ff ff       	jmp    101d76 <__alltraps>

0010211e <vector102>:
.globl vector102
vector102:
  pushl $0
  10211e:	6a 00                	push   $0x0
  pushl $102
  102120:	6a 66                	push   $0x66
  jmp __alltraps
  102122:	e9 4f fc ff ff       	jmp    101d76 <__alltraps>

00102127 <vector103>:
.globl vector103
vector103:
  pushl $0
  102127:	6a 00                	push   $0x0
  pushl $103
  102129:	6a 67                	push   $0x67
  jmp __alltraps
  10212b:	e9 46 fc ff ff       	jmp    101d76 <__alltraps>

00102130 <vector104>:
.globl vector104
vector104:
  pushl $0
  102130:	6a 00                	push   $0x0
  pushl $104
  102132:	6a 68                	push   $0x68
  jmp __alltraps
  102134:	e9 3d fc ff ff       	jmp    101d76 <__alltraps>

00102139 <vector105>:
.globl vector105
vector105:
  pushl $0
  102139:	6a 00                	push   $0x0
  pushl $105
  10213b:	6a 69                	push   $0x69
  jmp __alltraps
  10213d:	e9 34 fc ff ff       	jmp    101d76 <__alltraps>

00102142 <vector106>:
.globl vector106
vector106:
  pushl $0
  102142:	6a 00                	push   $0x0
  pushl $106
  102144:	6a 6a                	push   $0x6a
  jmp __alltraps
  102146:	e9 2b fc ff ff       	jmp    101d76 <__alltraps>

0010214b <vector107>:
.globl vector107
vector107:
  pushl $0
  10214b:	6a 00                	push   $0x0
  pushl $107
  10214d:	6a 6b                	push   $0x6b
  jmp __alltraps
  10214f:	e9 22 fc ff ff       	jmp    101d76 <__alltraps>

00102154 <vector108>:
.globl vector108
vector108:
  pushl $0
  102154:	6a 00                	push   $0x0
  pushl $108
  102156:	6a 6c                	push   $0x6c
  jmp __alltraps
  102158:	e9 19 fc ff ff       	jmp    101d76 <__alltraps>

0010215d <vector109>:
.globl vector109
vector109:
  pushl $0
  10215d:	6a 00                	push   $0x0
  pushl $109
  10215f:	6a 6d                	push   $0x6d
  jmp __alltraps
  102161:	e9 10 fc ff ff       	jmp    101d76 <__alltraps>

00102166 <vector110>:
.globl vector110
vector110:
  pushl $0
  102166:	6a 00                	push   $0x0
  pushl $110
  102168:	6a 6e                	push   $0x6e
  jmp __alltraps
  10216a:	e9 07 fc ff ff       	jmp    101d76 <__alltraps>

0010216f <vector111>:
.globl vector111
vector111:
  pushl $0
  10216f:	6a 00                	push   $0x0
  pushl $111
  102171:	6a 6f                	push   $0x6f
  jmp __alltraps
  102173:	e9 fe fb ff ff       	jmp    101d76 <__alltraps>

00102178 <vector112>:
.globl vector112
vector112:
  pushl $0
  102178:	6a 00                	push   $0x0
  pushl $112
  10217a:	6a 70                	push   $0x70
  jmp __alltraps
  10217c:	e9 f5 fb ff ff       	jmp    101d76 <__alltraps>

00102181 <vector113>:
.globl vector113
vector113:
  pushl $0
  102181:	6a 00                	push   $0x0
  pushl $113
  102183:	6a 71                	push   $0x71
  jmp __alltraps
  102185:	e9 ec fb ff ff       	jmp    101d76 <__alltraps>

0010218a <vector114>:
.globl vector114
vector114:
  pushl $0
  10218a:	6a 00                	push   $0x0
  pushl $114
  10218c:	6a 72                	push   $0x72
  jmp __alltraps
  10218e:	e9 e3 fb ff ff       	jmp    101d76 <__alltraps>

00102193 <vector115>:
.globl vector115
vector115:
  pushl $0
  102193:	6a 00                	push   $0x0
  pushl $115
  102195:	6a 73                	push   $0x73
  jmp __alltraps
  102197:	e9 da fb ff ff       	jmp    101d76 <__alltraps>

0010219c <vector116>:
.globl vector116
vector116:
  pushl $0
  10219c:	6a 00                	push   $0x0
  pushl $116
  10219e:	6a 74                	push   $0x74
  jmp __alltraps
  1021a0:	e9 d1 fb ff ff       	jmp    101d76 <__alltraps>

001021a5 <vector117>:
.globl vector117
vector117:
  pushl $0
  1021a5:	6a 00                	push   $0x0
  pushl $117
  1021a7:	6a 75                	push   $0x75
  jmp __alltraps
  1021a9:	e9 c8 fb ff ff       	jmp    101d76 <__alltraps>

001021ae <vector118>:
.globl vector118
vector118:
  pushl $0
  1021ae:	6a 00                	push   $0x0
  pushl $118
  1021b0:	6a 76                	push   $0x76
  jmp __alltraps
  1021b2:	e9 bf fb ff ff       	jmp    101d76 <__alltraps>

001021b7 <vector119>:
.globl vector119
vector119:
  pushl $0
  1021b7:	6a 00                	push   $0x0
  pushl $119
  1021b9:	6a 77                	push   $0x77
  jmp __alltraps
  1021bb:	e9 b6 fb ff ff       	jmp    101d76 <__alltraps>

001021c0 <vector120>:
.globl vector120
vector120:
  pushl $0
  1021c0:	6a 00                	push   $0x0
  pushl $120
  1021c2:	6a 78                	push   $0x78
  jmp __alltraps
  1021c4:	e9 ad fb ff ff       	jmp    101d76 <__alltraps>

001021c9 <vector121>:
.globl vector121
vector121:
  pushl $0
  1021c9:	6a 00                	push   $0x0
  pushl $121
  1021cb:	6a 79                	push   $0x79
  jmp __alltraps
  1021cd:	e9 a4 fb ff ff       	jmp    101d76 <__alltraps>

001021d2 <vector122>:
.globl vector122
vector122:
  pushl $0
  1021d2:	6a 00                	push   $0x0
  pushl $122
  1021d4:	6a 7a                	push   $0x7a
  jmp __alltraps
  1021d6:	e9 9b fb ff ff       	jmp    101d76 <__alltraps>

001021db <vector123>:
.globl vector123
vector123:
  pushl $0
  1021db:	6a 00                	push   $0x0
  pushl $123
  1021dd:	6a 7b                	push   $0x7b
  jmp __alltraps
  1021df:	e9 92 fb ff ff       	jmp    101d76 <__alltraps>

001021e4 <vector124>:
.globl vector124
vector124:
  pushl $0
  1021e4:	6a 00                	push   $0x0
  pushl $124
  1021e6:	6a 7c                	push   $0x7c
  jmp __alltraps
  1021e8:	e9 89 fb ff ff       	jmp    101d76 <__alltraps>

001021ed <vector125>:
.globl vector125
vector125:
  pushl $0
  1021ed:	6a 00                	push   $0x0
  pushl $125
  1021ef:	6a 7d                	push   $0x7d
  jmp __alltraps
  1021f1:	e9 80 fb ff ff       	jmp    101d76 <__alltraps>

001021f6 <vector126>:
.globl vector126
vector126:
  pushl $0
  1021f6:	6a 00                	push   $0x0
  pushl $126
  1021f8:	6a 7e                	push   $0x7e
  jmp __alltraps
  1021fa:	e9 77 fb ff ff       	jmp    101d76 <__alltraps>

001021ff <vector127>:
.globl vector127
vector127:
  pushl $0
  1021ff:	6a 00                	push   $0x0
  pushl $127
  102201:	6a 7f                	push   $0x7f
  jmp __alltraps
  102203:	e9 6e fb ff ff       	jmp    101d76 <__alltraps>

00102208 <vector128>:
.globl vector128
vector128:
  pushl $0
  102208:	6a 00                	push   $0x0
  pushl $128
  10220a:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10220f:	e9 62 fb ff ff       	jmp    101d76 <__alltraps>

00102214 <vector129>:
.globl vector129
vector129:
  pushl $0
  102214:	6a 00                	push   $0x0
  pushl $129
  102216:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10221b:	e9 56 fb ff ff       	jmp    101d76 <__alltraps>

00102220 <vector130>:
.globl vector130
vector130:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $130
  102222:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102227:	e9 4a fb ff ff       	jmp    101d76 <__alltraps>

0010222c <vector131>:
.globl vector131
vector131:
  pushl $0
  10222c:	6a 00                	push   $0x0
  pushl $131
  10222e:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102233:	e9 3e fb ff ff       	jmp    101d76 <__alltraps>

00102238 <vector132>:
.globl vector132
vector132:
  pushl $0
  102238:	6a 00                	push   $0x0
  pushl $132
  10223a:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10223f:	e9 32 fb ff ff       	jmp    101d76 <__alltraps>

00102244 <vector133>:
.globl vector133
vector133:
  pushl $0
  102244:	6a 00                	push   $0x0
  pushl $133
  102246:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10224b:	e9 26 fb ff ff       	jmp    101d76 <__alltraps>

00102250 <vector134>:
.globl vector134
vector134:
  pushl $0
  102250:	6a 00                	push   $0x0
  pushl $134
  102252:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102257:	e9 1a fb ff ff       	jmp    101d76 <__alltraps>

0010225c <vector135>:
.globl vector135
vector135:
  pushl $0
  10225c:	6a 00                	push   $0x0
  pushl $135
  10225e:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102263:	e9 0e fb ff ff       	jmp    101d76 <__alltraps>

00102268 <vector136>:
.globl vector136
vector136:
  pushl $0
  102268:	6a 00                	push   $0x0
  pushl $136
  10226a:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10226f:	e9 02 fb ff ff       	jmp    101d76 <__alltraps>

00102274 <vector137>:
.globl vector137
vector137:
  pushl $0
  102274:	6a 00                	push   $0x0
  pushl $137
  102276:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10227b:	e9 f6 fa ff ff       	jmp    101d76 <__alltraps>

00102280 <vector138>:
.globl vector138
vector138:
  pushl $0
  102280:	6a 00                	push   $0x0
  pushl $138
  102282:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102287:	e9 ea fa ff ff       	jmp    101d76 <__alltraps>

0010228c <vector139>:
.globl vector139
vector139:
  pushl $0
  10228c:	6a 00                	push   $0x0
  pushl $139
  10228e:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102293:	e9 de fa ff ff       	jmp    101d76 <__alltraps>

00102298 <vector140>:
.globl vector140
vector140:
  pushl $0
  102298:	6a 00                	push   $0x0
  pushl $140
  10229a:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10229f:	e9 d2 fa ff ff       	jmp    101d76 <__alltraps>

001022a4 <vector141>:
.globl vector141
vector141:
  pushl $0
  1022a4:	6a 00                	push   $0x0
  pushl $141
  1022a6:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1022ab:	e9 c6 fa ff ff       	jmp    101d76 <__alltraps>

001022b0 <vector142>:
.globl vector142
vector142:
  pushl $0
  1022b0:	6a 00                	push   $0x0
  pushl $142
  1022b2:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1022b7:	e9 ba fa ff ff       	jmp    101d76 <__alltraps>

001022bc <vector143>:
.globl vector143
vector143:
  pushl $0
  1022bc:	6a 00                	push   $0x0
  pushl $143
  1022be:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1022c3:	e9 ae fa ff ff       	jmp    101d76 <__alltraps>

001022c8 <vector144>:
.globl vector144
vector144:
  pushl $0
  1022c8:	6a 00                	push   $0x0
  pushl $144
  1022ca:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1022cf:	e9 a2 fa ff ff       	jmp    101d76 <__alltraps>

001022d4 <vector145>:
.globl vector145
vector145:
  pushl $0
  1022d4:	6a 00                	push   $0x0
  pushl $145
  1022d6:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1022db:	e9 96 fa ff ff       	jmp    101d76 <__alltraps>

001022e0 <vector146>:
.globl vector146
vector146:
  pushl $0
  1022e0:	6a 00                	push   $0x0
  pushl $146
  1022e2:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1022e7:	e9 8a fa ff ff       	jmp    101d76 <__alltraps>

001022ec <vector147>:
.globl vector147
vector147:
  pushl $0
  1022ec:	6a 00                	push   $0x0
  pushl $147
  1022ee:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1022f3:	e9 7e fa ff ff       	jmp    101d76 <__alltraps>

001022f8 <vector148>:
.globl vector148
vector148:
  pushl $0
  1022f8:	6a 00                	push   $0x0
  pushl $148
  1022fa:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1022ff:	e9 72 fa ff ff       	jmp    101d76 <__alltraps>

00102304 <vector149>:
.globl vector149
vector149:
  pushl $0
  102304:	6a 00                	push   $0x0
  pushl $149
  102306:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10230b:	e9 66 fa ff ff       	jmp    101d76 <__alltraps>

00102310 <vector150>:
.globl vector150
vector150:
  pushl $0
  102310:	6a 00                	push   $0x0
  pushl $150
  102312:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102317:	e9 5a fa ff ff       	jmp    101d76 <__alltraps>

0010231c <vector151>:
.globl vector151
vector151:
  pushl $0
  10231c:	6a 00                	push   $0x0
  pushl $151
  10231e:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102323:	e9 4e fa ff ff       	jmp    101d76 <__alltraps>

00102328 <vector152>:
.globl vector152
vector152:
  pushl $0
  102328:	6a 00                	push   $0x0
  pushl $152
  10232a:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10232f:	e9 42 fa ff ff       	jmp    101d76 <__alltraps>

00102334 <vector153>:
.globl vector153
vector153:
  pushl $0
  102334:	6a 00                	push   $0x0
  pushl $153
  102336:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10233b:	e9 36 fa ff ff       	jmp    101d76 <__alltraps>

00102340 <vector154>:
.globl vector154
vector154:
  pushl $0
  102340:	6a 00                	push   $0x0
  pushl $154
  102342:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102347:	e9 2a fa ff ff       	jmp    101d76 <__alltraps>

0010234c <vector155>:
.globl vector155
vector155:
  pushl $0
  10234c:	6a 00                	push   $0x0
  pushl $155
  10234e:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102353:	e9 1e fa ff ff       	jmp    101d76 <__alltraps>

00102358 <vector156>:
.globl vector156
vector156:
  pushl $0
  102358:	6a 00                	push   $0x0
  pushl $156
  10235a:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10235f:	e9 12 fa ff ff       	jmp    101d76 <__alltraps>

00102364 <vector157>:
.globl vector157
vector157:
  pushl $0
  102364:	6a 00                	push   $0x0
  pushl $157
  102366:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10236b:	e9 06 fa ff ff       	jmp    101d76 <__alltraps>

00102370 <vector158>:
.globl vector158
vector158:
  pushl $0
  102370:	6a 00                	push   $0x0
  pushl $158
  102372:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102377:	e9 fa f9 ff ff       	jmp    101d76 <__alltraps>

0010237c <vector159>:
.globl vector159
vector159:
  pushl $0
  10237c:	6a 00                	push   $0x0
  pushl $159
  10237e:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102383:	e9 ee f9 ff ff       	jmp    101d76 <__alltraps>

00102388 <vector160>:
.globl vector160
vector160:
  pushl $0
  102388:	6a 00                	push   $0x0
  pushl $160
  10238a:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10238f:	e9 e2 f9 ff ff       	jmp    101d76 <__alltraps>

00102394 <vector161>:
.globl vector161
vector161:
  pushl $0
  102394:	6a 00                	push   $0x0
  pushl $161
  102396:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10239b:	e9 d6 f9 ff ff       	jmp    101d76 <__alltraps>

001023a0 <vector162>:
.globl vector162
vector162:
  pushl $0
  1023a0:	6a 00                	push   $0x0
  pushl $162
  1023a2:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1023a7:	e9 ca f9 ff ff       	jmp    101d76 <__alltraps>

001023ac <vector163>:
.globl vector163
vector163:
  pushl $0
  1023ac:	6a 00                	push   $0x0
  pushl $163
  1023ae:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1023b3:	e9 be f9 ff ff       	jmp    101d76 <__alltraps>

001023b8 <vector164>:
.globl vector164
vector164:
  pushl $0
  1023b8:	6a 00                	push   $0x0
  pushl $164
  1023ba:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1023bf:	e9 b2 f9 ff ff       	jmp    101d76 <__alltraps>

001023c4 <vector165>:
.globl vector165
vector165:
  pushl $0
  1023c4:	6a 00                	push   $0x0
  pushl $165
  1023c6:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1023cb:	e9 a6 f9 ff ff       	jmp    101d76 <__alltraps>

001023d0 <vector166>:
.globl vector166
vector166:
  pushl $0
  1023d0:	6a 00                	push   $0x0
  pushl $166
  1023d2:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1023d7:	e9 9a f9 ff ff       	jmp    101d76 <__alltraps>

001023dc <vector167>:
.globl vector167
vector167:
  pushl $0
  1023dc:	6a 00                	push   $0x0
  pushl $167
  1023de:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1023e3:	e9 8e f9 ff ff       	jmp    101d76 <__alltraps>

001023e8 <vector168>:
.globl vector168
vector168:
  pushl $0
  1023e8:	6a 00                	push   $0x0
  pushl $168
  1023ea:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1023ef:	e9 82 f9 ff ff       	jmp    101d76 <__alltraps>

001023f4 <vector169>:
.globl vector169
vector169:
  pushl $0
  1023f4:	6a 00                	push   $0x0
  pushl $169
  1023f6:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1023fb:	e9 76 f9 ff ff       	jmp    101d76 <__alltraps>

00102400 <vector170>:
.globl vector170
vector170:
  pushl $0
  102400:	6a 00                	push   $0x0
  pushl $170
  102402:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102407:	e9 6a f9 ff ff       	jmp    101d76 <__alltraps>

0010240c <vector171>:
.globl vector171
vector171:
  pushl $0
  10240c:	6a 00                	push   $0x0
  pushl $171
  10240e:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102413:	e9 5e f9 ff ff       	jmp    101d76 <__alltraps>

00102418 <vector172>:
.globl vector172
vector172:
  pushl $0
  102418:	6a 00                	push   $0x0
  pushl $172
  10241a:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10241f:	e9 52 f9 ff ff       	jmp    101d76 <__alltraps>

00102424 <vector173>:
.globl vector173
vector173:
  pushl $0
  102424:	6a 00                	push   $0x0
  pushl $173
  102426:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10242b:	e9 46 f9 ff ff       	jmp    101d76 <__alltraps>

00102430 <vector174>:
.globl vector174
vector174:
  pushl $0
  102430:	6a 00                	push   $0x0
  pushl $174
  102432:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102437:	e9 3a f9 ff ff       	jmp    101d76 <__alltraps>

0010243c <vector175>:
.globl vector175
vector175:
  pushl $0
  10243c:	6a 00                	push   $0x0
  pushl $175
  10243e:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102443:	e9 2e f9 ff ff       	jmp    101d76 <__alltraps>

00102448 <vector176>:
.globl vector176
vector176:
  pushl $0
  102448:	6a 00                	push   $0x0
  pushl $176
  10244a:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10244f:	e9 22 f9 ff ff       	jmp    101d76 <__alltraps>

00102454 <vector177>:
.globl vector177
vector177:
  pushl $0
  102454:	6a 00                	push   $0x0
  pushl $177
  102456:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10245b:	e9 16 f9 ff ff       	jmp    101d76 <__alltraps>

00102460 <vector178>:
.globl vector178
vector178:
  pushl $0
  102460:	6a 00                	push   $0x0
  pushl $178
  102462:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102467:	e9 0a f9 ff ff       	jmp    101d76 <__alltraps>

0010246c <vector179>:
.globl vector179
vector179:
  pushl $0
  10246c:	6a 00                	push   $0x0
  pushl $179
  10246e:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102473:	e9 fe f8 ff ff       	jmp    101d76 <__alltraps>

00102478 <vector180>:
.globl vector180
vector180:
  pushl $0
  102478:	6a 00                	push   $0x0
  pushl $180
  10247a:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10247f:	e9 f2 f8 ff ff       	jmp    101d76 <__alltraps>

00102484 <vector181>:
.globl vector181
vector181:
  pushl $0
  102484:	6a 00                	push   $0x0
  pushl $181
  102486:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10248b:	e9 e6 f8 ff ff       	jmp    101d76 <__alltraps>

00102490 <vector182>:
.globl vector182
vector182:
  pushl $0
  102490:	6a 00                	push   $0x0
  pushl $182
  102492:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102497:	e9 da f8 ff ff       	jmp    101d76 <__alltraps>

0010249c <vector183>:
.globl vector183
vector183:
  pushl $0
  10249c:	6a 00                	push   $0x0
  pushl $183
  10249e:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1024a3:	e9 ce f8 ff ff       	jmp    101d76 <__alltraps>

001024a8 <vector184>:
.globl vector184
vector184:
  pushl $0
  1024a8:	6a 00                	push   $0x0
  pushl $184
  1024aa:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1024af:	e9 c2 f8 ff ff       	jmp    101d76 <__alltraps>

001024b4 <vector185>:
.globl vector185
vector185:
  pushl $0
  1024b4:	6a 00                	push   $0x0
  pushl $185
  1024b6:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1024bb:	e9 b6 f8 ff ff       	jmp    101d76 <__alltraps>

001024c0 <vector186>:
.globl vector186
vector186:
  pushl $0
  1024c0:	6a 00                	push   $0x0
  pushl $186
  1024c2:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1024c7:	e9 aa f8 ff ff       	jmp    101d76 <__alltraps>

001024cc <vector187>:
.globl vector187
vector187:
  pushl $0
  1024cc:	6a 00                	push   $0x0
  pushl $187
  1024ce:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1024d3:	e9 9e f8 ff ff       	jmp    101d76 <__alltraps>

001024d8 <vector188>:
.globl vector188
vector188:
  pushl $0
  1024d8:	6a 00                	push   $0x0
  pushl $188
  1024da:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1024df:	e9 92 f8 ff ff       	jmp    101d76 <__alltraps>

001024e4 <vector189>:
.globl vector189
vector189:
  pushl $0
  1024e4:	6a 00                	push   $0x0
  pushl $189
  1024e6:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1024eb:	e9 86 f8 ff ff       	jmp    101d76 <__alltraps>

001024f0 <vector190>:
.globl vector190
vector190:
  pushl $0
  1024f0:	6a 00                	push   $0x0
  pushl $190
  1024f2:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1024f7:	e9 7a f8 ff ff       	jmp    101d76 <__alltraps>

001024fc <vector191>:
.globl vector191
vector191:
  pushl $0
  1024fc:	6a 00                	push   $0x0
  pushl $191
  1024fe:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102503:	e9 6e f8 ff ff       	jmp    101d76 <__alltraps>

00102508 <vector192>:
.globl vector192
vector192:
  pushl $0
  102508:	6a 00                	push   $0x0
  pushl $192
  10250a:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10250f:	e9 62 f8 ff ff       	jmp    101d76 <__alltraps>

00102514 <vector193>:
.globl vector193
vector193:
  pushl $0
  102514:	6a 00                	push   $0x0
  pushl $193
  102516:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10251b:	e9 56 f8 ff ff       	jmp    101d76 <__alltraps>

00102520 <vector194>:
.globl vector194
vector194:
  pushl $0
  102520:	6a 00                	push   $0x0
  pushl $194
  102522:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102527:	e9 4a f8 ff ff       	jmp    101d76 <__alltraps>

0010252c <vector195>:
.globl vector195
vector195:
  pushl $0
  10252c:	6a 00                	push   $0x0
  pushl $195
  10252e:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102533:	e9 3e f8 ff ff       	jmp    101d76 <__alltraps>

00102538 <vector196>:
.globl vector196
vector196:
  pushl $0
  102538:	6a 00                	push   $0x0
  pushl $196
  10253a:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10253f:	e9 32 f8 ff ff       	jmp    101d76 <__alltraps>

00102544 <vector197>:
.globl vector197
vector197:
  pushl $0
  102544:	6a 00                	push   $0x0
  pushl $197
  102546:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10254b:	e9 26 f8 ff ff       	jmp    101d76 <__alltraps>

00102550 <vector198>:
.globl vector198
vector198:
  pushl $0
  102550:	6a 00                	push   $0x0
  pushl $198
  102552:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102557:	e9 1a f8 ff ff       	jmp    101d76 <__alltraps>

0010255c <vector199>:
.globl vector199
vector199:
  pushl $0
  10255c:	6a 00                	push   $0x0
  pushl $199
  10255e:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102563:	e9 0e f8 ff ff       	jmp    101d76 <__alltraps>

00102568 <vector200>:
.globl vector200
vector200:
  pushl $0
  102568:	6a 00                	push   $0x0
  pushl $200
  10256a:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10256f:	e9 02 f8 ff ff       	jmp    101d76 <__alltraps>

00102574 <vector201>:
.globl vector201
vector201:
  pushl $0
  102574:	6a 00                	push   $0x0
  pushl $201
  102576:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10257b:	e9 f6 f7 ff ff       	jmp    101d76 <__alltraps>

00102580 <vector202>:
.globl vector202
vector202:
  pushl $0
  102580:	6a 00                	push   $0x0
  pushl $202
  102582:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102587:	e9 ea f7 ff ff       	jmp    101d76 <__alltraps>

0010258c <vector203>:
.globl vector203
vector203:
  pushl $0
  10258c:	6a 00                	push   $0x0
  pushl $203
  10258e:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102593:	e9 de f7 ff ff       	jmp    101d76 <__alltraps>

00102598 <vector204>:
.globl vector204
vector204:
  pushl $0
  102598:	6a 00                	push   $0x0
  pushl $204
  10259a:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10259f:	e9 d2 f7 ff ff       	jmp    101d76 <__alltraps>

001025a4 <vector205>:
.globl vector205
vector205:
  pushl $0
  1025a4:	6a 00                	push   $0x0
  pushl $205
  1025a6:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1025ab:	e9 c6 f7 ff ff       	jmp    101d76 <__alltraps>

001025b0 <vector206>:
.globl vector206
vector206:
  pushl $0
  1025b0:	6a 00                	push   $0x0
  pushl $206
  1025b2:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1025b7:	e9 ba f7 ff ff       	jmp    101d76 <__alltraps>

001025bc <vector207>:
.globl vector207
vector207:
  pushl $0
  1025bc:	6a 00                	push   $0x0
  pushl $207
  1025be:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1025c3:	e9 ae f7 ff ff       	jmp    101d76 <__alltraps>

001025c8 <vector208>:
.globl vector208
vector208:
  pushl $0
  1025c8:	6a 00                	push   $0x0
  pushl $208
  1025ca:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1025cf:	e9 a2 f7 ff ff       	jmp    101d76 <__alltraps>

001025d4 <vector209>:
.globl vector209
vector209:
  pushl $0
  1025d4:	6a 00                	push   $0x0
  pushl $209
  1025d6:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1025db:	e9 96 f7 ff ff       	jmp    101d76 <__alltraps>

001025e0 <vector210>:
.globl vector210
vector210:
  pushl $0
  1025e0:	6a 00                	push   $0x0
  pushl $210
  1025e2:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1025e7:	e9 8a f7 ff ff       	jmp    101d76 <__alltraps>

001025ec <vector211>:
.globl vector211
vector211:
  pushl $0
  1025ec:	6a 00                	push   $0x0
  pushl $211
  1025ee:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1025f3:	e9 7e f7 ff ff       	jmp    101d76 <__alltraps>

001025f8 <vector212>:
.globl vector212
vector212:
  pushl $0
  1025f8:	6a 00                	push   $0x0
  pushl $212
  1025fa:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1025ff:	e9 72 f7 ff ff       	jmp    101d76 <__alltraps>

00102604 <vector213>:
.globl vector213
vector213:
  pushl $0
  102604:	6a 00                	push   $0x0
  pushl $213
  102606:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10260b:	e9 66 f7 ff ff       	jmp    101d76 <__alltraps>

00102610 <vector214>:
.globl vector214
vector214:
  pushl $0
  102610:	6a 00                	push   $0x0
  pushl $214
  102612:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102617:	e9 5a f7 ff ff       	jmp    101d76 <__alltraps>

0010261c <vector215>:
.globl vector215
vector215:
  pushl $0
  10261c:	6a 00                	push   $0x0
  pushl $215
  10261e:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102623:	e9 4e f7 ff ff       	jmp    101d76 <__alltraps>

00102628 <vector216>:
.globl vector216
vector216:
  pushl $0
  102628:	6a 00                	push   $0x0
  pushl $216
  10262a:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10262f:	e9 42 f7 ff ff       	jmp    101d76 <__alltraps>

00102634 <vector217>:
.globl vector217
vector217:
  pushl $0
  102634:	6a 00                	push   $0x0
  pushl $217
  102636:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10263b:	e9 36 f7 ff ff       	jmp    101d76 <__alltraps>

00102640 <vector218>:
.globl vector218
vector218:
  pushl $0
  102640:	6a 00                	push   $0x0
  pushl $218
  102642:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102647:	e9 2a f7 ff ff       	jmp    101d76 <__alltraps>

0010264c <vector219>:
.globl vector219
vector219:
  pushl $0
  10264c:	6a 00                	push   $0x0
  pushl $219
  10264e:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102653:	e9 1e f7 ff ff       	jmp    101d76 <__alltraps>

00102658 <vector220>:
.globl vector220
vector220:
  pushl $0
  102658:	6a 00                	push   $0x0
  pushl $220
  10265a:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10265f:	e9 12 f7 ff ff       	jmp    101d76 <__alltraps>

00102664 <vector221>:
.globl vector221
vector221:
  pushl $0
  102664:	6a 00                	push   $0x0
  pushl $221
  102666:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10266b:	e9 06 f7 ff ff       	jmp    101d76 <__alltraps>

00102670 <vector222>:
.globl vector222
vector222:
  pushl $0
  102670:	6a 00                	push   $0x0
  pushl $222
  102672:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102677:	e9 fa f6 ff ff       	jmp    101d76 <__alltraps>

0010267c <vector223>:
.globl vector223
vector223:
  pushl $0
  10267c:	6a 00                	push   $0x0
  pushl $223
  10267e:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102683:	e9 ee f6 ff ff       	jmp    101d76 <__alltraps>

00102688 <vector224>:
.globl vector224
vector224:
  pushl $0
  102688:	6a 00                	push   $0x0
  pushl $224
  10268a:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10268f:	e9 e2 f6 ff ff       	jmp    101d76 <__alltraps>

00102694 <vector225>:
.globl vector225
vector225:
  pushl $0
  102694:	6a 00                	push   $0x0
  pushl $225
  102696:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10269b:	e9 d6 f6 ff ff       	jmp    101d76 <__alltraps>

001026a0 <vector226>:
.globl vector226
vector226:
  pushl $0
  1026a0:	6a 00                	push   $0x0
  pushl $226
  1026a2:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1026a7:	e9 ca f6 ff ff       	jmp    101d76 <__alltraps>

001026ac <vector227>:
.globl vector227
vector227:
  pushl $0
  1026ac:	6a 00                	push   $0x0
  pushl $227
  1026ae:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1026b3:	e9 be f6 ff ff       	jmp    101d76 <__alltraps>

001026b8 <vector228>:
.globl vector228
vector228:
  pushl $0
  1026b8:	6a 00                	push   $0x0
  pushl $228
  1026ba:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1026bf:	e9 b2 f6 ff ff       	jmp    101d76 <__alltraps>

001026c4 <vector229>:
.globl vector229
vector229:
  pushl $0
  1026c4:	6a 00                	push   $0x0
  pushl $229
  1026c6:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1026cb:	e9 a6 f6 ff ff       	jmp    101d76 <__alltraps>

001026d0 <vector230>:
.globl vector230
vector230:
  pushl $0
  1026d0:	6a 00                	push   $0x0
  pushl $230
  1026d2:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1026d7:	e9 9a f6 ff ff       	jmp    101d76 <__alltraps>

001026dc <vector231>:
.globl vector231
vector231:
  pushl $0
  1026dc:	6a 00                	push   $0x0
  pushl $231
  1026de:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1026e3:	e9 8e f6 ff ff       	jmp    101d76 <__alltraps>

001026e8 <vector232>:
.globl vector232
vector232:
  pushl $0
  1026e8:	6a 00                	push   $0x0
  pushl $232
  1026ea:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1026ef:	e9 82 f6 ff ff       	jmp    101d76 <__alltraps>

001026f4 <vector233>:
.globl vector233
vector233:
  pushl $0
  1026f4:	6a 00                	push   $0x0
  pushl $233
  1026f6:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1026fb:	e9 76 f6 ff ff       	jmp    101d76 <__alltraps>

00102700 <vector234>:
.globl vector234
vector234:
  pushl $0
  102700:	6a 00                	push   $0x0
  pushl $234
  102702:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102707:	e9 6a f6 ff ff       	jmp    101d76 <__alltraps>

0010270c <vector235>:
.globl vector235
vector235:
  pushl $0
  10270c:	6a 00                	push   $0x0
  pushl $235
  10270e:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102713:	e9 5e f6 ff ff       	jmp    101d76 <__alltraps>

00102718 <vector236>:
.globl vector236
vector236:
  pushl $0
  102718:	6a 00                	push   $0x0
  pushl $236
  10271a:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10271f:	e9 52 f6 ff ff       	jmp    101d76 <__alltraps>

00102724 <vector237>:
.globl vector237
vector237:
  pushl $0
  102724:	6a 00                	push   $0x0
  pushl $237
  102726:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10272b:	e9 46 f6 ff ff       	jmp    101d76 <__alltraps>

00102730 <vector238>:
.globl vector238
vector238:
  pushl $0
  102730:	6a 00                	push   $0x0
  pushl $238
  102732:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102737:	e9 3a f6 ff ff       	jmp    101d76 <__alltraps>

0010273c <vector239>:
.globl vector239
vector239:
  pushl $0
  10273c:	6a 00                	push   $0x0
  pushl $239
  10273e:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102743:	e9 2e f6 ff ff       	jmp    101d76 <__alltraps>

00102748 <vector240>:
.globl vector240
vector240:
  pushl $0
  102748:	6a 00                	push   $0x0
  pushl $240
  10274a:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10274f:	e9 22 f6 ff ff       	jmp    101d76 <__alltraps>

00102754 <vector241>:
.globl vector241
vector241:
  pushl $0
  102754:	6a 00                	push   $0x0
  pushl $241
  102756:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10275b:	e9 16 f6 ff ff       	jmp    101d76 <__alltraps>

00102760 <vector242>:
.globl vector242
vector242:
  pushl $0
  102760:	6a 00                	push   $0x0
  pushl $242
  102762:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102767:	e9 0a f6 ff ff       	jmp    101d76 <__alltraps>

0010276c <vector243>:
.globl vector243
vector243:
  pushl $0
  10276c:	6a 00                	push   $0x0
  pushl $243
  10276e:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102773:	e9 fe f5 ff ff       	jmp    101d76 <__alltraps>

00102778 <vector244>:
.globl vector244
vector244:
  pushl $0
  102778:	6a 00                	push   $0x0
  pushl $244
  10277a:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10277f:	e9 f2 f5 ff ff       	jmp    101d76 <__alltraps>

00102784 <vector245>:
.globl vector245
vector245:
  pushl $0
  102784:	6a 00                	push   $0x0
  pushl $245
  102786:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10278b:	e9 e6 f5 ff ff       	jmp    101d76 <__alltraps>

00102790 <vector246>:
.globl vector246
vector246:
  pushl $0
  102790:	6a 00                	push   $0x0
  pushl $246
  102792:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102797:	e9 da f5 ff ff       	jmp    101d76 <__alltraps>

0010279c <vector247>:
.globl vector247
vector247:
  pushl $0
  10279c:	6a 00                	push   $0x0
  pushl $247
  10279e:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1027a3:	e9 ce f5 ff ff       	jmp    101d76 <__alltraps>

001027a8 <vector248>:
.globl vector248
vector248:
  pushl $0
  1027a8:	6a 00                	push   $0x0
  pushl $248
  1027aa:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1027af:	e9 c2 f5 ff ff       	jmp    101d76 <__alltraps>

001027b4 <vector249>:
.globl vector249
vector249:
  pushl $0
  1027b4:	6a 00                	push   $0x0
  pushl $249
  1027b6:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1027bb:	e9 b6 f5 ff ff       	jmp    101d76 <__alltraps>

001027c0 <vector250>:
.globl vector250
vector250:
  pushl $0
  1027c0:	6a 00                	push   $0x0
  pushl $250
  1027c2:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1027c7:	e9 aa f5 ff ff       	jmp    101d76 <__alltraps>

001027cc <vector251>:
.globl vector251
vector251:
  pushl $0
  1027cc:	6a 00                	push   $0x0
  pushl $251
  1027ce:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1027d3:	e9 9e f5 ff ff       	jmp    101d76 <__alltraps>

001027d8 <vector252>:
.globl vector252
vector252:
  pushl $0
  1027d8:	6a 00                	push   $0x0
  pushl $252
  1027da:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1027df:	e9 92 f5 ff ff       	jmp    101d76 <__alltraps>

001027e4 <vector253>:
.globl vector253
vector253:
  pushl $0
  1027e4:	6a 00                	push   $0x0
  pushl $253
  1027e6:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1027eb:	e9 86 f5 ff ff       	jmp    101d76 <__alltraps>

001027f0 <vector254>:
.globl vector254
vector254:
  pushl $0
  1027f0:	6a 00                	push   $0x0
  pushl $254
  1027f2:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1027f7:	e9 7a f5 ff ff       	jmp    101d76 <__alltraps>

001027fc <vector255>:
.globl vector255
vector255:
  pushl $0
  1027fc:	6a 00                	push   $0x0
  pushl $255
  1027fe:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102803:	e9 6e f5 ff ff       	jmp    101d76 <__alltraps>

00102808 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102808:	55                   	push   %ebp
  102809:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  10280b:	8b 45 08             	mov    0x8(%ebp),%eax
  10280e:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102811:	b8 23 00 00 00       	mov    $0x23,%eax
  102816:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102818:	b8 23 00 00 00       	mov    $0x23,%eax
  10281d:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  10281f:	b8 10 00 00 00       	mov    $0x10,%eax
  102824:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102826:	b8 10 00 00 00       	mov    $0x10,%eax
  10282b:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  10282d:	b8 10 00 00 00       	mov    $0x10,%eax
  102832:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102834:	ea 3b 28 10 00 08 00 	ljmp   $0x8,$0x10283b
}
  10283b:	5d                   	pop    %ebp
  10283c:	c3                   	ret    

0010283d <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  10283d:	55                   	push   %ebp
  10283e:	89 e5                	mov    %esp,%ebp
  102840:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102843:	b8 40 f9 10 00       	mov    $0x10f940,%eax
  102848:	05 00 04 00 00       	add    $0x400,%eax
  10284d:	a3 c4 f8 10 00       	mov    %eax,0x10f8c4
    ts.ts_ss0 = KERNEL_DS;
  102852:	66 c7 05 c8 f8 10 00 	movw   $0x10,0x10f8c8
  102859:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  10285b:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  102862:	68 00 
  102864:	b8 c0 f8 10 00       	mov    $0x10f8c0,%eax
  102869:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  10286f:	b8 c0 f8 10 00       	mov    $0x10f8c0,%eax
  102874:	c1 e8 10             	shr    $0x10,%eax
  102877:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  10287c:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102883:	83 e0 f0             	and    $0xfffffff0,%eax
  102886:	83 c8 09             	or     $0x9,%eax
  102889:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10288e:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102895:	83 c8 10             	or     $0x10,%eax
  102898:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10289d:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028a4:	83 e0 9f             	and    $0xffffff9f,%eax
  1028a7:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028ac:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028b3:	83 c8 80             	or     $0xffffff80,%eax
  1028b6:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028bb:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028c2:	83 e0 f0             	and    $0xfffffff0,%eax
  1028c5:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028ca:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028d1:	83 e0 ef             	and    $0xffffffef,%eax
  1028d4:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028d9:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028e0:	83 e0 df             	and    $0xffffffdf,%eax
  1028e3:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028e8:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028ef:	83 c8 40             	or     $0x40,%eax
  1028f2:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028f7:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028fe:	83 e0 7f             	and    $0x7f,%eax
  102901:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102906:	b8 c0 f8 10 00       	mov    $0x10f8c0,%eax
  10290b:	c1 e8 18             	shr    $0x18,%eax
  10290e:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102913:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10291a:	83 e0 ef             	and    $0xffffffef,%eax
  10291d:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102922:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  102929:	e8 da fe ff ff       	call   102808 <lgdt>
  10292e:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102934:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102938:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  10293b:	c9                   	leave  
  10293c:	c3                   	ret    

0010293d <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  10293d:	55                   	push   %ebp
  10293e:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102940:	e8 f8 fe ff ff       	call   10283d <gdt_init>
}
  102945:	5d                   	pop    %ebp
  102946:	c3                   	ret    

00102947 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102947:	55                   	push   %ebp
  102948:	89 e5                	mov    %esp,%ebp
  10294a:	83 ec 58             	sub    $0x58,%esp
  10294d:	8b 45 10             	mov    0x10(%ebp),%eax
  102950:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102953:	8b 45 14             	mov    0x14(%ebp),%eax
  102956:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102959:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10295c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10295f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102962:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102965:	8b 45 18             	mov    0x18(%ebp),%eax
  102968:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10296b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10296e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102971:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102974:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102977:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10297a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10297d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102981:	74 1c                	je     10299f <printnum+0x58>
  102983:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102986:	ba 00 00 00 00       	mov    $0x0,%edx
  10298b:	f7 75 e4             	divl   -0x1c(%ebp)
  10298e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102991:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102994:	ba 00 00 00 00       	mov    $0x0,%edx
  102999:	f7 75 e4             	divl   -0x1c(%ebp)
  10299c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10299f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1029a5:	f7 75 e4             	divl   -0x1c(%ebp)
  1029a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1029ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1029ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1029b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1029b7:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1029ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1029bd:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1029c0:	8b 45 18             	mov    0x18(%ebp),%eax
  1029c3:	ba 00 00 00 00       	mov    $0x0,%edx
  1029c8:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1029cb:	77 56                	ja     102a23 <printnum+0xdc>
  1029cd:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1029d0:	72 05                	jb     1029d7 <printnum+0x90>
  1029d2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1029d5:	77 4c                	ja     102a23 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1029d7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1029da:	8d 50 ff             	lea    -0x1(%eax),%edx
  1029dd:	8b 45 20             	mov    0x20(%ebp),%eax
  1029e0:	89 44 24 18          	mov    %eax,0x18(%esp)
  1029e4:	89 54 24 14          	mov    %edx,0x14(%esp)
  1029e8:	8b 45 18             	mov    0x18(%ebp),%eax
  1029eb:	89 44 24 10          	mov    %eax,0x10(%esp)
  1029ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1029f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1029f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1029f9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1029fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a00:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a04:	8b 45 08             	mov    0x8(%ebp),%eax
  102a07:	89 04 24             	mov    %eax,(%esp)
  102a0a:	e8 38 ff ff ff       	call   102947 <printnum>
  102a0f:	eb 1c                	jmp    102a2d <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102a11:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a14:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a18:	8b 45 20             	mov    0x20(%ebp),%eax
  102a1b:	89 04 24             	mov    %eax,(%esp)
  102a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a21:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102a23:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102a27:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102a2b:	7f e4                	jg     102a11 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102a2d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a30:	05 10 3c 10 00       	add    $0x103c10,%eax
  102a35:	0f b6 00             	movzbl (%eax),%eax
  102a38:	0f be c0             	movsbl %al,%eax
  102a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a3e:	89 54 24 04          	mov    %edx,0x4(%esp)
  102a42:	89 04 24             	mov    %eax,(%esp)
  102a45:	8b 45 08             	mov    0x8(%ebp),%eax
  102a48:	ff d0                	call   *%eax
}
  102a4a:	c9                   	leave  
  102a4b:	c3                   	ret    

00102a4c <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102a4c:	55                   	push   %ebp
  102a4d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102a4f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102a53:	7e 14                	jle    102a69 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102a55:	8b 45 08             	mov    0x8(%ebp),%eax
  102a58:	8b 00                	mov    (%eax),%eax
  102a5a:	8d 48 08             	lea    0x8(%eax),%ecx
  102a5d:	8b 55 08             	mov    0x8(%ebp),%edx
  102a60:	89 0a                	mov    %ecx,(%edx)
  102a62:	8b 50 04             	mov    0x4(%eax),%edx
  102a65:	8b 00                	mov    (%eax),%eax
  102a67:	eb 30                	jmp    102a99 <getuint+0x4d>
    }
    else if (lflag) {
  102a69:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a6d:	74 16                	je     102a85 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  102a72:	8b 00                	mov    (%eax),%eax
  102a74:	8d 48 04             	lea    0x4(%eax),%ecx
  102a77:	8b 55 08             	mov    0x8(%ebp),%edx
  102a7a:	89 0a                	mov    %ecx,(%edx)
  102a7c:	8b 00                	mov    (%eax),%eax
  102a7e:	ba 00 00 00 00       	mov    $0x0,%edx
  102a83:	eb 14                	jmp    102a99 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102a85:	8b 45 08             	mov    0x8(%ebp),%eax
  102a88:	8b 00                	mov    (%eax),%eax
  102a8a:	8d 48 04             	lea    0x4(%eax),%ecx
  102a8d:	8b 55 08             	mov    0x8(%ebp),%edx
  102a90:	89 0a                	mov    %ecx,(%edx)
  102a92:	8b 00                	mov    (%eax),%eax
  102a94:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102a99:	5d                   	pop    %ebp
  102a9a:	c3                   	ret    

00102a9b <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102a9b:	55                   	push   %ebp
  102a9c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102a9e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102aa2:	7e 14                	jle    102ab8 <getint+0x1d>
        return va_arg(*ap, long long);
  102aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa7:	8b 00                	mov    (%eax),%eax
  102aa9:	8d 48 08             	lea    0x8(%eax),%ecx
  102aac:	8b 55 08             	mov    0x8(%ebp),%edx
  102aaf:	89 0a                	mov    %ecx,(%edx)
  102ab1:	8b 50 04             	mov    0x4(%eax),%edx
  102ab4:	8b 00                	mov    (%eax),%eax
  102ab6:	eb 28                	jmp    102ae0 <getint+0x45>
    }
    else if (lflag) {
  102ab8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102abc:	74 12                	je     102ad0 <getint+0x35>
        return va_arg(*ap, long);
  102abe:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac1:	8b 00                	mov    (%eax),%eax
  102ac3:	8d 48 04             	lea    0x4(%eax),%ecx
  102ac6:	8b 55 08             	mov    0x8(%ebp),%edx
  102ac9:	89 0a                	mov    %ecx,(%edx)
  102acb:	8b 00                	mov    (%eax),%eax
  102acd:	99                   	cltd   
  102ace:	eb 10                	jmp    102ae0 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad3:	8b 00                	mov    (%eax),%eax
  102ad5:	8d 48 04             	lea    0x4(%eax),%ecx
  102ad8:	8b 55 08             	mov    0x8(%ebp),%edx
  102adb:	89 0a                	mov    %ecx,(%edx)
  102add:	8b 00                	mov    (%eax),%eax
  102adf:	99                   	cltd   
    }
}
  102ae0:	5d                   	pop    %ebp
  102ae1:	c3                   	ret    

00102ae2 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102ae2:	55                   	push   %ebp
  102ae3:	89 e5                	mov    %esp,%ebp
  102ae5:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102ae8:	8d 45 14             	lea    0x14(%ebp),%eax
  102aeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102af1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102af5:	8b 45 10             	mov    0x10(%ebp),%eax
  102af8:	89 44 24 08          	mov    %eax,0x8(%esp)
  102afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  102aff:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b03:	8b 45 08             	mov    0x8(%ebp),%eax
  102b06:	89 04 24             	mov    %eax,(%esp)
  102b09:	e8 02 00 00 00       	call   102b10 <vprintfmt>
    va_end(ap);
}
  102b0e:	c9                   	leave  
  102b0f:	c3                   	ret    

00102b10 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102b10:	55                   	push   %ebp
  102b11:	89 e5                	mov    %esp,%ebp
  102b13:	56                   	push   %esi
  102b14:	53                   	push   %ebx
  102b15:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b18:	eb 18                	jmp    102b32 <vprintfmt+0x22>
            if (ch == '\0') {
  102b1a:	85 db                	test   %ebx,%ebx
  102b1c:	75 05                	jne    102b23 <vprintfmt+0x13>
                return;
  102b1e:	e9 d1 03 00 00       	jmp    102ef4 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b26:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b2a:	89 1c 24             	mov    %ebx,(%esp)
  102b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  102b30:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b32:	8b 45 10             	mov    0x10(%ebp),%eax
  102b35:	8d 50 01             	lea    0x1(%eax),%edx
  102b38:	89 55 10             	mov    %edx,0x10(%ebp)
  102b3b:	0f b6 00             	movzbl (%eax),%eax
  102b3e:	0f b6 d8             	movzbl %al,%ebx
  102b41:	83 fb 25             	cmp    $0x25,%ebx
  102b44:	75 d4                	jne    102b1a <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102b46:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102b4a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102b51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b54:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102b57:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102b5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b61:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102b64:	8b 45 10             	mov    0x10(%ebp),%eax
  102b67:	8d 50 01             	lea    0x1(%eax),%edx
  102b6a:	89 55 10             	mov    %edx,0x10(%ebp)
  102b6d:	0f b6 00             	movzbl (%eax),%eax
  102b70:	0f b6 d8             	movzbl %al,%ebx
  102b73:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102b76:	83 f8 55             	cmp    $0x55,%eax
  102b79:	0f 87 44 03 00 00    	ja     102ec3 <vprintfmt+0x3b3>
  102b7f:	8b 04 85 34 3c 10 00 	mov    0x103c34(,%eax,4),%eax
  102b86:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102b88:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102b8c:	eb d6                	jmp    102b64 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102b8e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102b92:	eb d0                	jmp    102b64 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102b94:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102b9b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102b9e:	89 d0                	mov    %edx,%eax
  102ba0:	c1 e0 02             	shl    $0x2,%eax
  102ba3:	01 d0                	add    %edx,%eax
  102ba5:	01 c0                	add    %eax,%eax
  102ba7:	01 d8                	add    %ebx,%eax
  102ba9:	83 e8 30             	sub    $0x30,%eax
  102bac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102baf:	8b 45 10             	mov    0x10(%ebp),%eax
  102bb2:	0f b6 00             	movzbl (%eax),%eax
  102bb5:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102bb8:	83 fb 2f             	cmp    $0x2f,%ebx
  102bbb:	7e 0b                	jle    102bc8 <vprintfmt+0xb8>
  102bbd:	83 fb 39             	cmp    $0x39,%ebx
  102bc0:	7f 06                	jg     102bc8 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102bc2:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102bc6:	eb d3                	jmp    102b9b <vprintfmt+0x8b>
            goto process_precision;
  102bc8:	eb 33                	jmp    102bfd <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102bca:	8b 45 14             	mov    0x14(%ebp),%eax
  102bcd:	8d 50 04             	lea    0x4(%eax),%edx
  102bd0:	89 55 14             	mov    %edx,0x14(%ebp)
  102bd3:	8b 00                	mov    (%eax),%eax
  102bd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102bd8:	eb 23                	jmp    102bfd <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102bda:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102bde:	79 0c                	jns    102bec <vprintfmt+0xdc>
                width = 0;
  102be0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102be7:	e9 78 ff ff ff       	jmp    102b64 <vprintfmt+0x54>
  102bec:	e9 73 ff ff ff       	jmp    102b64 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102bf1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102bf8:	e9 67 ff ff ff       	jmp    102b64 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102bfd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102c01:	79 12                	jns    102c15 <vprintfmt+0x105>
                width = precision, precision = -1;
  102c03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c06:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102c09:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102c10:	e9 4f ff ff ff       	jmp    102b64 <vprintfmt+0x54>
  102c15:	e9 4a ff ff ff       	jmp    102b64 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102c1a:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102c1e:	e9 41 ff ff ff       	jmp    102b64 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102c23:	8b 45 14             	mov    0x14(%ebp),%eax
  102c26:	8d 50 04             	lea    0x4(%eax),%edx
  102c29:	89 55 14             	mov    %edx,0x14(%ebp)
  102c2c:	8b 00                	mov    (%eax),%eax
  102c2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c31:	89 54 24 04          	mov    %edx,0x4(%esp)
  102c35:	89 04 24             	mov    %eax,(%esp)
  102c38:	8b 45 08             	mov    0x8(%ebp),%eax
  102c3b:	ff d0                	call   *%eax
            break;
  102c3d:	e9 ac 02 00 00       	jmp    102eee <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102c42:	8b 45 14             	mov    0x14(%ebp),%eax
  102c45:	8d 50 04             	lea    0x4(%eax),%edx
  102c48:	89 55 14             	mov    %edx,0x14(%ebp)
  102c4b:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102c4d:	85 db                	test   %ebx,%ebx
  102c4f:	79 02                	jns    102c53 <vprintfmt+0x143>
                err = -err;
  102c51:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102c53:	83 fb 06             	cmp    $0x6,%ebx
  102c56:	7f 0b                	jg     102c63 <vprintfmt+0x153>
  102c58:	8b 34 9d f4 3b 10 00 	mov    0x103bf4(,%ebx,4),%esi
  102c5f:	85 f6                	test   %esi,%esi
  102c61:	75 23                	jne    102c86 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102c63:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102c67:	c7 44 24 08 21 3c 10 	movl   $0x103c21,0x8(%esp)
  102c6e:	00 
  102c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c72:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c76:	8b 45 08             	mov    0x8(%ebp),%eax
  102c79:	89 04 24             	mov    %eax,(%esp)
  102c7c:	e8 61 fe ff ff       	call   102ae2 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102c81:	e9 68 02 00 00       	jmp    102eee <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102c86:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102c8a:	c7 44 24 08 2a 3c 10 	movl   $0x103c2a,0x8(%esp)
  102c91:	00 
  102c92:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c95:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c99:	8b 45 08             	mov    0x8(%ebp),%eax
  102c9c:	89 04 24             	mov    %eax,(%esp)
  102c9f:	e8 3e fe ff ff       	call   102ae2 <printfmt>
            }
            break;
  102ca4:	e9 45 02 00 00       	jmp    102eee <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102ca9:	8b 45 14             	mov    0x14(%ebp),%eax
  102cac:	8d 50 04             	lea    0x4(%eax),%edx
  102caf:	89 55 14             	mov    %edx,0x14(%ebp)
  102cb2:	8b 30                	mov    (%eax),%esi
  102cb4:	85 f6                	test   %esi,%esi
  102cb6:	75 05                	jne    102cbd <vprintfmt+0x1ad>
                p = "(null)";
  102cb8:	be 2d 3c 10 00       	mov    $0x103c2d,%esi
            }
            if (width > 0 && padc != '-') {
  102cbd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102cc1:	7e 3e                	jle    102d01 <vprintfmt+0x1f1>
  102cc3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102cc7:	74 38                	je     102d01 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102cc9:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102ccc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cd3:	89 34 24             	mov    %esi,(%esp)
  102cd6:	e8 15 03 00 00       	call   102ff0 <strnlen>
  102cdb:	29 c3                	sub    %eax,%ebx
  102cdd:	89 d8                	mov    %ebx,%eax
  102cdf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102ce2:	eb 17                	jmp    102cfb <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102ce4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102ce8:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ceb:	89 54 24 04          	mov    %edx,0x4(%esp)
  102cef:	89 04 24             	mov    %eax,(%esp)
  102cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf5:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102cf7:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102cfb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102cff:	7f e3                	jg     102ce4 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102d01:	eb 38                	jmp    102d3b <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102d03:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102d07:	74 1f                	je     102d28 <vprintfmt+0x218>
  102d09:	83 fb 1f             	cmp    $0x1f,%ebx
  102d0c:	7e 05                	jle    102d13 <vprintfmt+0x203>
  102d0e:	83 fb 7e             	cmp    $0x7e,%ebx
  102d11:	7e 15                	jle    102d28 <vprintfmt+0x218>
                    putch('?', putdat);
  102d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d16:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d1a:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102d21:	8b 45 08             	mov    0x8(%ebp),%eax
  102d24:	ff d0                	call   *%eax
  102d26:	eb 0f                	jmp    102d37 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d2f:	89 1c 24             	mov    %ebx,(%esp)
  102d32:	8b 45 08             	mov    0x8(%ebp),%eax
  102d35:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102d37:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102d3b:	89 f0                	mov    %esi,%eax
  102d3d:	8d 70 01             	lea    0x1(%eax),%esi
  102d40:	0f b6 00             	movzbl (%eax),%eax
  102d43:	0f be d8             	movsbl %al,%ebx
  102d46:	85 db                	test   %ebx,%ebx
  102d48:	74 10                	je     102d5a <vprintfmt+0x24a>
  102d4a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d4e:	78 b3                	js     102d03 <vprintfmt+0x1f3>
  102d50:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102d54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d58:	79 a9                	jns    102d03 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102d5a:	eb 17                	jmp    102d73 <vprintfmt+0x263>
                putch(' ', putdat);
  102d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d63:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  102d6d:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102d6f:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102d73:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d77:	7f e3                	jg     102d5c <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102d79:	e9 70 01 00 00       	jmp    102eee <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102d7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d81:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d85:	8d 45 14             	lea    0x14(%ebp),%eax
  102d88:	89 04 24             	mov    %eax,(%esp)
  102d8b:	e8 0b fd ff ff       	call   102a9b <getint>
  102d90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d93:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d9c:	85 d2                	test   %edx,%edx
  102d9e:	79 26                	jns    102dc6 <vprintfmt+0x2b6>
                putch('-', putdat);
  102da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102da3:	89 44 24 04          	mov    %eax,0x4(%esp)
  102da7:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102dae:	8b 45 08             	mov    0x8(%ebp),%eax
  102db1:	ff d0                	call   *%eax
                num = -(long long)num;
  102db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102db6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102db9:	f7 d8                	neg    %eax
  102dbb:	83 d2 00             	adc    $0x0,%edx
  102dbe:	f7 da                	neg    %edx
  102dc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dc3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102dc6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102dcd:	e9 a8 00 00 00       	jmp    102e7a <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102dd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102dd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dd9:	8d 45 14             	lea    0x14(%ebp),%eax
  102ddc:	89 04 24             	mov    %eax,(%esp)
  102ddf:	e8 68 fc ff ff       	call   102a4c <getuint>
  102de4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102de7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102dea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102df1:	e9 84 00 00 00       	jmp    102e7a <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102df6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102df9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dfd:	8d 45 14             	lea    0x14(%ebp),%eax
  102e00:	89 04 24             	mov    %eax,(%esp)
  102e03:	e8 44 fc ff ff       	call   102a4c <getuint>
  102e08:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e0b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102e0e:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102e15:	eb 63                	jmp    102e7a <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e1e:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102e25:	8b 45 08             	mov    0x8(%ebp),%eax
  102e28:	ff d0                	call   *%eax
            putch('x', putdat);
  102e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e31:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102e38:	8b 45 08             	mov    0x8(%ebp),%eax
  102e3b:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102e3d:	8b 45 14             	mov    0x14(%ebp),%eax
  102e40:	8d 50 04             	lea    0x4(%eax),%edx
  102e43:	89 55 14             	mov    %edx,0x14(%ebp)
  102e46:	8b 00                	mov    (%eax),%eax
  102e48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102e52:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102e59:	eb 1f                	jmp    102e7a <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102e5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e62:	8d 45 14             	lea    0x14(%ebp),%eax
  102e65:	89 04 24             	mov    %eax,(%esp)
  102e68:	e8 df fb ff ff       	call   102a4c <getuint>
  102e6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e70:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102e73:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102e7a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102e7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e81:	89 54 24 18          	mov    %edx,0x18(%esp)
  102e85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102e88:	89 54 24 14          	mov    %edx,0x14(%esp)
  102e8c:	89 44 24 10          	mov    %eax,0x10(%esp)
  102e90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102e96:	89 44 24 08          	mov    %eax,0x8(%esp)
  102e9a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ea1:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea8:	89 04 24             	mov    %eax,(%esp)
  102eab:	e8 97 fa ff ff       	call   102947 <printnum>
            break;
  102eb0:	eb 3c                	jmp    102eee <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102eb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eb5:	89 44 24 04          	mov    %eax,0x4(%esp)
  102eb9:	89 1c 24             	mov    %ebx,(%esp)
  102ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  102ebf:	ff d0                	call   *%eax
            break;
  102ec1:	eb 2b                	jmp    102eee <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ec6:	89 44 24 04          	mov    %eax,0x4(%esp)
  102eca:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  102ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed4:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  102ed6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102eda:	eb 04                	jmp    102ee0 <vprintfmt+0x3d0>
  102edc:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102ee0:	8b 45 10             	mov    0x10(%ebp),%eax
  102ee3:	83 e8 01             	sub    $0x1,%eax
  102ee6:	0f b6 00             	movzbl (%eax),%eax
  102ee9:	3c 25                	cmp    $0x25,%al
  102eeb:	75 ef                	jne    102edc <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  102eed:	90                   	nop
        }
    }
  102eee:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102eef:	e9 3e fc ff ff       	jmp    102b32 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  102ef4:	83 c4 40             	add    $0x40,%esp
  102ef7:	5b                   	pop    %ebx
  102ef8:	5e                   	pop    %esi
  102ef9:	5d                   	pop    %ebp
  102efa:	c3                   	ret    

00102efb <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102efb:	55                   	push   %ebp
  102efc:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102efe:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f01:	8b 40 08             	mov    0x8(%eax),%eax
  102f04:	8d 50 01             	lea    0x1(%eax),%edx
  102f07:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f0a:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  102f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f10:	8b 10                	mov    (%eax),%edx
  102f12:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f15:	8b 40 04             	mov    0x4(%eax),%eax
  102f18:	39 c2                	cmp    %eax,%edx
  102f1a:	73 12                	jae    102f2e <sprintputch+0x33>
        *b->buf ++ = ch;
  102f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f1f:	8b 00                	mov    (%eax),%eax
  102f21:	8d 48 01             	lea    0x1(%eax),%ecx
  102f24:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f27:	89 0a                	mov    %ecx,(%edx)
  102f29:	8b 55 08             	mov    0x8(%ebp),%edx
  102f2c:	88 10                	mov    %dl,(%eax)
    }
}
  102f2e:	5d                   	pop    %ebp
  102f2f:	c3                   	ret    

00102f30 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  102f30:	55                   	push   %ebp
  102f31:	89 e5                	mov    %esp,%ebp
  102f33:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  102f36:	8d 45 14             	lea    0x14(%ebp),%eax
  102f39:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  102f3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f3f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f43:	8b 45 10             	mov    0x10(%ebp),%eax
  102f46:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f51:	8b 45 08             	mov    0x8(%ebp),%eax
  102f54:	89 04 24             	mov    %eax,(%esp)
  102f57:	e8 08 00 00 00       	call   102f64 <vsnprintf>
  102f5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  102f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102f62:	c9                   	leave  
  102f63:	c3                   	ret    

00102f64 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  102f64:	55                   	push   %ebp
  102f65:	89 e5                	mov    %esp,%ebp
  102f67:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  102f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  102f6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f70:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f73:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f76:	8b 45 08             	mov    0x8(%ebp),%eax
  102f79:	01 d0                	add    %edx,%eax
  102f7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  102f85:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102f89:	74 0a                	je     102f95 <vsnprintf+0x31>
  102f8b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102f8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f91:	39 c2                	cmp    %eax,%edx
  102f93:	76 07                	jbe    102f9c <vsnprintf+0x38>
        return -E_INVAL;
  102f95:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  102f9a:	eb 2a                	jmp    102fc6 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  102f9c:	8b 45 14             	mov    0x14(%ebp),%eax
  102f9f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102fa3:	8b 45 10             	mov    0x10(%ebp),%eax
  102fa6:	89 44 24 08          	mov    %eax,0x8(%esp)
  102faa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  102fad:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fb1:	c7 04 24 fb 2e 10 00 	movl   $0x102efb,(%esp)
  102fb8:	e8 53 fb ff ff       	call   102b10 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  102fbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fc0:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  102fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102fc6:	c9                   	leave  
  102fc7:	c3                   	ret    

00102fc8 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102fc8:	55                   	push   %ebp
  102fc9:	89 e5                	mov    %esp,%ebp
  102fcb:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102fce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102fd5:	eb 04                	jmp    102fdb <strlen+0x13>
        cnt ++;
  102fd7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  102fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  102fde:	8d 50 01             	lea    0x1(%eax),%edx
  102fe1:	89 55 08             	mov    %edx,0x8(%ebp)
  102fe4:	0f b6 00             	movzbl (%eax),%eax
  102fe7:	84 c0                	test   %al,%al
  102fe9:	75 ec                	jne    102fd7 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  102feb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102fee:	c9                   	leave  
  102fef:	c3                   	ret    

00102ff0 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102ff0:	55                   	push   %ebp
  102ff1:	89 e5                	mov    %esp,%ebp
  102ff3:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102ff6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102ffd:	eb 04                	jmp    103003 <strnlen+0x13>
        cnt ++;
  102fff:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  103003:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103006:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103009:	73 10                	jae    10301b <strnlen+0x2b>
  10300b:	8b 45 08             	mov    0x8(%ebp),%eax
  10300e:	8d 50 01             	lea    0x1(%eax),%edx
  103011:	89 55 08             	mov    %edx,0x8(%ebp)
  103014:	0f b6 00             	movzbl (%eax),%eax
  103017:	84 c0                	test   %al,%al
  103019:	75 e4                	jne    102fff <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  10301b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10301e:	c9                   	leave  
  10301f:	c3                   	ret    

00103020 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  103020:	55                   	push   %ebp
  103021:	89 e5                	mov    %esp,%ebp
  103023:	57                   	push   %edi
  103024:	56                   	push   %esi
  103025:	83 ec 20             	sub    $0x20,%esp
  103028:	8b 45 08             	mov    0x8(%ebp),%eax
  10302b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10302e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103031:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  103034:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10303a:	89 d1                	mov    %edx,%ecx
  10303c:	89 c2                	mov    %eax,%edx
  10303e:	89 ce                	mov    %ecx,%esi
  103040:	89 d7                	mov    %edx,%edi
  103042:	ac                   	lods   %ds:(%esi),%al
  103043:	aa                   	stos   %al,%es:(%edi)
  103044:	84 c0                	test   %al,%al
  103046:	75 fa                	jne    103042 <strcpy+0x22>
  103048:	89 fa                	mov    %edi,%edx
  10304a:	89 f1                	mov    %esi,%ecx
  10304c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10304f:	89 55 e8             	mov    %edx,-0x18(%ebp)
  103052:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  103055:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  103058:	83 c4 20             	add    $0x20,%esp
  10305b:	5e                   	pop    %esi
  10305c:	5f                   	pop    %edi
  10305d:	5d                   	pop    %ebp
  10305e:	c3                   	ret    

0010305f <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  10305f:	55                   	push   %ebp
  103060:	89 e5                	mov    %esp,%ebp
  103062:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  103065:	8b 45 08             	mov    0x8(%ebp),%eax
  103068:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  10306b:	eb 21                	jmp    10308e <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  10306d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103070:	0f b6 10             	movzbl (%eax),%edx
  103073:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103076:	88 10                	mov    %dl,(%eax)
  103078:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10307b:	0f b6 00             	movzbl (%eax),%eax
  10307e:	84 c0                	test   %al,%al
  103080:	74 04                	je     103086 <strncpy+0x27>
            src ++;
  103082:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  103086:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10308a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  10308e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103092:	75 d9                	jne    10306d <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  103094:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103097:	c9                   	leave  
  103098:	c3                   	ret    

00103099 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  103099:	55                   	push   %ebp
  10309a:	89 e5                	mov    %esp,%ebp
  10309c:	57                   	push   %edi
  10309d:	56                   	push   %esi
  10309e:	83 ec 20             	sub    $0x20,%esp
  1030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1030a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  1030ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1030b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030b3:	89 d1                	mov    %edx,%ecx
  1030b5:	89 c2                	mov    %eax,%edx
  1030b7:	89 ce                	mov    %ecx,%esi
  1030b9:	89 d7                	mov    %edx,%edi
  1030bb:	ac                   	lods   %ds:(%esi),%al
  1030bc:	ae                   	scas   %es:(%edi),%al
  1030bd:	75 08                	jne    1030c7 <strcmp+0x2e>
  1030bf:	84 c0                	test   %al,%al
  1030c1:	75 f8                	jne    1030bb <strcmp+0x22>
  1030c3:	31 c0                	xor    %eax,%eax
  1030c5:	eb 04                	jmp    1030cb <strcmp+0x32>
  1030c7:	19 c0                	sbb    %eax,%eax
  1030c9:	0c 01                	or     $0x1,%al
  1030cb:	89 fa                	mov    %edi,%edx
  1030cd:	89 f1                	mov    %esi,%ecx
  1030cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030d2:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1030d5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  1030d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1030db:	83 c4 20             	add    $0x20,%esp
  1030de:	5e                   	pop    %esi
  1030df:	5f                   	pop    %edi
  1030e0:	5d                   	pop    %ebp
  1030e1:	c3                   	ret    

001030e2 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1030e2:	55                   	push   %ebp
  1030e3:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1030e5:	eb 0c                	jmp    1030f3 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  1030e7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1030eb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1030ef:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1030f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030f7:	74 1a                	je     103113 <strncmp+0x31>
  1030f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1030fc:	0f b6 00             	movzbl (%eax),%eax
  1030ff:	84 c0                	test   %al,%al
  103101:	74 10                	je     103113 <strncmp+0x31>
  103103:	8b 45 08             	mov    0x8(%ebp),%eax
  103106:	0f b6 10             	movzbl (%eax),%edx
  103109:	8b 45 0c             	mov    0xc(%ebp),%eax
  10310c:	0f b6 00             	movzbl (%eax),%eax
  10310f:	38 c2                	cmp    %al,%dl
  103111:	74 d4                	je     1030e7 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  103113:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103117:	74 18                	je     103131 <strncmp+0x4f>
  103119:	8b 45 08             	mov    0x8(%ebp),%eax
  10311c:	0f b6 00             	movzbl (%eax),%eax
  10311f:	0f b6 d0             	movzbl %al,%edx
  103122:	8b 45 0c             	mov    0xc(%ebp),%eax
  103125:	0f b6 00             	movzbl (%eax),%eax
  103128:	0f b6 c0             	movzbl %al,%eax
  10312b:	29 c2                	sub    %eax,%edx
  10312d:	89 d0                	mov    %edx,%eax
  10312f:	eb 05                	jmp    103136 <strncmp+0x54>
  103131:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103136:	5d                   	pop    %ebp
  103137:	c3                   	ret    

00103138 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  103138:	55                   	push   %ebp
  103139:	89 e5                	mov    %esp,%ebp
  10313b:	83 ec 04             	sub    $0x4,%esp
  10313e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103141:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103144:	eb 14                	jmp    10315a <strchr+0x22>
        if (*s == c) {
  103146:	8b 45 08             	mov    0x8(%ebp),%eax
  103149:	0f b6 00             	movzbl (%eax),%eax
  10314c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  10314f:	75 05                	jne    103156 <strchr+0x1e>
            return (char *)s;
  103151:	8b 45 08             	mov    0x8(%ebp),%eax
  103154:	eb 13                	jmp    103169 <strchr+0x31>
        }
        s ++;
  103156:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  10315a:	8b 45 08             	mov    0x8(%ebp),%eax
  10315d:	0f b6 00             	movzbl (%eax),%eax
  103160:	84 c0                	test   %al,%al
  103162:	75 e2                	jne    103146 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  103164:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103169:	c9                   	leave  
  10316a:	c3                   	ret    

0010316b <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10316b:	55                   	push   %ebp
  10316c:	89 e5                	mov    %esp,%ebp
  10316e:	83 ec 04             	sub    $0x4,%esp
  103171:	8b 45 0c             	mov    0xc(%ebp),%eax
  103174:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103177:	eb 11                	jmp    10318a <strfind+0x1f>
        if (*s == c) {
  103179:	8b 45 08             	mov    0x8(%ebp),%eax
  10317c:	0f b6 00             	movzbl (%eax),%eax
  10317f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103182:	75 02                	jne    103186 <strfind+0x1b>
            break;
  103184:	eb 0e                	jmp    103194 <strfind+0x29>
        }
        s ++;
  103186:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  10318a:	8b 45 08             	mov    0x8(%ebp),%eax
  10318d:	0f b6 00             	movzbl (%eax),%eax
  103190:	84 c0                	test   %al,%al
  103192:	75 e5                	jne    103179 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  103194:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103197:	c9                   	leave  
  103198:	c3                   	ret    

00103199 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  103199:	55                   	push   %ebp
  10319a:	89 e5                	mov    %esp,%ebp
  10319c:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  10319f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1031a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1031ad:	eb 04                	jmp    1031b3 <strtol+0x1a>
        s ++;
  1031af:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1031b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b6:	0f b6 00             	movzbl (%eax),%eax
  1031b9:	3c 20                	cmp    $0x20,%al
  1031bb:	74 f2                	je     1031af <strtol+0x16>
  1031bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1031c0:	0f b6 00             	movzbl (%eax),%eax
  1031c3:	3c 09                	cmp    $0x9,%al
  1031c5:	74 e8                	je     1031af <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  1031c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ca:	0f b6 00             	movzbl (%eax),%eax
  1031cd:	3c 2b                	cmp    $0x2b,%al
  1031cf:	75 06                	jne    1031d7 <strtol+0x3e>
        s ++;
  1031d1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1031d5:	eb 15                	jmp    1031ec <strtol+0x53>
    }
    else if (*s == '-') {
  1031d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1031da:	0f b6 00             	movzbl (%eax),%eax
  1031dd:	3c 2d                	cmp    $0x2d,%al
  1031df:	75 0b                	jne    1031ec <strtol+0x53>
        s ++, neg = 1;
  1031e1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1031e5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1031ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031f0:	74 06                	je     1031f8 <strtol+0x5f>
  1031f2:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1031f6:	75 24                	jne    10321c <strtol+0x83>
  1031f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1031fb:	0f b6 00             	movzbl (%eax),%eax
  1031fe:	3c 30                	cmp    $0x30,%al
  103200:	75 1a                	jne    10321c <strtol+0x83>
  103202:	8b 45 08             	mov    0x8(%ebp),%eax
  103205:	83 c0 01             	add    $0x1,%eax
  103208:	0f b6 00             	movzbl (%eax),%eax
  10320b:	3c 78                	cmp    $0x78,%al
  10320d:	75 0d                	jne    10321c <strtol+0x83>
        s += 2, base = 16;
  10320f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  103213:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10321a:	eb 2a                	jmp    103246 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  10321c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103220:	75 17                	jne    103239 <strtol+0xa0>
  103222:	8b 45 08             	mov    0x8(%ebp),%eax
  103225:	0f b6 00             	movzbl (%eax),%eax
  103228:	3c 30                	cmp    $0x30,%al
  10322a:	75 0d                	jne    103239 <strtol+0xa0>
        s ++, base = 8;
  10322c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103230:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  103237:	eb 0d                	jmp    103246 <strtol+0xad>
    }
    else if (base == 0) {
  103239:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10323d:	75 07                	jne    103246 <strtol+0xad>
        base = 10;
  10323f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  103246:	8b 45 08             	mov    0x8(%ebp),%eax
  103249:	0f b6 00             	movzbl (%eax),%eax
  10324c:	3c 2f                	cmp    $0x2f,%al
  10324e:	7e 1b                	jle    10326b <strtol+0xd2>
  103250:	8b 45 08             	mov    0x8(%ebp),%eax
  103253:	0f b6 00             	movzbl (%eax),%eax
  103256:	3c 39                	cmp    $0x39,%al
  103258:	7f 11                	jg     10326b <strtol+0xd2>
            dig = *s - '0';
  10325a:	8b 45 08             	mov    0x8(%ebp),%eax
  10325d:	0f b6 00             	movzbl (%eax),%eax
  103260:	0f be c0             	movsbl %al,%eax
  103263:	83 e8 30             	sub    $0x30,%eax
  103266:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103269:	eb 48                	jmp    1032b3 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10326b:	8b 45 08             	mov    0x8(%ebp),%eax
  10326e:	0f b6 00             	movzbl (%eax),%eax
  103271:	3c 60                	cmp    $0x60,%al
  103273:	7e 1b                	jle    103290 <strtol+0xf7>
  103275:	8b 45 08             	mov    0x8(%ebp),%eax
  103278:	0f b6 00             	movzbl (%eax),%eax
  10327b:	3c 7a                	cmp    $0x7a,%al
  10327d:	7f 11                	jg     103290 <strtol+0xf7>
            dig = *s - 'a' + 10;
  10327f:	8b 45 08             	mov    0x8(%ebp),%eax
  103282:	0f b6 00             	movzbl (%eax),%eax
  103285:	0f be c0             	movsbl %al,%eax
  103288:	83 e8 57             	sub    $0x57,%eax
  10328b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10328e:	eb 23                	jmp    1032b3 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  103290:	8b 45 08             	mov    0x8(%ebp),%eax
  103293:	0f b6 00             	movzbl (%eax),%eax
  103296:	3c 40                	cmp    $0x40,%al
  103298:	7e 3d                	jle    1032d7 <strtol+0x13e>
  10329a:	8b 45 08             	mov    0x8(%ebp),%eax
  10329d:	0f b6 00             	movzbl (%eax),%eax
  1032a0:	3c 5a                	cmp    $0x5a,%al
  1032a2:	7f 33                	jg     1032d7 <strtol+0x13e>
            dig = *s - 'A' + 10;
  1032a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a7:	0f b6 00             	movzbl (%eax),%eax
  1032aa:	0f be c0             	movsbl %al,%eax
  1032ad:	83 e8 37             	sub    $0x37,%eax
  1032b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1032b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032b6:	3b 45 10             	cmp    0x10(%ebp),%eax
  1032b9:	7c 02                	jl     1032bd <strtol+0x124>
            break;
  1032bb:	eb 1a                	jmp    1032d7 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  1032bd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1032c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032c4:	0f af 45 10          	imul   0x10(%ebp),%eax
  1032c8:	89 c2                	mov    %eax,%edx
  1032ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032cd:	01 d0                	add    %edx,%eax
  1032cf:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  1032d2:	e9 6f ff ff ff       	jmp    103246 <strtol+0xad>

    if (endptr) {
  1032d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1032db:	74 08                	je     1032e5 <strtol+0x14c>
        *endptr = (char *) s;
  1032dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032e0:	8b 55 08             	mov    0x8(%ebp),%edx
  1032e3:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1032e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1032e9:	74 07                	je     1032f2 <strtol+0x159>
  1032eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032ee:	f7 d8                	neg    %eax
  1032f0:	eb 03                	jmp    1032f5 <strtol+0x15c>
  1032f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1032f5:	c9                   	leave  
  1032f6:	c3                   	ret    

001032f7 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1032f7:	55                   	push   %ebp
  1032f8:	89 e5                	mov    %esp,%ebp
  1032fa:	57                   	push   %edi
  1032fb:	83 ec 24             	sub    $0x24,%esp
  1032fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  103301:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  103304:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  103308:	8b 55 08             	mov    0x8(%ebp),%edx
  10330b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  10330e:	88 45 f7             	mov    %al,-0x9(%ebp)
  103311:	8b 45 10             	mov    0x10(%ebp),%eax
  103314:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  103317:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10331a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10331e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103321:	89 d7                	mov    %edx,%edi
  103323:	f3 aa                	rep stos %al,%es:(%edi)
  103325:	89 fa                	mov    %edi,%edx
  103327:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10332a:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  10332d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  103330:	83 c4 24             	add    $0x24,%esp
  103333:	5f                   	pop    %edi
  103334:	5d                   	pop    %ebp
  103335:	c3                   	ret    

00103336 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103336:	55                   	push   %ebp
  103337:	89 e5                	mov    %esp,%ebp
  103339:	57                   	push   %edi
  10333a:	56                   	push   %esi
  10333b:	53                   	push   %ebx
  10333c:	83 ec 30             	sub    $0x30,%esp
  10333f:	8b 45 08             	mov    0x8(%ebp),%eax
  103342:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103345:	8b 45 0c             	mov    0xc(%ebp),%eax
  103348:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10334b:	8b 45 10             	mov    0x10(%ebp),%eax
  10334e:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  103351:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103354:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103357:	73 42                	jae    10339b <memmove+0x65>
  103359:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10335c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10335f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103362:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103365:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103368:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10336b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10336e:	c1 e8 02             	shr    $0x2,%eax
  103371:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  103373:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103376:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103379:	89 d7                	mov    %edx,%edi
  10337b:	89 c6                	mov    %eax,%esi
  10337d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10337f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103382:	83 e1 03             	and    $0x3,%ecx
  103385:	74 02                	je     103389 <memmove+0x53>
  103387:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103389:	89 f0                	mov    %esi,%eax
  10338b:	89 fa                	mov    %edi,%edx
  10338d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  103390:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103393:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103396:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103399:	eb 36                	jmp    1033d1 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10339b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10339e:	8d 50 ff             	lea    -0x1(%eax),%edx
  1033a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033a4:	01 c2                	add    %eax,%edx
  1033a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033a9:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1033ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033af:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  1033b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033b5:	89 c1                	mov    %eax,%ecx
  1033b7:	89 d8                	mov    %ebx,%eax
  1033b9:	89 d6                	mov    %edx,%esi
  1033bb:	89 c7                	mov    %eax,%edi
  1033bd:	fd                   	std    
  1033be:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1033c0:	fc                   	cld    
  1033c1:	89 f8                	mov    %edi,%eax
  1033c3:	89 f2                	mov    %esi,%edx
  1033c5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1033c8:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1033cb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  1033ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1033d1:	83 c4 30             	add    $0x30,%esp
  1033d4:	5b                   	pop    %ebx
  1033d5:	5e                   	pop    %esi
  1033d6:	5f                   	pop    %edi
  1033d7:	5d                   	pop    %ebp
  1033d8:	c3                   	ret    

001033d9 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1033d9:	55                   	push   %ebp
  1033da:	89 e5                	mov    %esp,%ebp
  1033dc:	57                   	push   %edi
  1033dd:	56                   	push   %esi
  1033de:	83 ec 20             	sub    $0x20,%esp
  1033e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1033e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033ed:	8b 45 10             	mov    0x10(%ebp),%eax
  1033f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1033f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033f6:	c1 e8 02             	shr    $0x2,%eax
  1033f9:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1033fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1033fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103401:	89 d7                	mov    %edx,%edi
  103403:	89 c6                	mov    %eax,%esi
  103405:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103407:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10340a:	83 e1 03             	and    $0x3,%ecx
  10340d:	74 02                	je     103411 <memcpy+0x38>
  10340f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103411:	89 f0                	mov    %esi,%eax
  103413:	89 fa                	mov    %edi,%edx
  103415:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103418:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10341b:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  10341e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103421:	83 c4 20             	add    $0x20,%esp
  103424:	5e                   	pop    %esi
  103425:	5f                   	pop    %edi
  103426:	5d                   	pop    %ebp
  103427:	c3                   	ret    

00103428 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103428:	55                   	push   %ebp
  103429:	89 e5                	mov    %esp,%ebp
  10342b:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10342e:	8b 45 08             	mov    0x8(%ebp),%eax
  103431:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103434:	8b 45 0c             	mov    0xc(%ebp),%eax
  103437:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10343a:	eb 30                	jmp    10346c <memcmp+0x44>
        if (*s1 != *s2) {
  10343c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10343f:	0f b6 10             	movzbl (%eax),%edx
  103442:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103445:	0f b6 00             	movzbl (%eax),%eax
  103448:	38 c2                	cmp    %al,%dl
  10344a:	74 18                	je     103464 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  10344c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10344f:	0f b6 00             	movzbl (%eax),%eax
  103452:	0f b6 d0             	movzbl %al,%edx
  103455:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103458:	0f b6 00             	movzbl (%eax),%eax
  10345b:	0f b6 c0             	movzbl %al,%eax
  10345e:	29 c2                	sub    %eax,%edx
  103460:	89 d0                	mov    %edx,%eax
  103462:	eb 1a                	jmp    10347e <memcmp+0x56>
        }
        s1 ++, s2 ++;
  103464:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  103468:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  10346c:	8b 45 10             	mov    0x10(%ebp),%eax
  10346f:	8d 50 ff             	lea    -0x1(%eax),%edx
  103472:	89 55 10             	mov    %edx,0x10(%ebp)
  103475:	85 c0                	test   %eax,%eax
  103477:	75 c3                	jne    10343c <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  103479:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10347e:	c9                   	leave  
  10347f:	c3                   	ret    
