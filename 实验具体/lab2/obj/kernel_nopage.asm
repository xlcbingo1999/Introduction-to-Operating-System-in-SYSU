
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 88 89 11 00       	mov    $0x118988,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 ad 5d 00 00       	call   105e03 <memset>

    cons_init();                // init the console
  100056:	e8 6f 15 00 00       	call   1015ca <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 a0 5f 10 00 	movl   $0x105fa0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 bc 5f 10 00 	movl   $0x105fbc,(%esp)
  100070:	e8 c7 02 00 00       	call   10033c <cprintf>

    print_kerninfo();
  100075:	e8 f6 07 00 00       	call   100870 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 91 42 00 00       	call   104315 <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 aa 16 00 00       	call   101733 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 22 18 00 00       	call   1018b0 <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 ed 0c 00 00       	call   100d80 <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 09 16 00 00       	call   1016a1 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 f6 0b 00 00       	call   100cb2 <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 c1 5f 10 00 	movl   $0x105fc1,(%esp)
  10015c:	e8 db 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 cf 5f 10 00 	movl   $0x105fcf,(%esp)
  10017c:	e8 bb 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 dd 5f 10 00 	movl   $0x105fdd,(%esp)
  10019c:	e8 9b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 eb 5f 10 00 	movl   $0x105feb,(%esp)
  1001bc:	e8 7b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 f9 5f 10 00 	movl   $0x105ff9,(%esp)
  1001dc:	e8 5b 01 00 00       	call   10033c <cprintf>
    round ++;
  1001e1:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f3:	5d                   	pop    %ebp
  1001f4:	c3                   	ret    

001001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f5:	55                   	push   %ebp
  1001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	55                   	push   %ebp
  1001fb:	89 e5                	mov    %esp,%ebp
  1001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100200:	e8 25 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100205:	c7 04 24 08 60 10 00 	movl   $0x106008,(%esp)
  10020c:	e8 2b 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_user();
  100211:	e8 da ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100216:	e8 0f ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021b:	c7 04 24 28 60 10 00 	movl   $0x106028,(%esp)
  100222:	e8 15 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_kernel();
  100227:	e8 c9 ff ff ff       	call   1001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022c:	e8 f9 fe ff ff       	call   10012a <lab1_print_cur_status>
}
  100231:	c9                   	leave  
  100232:	c3                   	ret    

00100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100233:	55                   	push   %ebp
  100234:	89 e5                	mov    %esp,%ebp
  100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10023d:	74 13                	je     100252 <readline+0x1f>
        cprintf("%s", prompt);
  10023f:	8b 45 08             	mov    0x8(%ebp),%eax
  100242:	89 44 24 04          	mov    %eax,0x4(%esp)
  100246:	c7 04 24 47 60 10 00 	movl   $0x106047,(%esp)
  10024d:	e8 ea 00 00 00       	call   10033c <cprintf>
    }
    int i = 0, c;
  100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100259:	e8 66 01 00 00       	call   1003c4 <getchar>
  10025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100265:	79 07                	jns    10026e <readline+0x3b>
            return NULL;
  100267:	b8 00 00 00 00       	mov    $0x0,%eax
  10026c:	eb 79                	jmp    1002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100272:	7e 28                	jle    10029c <readline+0x69>
  100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10027b:	7f 1f                	jg     10029c <readline+0x69>
            cputchar(c);
  10027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100280:	89 04 24             	mov    %eax,(%esp)
  100283:	e8 da 00 00 00       	call   100362 <cputchar>
            buf[i ++] = c;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10028b:	8d 50 01             	lea    0x1(%eax),%edx
  10028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100294:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  10029a:	eb 46                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  10029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a0:	75 17                	jne    1002b9 <readline+0x86>
  1002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002a6:	7e 11                	jle    1002b9 <readline+0x86>
            cputchar(c);
  1002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ab:	89 04 24             	mov    %eax,(%esp)
  1002ae:	e8 af 00 00 00       	call   100362 <cputchar>
            i --;
  1002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002b7:	eb 29                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002bd:	74 06                	je     1002c5 <readline+0x92>
  1002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002c3:	75 1d                	jne    1002e2 <readline+0xaf>
            cputchar(c);
  1002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 92 00 00 00       	call   100362 <cputchar>
            buf[i] = '\0';
  1002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002d3:	05 60 7a 11 00       	add    $0x117a60,%eax
  1002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002db:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1002e0:	eb 05                	jmp    1002e7 <readline+0xb4>
        }
    }
  1002e2:	e9 72 ff ff ff       	jmp    100259 <readline+0x26>
}
  1002e7:	c9                   	leave  
  1002e8:	c3                   	ret    

001002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002e9:	55                   	push   %ebp
  1002ea:	89 e5                	mov    %esp,%ebp
  1002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f2:	89 04 24             	mov    %eax,(%esp)
  1002f5:	e8 fc 12 00 00       	call   1015f6 <cons_putc>
    (*cnt) ++;
  1002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fd:	8b 00                	mov    (%eax),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	8b 45 0c             	mov    0xc(%ebp),%eax
  100305:	89 10                	mov    %edx,(%eax)
}
  100307:	c9                   	leave  
  100308:	c3                   	ret    

00100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100309:	55                   	push   %ebp
  10030a:	89 e5                	mov    %esp,%ebp
  10030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100316:	8b 45 0c             	mov    0xc(%ebp),%eax
  100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10031d:	8b 45 08             	mov    0x8(%ebp),%eax
  100320:	89 44 24 08          	mov    %eax,0x8(%esp)
  100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100327:	89 44 24 04          	mov    %eax,0x4(%esp)
  10032b:	c7 04 24 e9 02 10 00 	movl   $0x1002e9,(%esp)
  100332:	e8 e5 52 00 00       	call   10561c <vprintfmt>
    return cnt;
  100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033a:	c9                   	leave  
  10033b:	c3                   	ret    

0010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10033c:	55                   	push   %ebp
  10033d:	89 e5                	mov    %esp,%ebp
  10033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100342:	8d 45 0c             	lea    0xc(%ebp),%eax
  100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034f:	8b 45 08             	mov    0x8(%ebp),%eax
  100352:	89 04 24             	mov    %eax,(%esp)
  100355:	e8 af ff ff ff       	call   100309 <vcprintf>
  10035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100360:	c9                   	leave  
  100361:	c3                   	ret    

00100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100362:	55                   	push   %ebp
  100363:	89 e5                	mov    %esp,%ebp
  100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100368:	8b 45 08             	mov    0x8(%ebp),%eax
  10036b:	89 04 24             	mov    %eax,(%esp)
  10036e:	e8 83 12 00 00       	call   1015f6 <cons_putc>
}
  100373:	c9                   	leave  
  100374:	c3                   	ret    

00100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100375:	55                   	push   %ebp
  100376:	89 e5                	mov    %esp,%ebp
  100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100382:	eb 13                	jmp    100397 <cputs+0x22>
        cputch(c, &cnt);
  100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10038b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10038f:	89 04 24             	mov    %eax,(%esp)
  100392:	e8 52 ff ff ff       	call   1002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100397:	8b 45 08             	mov    0x8(%ebp),%eax
  10039a:	8d 50 01             	lea    0x1(%eax),%edx
  10039d:	89 55 08             	mov    %edx,0x8(%ebp)
  1003a0:	0f b6 00             	movzbl (%eax),%eax
  1003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003aa:	75 d8                	jne    100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ba:	e8 2a ff ff ff       	call   1002e9 <cputch>
    return cnt;
  1003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003c2:	c9                   	leave  
  1003c3:	c3                   	ret    

001003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003c4:	55                   	push   %ebp
  1003c5:	89 e5                	mov    %esp,%ebp
  1003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003ca:	e8 63 12 00 00       	call   101632 <cons_getc>
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d6:	74 f2                	je     1003ca <getchar+0x6>
        /* do nothing */;
    return c;
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003db:	c9                   	leave  
  1003dc:	c3                   	ret    

001003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003dd:	55                   	push   %ebp
  1003de:	89 e5                	mov    %esp,%ebp
  1003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e6:	8b 00                	mov    (%eax),%eax
  1003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ee:	8b 00                	mov    (%eax),%eax
  1003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003fa:	e9 d2 00 00 00       	jmp    1004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100405:	01 d0                	add    %edx,%eax
  100407:	89 c2                	mov    %eax,%edx
  100409:	c1 ea 1f             	shr    $0x1f,%edx
  10040c:	01 d0                	add    %edx,%eax
  10040e:	d1 f8                	sar    %eax
  100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100419:	eb 04                	jmp    10041f <stab_binsearch+0x42>
            m --;
  10041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100425:	7c 1f                	jl     100446 <stab_binsearch+0x69>
  100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10042a:	89 d0                	mov    %edx,%eax
  10042c:	01 c0                	add    %eax,%eax
  10042e:	01 d0                	add    %edx,%eax
  100430:	c1 e0 02             	shl    $0x2,%eax
  100433:	89 c2                	mov    %eax,%edx
  100435:	8b 45 08             	mov    0x8(%ebp),%eax
  100438:	01 d0                	add    %edx,%eax
  10043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043e:	0f b6 c0             	movzbl %al,%eax
  100441:	3b 45 14             	cmp    0x14(%ebp),%eax
  100444:	75 d5                	jne    10041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10044c:	7d 0b                	jge    100459 <stab_binsearch+0x7c>
            l = true_m + 1;
  10044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100451:	83 c0 01             	add    $0x1,%eax
  100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100457:	eb 78                	jmp    1004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100463:	89 d0                	mov    %edx,%eax
  100465:	01 c0                	add    %eax,%eax
  100467:	01 d0                	add    %edx,%eax
  100469:	c1 e0 02             	shl    $0x2,%eax
  10046c:	89 c2                	mov    %eax,%edx
  10046e:	8b 45 08             	mov    0x8(%ebp),%eax
  100471:	01 d0                	add    %edx,%eax
  100473:	8b 40 08             	mov    0x8(%eax),%eax
  100476:	3b 45 18             	cmp    0x18(%ebp),%eax
  100479:	73 13                	jae    10048e <stab_binsearch+0xb1>
            *region_left = m;
  10047b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100486:	83 c0 01             	add    $0x1,%eax
  100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10048c:	eb 43                	jmp    1004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	89 d0                	mov    %edx,%eax
  100493:	01 c0                	add    %eax,%eax
  100495:	01 d0                	add    %edx,%eax
  100497:	c1 e0 02             	shl    $0x2,%eax
  10049a:	89 c2                	mov    %eax,%edx
  10049c:	8b 45 08             	mov    0x8(%ebp),%eax
  10049f:	01 d0                	add    %edx,%eax
  1004a1:	8b 40 08             	mov    0x8(%eax),%eax
  1004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004a7:	76 16                	jbe    1004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004af:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	83 e8 01             	sub    $0x1,%eax
  1004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004bd:	eb 12                	jmp    1004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004c5:	89 10                	mov    %edx,(%eax)
            l = m;
  1004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004d7:	0f 8e 22 ff ff ff    	jle    1003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e1:	75 0f                	jne    1004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e6:	8b 00                	mov    (%eax),%eax
  1004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ee:	89 10                	mov    %edx,(%eax)
  1004f0:	eb 3f                	jmp    100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f5:	8b 00                	mov    (%eax),%eax
  1004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004fa:	eb 04                	jmp    100500 <stab_binsearch+0x123>
  1004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 00                	mov    (%eax),%eax
  100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100508:	7d 1f                	jge    100529 <stab_binsearch+0x14c>
  10050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10050d:	89 d0                	mov    %edx,%eax
  10050f:	01 c0                	add    %eax,%eax
  100511:	01 d0                	add    %edx,%eax
  100513:	c1 e0 02             	shl    $0x2,%eax
  100516:	89 c2                	mov    %eax,%edx
  100518:	8b 45 08             	mov    0x8(%ebp),%eax
  10051b:	01 d0                	add    %edx,%eax
  10051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100521:	0f b6 c0             	movzbl %al,%eax
  100524:	3b 45 14             	cmp    0x14(%ebp),%eax
  100527:	75 d3                	jne    1004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100529:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10052f:	89 10                	mov    %edx,(%eax)
    }
}
  100531:	c9                   	leave  
  100532:	c3                   	ret    

00100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100533:	55                   	push   %ebp
  100534:	89 e5                	mov    %esp,%ebp
  100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053c:	c7 00 4c 60 10 00    	movl   $0x10604c,(%eax)
    info->eip_line = 0;
  100542:	8b 45 0c             	mov    0xc(%ebp),%eax
  100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054f:	c7 40 08 4c 60 10 00 	movl   $0x10604c,0x8(%eax)
    info->eip_fn_namelen = 9;
  100556:	8b 45 0c             	mov    0xc(%ebp),%eax
  100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	8b 55 08             	mov    0x8(%ebp),%edx
  100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100569:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100573:	c7 45 f4 a8 72 10 00 	movl   $0x1072a8,-0xc(%ebp)
    stab_end = __STAB_END__;
  10057a:	c7 45 f0 1c 1f 11 00 	movl   $0x111f1c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100581:	c7 45 ec 1d 1f 11 00 	movl   $0x111f1d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100588:	c7 45 e8 99 49 11 00 	movl   $0x114999,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100595:	76 0d                	jbe    1005a4 <debuginfo_eip+0x71>
  100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059a:	83 e8 01             	sub    $0x1,%eax
  10059d:	0f b6 00             	movzbl (%eax),%eax
  1005a0:	84 c0                	test   %al,%al
  1005a2:	74 0a                	je     1005ae <debuginfo_eip+0x7b>
        return -1;
  1005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005a9:	e9 c0 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005bb:	29 c2                	sub    %eax,%edx
  1005bd:	89 d0                	mov    %edx,%eax
  1005bf:	c1 f8 02             	sar    $0x2,%eax
  1005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005c8:	83 e8 01             	sub    $0x1,%eax
  1005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005dc:	00 
  1005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ee:	89 04 24             	mov    %eax,(%esp)
  1005f1:	e8 e7 fd ff ff       	call   1003dd <stab_binsearch>
    if (lfile == 0)
  1005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f9:	85 c0                	test   %eax,%eax
  1005fb:	75 0a                	jne    100607 <debuginfo_eip+0xd4>
        return -1;
  1005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100602:	e9 67 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100613:	8b 45 08             	mov    0x8(%ebp),%eax
  100616:	89 44 24 10          	mov    %eax,0x10(%esp)
  10061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100621:	00 
  100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100625:	89 44 24 08          	mov    %eax,0x8(%esp)
  100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100633:	89 04 24             	mov    %eax,(%esp)
  100636:	e8 a2 fd ff ff       	call   1003dd <stab_binsearch>

    if (lfun <= rfun) {
  10063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100641:	39 c2                	cmp    %eax,%edx
  100643:	7f 7c                	jg     1006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100648:	89 c2                	mov    %eax,%edx
  10064a:	89 d0                	mov    %edx,%eax
  10064c:	01 c0                	add    %eax,%eax
  10064e:	01 d0                	add    %edx,%eax
  100650:	c1 e0 02             	shl    $0x2,%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100658:	01 d0                	add    %edx,%eax
  10065a:	8b 10                	mov    (%eax),%edx
  10065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100662:	29 c1                	sub    %eax,%ecx
  100664:	89 c8                	mov    %ecx,%eax
  100666:	39 c2                	cmp    %eax,%edx
  100668:	73 22                	jae    10068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066d:	89 c2                	mov    %eax,%edx
  10066f:	89 d0                	mov    %edx,%eax
  100671:	01 c0                	add    %eax,%eax
  100673:	01 d0                	add    %edx,%eax
  100675:	c1 e0 02             	shl    $0x2,%eax
  100678:	89 c2                	mov    %eax,%edx
  10067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067d:	01 d0                	add    %edx,%eax
  10067f:	8b 10                	mov    (%eax),%edx
  100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100684:	01 c2                	add    %eax,%edx
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068f:	89 c2                	mov    %eax,%edx
  100691:	89 d0                	mov    %edx,%eax
  100693:	01 c0                	add    %eax,%eax
  100695:	01 d0                	add    %edx,%eax
  100697:	c1 e0 02             	shl    $0x2,%eax
  10069a:	89 c2                	mov    %eax,%edx
  10069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069f:	01 d0                	add    %edx,%eax
  1006a1:	8b 50 08             	mov    0x8(%eax),%edx
  1006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ad:	8b 40 10             	mov    0x10(%eax),%eax
  1006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006bf:	eb 15                	jmp    1006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d9:	8b 40 08             	mov    0x8(%eax),%eax
  1006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006e3:	00 
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 8b 55 00 00       	call   105c77 <strfind>
  1006ec:	89 c2                	mov    %eax,%edx
  1006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f1:	8b 40 08             	mov    0x8(%eax),%eax
  1006f4:	29 c2                	sub    %eax,%edx
  1006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10070a:	00 
  10070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10070e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100715:	89 44 24 04          	mov    %eax,0x4(%esp)
  100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071c:	89 04 24             	mov    %eax,(%esp)
  10071f:	e8 b9 fc ff ff       	call   1003dd <stab_binsearch>
    if (lline <= rline) {
  100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10072a:	39 c2                	cmp    %eax,%edx
  10072c:	7f 24                	jg     100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100731:	89 c2                	mov    %eax,%edx
  100733:	89 d0                	mov    %edx,%eax
  100735:	01 c0                	add    %eax,%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	c1 e0 02             	shl    $0x2,%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100741:	01 d0                	add    %edx,%eax
  100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100747:	0f b7 d0             	movzwl %ax,%edx
  10074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100750:	eb 13                	jmp    100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100757:	e9 12 01 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075f:	83 e8 01             	sub    $0x1,%eax
  100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10076b:	39 c2                	cmp    %eax,%edx
  10076d:	7c 56                	jl     1007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100772:	89 c2                	mov    %eax,%edx
  100774:	89 d0                	mov    %edx,%eax
  100776:	01 c0                	add    %eax,%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	c1 e0 02             	shl    $0x2,%eax
  10077d:	89 c2                	mov    %eax,%edx
  10077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100782:	01 d0                	add    %edx,%eax
  100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100788:	3c 84                	cmp    $0x84,%al
  10078a:	74 39                	je     1007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10078f:	89 c2                	mov    %eax,%edx
  100791:	89 d0                	mov    %edx,%eax
  100793:	01 c0                	add    %eax,%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	c1 e0 02             	shl    $0x2,%eax
  10079a:	89 c2                	mov    %eax,%edx
  10079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079f:	01 d0                	add    %edx,%eax
  1007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007a5:	3c 64                	cmp    $0x64,%al
  1007a7:	75 b3                	jne    10075c <debuginfo_eip+0x229>
  1007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ac:	89 c2                	mov    %eax,%edx
  1007ae:	89 d0                	mov    %edx,%eax
  1007b0:	01 c0                	add    %eax,%eax
  1007b2:	01 d0                	add    %edx,%eax
  1007b4:	c1 e0 02             	shl    $0x2,%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bc:	01 d0                	add    %edx,%eax
  1007be:	8b 40 08             	mov    0x8(%eax),%eax
  1007c1:	85 c0                	test   %eax,%eax
  1007c3:	74 97                	je     10075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007cb:	39 c2                	cmp    %eax,%edx
  1007cd:	7c 46                	jl     100815 <debuginfo_eip+0x2e2>
  1007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d2:	89 c2                	mov    %eax,%edx
  1007d4:	89 d0                	mov    %edx,%eax
  1007d6:	01 c0                	add    %eax,%eax
  1007d8:	01 d0                	add    %edx,%eax
  1007da:	c1 e0 02             	shl    $0x2,%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	8b 10                	mov    (%eax),%edx
  1007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007ec:	29 c1                	sub    %eax,%ecx
  1007ee:	89 c8                	mov    %ecx,%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	73 21                	jae    100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f7:	89 c2                	mov    %eax,%edx
  1007f9:	89 d0                	mov    %edx,%eax
  1007fb:	01 c0                	add    %eax,%eax
  1007fd:	01 d0                	add    %edx,%eax
  1007ff:	c1 e0 02             	shl    $0x2,%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100807:	01 d0                	add    %edx,%eax
  100809:	8b 10                	mov    (%eax),%edx
  10080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10080e:	01 c2                	add    %eax,%edx
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10081b:	39 c2                	cmp    %eax,%edx
  10081d:	7d 4a                	jge    100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100828:	eb 18                	jmp    100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10082a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082d:	8b 40 14             	mov    0x14(%eax),%eax
  100830:	8d 50 01             	lea    0x1(%eax),%edx
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083c:	83 c0 01             	add    $0x1,%eax
  10083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100848:	39 c2                	cmp    %eax,%edx
  10084a:	7d 1d                	jge    100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084f:	89 c2                	mov    %eax,%edx
  100851:	89 d0                	mov    %edx,%eax
  100853:	01 c0                	add    %eax,%eax
  100855:	01 d0                	add    %edx,%eax
  100857:	c1 e0 02             	shl    $0x2,%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085f:	01 d0                	add    %edx,%eax
  100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100865:	3c a0                	cmp    $0xa0,%al
  100867:	74 c1                	je     10082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10086e:	c9                   	leave  
  10086f:	c3                   	ret    

00100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100870:	55                   	push   %ebp
  100871:	89 e5                	mov    %esp,%ebp
  100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100876:	c7 04 24 56 60 10 00 	movl   $0x106056,(%esp)
  10087d:	e8 ba fa ff ff       	call   10033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100882:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100889:	00 
  10088a:	c7 04 24 6f 60 10 00 	movl   $0x10606f,(%esp)
  100891:	e8 a6 fa ff ff       	call   10033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100896:	c7 44 24 04 8c 5f 10 	movl   $0x105f8c,0x4(%esp)
  10089d:	00 
  10089e:	c7 04 24 87 60 10 00 	movl   $0x106087,(%esp)
  1008a5:	e8 92 fa ff ff       	call   10033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008aa:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008b1:	00 
  1008b2:	c7 04 24 9f 60 10 00 	movl   $0x10609f,(%esp)
  1008b9:	e8 7e fa ff ff       	call   10033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008be:	c7 44 24 04 88 89 11 	movl   $0x118988,0x4(%esp)
  1008c5:	00 
  1008c6:	c7 04 24 b7 60 10 00 	movl   $0x1060b7,(%esp)
  1008cd:	e8 6a fa ff ff       	call   10033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008d2:	b8 88 89 11 00       	mov    $0x118988,%eax
  1008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008dd:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008e2:	29 c2                	sub    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ec:	85 c0                	test   %eax,%eax
  1008ee:	0f 48 c2             	cmovs  %edx,%eax
  1008f1:	c1 f8 0a             	sar    $0xa,%eax
  1008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f8:	c7 04 24 d0 60 10 00 	movl   $0x1060d0,(%esp)
  1008ff:	e8 38 fa ff ff       	call   10033c <cprintf>
}
  100904:	c9                   	leave  
  100905:	c3                   	ret    

00100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100906:	55                   	push   %ebp
  100907:	89 e5                	mov    %esp,%ebp
  100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100912:	89 44 24 04          	mov    %eax,0x4(%esp)
  100916:	8b 45 08             	mov    0x8(%ebp),%eax
  100919:	89 04 24             	mov    %eax,(%esp)
  10091c:	e8 12 fc ff ff       	call   100533 <debuginfo_eip>
  100921:	85 c0                	test   %eax,%eax
  100923:	74 15                	je     10093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100925:	8b 45 08             	mov    0x8(%ebp),%eax
  100928:	89 44 24 04          	mov    %eax,0x4(%esp)
  10092c:	c7 04 24 fa 60 10 00 	movl   $0x1060fa,(%esp)
  100933:	e8 04 fa ff ff       	call   10033c <cprintf>
  100938:	eb 6d                	jmp    1009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100941:	eb 1c                	jmp    10095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100949:	01 d0                	add    %edx,%eax
  10094b:	0f b6 00             	movzbl (%eax),%eax
  10094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100957:	01 ca                	add    %ecx,%edx
  100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100965:	7f dc                	jg     100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100970:	01 d0                	add    %edx,%eax
  100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100978:	8b 55 08             	mov    0x8(%ebp),%edx
  10097b:	89 d1                	mov    %edx,%ecx
  10097d:	29 c1                	sub    %eax,%ecx
  10097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100993:	89 54 24 08          	mov    %edx,0x8(%esp)
  100997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099b:	c7 04 24 16 61 10 00 	movl   $0x106116,(%esp)
  1009a2:	e8 95 f9 ff ff       	call   10033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009af:	8b 45 04             	mov    0x4(%ebp),%eax
  1009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009b8:	c9                   	leave  
  1009b9:	c3                   	ret    

001009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009ba:	55                   	push   %ebp
  1009bb:	89 e5                	mov    %esp,%ebp
  1009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009c0:	89 e8                	mov    %ebp,%eax
  1009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp;
	uint32_t eip;
	ebp = read_ebp();
  1009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	eip = read_eip();
  1009cb:	e8 d9 ff ff ff       	call   1009a9 <read_eip>
  1009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i;
	int j;
	for(i = 0; i < STACKFRAME_DEPTH && ebp ; ++i){
  1009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009da:	e9 86 00 00 00       	jmp    100a65 <print_stackframe+0xab>
		cprintf("ebp:0x%08x eip:0x%08x args:",ebp,eip);
  1009df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ed:	c7 04 24 28 61 10 00 	movl   $0x106128,(%esp)
  1009f4:	e8 43 f9 ff ff       	call   10033c <cprintf>
		uint32_t *ebp_pointer = (uint32_t*)ebp;
  1009f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for(j = 0; j < 4; ++j){
  1009ff:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a06:	eb 28                	jmp    100a30 <print_stackframe+0x76>
			cprintf("0x%08x ",ebp_pointer[j+2]);
  100a08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a0b:	83 c0 02             	add    $0x2,%eax
  100a0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a18:	01 d0                	add    %edx,%eax
  100a1a:	8b 00                	mov    (%eax),%eax
  100a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a20:	c7 04 24 44 61 10 00 	movl   $0x106144,(%esp)
  100a27:	e8 10 f9 ff ff       	call   10033c <cprintf>
	int i;
	int j;
	for(i = 0; i < STACKFRAME_DEPTH && ebp ; ++i){
		cprintf("ebp:0x%08x eip:0x%08x args:",ebp,eip);
		uint32_t *ebp_pointer = (uint32_t*)ebp;
		for(j = 0; j < 4; ++j){
  100a2c:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a30:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a34:	7e d2                	jle    100a08 <print_stackframe+0x4e>
			cprintf("0x%08x ",ebp_pointer[j+2]);
		}
		cprintf("\n");
  100a36:	c7 04 24 4c 61 10 00 	movl   $0x10614c,(%esp)
  100a3d:	e8 fa f8 ff ff       	call   10033c <cprintf>
		print_debuginfo(eip-1);
  100a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a45:	83 e8 01             	sub    $0x1,%eax
  100a48:	89 04 24             	mov    %eax,(%esp)
  100a4b:	e8 b6 fe ff ff       	call   100906 <print_debuginfo>
		eip = ebp_pointer[1];
  100a50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a53:	8b 40 04             	mov    0x4(%eax),%eax
  100a56:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = ebp_pointer[0];
  100a59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a5c:	8b 00                	mov    (%eax),%eax
  100a5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip;
	ebp = read_ebp();
	eip = read_eip();
	int i;
	int j;
	for(i = 0; i < STACKFRAME_DEPTH && ebp ; ++i){
  100a61:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a65:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a69:	7f 0a                	jg     100a75 <print_stackframe+0xbb>
  100a6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a6f:	0f 85 6a ff ff ff    	jne    1009df <print_stackframe+0x25>
		cprintf("\n");
		print_debuginfo(eip-1);
		eip = ebp_pointer[1];
		ebp = ebp_pointer[0];
	}
}
  100a75:	c9                   	leave  
  100a76:	c3                   	ret    

00100a77 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a77:	55                   	push   %ebp
  100a78:	89 e5                	mov    %esp,%ebp
  100a7a:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a84:	eb 0c                	jmp    100a92 <parse+0x1b>
            *buf ++ = '\0';
  100a86:	8b 45 08             	mov    0x8(%ebp),%eax
  100a89:	8d 50 01             	lea    0x1(%eax),%edx
  100a8c:	89 55 08             	mov    %edx,0x8(%ebp)
  100a8f:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a92:	8b 45 08             	mov    0x8(%ebp),%eax
  100a95:	0f b6 00             	movzbl (%eax),%eax
  100a98:	84 c0                	test   %al,%al
  100a9a:	74 1d                	je     100ab9 <parse+0x42>
  100a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9f:	0f b6 00             	movzbl (%eax),%eax
  100aa2:	0f be c0             	movsbl %al,%eax
  100aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aa9:	c7 04 24 d0 61 10 00 	movl   $0x1061d0,(%esp)
  100ab0:	e8 8f 51 00 00       	call   105c44 <strchr>
  100ab5:	85 c0                	test   %eax,%eax
  100ab7:	75 cd                	jne    100a86 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  100abc:	0f b6 00             	movzbl (%eax),%eax
  100abf:	84 c0                	test   %al,%al
  100ac1:	75 02                	jne    100ac5 <parse+0x4e>
            break;
  100ac3:	eb 67                	jmp    100b2c <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ac5:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ac9:	75 14                	jne    100adf <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100acb:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ad2:	00 
  100ad3:	c7 04 24 d5 61 10 00 	movl   $0x1061d5,(%esp)
  100ada:	e8 5d f8 ff ff       	call   10033c <cprintf>
        }
        argv[argc ++] = buf;
  100adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae2:	8d 50 01             	lea    0x1(%eax),%edx
  100ae5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ae8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  100af2:	01 c2                	add    %eax,%edx
  100af4:	8b 45 08             	mov    0x8(%ebp),%eax
  100af7:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100af9:	eb 04                	jmp    100aff <parse+0x88>
            buf ++;
  100afb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100aff:	8b 45 08             	mov    0x8(%ebp),%eax
  100b02:	0f b6 00             	movzbl (%eax),%eax
  100b05:	84 c0                	test   %al,%al
  100b07:	74 1d                	je     100b26 <parse+0xaf>
  100b09:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0c:	0f b6 00             	movzbl (%eax),%eax
  100b0f:	0f be c0             	movsbl %al,%eax
  100b12:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b16:	c7 04 24 d0 61 10 00 	movl   $0x1061d0,(%esp)
  100b1d:	e8 22 51 00 00       	call   105c44 <strchr>
  100b22:	85 c0                	test   %eax,%eax
  100b24:	74 d5                	je     100afb <parse+0x84>
            buf ++;
        }
    }
  100b26:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b27:	e9 66 ff ff ff       	jmp    100a92 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b2f:	c9                   	leave  
  100b30:	c3                   	ret    

00100b31 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b31:	55                   	push   %ebp
  100b32:	89 e5                	mov    %esp,%ebp
  100b34:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b37:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b41:	89 04 24             	mov    %eax,(%esp)
  100b44:	e8 2e ff ff ff       	call   100a77 <parse>
  100b49:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b50:	75 0a                	jne    100b5c <runcmd+0x2b>
        return 0;
  100b52:	b8 00 00 00 00       	mov    $0x0,%eax
  100b57:	e9 85 00 00 00       	jmp    100be1 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b63:	eb 5c                	jmp    100bc1 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b65:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b6b:	89 d0                	mov    %edx,%eax
  100b6d:	01 c0                	add    %eax,%eax
  100b6f:	01 d0                	add    %edx,%eax
  100b71:	c1 e0 02             	shl    $0x2,%eax
  100b74:	05 20 70 11 00       	add    $0x117020,%eax
  100b79:	8b 00                	mov    (%eax),%eax
  100b7b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b7f:	89 04 24             	mov    %eax,(%esp)
  100b82:	e8 1e 50 00 00       	call   105ba5 <strcmp>
  100b87:	85 c0                	test   %eax,%eax
  100b89:	75 32                	jne    100bbd <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b8e:	89 d0                	mov    %edx,%eax
  100b90:	01 c0                	add    %eax,%eax
  100b92:	01 d0                	add    %edx,%eax
  100b94:	c1 e0 02             	shl    $0x2,%eax
  100b97:	05 20 70 11 00       	add    $0x117020,%eax
  100b9c:	8b 40 08             	mov    0x8(%eax),%eax
  100b9f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100ba2:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100ba5:	8b 55 0c             	mov    0xc(%ebp),%edx
  100ba8:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bac:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100baf:	83 c2 04             	add    $0x4,%edx
  100bb2:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bb6:	89 0c 24             	mov    %ecx,(%esp)
  100bb9:	ff d0                	call   *%eax
  100bbb:	eb 24                	jmp    100be1 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bbd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bc4:	83 f8 02             	cmp    $0x2,%eax
  100bc7:	76 9c                	jbe    100b65 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bc9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd0:	c7 04 24 f3 61 10 00 	movl   $0x1061f3,(%esp)
  100bd7:	e8 60 f7 ff ff       	call   10033c <cprintf>
    return 0;
  100bdc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100be1:	c9                   	leave  
  100be2:	c3                   	ret    

00100be3 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100be3:	55                   	push   %ebp
  100be4:	89 e5                	mov    %esp,%ebp
  100be6:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100be9:	c7 04 24 0c 62 10 00 	movl   $0x10620c,(%esp)
  100bf0:	e8 47 f7 ff ff       	call   10033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bf5:	c7 04 24 34 62 10 00 	movl   $0x106234,(%esp)
  100bfc:	e8 3b f7 ff ff       	call   10033c <cprintf>

    if (tf != NULL) {
  100c01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c05:	74 0b                	je     100c12 <kmonitor+0x2f>
        print_trapframe(tf);
  100c07:	8b 45 08             	mov    0x8(%ebp),%eax
  100c0a:	89 04 24             	mov    %eax,(%esp)
  100c0d:	e8 56 0e 00 00       	call   101a68 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c12:	c7 04 24 59 62 10 00 	movl   $0x106259,(%esp)
  100c19:	e8 15 f6 ff ff       	call   100233 <readline>
  100c1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c25:	74 18                	je     100c3f <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c27:	8b 45 08             	mov    0x8(%ebp),%eax
  100c2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c31:	89 04 24             	mov    %eax,(%esp)
  100c34:	e8 f8 fe ff ff       	call   100b31 <runcmd>
  100c39:	85 c0                	test   %eax,%eax
  100c3b:	79 02                	jns    100c3f <kmonitor+0x5c>
                break;
  100c3d:	eb 02                	jmp    100c41 <kmonitor+0x5e>
            }
        }
    }
  100c3f:	eb d1                	jmp    100c12 <kmonitor+0x2f>
}
  100c41:	c9                   	leave  
  100c42:	c3                   	ret    

00100c43 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c43:	55                   	push   %ebp
  100c44:	89 e5                	mov    %esp,%ebp
  100c46:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c50:	eb 3f                	jmp    100c91 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c55:	89 d0                	mov    %edx,%eax
  100c57:	01 c0                	add    %eax,%eax
  100c59:	01 d0                	add    %edx,%eax
  100c5b:	c1 e0 02             	shl    $0x2,%eax
  100c5e:	05 20 70 11 00       	add    $0x117020,%eax
  100c63:	8b 48 04             	mov    0x4(%eax),%ecx
  100c66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c69:	89 d0                	mov    %edx,%eax
  100c6b:	01 c0                	add    %eax,%eax
  100c6d:	01 d0                	add    %edx,%eax
  100c6f:	c1 e0 02             	shl    $0x2,%eax
  100c72:	05 20 70 11 00       	add    $0x117020,%eax
  100c77:	8b 00                	mov    (%eax),%eax
  100c79:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c81:	c7 04 24 5d 62 10 00 	movl   $0x10625d,(%esp)
  100c88:	e8 af f6 ff ff       	call   10033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c8d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c94:	83 f8 02             	cmp    $0x2,%eax
  100c97:	76 b9                	jbe    100c52 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c9e:	c9                   	leave  
  100c9f:	c3                   	ret    

00100ca0 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100ca0:	55                   	push   %ebp
  100ca1:	89 e5                	mov    %esp,%ebp
  100ca3:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100ca6:	e8 c5 fb ff ff       	call   100870 <print_kerninfo>
    return 0;
  100cab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb0:	c9                   	leave  
  100cb1:	c3                   	ret    

00100cb2 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cb2:	55                   	push   %ebp
  100cb3:	89 e5                	mov    %esp,%ebp
  100cb5:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cb8:	e8 fd fc ff ff       	call   1009ba <print_stackframe>
    return 0;
  100cbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cc2:	c9                   	leave  
  100cc3:	c3                   	ret    

00100cc4 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cc4:	55                   	push   %ebp
  100cc5:	89 e5                	mov    %esp,%ebp
  100cc7:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cca:	a1 60 7e 11 00       	mov    0x117e60,%eax
  100ccf:	85 c0                	test   %eax,%eax
  100cd1:	74 02                	je     100cd5 <__panic+0x11>
        goto panic_dead;
  100cd3:	eb 48                	jmp    100d1d <__panic+0x59>
    }
    is_panic = 1;
  100cd5:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100cdc:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cdf:	8d 45 14             	lea    0x14(%ebp),%eax
  100ce2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100ce5:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ce8:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cec:	8b 45 08             	mov    0x8(%ebp),%eax
  100cef:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cf3:	c7 04 24 66 62 10 00 	movl   $0x106266,(%esp)
  100cfa:	e8 3d f6 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d02:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d06:	8b 45 10             	mov    0x10(%ebp),%eax
  100d09:	89 04 24             	mov    %eax,(%esp)
  100d0c:	e8 f8 f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d11:	c7 04 24 82 62 10 00 	movl   $0x106282,(%esp)
  100d18:	e8 1f f6 ff ff       	call   10033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d1d:	e8 85 09 00 00       	call   1016a7 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d22:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d29:	e8 b5 fe ff ff       	call   100be3 <kmonitor>
    }
  100d2e:	eb f2                	jmp    100d22 <__panic+0x5e>

00100d30 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d30:	55                   	push   %ebp
  100d31:	89 e5                	mov    %esp,%ebp
  100d33:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d36:	8d 45 14             	lea    0x14(%ebp),%eax
  100d39:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d3f:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d43:	8b 45 08             	mov    0x8(%ebp),%eax
  100d46:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d4a:	c7 04 24 84 62 10 00 	movl   $0x106284,(%esp)
  100d51:	e8 e6 f5 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d59:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d5d:	8b 45 10             	mov    0x10(%ebp),%eax
  100d60:	89 04 24             	mov    %eax,(%esp)
  100d63:	e8 a1 f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d68:	c7 04 24 82 62 10 00 	movl   $0x106282,(%esp)
  100d6f:	e8 c8 f5 ff ff       	call   10033c <cprintf>
    va_end(ap);
}
  100d74:	c9                   	leave  
  100d75:	c3                   	ret    

00100d76 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d76:	55                   	push   %ebp
  100d77:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d79:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100d7e:	5d                   	pop    %ebp
  100d7f:	c3                   	ret    

00100d80 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d80:	55                   	push   %ebp
  100d81:	89 e5                	mov    %esp,%ebp
  100d83:	83 ec 28             	sub    $0x28,%esp
  100d86:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d8c:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d90:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d94:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d98:	ee                   	out    %al,(%dx)
  100d99:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d9f:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100da3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100da7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dab:	ee                   	out    %al,(%dx)
  100dac:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100db2:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100db6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dba:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dbe:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dbf:	c7 05 6c 89 11 00 00 	movl   $0x0,0x11896c
  100dc6:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dc9:	c7 04 24 a2 62 10 00 	movl   $0x1062a2,(%esp)
  100dd0:	e8 67 f5 ff ff       	call   10033c <cprintf>
    pic_enable(IRQ_TIMER);
  100dd5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100ddc:	e8 24 09 00 00       	call   101705 <pic_enable>
}
  100de1:	c9                   	leave  
  100de2:	c3                   	ret    

00100de3 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100de3:	55                   	push   %ebp
  100de4:	89 e5                	mov    %esp,%ebp
  100de6:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100de9:	9c                   	pushf  
  100dea:	58                   	pop    %eax
  100deb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100df1:	25 00 02 00 00       	and    $0x200,%eax
  100df6:	85 c0                	test   %eax,%eax
  100df8:	74 0c                	je     100e06 <__intr_save+0x23>
        intr_disable();
  100dfa:	e8 a8 08 00 00       	call   1016a7 <intr_disable>
        return 1;
  100dff:	b8 01 00 00 00       	mov    $0x1,%eax
  100e04:	eb 05                	jmp    100e0b <__intr_save+0x28>
    }
    return 0;
  100e06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e0b:	c9                   	leave  
  100e0c:	c3                   	ret    

00100e0d <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e0d:	55                   	push   %ebp
  100e0e:	89 e5                	mov    %esp,%ebp
  100e10:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e17:	74 05                	je     100e1e <__intr_restore+0x11>
        intr_enable();
  100e19:	e8 83 08 00 00       	call   1016a1 <intr_enable>
    }
}
  100e1e:	c9                   	leave  
  100e1f:	c3                   	ret    

00100e20 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e20:	55                   	push   %ebp
  100e21:	89 e5                	mov    %esp,%ebp
  100e23:	83 ec 10             	sub    $0x10,%esp
  100e26:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e2c:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e30:	89 c2                	mov    %eax,%edx
  100e32:	ec                   	in     (%dx),%al
  100e33:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e36:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e3c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e40:	89 c2                	mov    %eax,%edx
  100e42:	ec                   	in     (%dx),%al
  100e43:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e46:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e4c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e50:	89 c2                	mov    %eax,%edx
  100e52:	ec                   	in     (%dx),%al
  100e53:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e56:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e5c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e60:	89 c2                	mov    %eax,%edx
  100e62:	ec                   	in     (%dx),%al
  100e63:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e66:	c9                   	leave  
  100e67:	c3                   	ret    

00100e68 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e68:	55                   	push   %ebp
  100e69:	89 e5                	mov    %esp,%ebp
  100e6b:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e6e:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e78:	0f b7 00             	movzwl (%eax),%eax
  100e7b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e82:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e87:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8a:	0f b7 00             	movzwl (%eax),%eax
  100e8d:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e91:	74 12                	je     100ea5 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e93:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e9a:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100ea1:	b4 03 
  100ea3:	eb 13                	jmp    100eb8 <cga_init+0x50>
    } else {
        *cp = was;
  100ea5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ea8:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100eac:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eaf:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100eb6:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100eb8:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ebf:	0f b7 c0             	movzwl %ax,%eax
  100ec2:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ec6:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100eca:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ece:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ed2:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ed3:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100eda:	83 c0 01             	add    $0x1,%eax
  100edd:	0f b7 c0             	movzwl %ax,%eax
  100ee0:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ee4:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ee8:	89 c2                	mov    %eax,%edx
  100eea:	ec                   	in     (%dx),%al
  100eeb:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100eee:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ef2:	0f b6 c0             	movzbl %al,%eax
  100ef5:	c1 e0 08             	shl    $0x8,%eax
  100ef8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100efb:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f02:	0f b7 c0             	movzwl %ax,%eax
  100f05:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f09:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f0d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f11:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f15:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f16:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f1d:	83 c0 01             	add    $0x1,%eax
  100f20:	0f b7 c0             	movzwl %ax,%eax
  100f23:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f27:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f2b:	89 c2                	mov    %eax,%edx
  100f2d:	ec                   	in     (%dx),%al
  100f2e:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f31:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f35:	0f b6 c0             	movzbl %al,%eax
  100f38:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f3e:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f46:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f4c:	c9                   	leave  
  100f4d:	c3                   	ret    

00100f4e <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f4e:	55                   	push   %ebp
  100f4f:	89 e5                	mov    %esp,%ebp
  100f51:	83 ec 48             	sub    $0x48,%esp
  100f54:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f5a:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f5e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f62:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f66:	ee                   	out    %al,(%dx)
  100f67:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f6d:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f71:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f75:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f79:	ee                   	out    %al,(%dx)
  100f7a:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f80:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f84:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f88:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f8c:	ee                   	out    %al,(%dx)
  100f8d:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f93:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f97:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f9b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f9f:	ee                   	out    %al,(%dx)
  100fa0:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fa6:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100faa:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fae:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fb2:	ee                   	out    %al,(%dx)
  100fb3:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fb9:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fbd:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fc1:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fc5:	ee                   	out    %al,(%dx)
  100fc6:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fcc:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fd0:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fd4:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fd8:	ee                   	out    %al,(%dx)
  100fd9:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fdf:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100fe3:	89 c2                	mov    %eax,%edx
  100fe5:	ec                   	in     (%dx),%al
  100fe6:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100fe9:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fed:	3c ff                	cmp    $0xff,%al
  100fef:	0f 95 c0             	setne  %al
  100ff2:	0f b6 c0             	movzbl %al,%eax
  100ff5:	a3 88 7e 11 00       	mov    %eax,0x117e88
  100ffa:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101000:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101004:	89 c2                	mov    %eax,%edx
  101006:	ec                   	in     (%dx),%al
  101007:	88 45 d5             	mov    %al,-0x2b(%ebp)
  10100a:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  101010:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  101014:	89 c2                	mov    %eax,%edx
  101016:	ec                   	in     (%dx),%al
  101017:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10101a:	a1 88 7e 11 00       	mov    0x117e88,%eax
  10101f:	85 c0                	test   %eax,%eax
  101021:	74 0c                	je     10102f <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  101023:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10102a:	e8 d6 06 00 00       	call   101705 <pic_enable>
    }
}
  10102f:	c9                   	leave  
  101030:	c3                   	ret    

00101031 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101031:	55                   	push   %ebp
  101032:	89 e5                	mov    %esp,%ebp
  101034:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101037:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10103e:	eb 09                	jmp    101049 <lpt_putc_sub+0x18>
        delay();
  101040:	e8 db fd ff ff       	call   100e20 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101045:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101049:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10104f:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101053:	89 c2                	mov    %eax,%edx
  101055:	ec                   	in     (%dx),%al
  101056:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101059:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10105d:	84 c0                	test   %al,%al
  10105f:	78 09                	js     10106a <lpt_putc_sub+0x39>
  101061:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101068:	7e d6                	jle    101040 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  10106a:	8b 45 08             	mov    0x8(%ebp),%eax
  10106d:	0f b6 c0             	movzbl %al,%eax
  101070:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101076:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101079:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10107d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101081:	ee                   	out    %al,(%dx)
  101082:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101088:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10108c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101090:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101094:	ee                   	out    %al,(%dx)
  101095:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  10109b:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  10109f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010a3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010a7:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010a8:	c9                   	leave  
  1010a9:	c3                   	ret    

001010aa <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010aa:	55                   	push   %ebp
  1010ab:	89 e5                	mov    %esp,%ebp
  1010ad:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010b0:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010b4:	74 0d                	je     1010c3 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1010b9:	89 04 24             	mov    %eax,(%esp)
  1010bc:	e8 70 ff ff ff       	call   101031 <lpt_putc_sub>
  1010c1:	eb 24                	jmp    1010e7 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010c3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010ca:	e8 62 ff ff ff       	call   101031 <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010cf:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010d6:	e8 56 ff ff ff       	call   101031 <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010db:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010e2:	e8 4a ff ff ff       	call   101031 <lpt_putc_sub>
    }
}
  1010e7:	c9                   	leave  
  1010e8:	c3                   	ret    

001010e9 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010e9:	55                   	push   %ebp
  1010ea:	89 e5                	mov    %esp,%ebp
  1010ec:	53                   	push   %ebx
  1010ed:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f3:	b0 00                	mov    $0x0,%al
  1010f5:	85 c0                	test   %eax,%eax
  1010f7:	75 07                	jne    101100 <cga_putc+0x17>
        c |= 0x0700;
  1010f9:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101100:	8b 45 08             	mov    0x8(%ebp),%eax
  101103:	0f b6 c0             	movzbl %al,%eax
  101106:	83 f8 0a             	cmp    $0xa,%eax
  101109:	74 4c                	je     101157 <cga_putc+0x6e>
  10110b:	83 f8 0d             	cmp    $0xd,%eax
  10110e:	74 57                	je     101167 <cga_putc+0x7e>
  101110:	83 f8 08             	cmp    $0x8,%eax
  101113:	0f 85 88 00 00 00    	jne    1011a1 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101119:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101120:	66 85 c0             	test   %ax,%ax
  101123:	74 30                	je     101155 <cga_putc+0x6c>
            crt_pos --;
  101125:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10112c:	83 e8 01             	sub    $0x1,%eax
  10112f:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101135:	a1 80 7e 11 00       	mov    0x117e80,%eax
  10113a:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  101141:	0f b7 d2             	movzwl %dx,%edx
  101144:	01 d2                	add    %edx,%edx
  101146:	01 c2                	add    %eax,%edx
  101148:	8b 45 08             	mov    0x8(%ebp),%eax
  10114b:	b0 00                	mov    $0x0,%al
  10114d:	83 c8 20             	or     $0x20,%eax
  101150:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101153:	eb 72                	jmp    1011c7 <cga_putc+0xde>
  101155:	eb 70                	jmp    1011c7 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101157:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10115e:	83 c0 50             	add    $0x50,%eax
  101161:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101167:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  10116e:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  101175:	0f b7 c1             	movzwl %cx,%eax
  101178:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10117e:	c1 e8 10             	shr    $0x10,%eax
  101181:	89 c2                	mov    %eax,%edx
  101183:	66 c1 ea 06          	shr    $0x6,%dx
  101187:	89 d0                	mov    %edx,%eax
  101189:	c1 e0 02             	shl    $0x2,%eax
  10118c:	01 d0                	add    %edx,%eax
  10118e:	c1 e0 04             	shl    $0x4,%eax
  101191:	29 c1                	sub    %eax,%ecx
  101193:	89 ca                	mov    %ecx,%edx
  101195:	89 d8                	mov    %ebx,%eax
  101197:	29 d0                	sub    %edx,%eax
  101199:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  10119f:	eb 26                	jmp    1011c7 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011a1:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  1011a7:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011ae:	8d 50 01             	lea    0x1(%eax),%edx
  1011b1:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  1011b8:	0f b7 c0             	movzwl %ax,%eax
  1011bb:	01 c0                	add    %eax,%eax
  1011bd:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1011c3:	66 89 02             	mov    %ax,(%edx)
        break;
  1011c6:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011c7:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011ce:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011d2:	76 5b                	jbe    10122f <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011d4:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011d9:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011df:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011e4:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011eb:	00 
  1011ec:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011f0:	89 04 24             	mov    %eax,(%esp)
  1011f3:	e8 4a 4c 00 00       	call   105e42 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011f8:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011ff:	eb 15                	jmp    101216 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101201:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101206:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101209:	01 d2                	add    %edx,%edx
  10120b:	01 d0                	add    %edx,%eax
  10120d:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101212:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101216:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10121d:	7e e2                	jle    101201 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  10121f:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101226:	83 e8 50             	sub    $0x50,%eax
  101229:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10122f:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101236:	0f b7 c0             	movzwl %ax,%eax
  101239:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10123d:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101241:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101245:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101249:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10124a:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101251:	66 c1 e8 08          	shr    $0x8,%ax
  101255:	0f b6 c0             	movzbl %al,%eax
  101258:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  10125f:	83 c2 01             	add    $0x1,%edx
  101262:	0f b7 d2             	movzwl %dx,%edx
  101265:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101269:	88 45 ed             	mov    %al,-0x13(%ebp)
  10126c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101270:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101274:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101275:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  10127c:	0f b7 c0             	movzwl %ax,%eax
  10127f:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101283:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101287:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10128b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10128f:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101290:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101297:	0f b6 c0             	movzbl %al,%eax
  10129a:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1012a1:	83 c2 01             	add    $0x1,%edx
  1012a4:	0f b7 d2             	movzwl %dx,%edx
  1012a7:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012ab:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012ae:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012b2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012b6:	ee                   	out    %al,(%dx)
}
  1012b7:	83 c4 34             	add    $0x34,%esp
  1012ba:	5b                   	pop    %ebx
  1012bb:	5d                   	pop    %ebp
  1012bc:	c3                   	ret    

001012bd <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012bd:	55                   	push   %ebp
  1012be:	89 e5                	mov    %esp,%ebp
  1012c0:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012ca:	eb 09                	jmp    1012d5 <serial_putc_sub+0x18>
        delay();
  1012cc:	e8 4f fb ff ff       	call   100e20 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012d5:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012db:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012df:	89 c2                	mov    %eax,%edx
  1012e1:	ec                   	in     (%dx),%al
  1012e2:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012e5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012e9:	0f b6 c0             	movzbl %al,%eax
  1012ec:	83 e0 20             	and    $0x20,%eax
  1012ef:	85 c0                	test   %eax,%eax
  1012f1:	75 09                	jne    1012fc <serial_putc_sub+0x3f>
  1012f3:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012fa:	7e d0                	jle    1012cc <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1012ff:	0f b6 c0             	movzbl %al,%eax
  101302:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101308:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10130b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10130f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101313:	ee                   	out    %al,(%dx)
}
  101314:	c9                   	leave  
  101315:	c3                   	ret    

00101316 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101316:	55                   	push   %ebp
  101317:	89 e5                	mov    %esp,%ebp
  101319:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10131c:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101320:	74 0d                	je     10132f <serial_putc+0x19>
        serial_putc_sub(c);
  101322:	8b 45 08             	mov    0x8(%ebp),%eax
  101325:	89 04 24             	mov    %eax,(%esp)
  101328:	e8 90 ff ff ff       	call   1012bd <serial_putc_sub>
  10132d:	eb 24                	jmp    101353 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  10132f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101336:	e8 82 ff ff ff       	call   1012bd <serial_putc_sub>
        serial_putc_sub(' ');
  10133b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101342:	e8 76 ff ff ff       	call   1012bd <serial_putc_sub>
        serial_putc_sub('\b');
  101347:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10134e:	e8 6a ff ff ff       	call   1012bd <serial_putc_sub>
    }
}
  101353:	c9                   	leave  
  101354:	c3                   	ret    

00101355 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101355:	55                   	push   %ebp
  101356:	89 e5                	mov    %esp,%ebp
  101358:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10135b:	eb 33                	jmp    101390 <cons_intr+0x3b>
        if (c != 0) {
  10135d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101361:	74 2d                	je     101390 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101363:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101368:	8d 50 01             	lea    0x1(%eax),%edx
  10136b:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  101371:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101374:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10137a:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10137f:	3d 00 02 00 00       	cmp    $0x200,%eax
  101384:	75 0a                	jne    101390 <cons_intr+0x3b>
                cons.wpos = 0;
  101386:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  10138d:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101390:	8b 45 08             	mov    0x8(%ebp),%eax
  101393:	ff d0                	call   *%eax
  101395:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101398:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10139c:	75 bf                	jne    10135d <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  10139e:	c9                   	leave  
  10139f:	c3                   	ret    

001013a0 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013a0:	55                   	push   %ebp
  1013a1:	89 e5                	mov    %esp,%ebp
  1013a3:	83 ec 10             	sub    $0x10,%esp
  1013a6:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013ac:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013b0:	89 c2                	mov    %eax,%edx
  1013b2:	ec                   	in     (%dx),%al
  1013b3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013b6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013ba:	0f b6 c0             	movzbl %al,%eax
  1013bd:	83 e0 01             	and    $0x1,%eax
  1013c0:	85 c0                	test   %eax,%eax
  1013c2:	75 07                	jne    1013cb <serial_proc_data+0x2b>
        return -1;
  1013c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013c9:	eb 2a                	jmp    1013f5 <serial_proc_data+0x55>
  1013cb:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013d1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013d5:	89 c2                	mov    %eax,%edx
  1013d7:	ec                   	in     (%dx),%al
  1013d8:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013db:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013df:	0f b6 c0             	movzbl %al,%eax
  1013e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013e5:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013e9:	75 07                	jne    1013f2 <serial_proc_data+0x52>
        c = '\b';
  1013eb:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013f5:	c9                   	leave  
  1013f6:	c3                   	ret    

001013f7 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013f7:	55                   	push   %ebp
  1013f8:	89 e5                	mov    %esp,%ebp
  1013fa:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013fd:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101402:	85 c0                	test   %eax,%eax
  101404:	74 0c                	je     101412 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101406:	c7 04 24 a0 13 10 00 	movl   $0x1013a0,(%esp)
  10140d:	e8 43 ff ff ff       	call   101355 <cons_intr>
    }
}
  101412:	c9                   	leave  
  101413:	c3                   	ret    

00101414 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101414:	55                   	push   %ebp
  101415:	89 e5                	mov    %esp,%ebp
  101417:	83 ec 38             	sub    $0x38,%esp
  10141a:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101420:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101424:	89 c2                	mov    %eax,%edx
  101426:	ec                   	in     (%dx),%al
  101427:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10142a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10142e:	0f b6 c0             	movzbl %al,%eax
  101431:	83 e0 01             	and    $0x1,%eax
  101434:	85 c0                	test   %eax,%eax
  101436:	75 0a                	jne    101442 <kbd_proc_data+0x2e>
        return -1;
  101438:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10143d:	e9 59 01 00 00       	jmp    10159b <kbd_proc_data+0x187>
  101442:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101448:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10144c:	89 c2                	mov    %eax,%edx
  10144e:	ec                   	in     (%dx),%al
  10144f:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101452:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101456:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101459:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10145d:	75 17                	jne    101476 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10145f:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101464:	83 c8 40             	or     $0x40,%eax
  101467:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  10146c:	b8 00 00 00 00       	mov    $0x0,%eax
  101471:	e9 25 01 00 00       	jmp    10159b <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101476:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147a:	84 c0                	test   %al,%al
  10147c:	79 47                	jns    1014c5 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10147e:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101483:	83 e0 40             	and    $0x40,%eax
  101486:	85 c0                	test   %eax,%eax
  101488:	75 09                	jne    101493 <kbd_proc_data+0x7f>
  10148a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10148e:	83 e0 7f             	and    $0x7f,%eax
  101491:	eb 04                	jmp    101497 <kbd_proc_data+0x83>
  101493:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101497:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10149a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149e:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014a5:	83 c8 40             	or     $0x40,%eax
  1014a8:	0f b6 c0             	movzbl %al,%eax
  1014ab:	f7 d0                	not    %eax
  1014ad:	89 c2                	mov    %eax,%edx
  1014af:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014b4:	21 d0                	and    %edx,%eax
  1014b6:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1014bb:	b8 00 00 00 00       	mov    $0x0,%eax
  1014c0:	e9 d6 00 00 00       	jmp    10159b <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014c5:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014ca:	83 e0 40             	and    $0x40,%eax
  1014cd:	85 c0                	test   %eax,%eax
  1014cf:	74 11                	je     1014e2 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014d1:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014d5:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014da:	83 e0 bf             	and    $0xffffffbf,%eax
  1014dd:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014e2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014e6:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014ed:	0f b6 d0             	movzbl %al,%edx
  1014f0:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014f5:	09 d0                	or     %edx,%eax
  1014f7:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  1014fc:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101500:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  101507:	0f b6 d0             	movzbl %al,%edx
  10150a:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10150f:	31 d0                	xor    %edx,%eax
  101511:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  101516:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10151b:	83 e0 03             	and    $0x3,%eax
  10151e:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  101525:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101529:	01 d0                	add    %edx,%eax
  10152b:	0f b6 00             	movzbl (%eax),%eax
  10152e:	0f b6 c0             	movzbl %al,%eax
  101531:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101534:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101539:	83 e0 08             	and    $0x8,%eax
  10153c:	85 c0                	test   %eax,%eax
  10153e:	74 22                	je     101562 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101540:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101544:	7e 0c                	jle    101552 <kbd_proc_data+0x13e>
  101546:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10154a:	7f 06                	jg     101552 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  10154c:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101550:	eb 10                	jmp    101562 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101552:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101556:	7e 0a                	jle    101562 <kbd_proc_data+0x14e>
  101558:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10155c:	7f 04                	jg     101562 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10155e:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101562:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101567:	f7 d0                	not    %eax
  101569:	83 e0 06             	and    $0x6,%eax
  10156c:	85 c0                	test   %eax,%eax
  10156e:	75 28                	jne    101598 <kbd_proc_data+0x184>
  101570:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101577:	75 1f                	jne    101598 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101579:	c7 04 24 bd 62 10 00 	movl   $0x1062bd,(%esp)
  101580:	e8 b7 ed ff ff       	call   10033c <cprintf>
  101585:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10158b:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10158f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101593:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101597:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101598:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10159b:	c9                   	leave  
  10159c:	c3                   	ret    

0010159d <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10159d:	55                   	push   %ebp
  10159e:	89 e5                	mov    %esp,%ebp
  1015a0:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015a3:	c7 04 24 14 14 10 00 	movl   $0x101414,(%esp)
  1015aa:	e8 a6 fd ff ff       	call   101355 <cons_intr>
}
  1015af:	c9                   	leave  
  1015b0:	c3                   	ret    

001015b1 <kbd_init>:

static void
kbd_init(void) {
  1015b1:	55                   	push   %ebp
  1015b2:	89 e5                	mov    %esp,%ebp
  1015b4:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015b7:	e8 e1 ff ff ff       	call   10159d <kbd_intr>
    pic_enable(IRQ_KBD);
  1015bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015c3:	e8 3d 01 00 00       	call   101705 <pic_enable>
}
  1015c8:	c9                   	leave  
  1015c9:	c3                   	ret    

001015ca <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015ca:	55                   	push   %ebp
  1015cb:	89 e5                	mov    %esp,%ebp
  1015cd:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015d0:	e8 93 f8 ff ff       	call   100e68 <cga_init>
    serial_init();
  1015d5:	e8 74 f9 ff ff       	call   100f4e <serial_init>
    kbd_init();
  1015da:	e8 d2 ff ff ff       	call   1015b1 <kbd_init>
    if (!serial_exists) {
  1015df:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015e4:	85 c0                	test   %eax,%eax
  1015e6:	75 0c                	jne    1015f4 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015e8:	c7 04 24 c9 62 10 00 	movl   $0x1062c9,(%esp)
  1015ef:	e8 48 ed ff ff       	call   10033c <cprintf>
    }
}
  1015f4:	c9                   	leave  
  1015f5:	c3                   	ret    

001015f6 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015f6:	55                   	push   %ebp
  1015f7:	89 e5                	mov    %esp,%ebp
  1015f9:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1015fc:	e8 e2 f7 ff ff       	call   100de3 <__intr_save>
  101601:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101604:	8b 45 08             	mov    0x8(%ebp),%eax
  101607:	89 04 24             	mov    %eax,(%esp)
  10160a:	e8 9b fa ff ff       	call   1010aa <lpt_putc>
        cga_putc(c);
  10160f:	8b 45 08             	mov    0x8(%ebp),%eax
  101612:	89 04 24             	mov    %eax,(%esp)
  101615:	e8 cf fa ff ff       	call   1010e9 <cga_putc>
        serial_putc(c);
  10161a:	8b 45 08             	mov    0x8(%ebp),%eax
  10161d:	89 04 24             	mov    %eax,(%esp)
  101620:	e8 f1 fc ff ff       	call   101316 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101628:	89 04 24             	mov    %eax,(%esp)
  10162b:	e8 dd f7 ff ff       	call   100e0d <__intr_restore>
}
  101630:	c9                   	leave  
  101631:	c3                   	ret    

00101632 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101632:	55                   	push   %ebp
  101633:	89 e5                	mov    %esp,%ebp
  101635:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101638:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  10163f:	e8 9f f7 ff ff       	call   100de3 <__intr_save>
  101644:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101647:	e8 ab fd ff ff       	call   1013f7 <serial_intr>
        kbd_intr();
  10164c:	e8 4c ff ff ff       	call   10159d <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101651:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  101657:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10165c:	39 c2                	cmp    %eax,%edx
  10165e:	74 31                	je     101691 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101660:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101665:	8d 50 01             	lea    0x1(%eax),%edx
  101668:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  10166e:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  101675:	0f b6 c0             	movzbl %al,%eax
  101678:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  10167b:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101680:	3d 00 02 00 00       	cmp    $0x200,%eax
  101685:	75 0a                	jne    101691 <cons_getc+0x5f>
                cons.rpos = 0;
  101687:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  10168e:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101691:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101694:	89 04 24             	mov    %eax,(%esp)
  101697:	e8 71 f7 ff ff       	call   100e0d <__intr_restore>
    return c;
  10169c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10169f:	c9                   	leave  
  1016a0:	c3                   	ret    

001016a1 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016a1:	55                   	push   %ebp
  1016a2:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016a4:	fb                   	sti    
    sti();
}
  1016a5:	5d                   	pop    %ebp
  1016a6:	c3                   	ret    

001016a7 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016a7:	55                   	push   %ebp
  1016a8:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016aa:	fa                   	cli    
    cli();
}
  1016ab:	5d                   	pop    %ebp
  1016ac:	c3                   	ret    

001016ad <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016ad:	55                   	push   %ebp
  1016ae:	89 e5                	mov    %esp,%ebp
  1016b0:	83 ec 14             	sub    $0x14,%esp
  1016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1016b6:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016ba:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016be:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016c4:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016c9:	85 c0                	test   %eax,%eax
  1016cb:	74 36                	je     101703 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016cd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016d1:	0f b6 c0             	movzbl %al,%eax
  1016d4:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016da:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016dd:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016e1:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016e5:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016e6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016ea:	66 c1 e8 08          	shr    $0x8,%ax
  1016ee:	0f b6 c0             	movzbl %al,%eax
  1016f1:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016f7:	88 45 f9             	mov    %al,-0x7(%ebp)
  1016fa:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016fe:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101702:	ee                   	out    %al,(%dx)
    }
}
  101703:	c9                   	leave  
  101704:	c3                   	ret    

00101705 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101705:	55                   	push   %ebp
  101706:	89 e5                	mov    %esp,%ebp
  101708:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10170b:	8b 45 08             	mov    0x8(%ebp),%eax
  10170e:	ba 01 00 00 00       	mov    $0x1,%edx
  101713:	89 c1                	mov    %eax,%ecx
  101715:	d3 e2                	shl    %cl,%edx
  101717:	89 d0                	mov    %edx,%eax
  101719:	f7 d0                	not    %eax
  10171b:	89 c2                	mov    %eax,%edx
  10171d:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101724:	21 d0                	and    %edx,%eax
  101726:	0f b7 c0             	movzwl %ax,%eax
  101729:	89 04 24             	mov    %eax,(%esp)
  10172c:	e8 7c ff ff ff       	call   1016ad <pic_setmask>
}
  101731:	c9                   	leave  
  101732:	c3                   	ret    

00101733 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101733:	55                   	push   %ebp
  101734:	89 e5                	mov    %esp,%ebp
  101736:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101739:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  101740:	00 00 00 
  101743:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101749:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  10174d:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101751:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101755:	ee                   	out    %al,(%dx)
  101756:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10175c:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101760:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101764:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101768:	ee                   	out    %al,(%dx)
  101769:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10176f:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101773:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101777:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10177b:	ee                   	out    %al,(%dx)
  10177c:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101782:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101786:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10178a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10178e:	ee                   	out    %al,(%dx)
  10178f:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  101795:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101799:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10179d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017a1:	ee                   	out    %al,(%dx)
  1017a2:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017a8:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017ac:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017b0:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017b4:	ee                   	out    %al,(%dx)
  1017b5:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017bb:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017bf:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017c3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017c7:	ee                   	out    %al,(%dx)
  1017c8:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017ce:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017d2:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017d6:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017da:	ee                   	out    %al,(%dx)
  1017db:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017e1:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017e5:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017e9:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017ed:	ee                   	out    %al,(%dx)
  1017ee:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1017f4:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  1017f8:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017fc:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101800:	ee                   	out    %al,(%dx)
  101801:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101807:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  10180b:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10180f:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101813:	ee                   	out    %al,(%dx)
  101814:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10181a:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  10181e:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101822:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101826:	ee                   	out    %al,(%dx)
  101827:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  10182d:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101831:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101835:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101839:	ee                   	out    %al,(%dx)
  10183a:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101840:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101844:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101848:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10184c:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10184d:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101854:	66 83 f8 ff          	cmp    $0xffff,%ax
  101858:	74 12                	je     10186c <pic_init+0x139>
        pic_setmask(irq_mask);
  10185a:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101861:	0f b7 c0             	movzwl %ax,%eax
  101864:	89 04 24             	mov    %eax,(%esp)
  101867:	e8 41 fe ff ff       	call   1016ad <pic_setmask>
    }
}
  10186c:	c9                   	leave  
  10186d:	c3                   	ret    

0010186e <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  10186e:	55                   	push   %ebp
  10186f:	89 e5                	mov    %esp,%ebp
  101871:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101874:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  10187b:	00 
  10187c:	c7 04 24 00 63 10 00 	movl   $0x106300,(%esp)
  101883:	e8 b4 ea ff ff       	call   10033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101888:	c7 04 24 0a 63 10 00 	movl   $0x10630a,(%esp)
  10188f:	e8 a8 ea ff ff       	call   10033c <cprintf>
    panic("EOT: kernel seems ok.");
  101894:	c7 44 24 08 18 63 10 	movl   $0x106318,0x8(%esp)
  10189b:	00 
  10189c:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1018a3:	00 
  1018a4:	c7 04 24 2e 63 10 00 	movl   $0x10632e,(%esp)
  1018ab:	e8 14 f4 ff ff       	call   100cc4 <__panic>

001018b0 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018b0:	55                   	push   %ebp
  1018b1:	89 e5                	mov    %esp,%ebp
  1018b3:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i;
	for(i = 0; i < sizeof(idt) / sizeof(struct gatedesc); ++i){
  1018b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018bd:	e9 c3 00 00 00       	jmp    101985 <idt_init+0xd5>
		SETGATE(idt[i],0,GD_KTEXT,__vectors[i],0);
  1018c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c5:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018cc:	89 c2                	mov    %eax,%edx
  1018ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d1:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018d8:	00 
  1018d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018dc:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018e3:	00 08 00 
  1018e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e9:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018f0:	00 
  1018f1:	83 e2 e0             	and    $0xffffffe0,%edx
  1018f4:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fe:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  101905:	00 
  101906:	83 e2 1f             	and    $0x1f,%edx
  101909:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  101910:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101913:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10191a:	00 
  10191b:	83 e2 f0             	and    $0xfffffff0,%edx
  10191e:	83 ca 0e             	or     $0xe,%edx
  101921:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101928:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10192b:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101932:	00 
  101933:	83 e2 ef             	and    $0xffffffef,%edx
  101936:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10193d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101940:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101947:	00 
  101948:	83 e2 9f             	and    $0xffffff9f,%edx
  10194b:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101952:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101955:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10195c:	00 
  10195d:	83 ca 80             	or     $0xffffff80,%edx
  101960:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101967:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196a:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  101971:	c1 e8 10             	shr    $0x10,%eax
  101974:	89 c2                	mov    %eax,%edx
  101976:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101979:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  101980:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i;
	for(i = 0; i < sizeof(idt) / sizeof(struct gatedesc); ++i){
  101981:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101985:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101988:	3d ff 00 00 00       	cmp    $0xff,%eax
  10198d:	0f 86 2f ff ff ff    	jbe    1018c2 <idt_init+0x12>
		SETGATE(idt[i],0,GD_KTEXT,__vectors[i],0);
	}
	SETGATE(idt[T_SWITCH_TOK],0,GD_KTEXT,__vectors[T_SWITCH_TOK],3);
  101993:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  101998:	66 a3 88 84 11 00    	mov    %ax,0x118488
  10199e:	66 c7 05 8a 84 11 00 	movw   $0x8,0x11848a
  1019a5:	08 00 
  1019a7:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  1019ae:	83 e0 e0             	and    $0xffffffe0,%eax
  1019b1:	a2 8c 84 11 00       	mov    %al,0x11848c
  1019b6:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  1019bd:	83 e0 1f             	and    $0x1f,%eax
  1019c0:	a2 8c 84 11 00       	mov    %al,0x11848c
  1019c5:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019cc:	83 e0 f0             	and    $0xfffffff0,%eax
  1019cf:	83 c8 0e             	or     $0xe,%eax
  1019d2:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019d7:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019de:	83 e0 ef             	and    $0xffffffef,%eax
  1019e1:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019e6:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019ed:	83 c8 60             	or     $0x60,%eax
  1019f0:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019f5:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019fc:	83 c8 80             	or     $0xffffff80,%eax
  1019ff:	a2 8d 84 11 00       	mov    %al,0x11848d
  101a04:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  101a09:	c1 e8 10             	shr    $0x10,%eax
  101a0c:	66 a3 8e 84 11 00    	mov    %ax,0x11848e
  101a12:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a1c:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
  101a1f:	c9                   	leave  
  101a20:	c3                   	ret    

00101a21 <trapname>:

static const char *
trapname(int trapno) {
  101a21:	55                   	push   %ebp
  101a22:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a24:	8b 45 08             	mov    0x8(%ebp),%eax
  101a27:	83 f8 13             	cmp    $0x13,%eax
  101a2a:	77 0c                	ja     101a38 <trapname+0x17>
        return excnames[trapno];
  101a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a2f:	8b 04 85 80 66 10 00 	mov    0x106680(,%eax,4),%eax
  101a36:	eb 18                	jmp    101a50 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a38:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a3c:	7e 0d                	jle    101a4b <trapname+0x2a>
  101a3e:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a42:	7f 07                	jg     101a4b <trapname+0x2a>
        return "Hardware Interrupt";
  101a44:	b8 3f 63 10 00       	mov    $0x10633f,%eax
  101a49:	eb 05                	jmp    101a50 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a4b:	b8 52 63 10 00       	mov    $0x106352,%eax
}
  101a50:	5d                   	pop    %ebp
  101a51:	c3                   	ret    

00101a52 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a52:	55                   	push   %ebp
  101a53:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a55:	8b 45 08             	mov    0x8(%ebp),%eax
  101a58:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a5c:	66 83 f8 08          	cmp    $0x8,%ax
  101a60:	0f 94 c0             	sete   %al
  101a63:	0f b6 c0             	movzbl %al,%eax
}
  101a66:	5d                   	pop    %ebp
  101a67:	c3                   	ret    

00101a68 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a68:	55                   	push   %ebp
  101a69:	89 e5                	mov    %esp,%ebp
  101a6b:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a71:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a75:	c7 04 24 93 63 10 00 	movl   $0x106393,(%esp)
  101a7c:	e8 bb e8 ff ff       	call   10033c <cprintf>
    print_regs(&tf->tf_regs);
  101a81:	8b 45 08             	mov    0x8(%ebp),%eax
  101a84:	89 04 24             	mov    %eax,(%esp)
  101a87:	e8 a1 01 00 00       	call   101c2d <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8f:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a93:	0f b7 c0             	movzwl %ax,%eax
  101a96:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a9a:	c7 04 24 a4 63 10 00 	movl   $0x1063a4,(%esp)
  101aa1:	e8 96 e8 ff ff       	call   10033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa9:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101aad:	0f b7 c0             	movzwl %ax,%eax
  101ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab4:	c7 04 24 b7 63 10 00 	movl   $0x1063b7,(%esp)
  101abb:	e8 7c e8 ff ff       	call   10033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac3:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101ac7:	0f b7 c0             	movzwl %ax,%eax
  101aca:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ace:	c7 04 24 ca 63 10 00 	movl   $0x1063ca,(%esp)
  101ad5:	e8 62 e8 ff ff       	call   10033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ada:	8b 45 08             	mov    0x8(%ebp),%eax
  101add:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101ae1:	0f b7 c0             	movzwl %ax,%eax
  101ae4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae8:	c7 04 24 dd 63 10 00 	movl   $0x1063dd,(%esp)
  101aef:	e8 48 e8 ff ff       	call   10033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101af4:	8b 45 08             	mov    0x8(%ebp),%eax
  101af7:	8b 40 30             	mov    0x30(%eax),%eax
  101afa:	89 04 24             	mov    %eax,(%esp)
  101afd:	e8 1f ff ff ff       	call   101a21 <trapname>
  101b02:	8b 55 08             	mov    0x8(%ebp),%edx
  101b05:	8b 52 30             	mov    0x30(%edx),%edx
  101b08:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b0c:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b10:	c7 04 24 f0 63 10 00 	movl   $0x1063f0,(%esp)
  101b17:	e8 20 e8 ff ff       	call   10033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1f:	8b 40 34             	mov    0x34(%eax),%eax
  101b22:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b26:	c7 04 24 02 64 10 00 	movl   $0x106402,(%esp)
  101b2d:	e8 0a e8 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b32:	8b 45 08             	mov    0x8(%ebp),%eax
  101b35:	8b 40 38             	mov    0x38(%eax),%eax
  101b38:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b3c:	c7 04 24 11 64 10 00 	movl   $0x106411,(%esp)
  101b43:	e8 f4 e7 ff ff       	call   10033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b48:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b4f:	0f b7 c0             	movzwl %ax,%eax
  101b52:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b56:	c7 04 24 20 64 10 00 	movl   $0x106420,(%esp)
  101b5d:	e8 da e7 ff ff       	call   10033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b62:	8b 45 08             	mov    0x8(%ebp),%eax
  101b65:	8b 40 40             	mov    0x40(%eax),%eax
  101b68:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b6c:	c7 04 24 33 64 10 00 	movl   $0x106433,(%esp)
  101b73:	e8 c4 e7 ff ff       	call   10033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b7f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b86:	eb 3e                	jmp    101bc6 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b88:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8b:	8b 50 40             	mov    0x40(%eax),%edx
  101b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b91:	21 d0                	and    %edx,%eax
  101b93:	85 c0                	test   %eax,%eax
  101b95:	74 28                	je     101bbf <print_trapframe+0x157>
  101b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b9a:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101ba1:	85 c0                	test   %eax,%eax
  101ba3:	74 1a                	je     101bbf <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ba8:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101baf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb3:	c7 04 24 42 64 10 00 	movl   $0x106442,(%esp)
  101bba:	e8 7d e7 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bbf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101bc3:	d1 65 f0             	shll   -0x10(%ebp)
  101bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bc9:	83 f8 17             	cmp    $0x17,%eax
  101bcc:	76 ba                	jbe    101b88 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bce:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd1:	8b 40 40             	mov    0x40(%eax),%eax
  101bd4:	25 00 30 00 00       	and    $0x3000,%eax
  101bd9:	c1 e8 0c             	shr    $0xc,%eax
  101bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be0:	c7 04 24 46 64 10 00 	movl   $0x106446,(%esp)
  101be7:	e8 50 e7 ff ff       	call   10033c <cprintf>

    if (!trap_in_kernel(tf)) {
  101bec:	8b 45 08             	mov    0x8(%ebp),%eax
  101bef:	89 04 24             	mov    %eax,(%esp)
  101bf2:	e8 5b fe ff ff       	call   101a52 <trap_in_kernel>
  101bf7:	85 c0                	test   %eax,%eax
  101bf9:	75 30                	jne    101c2b <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfe:	8b 40 44             	mov    0x44(%eax),%eax
  101c01:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c05:	c7 04 24 4f 64 10 00 	movl   $0x10644f,(%esp)
  101c0c:	e8 2b e7 ff ff       	call   10033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c11:	8b 45 08             	mov    0x8(%ebp),%eax
  101c14:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c18:	0f b7 c0             	movzwl %ax,%eax
  101c1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c1f:	c7 04 24 5e 64 10 00 	movl   $0x10645e,(%esp)
  101c26:	e8 11 e7 ff ff       	call   10033c <cprintf>
    }
}
  101c2b:	c9                   	leave  
  101c2c:	c3                   	ret    

00101c2d <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c2d:	55                   	push   %ebp
  101c2e:	89 e5                	mov    %esp,%ebp
  101c30:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c33:	8b 45 08             	mov    0x8(%ebp),%eax
  101c36:	8b 00                	mov    (%eax),%eax
  101c38:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3c:	c7 04 24 71 64 10 00 	movl   $0x106471,(%esp)
  101c43:	e8 f4 e6 ff ff       	call   10033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c48:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4b:	8b 40 04             	mov    0x4(%eax),%eax
  101c4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c52:	c7 04 24 80 64 10 00 	movl   $0x106480,(%esp)
  101c59:	e8 de e6 ff ff       	call   10033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c61:	8b 40 08             	mov    0x8(%eax),%eax
  101c64:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c68:	c7 04 24 8f 64 10 00 	movl   $0x10648f,(%esp)
  101c6f:	e8 c8 e6 ff ff       	call   10033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c74:	8b 45 08             	mov    0x8(%ebp),%eax
  101c77:	8b 40 0c             	mov    0xc(%eax),%eax
  101c7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c7e:	c7 04 24 9e 64 10 00 	movl   $0x10649e,(%esp)
  101c85:	e8 b2 e6 ff ff       	call   10033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c8d:	8b 40 10             	mov    0x10(%eax),%eax
  101c90:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c94:	c7 04 24 ad 64 10 00 	movl   $0x1064ad,(%esp)
  101c9b:	e8 9c e6 ff ff       	call   10033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca3:	8b 40 14             	mov    0x14(%eax),%eax
  101ca6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101caa:	c7 04 24 bc 64 10 00 	movl   $0x1064bc,(%esp)
  101cb1:	e8 86 e6 ff ff       	call   10033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb9:	8b 40 18             	mov    0x18(%eax),%eax
  101cbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc0:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  101cc7:	e8 70 e6 ff ff       	call   10033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  101ccf:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd6:	c7 04 24 da 64 10 00 	movl   $0x1064da,(%esp)
  101cdd:	e8 5a e6 ff ff       	call   10033c <cprintf>
}
  101ce2:	c9                   	leave  
  101ce3:	c3                   	ret    

00101ce4 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101ce4:	55                   	push   %ebp
  101ce5:	89 e5                	mov    %esp,%ebp
  101ce7:	83 ec 28             	sub    $0x28,%esp
    char c;
    static int tick_count = 0;
    switch (tf->tf_trapno) {
  101cea:	8b 45 08             	mov    0x8(%ebp),%eax
  101ced:	8b 40 30             	mov    0x30(%eax),%eax
  101cf0:	83 f8 2f             	cmp    $0x2f,%eax
  101cf3:	77 21                	ja     101d16 <trap_dispatch+0x32>
  101cf5:	83 f8 2e             	cmp    $0x2e,%eax
  101cf8:	0f 83 15 01 00 00    	jae    101e13 <trap_dispatch+0x12f>
  101cfe:	83 f8 21             	cmp    $0x21,%eax
  101d01:	0f 84 92 00 00 00    	je     101d99 <trap_dispatch+0xb5>
  101d07:	83 f8 24             	cmp    $0x24,%eax
  101d0a:	74 67                	je     101d73 <trap_dispatch+0x8f>
  101d0c:	83 f8 20             	cmp    $0x20,%eax
  101d0f:	74 16                	je     101d27 <trap_dispatch+0x43>
  101d11:	e9 c5 00 00 00       	jmp    101ddb <trap_dispatch+0xf7>
  101d16:	83 e8 78             	sub    $0x78,%eax
  101d19:	83 f8 01             	cmp    $0x1,%eax
  101d1c:	0f 87 b9 00 00 00    	ja     101ddb <trap_dispatch+0xf7>
  101d22:	e9 98 00 00 00       	jmp    101dbf <trap_dispatch+0xdb>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    	if((++tick_count) % TICK_NUM == 0){
  101d27:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  101d2c:	83 c0 01             	add    $0x1,%eax
  101d2f:	a3 c0 88 11 00       	mov    %eax,0x1188c0
  101d34:	8b 0d c0 88 11 00    	mov    0x1188c0,%ecx
  101d3a:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d3f:	89 c8                	mov    %ecx,%eax
  101d41:	f7 ea                	imul   %edx
  101d43:	c1 fa 05             	sar    $0x5,%edx
  101d46:	89 c8                	mov    %ecx,%eax
  101d48:	c1 f8 1f             	sar    $0x1f,%eax
  101d4b:	29 c2                	sub    %eax,%edx
  101d4d:	89 d0                	mov    %edx,%eax
  101d4f:	6b c0 64             	imul   $0x64,%eax,%eax
  101d52:	29 c1                	sub    %eax,%ecx
  101d54:	89 c8                	mov    %ecx,%eax
  101d56:	85 c0                	test   %eax,%eax
  101d58:	75 14                	jne    101d6e <trap_dispatch+0x8a>
        	print_ticks();
  101d5a:	e8 0f fb ff ff       	call   10186e <print_ticks>
        	tick_count = 0;
  101d5f:	c7 05 c0 88 11 00 00 	movl   $0x0,0x1188c0
  101d66:	00 00 00 
        }
        break;
  101d69:	e9 a6 00 00 00       	jmp    101e14 <trap_dispatch+0x130>
  101d6e:	e9 a1 00 00 00       	jmp    101e14 <trap_dispatch+0x130>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d73:	e8 ba f8 ff ff       	call   101632 <cons_getc>
  101d78:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d7b:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d7f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d83:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d87:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d8b:	c7 04 24 e9 64 10 00 	movl   $0x1064e9,(%esp)
  101d92:	e8 a5 e5 ff ff       	call   10033c <cprintf>
        break;
  101d97:	eb 7b                	jmp    101e14 <trap_dispatch+0x130>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d99:	e8 94 f8 ff ff       	call   101632 <cons_getc>
  101d9e:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101da1:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101da5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101da9:	89 54 24 08          	mov    %edx,0x8(%esp)
  101dad:	89 44 24 04          	mov    %eax,0x4(%esp)
  101db1:	c7 04 24 fb 64 10 00 	movl   $0x1064fb,(%esp)
  101db8:	e8 7f e5 ff ff       	call   10033c <cprintf>
        break;
  101dbd:	eb 55                	jmp    101e14 <trap_dispatch+0x130>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101dbf:	c7 44 24 08 0a 65 10 	movl   $0x10650a,0x8(%esp)
  101dc6:	00 
  101dc7:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
  101dce:	00 
  101dcf:	c7 04 24 2e 63 10 00 	movl   $0x10632e,(%esp)
  101dd6:	e8 e9 ee ff ff       	call   100cc4 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  101dde:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101de2:	0f b7 c0             	movzwl %ax,%eax
  101de5:	83 e0 03             	and    $0x3,%eax
  101de8:	85 c0                	test   %eax,%eax
  101dea:	75 28                	jne    101e14 <trap_dispatch+0x130>
            print_trapframe(tf);
  101dec:	8b 45 08             	mov    0x8(%ebp),%eax
  101def:	89 04 24             	mov    %eax,(%esp)
  101df2:	e8 71 fc ff ff       	call   101a68 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101df7:	c7 44 24 08 1a 65 10 	movl   $0x10651a,0x8(%esp)
  101dfe:	00 
  101dff:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  101e06:	00 
  101e07:	c7 04 24 2e 63 10 00 	movl   $0x10632e,(%esp)
  101e0e:	e8 b1 ee ff ff       	call   100cc4 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e13:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101e14:	c9                   	leave  
  101e15:	c3                   	ret    

00101e16 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e16:	55                   	push   %ebp
  101e17:	89 e5                	mov    %esp,%ebp
  101e19:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101e1f:	89 04 24             	mov    %eax,(%esp)
  101e22:	e8 bd fe ff ff       	call   101ce4 <trap_dispatch>
}
  101e27:	c9                   	leave  
  101e28:	c3                   	ret    

00101e29 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101e29:	1e                   	push   %ds
    pushl %es
  101e2a:	06                   	push   %es
    pushl %fs
  101e2b:	0f a0                	push   %fs
    pushl %gs
  101e2d:	0f a8                	push   %gs
    pushal
  101e2f:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101e30:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101e35:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101e37:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101e39:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101e3a:	e8 d7 ff ff ff       	call   101e16 <trap>

    # pop the pushed stack pointer
    popl %esp
  101e3f:	5c                   	pop    %esp

00101e40 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101e40:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101e41:	0f a9                	pop    %gs
    popl %fs
  101e43:	0f a1                	pop    %fs
    popl %es
  101e45:	07                   	pop    %es
    popl %ds
  101e46:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101e47:	83 c4 08             	add    $0x8,%esp
    iret
  101e4a:	cf                   	iret   

00101e4b <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e4b:	6a 00                	push   $0x0
  pushl $0
  101e4d:	6a 00                	push   $0x0
  jmp __alltraps
  101e4f:	e9 d5 ff ff ff       	jmp    101e29 <__alltraps>

00101e54 <vector1>:
.globl vector1
vector1:
  pushl $0
  101e54:	6a 00                	push   $0x0
  pushl $1
  101e56:	6a 01                	push   $0x1
  jmp __alltraps
  101e58:	e9 cc ff ff ff       	jmp    101e29 <__alltraps>

00101e5d <vector2>:
.globl vector2
vector2:
  pushl $0
  101e5d:	6a 00                	push   $0x0
  pushl $2
  101e5f:	6a 02                	push   $0x2
  jmp __alltraps
  101e61:	e9 c3 ff ff ff       	jmp    101e29 <__alltraps>

00101e66 <vector3>:
.globl vector3
vector3:
  pushl $0
  101e66:	6a 00                	push   $0x0
  pushl $3
  101e68:	6a 03                	push   $0x3
  jmp __alltraps
  101e6a:	e9 ba ff ff ff       	jmp    101e29 <__alltraps>

00101e6f <vector4>:
.globl vector4
vector4:
  pushl $0
  101e6f:	6a 00                	push   $0x0
  pushl $4
  101e71:	6a 04                	push   $0x4
  jmp __alltraps
  101e73:	e9 b1 ff ff ff       	jmp    101e29 <__alltraps>

00101e78 <vector5>:
.globl vector5
vector5:
  pushl $0
  101e78:	6a 00                	push   $0x0
  pushl $5
  101e7a:	6a 05                	push   $0x5
  jmp __alltraps
  101e7c:	e9 a8 ff ff ff       	jmp    101e29 <__alltraps>

00101e81 <vector6>:
.globl vector6
vector6:
  pushl $0
  101e81:	6a 00                	push   $0x0
  pushl $6
  101e83:	6a 06                	push   $0x6
  jmp __alltraps
  101e85:	e9 9f ff ff ff       	jmp    101e29 <__alltraps>

00101e8a <vector7>:
.globl vector7
vector7:
  pushl $0
  101e8a:	6a 00                	push   $0x0
  pushl $7
  101e8c:	6a 07                	push   $0x7
  jmp __alltraps
  101e8e:	e9 96 ff ff ff       	jmp    101e29 <__alltraps>

00101e93 <vector8>:
.globl vector8
vector8:
  pushl $8
  101e93:	6a 08                	push   $0x8
  jmp __alltraps
  101e95:	e9 8f ff ff ff       	jmp    101e29 <__alltraps>

00101e9a <vector9>:
.globl vector9
vector9:
  pushl $9
  101e9a:	6a 09                	push   $0x9
  jmp __alltraps
  101e9c:	e9 88 ff ff ff       	jmp    101e29 <__alltraps>

00101ea1 <vector10>:
.globl vector10
vector10:
  pushl $10
  101ea1:	6a 0a                	push   $0xa
  jmp __alltraps
  101ea3:	e9 81 ff ff ff       	jmp    101e29 <__alltraps>

00101ea8 <vector11>:
.globl vector11
vector11:
  pushl $11
  101ea8:	6a 0b                	push   $0xb
  jmp __alltraps
  101eaa:	e9 7a ff ff ff       	jmp    101e29 <__alltraps>

00101eaf <vector12>:
.globl vector12
vector12:
  pushl $12
  101eaf:	6a 0c                	push   $0xc
  jmp __alltraps
  101eb1:	e9 73 ff ff ff       	jmp    101e29 <__alltraps>

00101eb6 <vector13>:
.globl vector13
vector13:
  pushl $13
  101eb6:	6a 0d                	push   $0xd
  jmp __alltraps
  101eb8:	e9 6c ff ff ff       	jmp    101e29 <__alltraps>

00101ebd <vector14>:
.globl vector14
vector14:
  pushl $14
  101ebd:	6a 0e                	push   $0xe
  jmp __alltraps
  101ebf:	e9 65 ff ff ff       	jmp    101e29 <__alltraps>

00101ec4 <vector15>:
.globl vector15
vector15:
  pushl $0
  101ec4:	6a 00                	push   $0x0
  pushl $15
  101ec6:	6a 0f                	push   $0xf
  jmp __alltraps
  101ec8:	e9 5c ff ff ff       	jmp    101e29 <__alltraps>

00101ecd <vector16>:
.globl vector16
vector16:
  pushl $0
  101ecd:	6a 00                	push   $0x0
  pushl $16
  101ecf:	6a 10                	push   $0x10
  jmp __alltraps
  101ed1:	e9 53 ff ff ff       	jmp    101e29 <__alltraps>

00101ed6 <vector17>:
.globl vector17
vector17:
  pushl $17
  101ed6:	6a 11                	push   $0x11
  jmp __alltraps
  101ed8:	e9 4c ff ff ff       	jmp    101e29 <__alltraps>

00101edd <vector18>:
.globl vector18
vector18:
  pushl $0
  101edd:	6a 00                	push   $0x0
  pushl $18
  101edf:	6a 12                	push   $0x12
  jmp __alltraps
  101ee1:	e9 43 ff ff ff       	jmp    101e29 <__alltraps>

00101ee6 <vector19>:
.globl vector19
vector19:
  pushl $0
  101ee6:	6a 00                	push   $0x0
  pushl $19
  101ee8:	6a 13                	push   $0x13
  jmp __alltraps
  101eea:	e9 3a ff ff ff       	jmp    101e29 <__alltraps>

00101eef <vector20>:
.globl vector20
vector20:
  pushl $0
  101eef:	6a 00                	push   $0x0
  pushl $20
  101ef1:	6a 14                	push   $0x14
  jmp __alltraps
  101ef3:	e9 31 ff ff ff       	jmp    101e29 <__alltraps>

00101ef8 <vector21>:
.globl vector21
vector21:
  pushl $0
  101ef8:	6a 00                	push   $0x0
  pushl $21
  101efa:	6a 15                	push   $0x15
  jmp __alltraps
  101efc:	e9 28 ff ff ff       	jmp    101e29 <__alltraps>

00101f01 <vector22>:
.globl vector22
vector22:
  pushl $0
  101f01:	6a 00                	push   $0x0
  pushl $22
  101f03:	6a 16                	push   $0x16
  jmp __alltraps
  101f05:	e9 1f ff ff ff       	jmp    101e29 <__alltraps>

00101f0a <vector23>:
.globl vector23
vector23:
  pushl $0
  101f0a:	6a 00                	push   $0x0
  pushl $23
  101f0c:	6a 17                	push   $0x17
  jmp __alltraps
  101f0e:	e9 16 ff ff ff       	jmp    101e29 <__alltraps>

00101f13 <vector24>:
.globl vector24
vector24:
  pushl $0
  101f13:	6a 00                	push   $0x0
  pushl $24
  101f15:	6a 18                	push   $0x18
  jmp __alltraps
  101f17:	e9 0d ff ff ff       	jmp    101e29 <__alltraps>

00101f1c <vector25>:
.globl vector25
vector25:
  pushl $0
  101f1c:	6a 00                	push   $0x0
  pushl $25
  101f1e:	6a 19                	push   $0x19
  jmp __alltraps
  101f20:	e9 04 ff ff ff       	jmp    101e29 <__alltraps>

00101f25 <vector26>:
.globl vector26
vector26:
  pushl $0
  101f25:	6a 00                	push   $0x0
  pushl $26
  101f27:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f29:	e9 fb fe ff ff       	jmp    101e29 <__alltraps>

00101f2e <vector27>:
.globl vector27
vector27:
  pushl $0
  101f2e:	6a 00                	push   $0x0
  pushl $27
  101f30:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f32:	e9 f2 fe ff ff       	jmp    101e29 <__alltraps>

00101f37 <vector28>:
.globl vector28
vector28:
  pushl $0
  101f37:	6a 00                	push   $0x0
  pushl $28
  101f39:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f3b:	e9 e9 fe ff ff       	jmp    101e29 <__alltraps>

00101f40 <vector29>:
.globl vector29
vector29:
  pushl $0
  101f40:	6a 00                	push   $0x0
  pushl $29
  101f42:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f44:	e9 e0 fe ff ff       	jmp    101e29 <__alltraps>

00101f49 <vector30>:
.globl vector30
vector30:
  pushl $0
  101f49:	6a 00                	push   $0x0
  pushl $30
  101f4b:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f4d:	e9 d7 fe ff ff       	jmp    101e29 <__alltraps>

00101f52 <vector31>:
.globl vector31
vector31:
  pushl $0
  101f52:	6a 00                	push   $0x0
  pushl $31
  101f54:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f56:	e9 ce fe ff ff       	jmp    101e29 <__alltraps>

00101f5b <vector32>:
.globl vector32
vector32:
  pushl $0
  101f5b:	6a 00                	push   $0x0
  pushl $32
  101f5d:	6a 20                	push   $0x20
  jmp __alltraps
  101f5f:	e9 c5 fe ff ff       	jmp    101e29 <__alltraps>

00101f64 <vector33>:
.globl vector33
vector33:
  pushl $0
  101f64:	6a 00                	push   $0x0
  pushl $33
  101f66:	6a 21                	push   $0x21
  jmp __alltraps
  101f68:	e9 bc fe ff ff       	jmp    101e29 <__alltraps>

00101f6d <vector34>:
.globl vector34
vector34:
  pushl $0
  101f6d:	6a 00                	push   $0x0
  pushl $34
  101f6f:	6a 22                	push   $0x22
  jmp __alltraps
  101f71:	e9 b3 fe ff ff       	jmp    101e29 <__alltraps>

00101f76 <vector35>:
.globl vector35
vector35:
  pushl $0
  101f76:	6a 00                	push   $0x0
  pushl $35
  101f78:	6a 23                	push   $0x23
  jmp __alltraps
  101f7a:	e9 aa fe ff ff       	jmp    101e29 <__alltraps>

00101f7f <vector36>:
.globl vector36
vector36:
  pushl $0
  101f7f:	6a 00                	push   $0x0
  pushl $36
  101f81:	6a 24                	push   $0x24
  jmp __alltraps
  101f83:	e9 a1 fe ff ff       	jmp    101e29 <__alltraps>

00101f88 <vector37>:
.globl vector37
vector37:
  pushl $0
  101f88:	6a 00                	push   $0x0
  pushl $37
  101f8a:	6a 25                	push   $0x25
  jmp __alltraps
  101f8c:	e9 98 fe ff ff       	jmp    101e29 <__alltraps>

00101f91 <vector38>:
.globl vector38
vector38:
  pushl $0
  101f91:	6a 00                	push   $0x0
  pushl $38
  101f93:	6a 26                	push   $0x26
  jmp __alltraps
  101f95:	e9 8f fe ff ff       	jmp    101e29 <__alltraps>

00101f9a <vector39>:
.globl vector39
vector39:
  pushl $0
  101f9a:	6a 00                	push   $0x0
  pushl $39
  101f9c:	6a 27                	push   $0x27
  jmp __alltraps
  101f9e:	e9 86 fe ff ff       	jmp    101e29 <__alltraps>

00101fa3 <vector40>:
.globl vector40
vector40:
  pushl $0
  101fa3:	6a 00                	push   $0x0
  pushl $40
  101fa5:	6a 28                	push   $0x28
  jmp __alltraps
  101fa7:	e9 7d fe ff ff       	jmp    101e29 <__alltraps>

00101fac <vector41>:
.globl vector41
vector41:
  pushl $0
  101fac:	6a 00                	push   $0x0
  pushl $41
  101fae:	6a 29                	push   $0x29
  jmp __alltraps
  101fb0:	e9 74 fe ff ff       	jmp    101e29 <__alltraps>

00101fb5 <vector42>:
.globl vector42
vector42:
  pushl $0
  101fb5:	6a 00                	push   $0x0
  pushl $42
  101fb7:	6a 2a                	push   $0x2a
  jmp __alltraps
  101fb9:	e9 6b fe ff ff       	jmp    101e29 <__alltraps>

00101fbe <vector43>:
.globl vector43
vector43:
  pushl $0
  101fbe:	6a 00                	push   $0x0
  pushl $43
  101fc0:	6a 2b                	push   $0x2b
  jmp __alltraps
  101fc2:	e9 62 fe ff ff       	jmp    101e29 <__alltraps>

00101fc7 <vector44>:
.globl vector44
vector44:
  pushl $0
  101fc7:	6a 00                	push   $0x0
  pushl $44
  101fc9:	6a 2c                	push   $0x2c
  jmp __alltraps
  101fcb:	e9 59 fe ff ff       	jmp    101e29 <__alltraps>

00101fd0 <vector45>:
.globl vector45
vector45:
  pushl $0
  101fd0:	6a 00                	push   $0x0
  pushl $45
  101fd2:	6a 2d                	push   $0x2d
  jmp __alltraps
  101fd4:	e9 50 fe ff ff       	jmp    101e29 <__alltraps>

00101fd9 <vector46>:
.globl vector46
vector46:
  pushl $0
  101fd9:	6a 00                	push   $0x0
  pushl $46
  101fdb:	6a 2e                	push   $0x2e
  jmp __alltraps
  101fdd:	e9 47 fe ff ff       	jmp    101e29 <__alltraps>

00101fe2 <vector47>:
.globl vector47
vector47:
  pushl $0
  101fe2:	6a 00                	push   $0x0
  pushl $47
  101fe4:	6a 2f                	push   $0x2f
  jmp __alltraps
  101fe6:	e9 3e fe ff ff       	jmp    101e29 <__alltraps>

00101feb <vector48>:
.globl vector48
vector48:
  pushl $0
  101feb:	6a 00                	push   $0x0
  pushl $48
  101fed:	6a 30                	push   $0x30
  jmp __alltraps
  101fef:	e9 35 fe ff ff       	jmp    101e29 <__alltraps>

00101ff4 <vector49>:
.globl vector49
vector49:
  pushl $0
  101ff4:	6a 00                	push   $0x0
  pushl $49
  101ff6:	6a 31                	push   $0x31
  jmp __alltraps
  101ff8:	e9 2c fe ff ff       	jmp    101e29 <__alltraps>

00101ffd <vector50>:
.globl vector50
vector50:
  pushl $0
  101ffd:	6a 00                	push   $0x0
  pushl $50
  101fff:	6a 32                	push   $0x32
  jmp __alltraps
  102001:	e9 23 fe ff ff       	jmp    101e29 <__alltraps>

00102006 <vector51>:
.globl vector51
vector51:
  pushl $0
  102006:	6a 00                	push   $0x0
  pushl $51
  102008:	6a 33                	push   $0x33
  jmp __alltraps
  10200a:	e9 1a fe ff ff       	jmp    101e29 <__alltraps>

0010200f <vector52>:
.globl vector52
vector52:
  pushl $0
  10200f:	6a 00                	push   $0x0
  pushl $52
  102011:	6a 34                	push   $0x34
  jmp __alltraps
  102013:	e9 11 fe ff ff       	jmp    101e29 <__alltraps>

00102018 <vector53>:
.globl vector53
vector53:
  pushl $0
  102018:	6a 00                	push   $0x0
  pushl $53
  10201a:	6a 35                	push   $0x35
  jmp __alltraps
  10201c:	e9 08 fe ff ff       	jmp    101e29 <__alltraps>

00102021 <vector54>:
.globl vector54
vector54:
  pushl $0
  102021:	6a 00                	push   $0x0
  pushl $54
  102023:	6a 36                	push   $0x36
  jmp __alltraps
  102025:	e9 ff fd ff ff       	jmp    101e29 <__alltraps>

0010202a <vector55>:
.globl vector55
vector55:
  pushl $0
  10202a:	6a 00                	push   $0x0
  pushl $55
  10202c:	6a 37                	push   $0x37
  jmp __alltraps
  10202e:	e9 f6 fd ff ff       	jmp    101e29 <__alltraps>

00102033 <vector56>:
.globl vector56
vector56:
  pushl $0
  102033:	6a 00                	push   $0x0
  pushl $56
  102035:	6a 38                	push   $0x38
  jmp __alltraps
  102037:	e9 ed fd ff ff       	jmp    101e29 <__alltraps>

0010203c <vector57>:
.globl vector57
vector57:
  pushl $0
  10203c:	6a 00                	push   $0x0
  pushl $57
  10203e:	6a 39                	push   $0x39
  jmp __alltraps
  102040:	e9 e4 fd ff ff       	jmp    101e29 <__alltraps>

00102045 <vector58>:
.globl vector58
vector58:
  pushl $0
  102045:	6a 00                	push   $0x0
  pushl $58
  102047:	6a 3a                	push   $0x3a
  jmp __alltraps
  102049:	e9 db fd ff ff       	jmp    101e29 <__alltraps>

0010204e <vector59>:
.globl vector59
vector59:
  pushl $0
  10204e:	6a 00                	push   $0x0
  pushl $59
  102050:	6a 3b                	push   $0x3b
  jmp __alltraps
  102052:	e9 d2 fd ff ff       	jmp    101e29 <__alltraps>

00102057 <vector60>:
.globl vector60
vector60:
  pushl $0
  102057:	6a 00                	push   $0x0
  pushl $60
  102059:	6a 3c                	push   $0x3c
  jmp __alltraps
  10205b:	e9 c9 fd ff ff       	jmp    101e29 <__alltraps>

00102060 <vector61>:
.globl vector61
vector61:
  pushl $0
  102060:	6a 00                	push   $0x0
  pushl $61
  102062:	6a 3d                	push   $0x3d
  jmp __alltraps
  102064:	e9 c0 fd ff ff       	jmp    101e29 <__alltraps>

00102069 <vector62>:
.globl vector62
vector62:
  pushl $0
  102069:	6a 00                	push   $0x0
  pushl $62
  10206b:	6a 3e                	push   $0x3e
  jmp __alltraps
  10206d:	e9 b7 fd ff ff       	jmp    101e29 <__alltraps>

00102072 <vector63>:
.globl vector63
vector63:
  pushl $0
  102072:	6a 00                	push   $0x0
  pushl $63
  102074:	6a 3f                	push   $0x3f
  jmp __alltraps
  102076:	e9 ae fd ff ff       	jmp    101e29 <__alltraps>

0010207b <vector64>:
.globl vector64
vector64:
  pushl $0
  10207b:	6a 00                	push   $0x0
  pushl $64
  10207d:	6a 40                	push   $0x40
  jmp __alltraps
  10207f:	e9 a5 fd ff ff       	jmp    101e29 <__alltraps>

00102084 <vector65>:
.globl vector65
vector65:
  pushl $0
  102084:	6a 00                	push   $0x0
  pushl $65
  102086:	6a 41                	push   $0x41
  jmp __alltraps
  102088:	e9 9c fd ff ff       	jmp    101e29 <__alltraps>

0010208d <vector66>:
.globl vector66
vector66:
  pushl $0
  10208d:	6a 00                	push   $0x0
  pushl $66
  10208f:	6a 42                	push   $0x42
  jmp __alltraps
  102091:	e9 93 fd ff ff       	jmp    101e29 <__alltraps>

00102096 <vector67>:
.globl vector67
vector67:
  pushl $0
  102096:	6a 00                	push   $0x0
  pushl $67
  102098:	6a 43                	push   $0x43
  jmp __alltraps
  10209a:	e9 8a fd ff ff       	jmp    101e29 <__alltraps>

0010209f <vector68>:
.globl vector68
vector68:
  pushl $0
  10209f:	6a 00                	push   $0x0
  pushl $68
  1020a1:	6a 44                	push   $0x44
  jmp __alltraps
  1020a3:	e9 81 fd ff ff       	jmp    101e29 <__alltraps>

001020a8 <vector69>:
.globl vector69
vector69:
  pushl $0
  1020a8:	6a 00                	push   $0x0
  pushl $69
  1020aa:	6a 45                	push   $0x45
  jmp __alltraps
  1020ac:	e9 78 fd ff ff       	jmp    101e29 <__alltraps>

001020b1 <vector70>:
.globl vector70
vector70:
  pushl $0
  1020b1:	6a 00                	push   $0x0
  pushl $70
  1020b3:	6a 46                	push   $0x46
  jmp __alltraps
  1020b5:	e9 6f fd ff ff       	jmp    101e29 <__alltraps>

001020ba <vector71>:
.globl vector71
vector71:
  pushl $0
  1020ba:	6a 00                	push   $0x0
  pushl $71
  1020bc:	6a 47                	push   $0x47
  jmp __alltraps
  1020be:	e9 66 fd ff ff       	jmp    101e29 <__alltraps>

001020c3 <vector72>:
.globl vector72
vector72:
  pushl $0
  1020c3:	6a 00                	push   $0x0
  pushl $72
  1020c5:	6a 48                	push   $0x48
  jmp __alltraps
  1020c7:	e9 5d fd ff ff       	jmp    101e29 <__alltraps>

001020cc <vector73>:
.globl vector73
vector73:
  pushl $0
  1020cc:	6a 00                	push   $0x0
  pushl $73
  1020ce:	6a 49                	push   $0x49
  jmp __alltraps
  1020d0:	e9 54 fd ff ff       	jmp    101e29 <__alltraps>

001020d5 <vector74>:
.globl vector74
vector74:
  pushl $0
  1020d5:	6a 00                	push   $0x0
  pushl $74
  1020d7:	6a 4a                	push   $0x4a
  jmp __alltraps
  1020d9:	e9 4b fd ff ff       	jmp    101e29 <__alltraps>

001020de <vector75>:
.globl vector75
vector75:
  pushl $0
  1020de:	6a 00                	push   $0x0
  pushl $75
  1020e0:	6a 4b                	push   $0x4b
  jmp __alltraps
  1020e2:	e9 42 fd ff ff       	jmp    101e29 <__alltraps>

001020e7 <vector76>:
.globl vector76
vector76:
  pushl $0
  1020e7:	6a 00                	push   $0x0
  pushl $76
  1020e9:	6a 4c                	push   $0x4c
  jmp __alltraps
  1020eb:	e9 39 fd ff ff       	jmp    101e29 <__alltraps>

001020f0 <vector77>:
.globl vector77
vector77:
  pushl $0
  1020f0:	6a 00                	push   $0x0
  pushl $77
  1020f2:	6a 4d                	push   $0x4d
  jmp __alltraps
  1020f4:	e9 30 fd ff ff       	jmp    101e29 <__alltraps>

001020f9 <vector78>:
.globl vector78
vector78:
  pushl $0
  1020f9:	6a 00                	push   $0x0
  pushl $78
  1020fb:	6a 4e                	push   $0x4e
  jmp __alltraps
  1020fd:	e9 27 fd ff ff       	jmp    101e29 <__alltraps>

00102102 <vector79>:
.globl vector79
vector79:
  pushl $0
  102102:	6a 00                	push   $0x0
  pushl $79
  102104:	6a 4f                	push   $0x4f
  jmp __alltraps
  102106:	e9 1e fd ff ff       	jmp    101e29 <__alltraps>

0010210b <vector80>:
.globl vector80
vector80:
  pushl $0
  10210b:	6a 00                	push   $0x0
  pushl $80
  10210d:	6a 50                	push   $0x50
  jmp __alltraps
  10210f:	e9 15 fd ff ff       	jmp    101e29 <__alltraps>

00102114 <vector81>:
.globl vector81
vector81:
  pushl $0
  102114:	6a 00                	push   $0x0
  pushl $81
  102116:	6a 51                	push   $0x51
  jmp __alltraps
  102118:	e9 0c fd ff ff       	jmp    101e29 <__alltraps>

0010211d <vector82>:
.globl vector82
vector82:
  pushl $0
  10211d:	6a 00                	push   $0x0
  pushl $82
  10211f:	6a 52                	push   $0x52
  jmp __alltraps
  102121:	e9 03 fd ff ff       	jmp    101e29 <__alltraps>

00102126 <vector83>:
.globl vector83
vector83:
  pushl $0
  102126:	6a 00                	push   $0x0
  pushl $83
  102128:	6a 53                	push   $0x53
  jmp __alltraps
  10212a:	e9 fa fc ff ff       	jmp    101e29 <__alltraps>

0010212f <vector84>:
.globl vector84
vector84:
  pushl $0
  10212f:	6a 00                	push   $0x0
  pushl $84
  102131:	6a 54                	push   $0x54
  jmp __alltraps
  102133:	e9 f1 fc ff ff       	jmp    101e29 <__alltraps>

00102138 <vector85>:
.globl vector85
vector85:
  pushl $0
  102138:	6a 00                	push   $0x0
  pushl $85
  10213a:	6a 55                	push   $0x55
  jmp __alltraps
  10213c:	e9 e8 fc ff ff       	jmp    101e29 <__alltraps>

00102141 <vector86>:
.globl vector86
vector86:
  pushl $0
  102141:	6a 00                	push   $0x0
  pushl $86
  102143:	6a 56                	push   $0x56
  jmp __alltraps
  102145:	e9 df fc ff ff       	jmp    101e29 <__alltraps>

0010214a <vector87>:
.globl vector87
vector87:
  pushl $0
  10214a:	6a 00                	push   $0x0
  pushl $87
  10214c:	6a 57                	push   $0x57
  jmp __alltraps
  10214e:	e9 d6 fc ff ff       	jmp    101e29 <__alltraps>

00102153 <vector88>:
.globl vector88
vector88:
  pushl $0
  102153:	6a 00                	push   $0x0
  pushl $88
  102155:	6a 58                	push   $0x58
  jmp __alltraps
  102157:	e9 cd fc ff ff       	jmp    101e29 <__alltraps>

0010215c <vector89>:
.globl vector89
vector89:
  pushl $0
  10215c:	6a 00                	push   $0x0
  pushl $89
  10215e:	6a 59                	push   $0x59
  jmp __alltraps
  102160:	e9 c4 fc ff ff       	jmp    101e29 <__alltraps>

00102165 <vector90>:
.globl vector90
vector90:
  pushl $0
  102165:	6a 00                	push   $0x0
  pushl $90
  102167:	6a 5a                	push   $0x5a
  jmp __alltraps
  102169:	e9 bb fc ff ff       	jmp    101e29 <__alltraps>

0010216e <vector91>:
.globl vector91
vector91:
  pushl $0
  10216e:	6a 00                	push   $0x0
  pushl $91
  102170:	6a 5b                	push   $0x5b
  jmp __alltraps
  102172:	e9 b2 fc ff ff       	jmp    101e29 <__alltraps>

00102177 <vector92>:
.globl vector92
vector92:
  pushl $0
  102177:	6a 00                	push   $0x0
  pushl $92
  102179:	6a 5c                	push   $0x5c
  jmp __alltraps
  10217b:	e9 a9 fc ff ff       	jmp    101e29 <__alltraps>

00102180 <vector93>:
.globl vector93
vector93:
  pushl $0
  102180:	6a 00                	push   $0x0
  pushl $93
  102182:	6a 5d                	push   $0x5d
  jmp __alltraps
  102184:	e9 a0 fc ff ff       	jmp    101e29 <__alltraps>

00102189 <vector94>:
.globl vector94
vector94:
  pushl $0
  102189:	6a 00                	push   $0x0
  pushl $94
  10218b:	6a 5e                	push   $0x5e
  jmp __alltraps
  10218d:	e9 97 fc ff ff       	jmp    101e29 <__alltraps>

00102192 <vector95>:
.globl vector95
vector95:
  pushl $0
  102192:	6a 00                	push   $0x0
  pushl $95
  102194:	6a 5f                	push   $0x5f
  jmp __alltraps
  102196:	e9 8e fc ff ff       	jmp    101e29 <__alltraps>

0010219b <vector96>:
.globl vector96
vector96:
  pushl $0
  10219b:	6a 00                	push   $0x0
  pushl $96
  10219d:	6a 60                	push   $0x60
  jmp __alltraps
  10219f:	e9 85 fc ff ff       	jmp    101e29 <__alltraps>

001021a4 <vector97>:
.globl vector97
vector97:
  pushl $0
  1021a4:	6a 00                	push   $0x0
  pushl $97
  1021a6:	6a 61                	push   $0x61
  jmp __alltraps
  1021a8:	e9 7c fc ff ff       	jmp    101e29 <__alltraps>

001021ad <vector98>:
.globl vector98
vector98:
  pushl $0
  1021ad:	6a 00                	push   $0x0
  pushl $98
  1021af:	6a 62                	push   $0x62
  jmp __alltraps
  1021b1:	e9 73 fc ff ff       	jmp    101e29 <__alltraps>

001021b6 <vector99>:
.globl vector99
vector99:
  pushl $0
  1021b6:	6a 00                	push   $0x0
  pushl $99
  1021b8:	6a 63                	push   $0x63
  jmp __alltraps
  1021ba:	e9 6a fc ff ff       	jmp    101e29 <__alltraps>

001021bf <vector100>:
.globl vector100
vector100:
  pushl $0
  1021bf:	6a 00                	push   $0x0
  pushl $100
  1021c1:	6a 64                	push   $0x64
  jmp __alltraps
  1021c3:	e9 61 fc ff ff       	jmp    101e29 <__alltraps>

001021c8 <vector101>:
.globl vector101
vector101:
  pushl $0
  1021c8:	6a 00                	push   $0x0
  pushl $101
  1021ca:	6a 65                	push   $0x65
  jmp __alltraps
  1021cc:	e9 58 fc ff ff       	jmp    101e29 <__alltraps>

001021d1 <vector102>:
.globl vector102
vector102:
  pushl $0
  1021d1:	6a 00                	push   $0x0
  pushl $102
  1021d3:	6a 66                	push   $0x66
  jmp __alltraps
  1021d5:	e9 4f fc ff ff       	jmp    101e29 <__alltraps>

001021da <vector103>:
.globl vector103
vector103:
  pushl $0
  1021da:	6a 00                	push   $0x0
  pushl $103
  1021dc:	6a 67                	push   $0x67
  jmp __alltraps
  1021de:	e9 46 fc ff ff       	jmp    101e29 <__alltraps>

001021e3 <vector104>:
.globl vector104
vector104:
  pushl $0
  1021e3:	6a 00                	push   $0x0
  pushl $104
  1021e5:	6a 68                	push   $0x68
  jmp __alltraps
  1021e7:	e9 3d fc ff ff       	jmp    101e29 <__alltraps>

001021ec <vector105>:
.globl vector105
vector105:
  pushl $0
  1021ec:	6a 00                	push   $0x0
  pushl $105
  1021ee:	6a 69                	push   $0x69
  jmp __alltraps
  1021f0:	e9 34 fc ff ff       	jmp    101e29 <__alltraps>

001021f5 <vector106>:
.globl vector106
vector106:
  pushl $0
  1021f5:	6a 00                	push   $0x0
  pushl $106
  1021f7:	6a 6a                	push   $0x6a
  jmp __alltraps
  1021f9:	e9 2b fc ff ff       	jmp    101e29 <__alltraps>

001021fe <vector107>:
.globl vector107
vector107:
  pushl $0
  1021fe:	6a 00                	push   $0x0
  pushl $107
  102200:	6a 6b                	push   $0x6b
  jmp __alltraps
  102202:	e9 22 fc ff ff       	jmp    101e29 <__alltraps>

00102207 <vector108>:
.globl vector108
vector108:
  pushl $0
  102207:	6a 00                	push   $0x0
  pushl $108
  102209:	6a 6c                	push   $0x6c
  jmp __alltraps
  10220b:	e9 19 fc ff ff       	jmp    101e29 <__alltraps>

00102210 <vector109>:
.globl vector109
vector109:
  pushl $0
  102210:	6a 00                	push   $0x0
  pushl $109
  102212:	6a 6d                	push   $0x6d
  jmp __alltraps
  102214:	e9 10 fc ff ff       	jmp    101e29 <__alltraps>

00102219 <vector110>:
.globl vector110
vector110:
  pushl $0
  102219:	6a 00                	push   $0x0
  pushl $110
  10221b:	6a 6e                	push   $0x6e
  jmp __alltraps
  10221d:	e9 07 fc ff ff       	jmp    101e29 <__alltraps>

00102222 <vector111>:
.globl vector111
vector111:
  pushl $0
  102222:	6a 00                	push   $0x0
  pushl $111
  102224:	6a 6f                	push   $0x6f
  jmp __alltraps
  102226:	e9 fe fb ff ff       	jmp    101e29 <__alltraps>

0010222b <vector112>:
.globl vector112
vector112:
  pushl $0
  10222b:	6a 00                	push   $0x0
  pushl $112
  10222d:	6a 70                	push   $0x70
  jmp __alltraps
  10222f:	e9 f5 fb ff ff       	jmp    101e29 <__alltraps>

00102234 <vector113>:
.globl vector113
vector113:
  pushl $0
  102234:	6a 00                	push   $0x0
  pushl $113
  102236:	6a 71                	push   $0x71
  jmp __alltraps
  102238:	e9 ec fb ff ff       	jmp    101e29 <__alltraps>

0010223d <vector114>:
.globl vector114
vector114:
  pushl $0
  10223d:	6a 00                	push   $0x0
  pushl $114
  10223f:	6a 72                	push   $0x72
  jmp __alltraps
  102241:	e9 e3 fb ff ff       	jmp    101e29 <__alltraps>

00102246 <vector115>:
.globl vector115
vector115:
  pushl $0
  102246:	6a 00                	push   $0x0
  pushl $115
  102248:	6a 73                	push   $0x73
  jmp __alltraps
  10224a:	e9 da fb ff ff       	jmp    101e29 <__alltraps>

0010224f <vector116>:
.globl vector116
vector116:
  pushl $0
  10224f:	6a 00                	push   $0x0
  pushl $116
  102251:	6a 74                	push   $0x74
  jmp __alltraps
  102253:	e9 d1 fb ff ff       	jmp    101e29 <__alltraps>

00102258 <vector117>:
.globl vector117
vector117:
  pushl $0
  102258:	6a 00                	push   $0x0
  pushl $117
  10225a:	6a 75                	push   $0x75
  jmp __alltraps
  10225c:	e9 c8 fb ff ff       	jmp    101e29 <__alltraps>

00102261 <vector118>:
.globl vector118
vector118:
  pushl $0
  102261:	6a 00                	push   $0x0
  pushl $118
  102263:	6a 76                	push   $0x76
  jmp __alltraps
  102265:	e9 bf fb ff ff       	jmp    101e29 <__alltraps>

0010226a <vector119>:
.globl vector119
vector119:
  pushl $0
  10226a:	6a 00                	push   $0x0
  pushl $119
  10226c:	6a 77                	push   $0x77
  jmp __alltraps
  10226e:	e9 b6 fb ff ff       	jmp    101e29 <__alltraps>

00102273 <vector120>:
.globl vector120
vector120:
  pushl $0
  102273:	6a 00                	push   $0x0
  pushl $120
  102275:	6a 78                	push   $0x78
  jmp __alltraps
  102277:	e9 ad fb ff ff       	jmp    101e29 <__alltraps>

0010227c <vector121>:
.globl vector121
vector121:
  pushl $0
  10227c:	6a 00                	push   $0x0
  pushl $121
  10227e:	6a 79                	push   $0x79
  jmp __alltraps
  102280:	e9 a4 fb ff ff       	jmp    101e29 <__alltraps>

00102285 <vector122>:
.globl vector122
vector122:
  pushl $0
  102285:	6a 00                	push   $0x0
  pushl $122
  102287:	6a 7a                	push   $0x7a
  jmp __alltraps
  102289:	e9 9b fb ff ff       	jmp    101e29 <__alltraps>

0010228e <vector123>:
.globl vector123
vector123:
  pushl $0
  10228e:	6a 00                	push   $0x0
  pushl $123
  102290:	6a 7b                	push   $0x7b
  jmp __alltraps
  102292:	e9 92 fb ff ff       	jmp    101e29 <__alltraps>

00102297 <vector124>:
.globl vector124
vector124:
  pushl $0
  102297:	6a 00                	push   $0x0
  pushl $124
  102299:	6a 7c                	push   $0x7c
  jmp __alltraps
  10229b:	e9 89 fb ff ff       	jmp    101e29 <__alltraps>

001022a0 <vector125>:
.globl vector125
vector125:
  pushl $0
  1022a0:	6a 00                	push   $0x0
  pushl $125
  1022a2:	6a 7d                	push   $0x7d
  jmp __alltraps
  1022a4:	e9 80 fb ff ff       	jmp    101e29 <__alltraps>

001022a9 <vector126>:
.globl vector126
vector126:
  pushl $0
  1022a9:	6a 00                	push   $0x0
  pushl $126
  1022ab:	6a 7e                	push   $0x7e
  jmp __alltraps
  1022ad:	e9 77 fb ff ff       	jmp    101e29 <__alltraps>

001022b2 <vector127>:
.globl vector127
vector127:
  pushl $0
  1022b2:	6a 00                	push   $0x0
  pushl $127
  1022b4:	6a 7f                	push   $0x7f
  jmp __alltraps
  1022b6:	e9 6e fb ff ff       	jmp    101e29 <__alltraps>

001022bb <vector128>:
.globl vector128
vector128:
  pushl $0
  1022bb:	6a 00                	push   $0x0
  pushl $128
  1022bd:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1022c2:	e9 62 fb ff ff       	jmp    101e29 <__alltraps>

001022c7 <vector129>:
.globl vector129
vector129:
  pushl $0
  1022c7:	6a 00                	push   $0x0
  pushl $129
  1022c9:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1022ce:	e9 56 fb ff ff       	jmp    101e29 <__alltraps>

001022d3 <vector130>:
.globl vector130
vector130:
  pushl $0
  1022d3:	6a 00                	push   $0x0
  pushl $130
  1022d5:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1022da:	e9 4a fb ff ff       	jmp    101e29 <__alltraps>

001022df <vector131>:
.globl vector131
vector131:
  pushl $0
  1022df:	6a 00                	push   $0x0
  pushl $131
  1022e1:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1022e6:	e9 3e fb ff ff       	jmp    101e29 <__alltraps>

001022eb <vector132>:
.globl vector132
vector132:
  pushl $0
  1022eb:	6a 00                	push   $0x0
  pushl $132
  1022ed:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1022f2:	e9 32 fb ff ff       	jmp    101e29 <__alltraps>

001022f7 <vector133>:
.globl vector133
vector133:
  pushl $0
  1022f7:	6a 00                	push   $0x0
  pushl $133
  1022f9:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1022fe:	e9 26 fb ff ff       	jmp    101e29 <__alltraps>

00102303 <vector134>:
.globl vector134
vector134:
  pushl $0
  102303:	6a 00                	push   $0x0
  pushl $134
  102305:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10230a:	e9 1a fb ff ff       	jmp    101e29 <__alltraps>

0010230f <vector135>:
.globl vector135
vector135:
  pushl $0
  10230f:	6a 00                	push   $0x0
  pushl $135
  102311:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102316:	e9 0e fb ff ff       	jmp    101e29 <__alltraps>

0010231b <vector136>:
.globl vector136
vector136:
  pushl $0
  10231b:	6a 00                	push   $0x0
  pushl $136
  10231d:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102322:	e9 02 fb ff ff       	jmp    101e29 <__alltraps>

00102327 <vector137>:
.globl vector137
vector137:
  pushl $0
  102327:	6a 00                	push   $0x0
  pushl $137
  102329:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10232e:	e9 f6 fa ff ff       	jmp    101e29 <__alltraps>

00102333 <vector138>:
.globl vector138
vector138:
  pushl $0
  102333:	6a 00                	push   $0x0
  pushl $138
  102335:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10233a:	e9 ea fa ff ff       	jmp    101e29 <__alltraps>

0010233f <vector139>:
.globl vector139
vector139:
  pushl $0
  10233f:	6a 00                	push   $0x0
  pushl $139
  102341:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102346:	e9 de fa ff ff       	jmp    101e29 <__alltraps>

0010234b <vector140>:
.globl vector140
vector140:
  pushl $0
  10234b:	6a 00                	push   $0x0
  pushl $140
  10234d:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102352:	e9 d2 fa ff ff       	jmp    101e29 <__alltraps>

00102357 <vector141>:
.globl vector141
vector141:
  pushl $0
  102357:	6a 00                	push   $0x0
  pushl $141
  102359:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10235e:	e9 c6 fa ff ff       	jmp    101e29 <__alltraps>

00102363 <vector142>:
.globl vector142
vector142:
  pushl $0
  102363:	6a 00                	push   $0x0
  pushl $142
  102365:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10236a:	e9 ba fa ff ff       	jmp    101e29 <__alltraps>

0010236f <vector143>:
.globl vector143
vector143:
  pushl $0
  10236f:	6a 00                	push   $0x0
  pushl $143
  102371:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102376:	e9 ae fa ff ff       	jmp    101e29 <__alltraps>

0010237b <vector144>:
.globl vector144
vector144:
  pushl $0
  10237b:	6a 00                	push   $0x0
  pushl $144
  10237d:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102382:	e9 a2 fa ff ff       	jmp    101e29 <__alltraps>

00102387 <vector145>:
.globl vector145
vector145:
  pushl $0
  102387:	6a 00                	push   $0x0
  pushl $145
  102389:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10238e:	e9 96 fa ff ff       	jmp    101e29 <__alltraps>

00102393 <vector146>:
.globl vector146
vector146:
  pushl $0
  102393:	6a 00                	push   $0x0
  pushl $146
  102395:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10239a:	e9 8a fa ff ff       	jmp    101e29 <__alltraps>

0010239f <vector147>:
.globl vector147
vector147:
  pushl $0
  10239f:	6a 00                	push   $0x0
  pushl $147
  1023a1:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1023a6:	e9 7e fa ff ff       	jmp    101e29 <__alltraps>

001023ab <vector148>:
.globl vector148
vector148:
  pushl $0
  1023ab:	6a 00                	push   $0x0
  pushl $148
  1023ad:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1023b2:	e9 72 fa ff ff       	jmp    101e29 <__alltraps>

001023b7 <vector149>:
.globl vector149
vector149:
  pushl $0
  1023b7:	6a 00                	push   $0x0
  pushl $149
  1023b9:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1023be:	e9 66 fa ff ff       	jmp    101e29 <__alltraps>

001023c3 <vector150>:
.globl vector150
vector150:
  pushl $0
  1023c3:	6a 00                	push   $0x0
  pushl $150
  1023c5:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1023ca:	e9 5a fa ff ff       	jmp    101e29 <__alltraps>

001023cf <vector151>:
.globl vector151
vector151:
  pushl $0
  1023cf:	6a 00                	push   $0x0
  pushl $151
  1023d1:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1023d6:	e9 4e fa ff ff       	jmp    101e29 <__alltraps>

001023db <vector152>:
.globl vector152
vector152:
  pushl $0
  1023db:	6a 00                	push   $0x0
  pushl $152
  1023dd:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1023e2:	e9 42 fa ff ff       	jmp    101e29 <__alltraps>

001023e7 <vector153>:
.globl vector153
vector153:
  pushl $0
  1023e7:	6a 00                	push   $0x0
  pushl $153
  1023e9:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1023ee:	e9 36 fa ff ff       	jmp    101e29 <__alltraps>

001023f3 <vector154>:
.globl vector154
vector154:
  pushl $0
  1023f3:	6a 00                	push   $0x0
  pushl $154
  1023f5:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1023fa:	e9 2a fa ff ff       	jmp    101e29 <__alltraps>

001023ff <vector155>:
.globl vector155
vector155:
  pushl $0
  1023ff:	6a 00                	push   $0x0
  pushl $155
  102401:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102406:	e9 1e fa ff ff       	jmp    101e29 <__alltraps>

0010240b <vector156>:
.globl vector156
vector156:
  pushl $0
  10240b:	6a 00                	push   $0x0
  pushl $156
  10240d:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102412:	e9 12 fa ff ff       	jmp    101e29 <__alltraps>

00102417 <vector157>:
.globl vector157
vector157:
  pushl $0
  102417:	6a 00                	push   $0x0
  pushl $157
  102419:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10241e:	e9 06 fa ff ff       	jmp    101e29 <__alltraps>

00102423 <vector158>:
.globl vector158
vector158:
  pushl $0
  102423:	6a 00                	push   $0x0
  pushl $158
  102425:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10242a:	e9 fa f9 ff ff       	jmp    101e29 <__alltraps>

0010242f <vector159>:
.globl vector159
vector159:
  pushl $0
  10242f:	6a 00                	push   $0x0
  pushl $159
  102431:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102436:	e9 ee f9 ff ff       	jmp    101e29 <__alltraps>

0010243b <vector160>:
.globl vector160
vector160:
  pushl $0
  10243b:	6a 00                	push   $0x0
  pushl $160
  10243d:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102442:	e9 e2 f9 ff ff       	jmp    101e29 <__alltraps>

00102447 <vector161>:
.globl vector161
vector161:
  pushl $0
  102447:	6a 00                	push   $0x0
  pushl $161
  102449:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10244e:	e9 d6 f9 ff ff       	jmp    101e29 <__alltraps>

00102453 <vector162>:
.globl vector162
vector162:
  pushl $0
  102453:	6a 00                	push   $0x0
  pushl $162
  102455:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10245a:	e9 ca f9 ff ff       	jmp    101e29 <__alltraps>

0010245f <vector163>:
.globl vector163
vector163:
  pushl $0
  10245f:	6a 00                	push   $0x0
  pushl $163
  102461:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102466:	e9 be f9 ff ff       	jmp    101e29 <__alltraps>

0010246b <vector164>:
.globl vector164
vector164:
  pushl $0
  10246b:	6a 00                	push   $0x0
  pushl $164
  10246d:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102472:	e9 b2 f9 ff ff       	jmp    101e29 <__alltraps>

00102477 <vector165>:
.globl vector165
vector165:
  pushl $0
  102477:	6a 00                	push   $0x0
  pushl $165
  102479:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10247e:	e9 a6 f9 ff ff       	jmp    101e29 <__alltraps>

00102483 <vector166>:
.globl vector166
vector166:
  pushl $0
  102483:	6a 00                	push   $0x0
  pushl $166
  102485:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10248a:	e9 9a f9 ff ff       	jmp    101e29 <__alltraps>

0010248f <vector167>:
.globl vector167
vector167:
  pushl $0
  10248f:	6a 00                	push   $0x0
  pushl $167
  102491:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102496:	e9 8e f9 ff ff       	jmp    101e29 <__alltraps>

0010249b <vector168>:
.globl vector168
vector168:
  pushl $0
  10249b:	6a 00                	push   $0x0
  pushl $168
  10249d:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1024a2:	e9 82 f9 ff ff       	jmp    101e29 <__alltraps>

001024a7 <vector169>:
.globl vector169
vector169:
  pushl $0
  1024a7:	6a 00                	push   $0x0
  pushl $169
  1024a9:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1024ae:	e9 76 f9 ff ff       	jmp    101e29 <__alltraps>

001024b3 <vector170>:
.globl vector170
vector170:
  pushl $0
  1024b3:	6a 00                	push   $0x0
  pushl $170
  1024b5:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1024ba:	e9 6a f9 ff ff       	jmp    101e29 <__alltraps>

001024bf <vector171>:
.globl vector171
vector171:
  pushl $0
  1024bf:	6a 00                	push   $0x0
  pushl $171
  1024c1:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1024c6:	e9 5e f9 ff ff       	jmp    101e29 <__alltraps>

001024cb <vector172>:
.globl vector172
vector172:
  pushl $0
  1024cb:	6a 00                	push   $0x0
  pushl $172
  1024cd:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1024d2:	e9 52 f9 ff ff       	jmp    101e29 <__alltraps>

001024d7 <vector173>:
.globl vector173
vector173:
  pushl $0
  1024d7:	6a 00                	push   $0x0
  pushl $173
  1024d9:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1024de:	e9 46 f9 ff ff       	jmp    101e29 <__alltraps>

001024e3 <vector174>:
.globl vector174
vector174:
  pushl $0
  1024e3:	6a 00                	push   $0x0
  pushl $174
  1024e5:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1024ea:	e9 3a f9 ff ff       	jmp    101e29 <__alltraps>

001024ef <vector175>:
.globl vector175
vector175:
  pushl $0
  1024ef:	6a 00                	push   $0x0
  pushl $175
  1024f1:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1024f6:	e9 2e f9 ff ff       	jmp    101e29 <__alltraps>

001024fb <vector176>:
.globl vector176
vector176:
  pushl $0
  1024fb:	6a 00                	push   $0x0
  pushl $176
  1024fd:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102502:	e9 22 f9 ff ff       	jmp    101e29 <__alltraps>

00102507 <vector177>:
.globl vector177
vector177:
  pushl $0
  102507:	6a 00                	push   $0x0
  pushl $177
  102509:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10250e:	e9 16 f9 ff ff       	jmp    101e29 <__alltraps>

00102513 <vector178>:
.globl vector178
vector178:
  pushl $0
  102513:	6a 00                	push   $0x0
  pushl $178
  102515:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10251a:	e9 0a f9 ff ff       	jmp    101e29 <__alltraps>

0010251f <vector179>:
.globl vector179
vector179:
  pushl $0
  10251f:	6a 00                	push   $0x0
  pushl $179
  102521:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102526:	e9 fe f8 ff ff       	jmp    101e29 <__alltraps>

0010252b <vector180>:
.globl vector180
vector180:
  pushl $0
  10252b:	6a 00                	push   $0x0
  pushl $180
  10252d:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102532:	e9 f2 f8 ff ff       	jmp    101e29 <__alltraps>

00102537 <vector181>:
.globl vector181
vector181:
  pushl $0
  102537:	6a 00                	push   $0x0
  pushl $181
  102539:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10253e:	e9 e6 f8 ff ff       	jmp    101e29 <__alltraps>

00102543 <vector182>:
.globl vector182
vector182:
  pushl $0
  102543:	6a 00                	push   $0x0
  pushl $182
  102545:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10254a:	e9 da f8 ff ff       	jmp    101e29 <__alltraps>

0010254f <vector183>:
.globl vector183
vector183:
  pushl $0
  10254f:	6a 00                	push   $0x0
  pushl $183
  102551:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102556:	e9 ce f8 ff ff       	jmp    101e29 <__alltraps>

0010255b <vector184>:
.globl vector184
vector184:
  pushl $0
  10255b:	6a 00                	push   $0x0
  pushl $184
  10255d:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102562:	e9 c2 f8 ff ff       	jmp    101e29 <__alltraps>

00102567 <vector185>:
.globl vector185
vector185:
  pushl $0
  102567:	6a 00                	push   $0x0
  pushl $185
  102569:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10256e:	e9 b6 f8 ff ff       	jmp    101e29 <__alltraps>

00102573 <vector186>:
.globl vector186
vector186:
  pushl $0
  102573:	6a 00                	push   $0x0
  pushl $186
  102575:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10257a:	e9 aa f8 ff ff       	jmp    101e29 <__alltraps>

0010257f <vector187>:
.globl vector187
vector187:
  pushl $0
  10257f:	6a 00                	push   $0x0
  pushl $187
  102581:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102586:	e9 9e f8 ff ff       	jmp    101e29 <__alltraps>

0010258b <vector188>:
.globl vector188
vector188:
  pushl $0
  10258b:	6a 00                	push   $0x0
  pushl $188
  10258d:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102592:	e9 92 f8 ff ff       	jmp    101e29 <__alltraps>

00102597 <vector189>:
.globl vector189
vector189:
  pushl $0
  102597:	6a 00                	push   $0x0
  pushl $189
  102599:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10259e:	e9 86 f8 ff ff       	jmp    101e29 <__alltraps>

001025a3 <vector190>:
.globl vector190
vector190:
  pushl $0
  1025a3:	6a 00                	push   $0x0
  pushl $190
  1025a5:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1025aa:	e9 7a f8 ff ff       	jmp    101e29 <__alltraps>

001025af <vector191>:
.globl vector191
vector191:
  pushl $0
  1025af:	6a 00                	push   $0x0
  pushl $191
  1025b1:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1025b6:	e9 6e f8 ff ff       	jmp    101e29 <__alltraps>

001025bb <vector192>:
.globl vector192
vector192:
  pushl $0
  1025bb:	6a 00                	push   $0x0
  pushl $192
  1025bd:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1025c2:	e9 62 f8 ff ff       	jmp    101e29 <__alltraps>

001025c7 <vector193>:
.globl vector193
vector193:
  pushl $0
  1025c7:	6a 00                	push   $0x0
  pushl $193
  1025c9:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1025ce:	e9 56 f8 ff ff       	jmp    101e29 <__alltraps>

001025d3 <vector194>:
.globl vector194
vector194:
  pushl $0
  1025d3:	6a 00                	push   $0x0
  pushl $194
  1025d5:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1025da:	e9 4a f8 ff ff       	jmp    101e29 <__alltraps>

001025df <vector195>:
.globl vector195
vector195:
  pushl $0
  1025df:	6a 00                	push   $0x0
  pushl $195
  1025e1:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1025e6:	e9 3e f8 ff ff       	jmp    101e29 <__alltraps>

001025eb <vector196>:
.globl vector196
vector196:
  pushl $0
  1025eb:	6a 00                	push   $0x0
  pushl $196
  1025ed:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1025f2:	e9 32 f8 ff ff       	jmp    101e29 <__alltraps>

001025f7 <vector197>:
.globl vector197
vector197:
  pushl $0
  1025f7:	6a 00                	push   $0x0
  pushl $197
  1025f9:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1025fe:	e9 26 f8 ff ff       	jmp    101e29 <__alltraps>

00102603 <vector198>:
.globl vector198
vector198:
  pushl $0
  102603:	6a 00                	push   $0x0
  pushl $198
  102605:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10260a:	e9 1a f8 ff ff       	jmp    101e29 <__alltraps>

0010260f <vector199>:
.globl vector199
vector199:
  pushl $0
  10260f:	6a 00                	push   $0x0
  pushl $199
  102611:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102616:	e9 0e f8 ff ff       	jmp    101e29 <__alltraps>

0010261b <vector200>:
.globl vector200
vector200:
  pushl $0
  10261b:	6a 00                	push   $0x0
  pushl $200
  10261d:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102622:	e9 02 f8 ff ff       	jmp    101e29 <__alltraps>

00102627 <vector201>:
.globl vector201
vector201:
  pushl $0
  102627:	6a 00                	push   $0x0
  pushl $201
  102629:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10262e:	e9 f6 f7 ff ff       	jmp    101e29 <__alltraps>

00102633 <vector202>:
.globl vector202
vector202:
  pushl $0
  102633:	6a 00                	push   $0x0
  pushl $202
  102635:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10263a:	e9 ea f7 ff ff       	jmp    101e29 <__alltraps>

0010263f <vector203>:
.globl vector203
vector203:
  pushl $0
  10263f:	6a 00                	push   $0x0
  pushl $203
  102641:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102646:	e9 de f7 ff ff       	jmp    101e29 <__alltraps>

0010264b <vector204>:
.globl vector204
vector204:
  pushl $0
  10264b:	6a 00                	push   $0x0
  pushl $204
  10264d:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102652:	e9 d2 f7 ff ff       	jmp    101e29 <__alltraps>

00102657 <vector205>:
.globl vector205
vector205:
  pushl $0
  102657:	6a 00                	push   $0x0
  pushl $205
  102659:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10265e:	e9 c6 f7 ff ff       	jmp    101e29 <__alltraps>

00102663 <vector206>:
.globl vector206
vector206:
  pushl $0
  102663:	6a 00                	push   $0x0
  pushl $206
  102665:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10266a:	e9 ba f7 ff ff       	jmp    101e29 <__alltraps>

0010266f <vector207>:
.globl vector207
vector207:
  pushl $0
  10266f:	6a 00                	push   $0x0
  pushl $207
  102671:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102676:	e9 ae f7 ff ff       	jmp    101e29 <__alltraps>

0010267b <vector208>:
.globl vector208
vector208:
  pushl $0
  10267b:	6a 00                	push   $0x0
  pushl $208
  10267d:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102682:	e9 a2 f7 ff ff       	jmp    101e29 <__alltraps>

00102687 <vector209>:
.globl vector209
vector209:
  pushl $0
  102687:	6a 00                	push   $0x0
  pushl $209
  102689:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10268e:	e9 96 f7 ff ff       	jmp    101e29 <__alltraps>

00102693 <vector210>:
.globl vector210
vector210:
  pushl $0
  102693:	6a 00                	push   $0x0
  pushl $210
  102695:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10269a:	e9 8a f7 ff ff       	jmp    101e29 <__alltraps>

0010269f <vector211>:
.globl vector211
vector211:
  pushl $0
  10269f:	6a 00                	push   $0x0
  pushl $211
  1026a1:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1026a6:	e9 7e f7 ff ff       	jmp    101e29 <__alltraps>

001026ab <vector212>:
.globl vector212
vector212:
  pushl $0
  1026ab:	6a 00                	push   $0x0
  pushl $212
  1026ad:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1026b2:	e9 72 f7 ff ff       	jmp    101e29 <__alltraps>

001026b7 <vector213>:
.globl vector213
vector213:
  pushl $0
  1026b7:	6a 00                	push   $0x0
  pushl $213
  1026b9:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1026be:	e9 66 f7 ff ff       	jmp    101e29 <__alltraps>

001026c3 <vector214>:
.globl vector214
vector214:
  pushl $0
  1026c3:	6a 00                	push   $0x0
  pushl $214
  1026c5:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1026ca:	e9 5a f7 ff ff       	jmp    101e29 <__alltraps>

001026cf <vector215>:
.globl vector215
vector215:
  pushl $0
  1026cf:	6a 00                	push   $0x0
  pushl $215
  1026d1:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1026d6:	e9 4e f7 ff ff       	jmp    101e29 <__alltraps>

001026db <vector216>:
.globl vector216
vector216:
  pushl $0
  1026db:	6a 00                	push   $0x0
  pushl $216
  1026dd:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1026e2:	e9 42 f7 ff ff       	jmp    101e29 <__alltraps>

001026e7 <vector217>:
.globl vector217
vector217:
  pushl $0
  1026e7:	6a 00                	push   $0x0
  pushl $217
  1026e9:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1026ee:	e9 36 f7 ff ff       	jmp    101e29 <__alltraps>

001026f3 <vector218>:
.globl vector218
vector218:
  pushl $0
  1026f3:	6a 00                	push   $0x0
  pushl $218
  1026f5:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1026fa:	e9 2a f7 ff ff       	jmp    101e29 <__alltraps>

001026ff <vector219>:
.globl vector219
vector219:
  pushl $0
  1026ff:	6a 00                	push   $0x0
  pushl $219
  102701:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102706:	e9 1e f7 ff ff       	jmp    101e29 <__alltraps>

0010270b <vector220>:
.globl vector220
vector220:
  pushl $0
  10270b:	6a 00                	push   $0x0
  pushl $220
  10270d:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102712:	e9 12 f7 ff ff       	jmp    101e29 <__alltraps>

00102717 <vector221>:
.globl vector221
vector221:
  pushl $0
  102717:	6a 00                	push   $0x0
  pushl $221
  102719:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10271e:	e9 06 f7 ff ff       	jmp    101e29 <__alltraps>

00102723 <vector222>:
.globl vector222
vector222:
  pushl $0
  102723:	6a 00                	push   $0x0
  pushl $222
  102725:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10272a:	e9 fa f6 ff ff       	jmp    101e29 <__alltraps>

0010272f <vector223>:
.globl vector223
vector223:
  pushl $0
  10272f:	6a 00                	push   $0x0
  pushl $223
  102731:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102736:	e9 ee f6 ff ff       	jmp    101e29 <__alltraps>

0010273b <vector224>:
.globl vector224
vector224:
  pushl $0
  10273b:	6a 00                	push   $0x0
  pushl $224
  10273d:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102742:	e9 e2 f6 ff ff       	jmp    101e29 <__alltraps>

00102747 <vector225>:
.globl vector225
vector225:
  pushl $0
  102747:	6a 00                	push   $0x0
  pushl $225
  102749:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10274e:	e9 d6 f6 ff ff       	jmp    101e29 <__alltraps>

00102753 <vector226>:
.globl vector226
vector226:
  pushl $0
  102753:	6a 00                	push   $0x0
  pushl $226
  102755:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10275a:	e9 ca f6 ff ff       	jmp    101e29 <__alltraps>

0010275f <vector227>:
.globl vector227
vector227:
  pushl $0
  10275f:	6a 00                	push   $0x0
  pushl $227
  102761:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102766:	e9 be f6 ff ff       	jmp    101e29 <__alltraps>

0010276b <vector228>:
.globl vector228
vector228:
  pushl $0
  10276b:	6a 00                	push   $0x0
  pushl $228
  10276d:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102772:	e9 b2 f6 ff ff       	jmp    101e29 <__alltraps>

00102777 <vector229>:
.globl vector229
vector229:
  pushl $0
  102777:	6a 00                	push   $0x0
  pushl $229
  102779:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10277e:	e9 a6 f6 ff ff       	jmp    101e29 <__alltraps>

00102783 <vector230>:
.globl vector230
vector230:
  pushl $0
  102783:	6a 00                	push   $0x0
  pushl $230
  102785:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10278a:	e9 9a f6 ff ff       	jmp    101e29 <__alltraps>

0010278f <vector231>:
.globl vector231
vector231:
  pushl $0
  10278f:	6a 00                	push   $0x0
  pushl $231
  102791:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102796:	e9 8e f6 ff ff       	jmp    101e29 <__alltraps>

0010279b <vector232>:
.globl vector232
vector232:
  pushl $0
  10279b:	6a 00                	push   $0x0
  pushl $232
  10279d:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1027a2:	e9 82 f6 ff ff       	jmp    101e29 <__alltraps>

001027a7 <vector233>:
.globl vector233
vector233:
  pushl $0
  1027a7:	6a 00                	push   $0x0
  pushl $233
  1027a9:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1027ae:	e9 76 f6 ff ff       	jmp    101e29 <__alltraps>

001027b3 <vector234>:
.globl vector234
vector234:
  pushl $0
  1027b3:	6a 00                	push   $0x0
  pushl $234
  1027b5:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1027ba:	e9 6a f6 ff ff       	jmp    101e29 <__alltraps>

001027bf <vector235>:
.globl vector235
vector235:
  pushl $0
  1027bf:	6a 00                	push   $0x0
  pushl $235
  1027c1:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1027c6:	e9 5e f6 ff ff       	jmp    101e29 <__alltraps>

001027cb <vector236>:
.globl vector236
vector236:
  pushl $0
  1027cb:	6a 00                	push   $0x0
  pushl $236
  1027cd:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1027d2:	e9 52 f6 ff ff       	jmp    101e29 <__alltraps>

001027d7 <vector237>:
.globl vector237
vector237:
  pushl $0
  1027d7:	6a 00                	push   $0x0
  pushl $237
  1027d9:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1027de:	e9 46 f6 ff ff       	jmp    101e29 <__alltraps>

001027e3 <vector238>:
.globl vector238
vector238:
  pushl $0
  1027e3:	6a 00                	push   $0x0
  pushl $238
  1027e5:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1027ea:	e9 3a f6 ff ff       	jmp    101e29 <__alltraps>

001027ef <vector239>:
.globl vector239
vector239:
  pushl $0
  1027ef:	6a 00                	push   $0x0
  pushl $239
  1027f1:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1027f6:	e9 2e f6 ff ff       	jmp    101e29 <__alltraps>

001027fb <vector240>:
.globl vector240
vector240:
  pushl $0
  1027fb:	6a 00                	push   $0x0
  pushl $240
  1027fd:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102802:	e9 22 f6 ff ff       	jmp    101e29 <__alltraps>

00102807 <vector241>:
.globl vector241
vector241:
  pushl $0
  102807:	6a 00                	push   $0x0
  pushl $241
  102809:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10280e:	e9 16 f6 ff ff       	jmp    101e29 <__alltraps>

00102813 <vector242>:
.globl vector242
vector242:
  pushl $0
  102813:	6a 00                	push   $0x0
  pushl $242
  102815:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10281a:	e9 0a f6 ff ff       	jmp    101e29 <__alltraps>

0010281f <vector243>:
.globl vector243
vector243:
  pushl $0
  10281f:	6a 00                	push   $0x0
  pushl $243
  102821:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102826:	e9 fe f5 ff ff       	jmp    101e29 <__alltraps>

0010282b <vector244>:
.globl vector244
vector244:
  pushl $0
  10282b:	6a 00                	push   $0x0
  pushl $244
  10282d:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102832:	e9 f2 f5 ff ff       	jmp    101e29 <__alltraps>

00102837 <vector245>:
.globl vector245
vector245:
  pushl $0
  102837:	6a 00                	push   $0x0
  pushl $245
  102839:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10283e:	e9 e6 f5 ff ff       	jmp    101e29 <__alltraps>

00102843 <vector246>:
.globl vector246
vector246:
  pushl $0
  102843:	6a 00                	push   $0x0
  pushl $246
  102845:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10284a:	e9 da f5 ff ff       	jmp    101e29 <__alltraps>

0010284f <vector247>:
.globl vector247
vector247:
  pushl $0
  10284f:	6a 00                	push   $0x0
  pushl $247
  102851:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102856:	e9 ce f5 ff ff       	jmp    101e29 <__alltraps>

0010285b <vector248>:
.globl vector248
vector248:
  pushl $0
  10285b:	6a 00                	push   $0x0
  pushl $248
  10285d:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102862:	e9 c2 f5 ff ff       	jmp    101e29 <__alltraps>

00102867 <vector249>:
.globl vector249
vector249:
  pushl $0
  102867:	6a 00                	push   $0x0
  pushl $249
  102869:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10286e:	e9 b6 f5 ff ff       	jmp    101e29 <__alltraps>

00102873 <vector250>:
.globl vector250
vector250:
  pushl $0
  102873:	6a 00                	push   $0x0
  pushl $250
  102875:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10287a:	e9 aa f5 ff ff       	jmp    101e29 <__alltraps>

0010287f <vector251>:
.globl vector251
vector251:
  pushl $0
  10287f:	6a 00                	push   $0x0
  pushl $251
  102881:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102886:	e9 9e f5 ff ff       	jmp    101e29 <__alltraps>

0010288b <vector252>:
.globl vector252
vector252:
  pushl $0
  10288b:	6a 00                	push   $0x0
  pushl $252
  10288d:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102892:	e9 92 f5 ff ff       	jmp    101e29 <__alltraps>

00102897 <vector253>:
.globl vector253
vector253:
  pushl $0
  102897:	6a 00                	push   $0x0
  pushl $253
  102899:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10289e:	e9 86 f5 ff ff       	jmp    101e29 <__alltraps>

001028a3 <vector254>:
.globl vector254
vector254:
  pushl $0
  1028a3:	6a 00                	push   $0x0
  pushl $254
  1028a5:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1028aa:	e9 7a f5 ff ff       	jmp    101e29 <__alltraps>

001028af <vector255>:
.globl vector255
vector255:
  pushl $0
  1028af:	6a 00                	push   $0x0
  pushl $255
  1028b1:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1028b6:	e9 6e f5 ff ff       	jmp    101e29 <__alltraps>

001028bb <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1028bb:	55                   	push   %ebp
  1028bc:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1028be:	8b 55 08             	mov    0x8(%ebp),%edx
  1028c1:	a1 84 89 11 00       	mov    0x118984,%eax
  1028c6:	29 c2                	sub    %eax,%edx
  1028c8:	89 d0                	mov    %edx,%eax
  1028ca:	c1 f8 02             	sar    $0x2,%eax
  1028cd:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1028d3:	5d                   	pop    %ebp
  1028d4:	c3                   	ret    

001028d5 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1028d5:	55                   	push   %ebp
  1028d6:	89 e5                	mov    %esp,%ebp
  1028d8:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1028db:	8b 45 08             	mov    0x8(%ebp),%eax
  1028de:	89 04 24             	mov    %eax,(%esp)
  1028e1:	e8 d5 ff ff ff       	call   1028bb <page2ppn>
  1028e6:	c1 e0 0c             	shl    $0xc,%eax
}
  1028e9:	c9                   	leave  
  1028ea:	c3                   	ret    

001028eb <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  1028eb:	55                   	push   %ebp
  1028ec:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1028ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1028f1:	8b 00                	mov    (%eax),%eax
}
  1028f3:	5d                   	pop    %ebp
  1028f4:	c3                   	ret    

001028f5 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  1028f5:	55                   	push   %ebp
  1028f6:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1028f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1028fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  1028fe:	89 10                	mov    %edx,(%eax)
}
  102900:	5d                   	pop    %ebp
  102901:	c3                   	ret    

00102902 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  102902:	55                   	push   %ebp
  102903:	89 e5                	mov    %esp,%ebp
  102905:	83 ec 10             	sub    $0x10,%esp
  102908:	c7 45 fc 70 89 11 00 	movl   $0x118970,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10290f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102912:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102915:	89 50 04             	mov    %edx,0x4(%eax)
  102918:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10291b:	8b 50 04             	mov    0x4(%eax),%edx
  10291e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102921:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  102923:	c7 05 78 89 11 00 00 	movl   $0x0,0x118978
  10292a:	00 00 00 
}
  10292d:	c9                   	leave  
  10292e:	c3                   	ret    

0010292f <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  10292f:	55                   	push   %ebp
  102930:	89 e5                	mov    %esp,%ebp
  102932:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  102935:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102939:	75 24                	jne    10295f <default_init_memmap+0x30>
  10293b:	c7 44 24 0c d0 66 10 	movl   $0x1066d0,0xc(%esp)
  102942:	00 
  102943:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  10294a:	00 
  10294b:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  102952:	00 
  102953:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  10295a:	e8 65 e3 ff ff       	call   100cc4 <__panic>
    struct Page *p = base;
  10295f:	8b 45 08             	mov    0x8(%ebp),%eax
  102962:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102965:	e9 de 00 00 00       	jmp    102a48 <default_init_memmap+0x119>
        assert(PageReserved(p));
  10296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10296d:	83 c0 04             	add    $0x4,%eax
  102970:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102977:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10297a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10297d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102980:	0f a3 10             	bt     %edx,(%eax)
  102983:	19 c0                	sbb    %eax,%eax
  102985:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  102988:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10298c:	0f 95 c0             	setne  %al
  10298f:	0f b6 c0             	movzbl %al,%eax
  102992:	85 c0                	test   %eax,%eax
  102994:	75 24                	jne    1029ba <default_init_memmap+0x8b>
  102996:	c7 44 24 0c 01 67 10 	movl   $0x106701,0xc(%esp)
  10299d:	00 
  10299e:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1029a5:	00 
  1029a6:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  1029ad:	00 
  1029ae:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1029b5:	e8 0a e3 ff ff       	call   100cc4 <__panic>
        p->flags = p->property = 0;
  1029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029bd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  1029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029c7:	8b 50 08             	mov    0x8(%eax),%edx
  1029ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029cd:	89 50 04             	mov    %edx,0x4(%eax)
        SetPageProperty(p);
  1029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029d3:	83 c0 04             	add    $0x4,%eax
  1029d6:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  1029dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1029e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1029e6:	0f ab 10             	bts    %edx,(%eax)
        set_page_ref(p, 0);
  1029e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1029f0:	00 
  1029f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029f4:	89 04 24             	mov    %eax,(%esp)
  1029f7:	e8 f9 fe ff ff       	call   1028f5 <set_page_ref>
        list_add_before(&free_list, &(p->page_link));
  1029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029ff:	83 c0 0c             	add    $0xc,%eax
  102a02:	c7 45 dc 70 89 11 00 	movl   $0x118970,-0x24(%ebp)
  102a09:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102a0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a0f:	8b 00                	mov    (%eax),%eax
  102a11:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102a14:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102a17:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102a1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a1d:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102a20:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a23:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102a26:	89 10                	mov    %edx,(%eax)
  102a28:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a2b:	8b 10                	mov    (%eax),%edx
  102a2d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102a30:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102a33:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a36:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102a39:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102a3c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a3f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102a42:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102a44:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102a48:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a4b:	89 d0                	mov    %edx,%eax
  102a4d:	c1 e0 02             	shl    $0x2,%eax
  102a50:	01 d0                	add    %edx,%eax
  102a52:	c1 e0 02             	shl    $0x2,%eax
  102a55:	89 c2                	mov    %eax,%edx
  102a57:	8b 45 08             	mov    0x8(%ebp),%eax
  102a5a:	01 d0                	add    %edx,%eax
  102a5c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102a5f:	0f 85 05 ff ff ff    	jne    10296a <default_init_memmap+0x3b>
        p->flags = p->property = 0;
        SetPageProperty(p);
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;
  102a65:	8b 45 08             	mov    0x8(%ebp),%eax
  102a68:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a6b:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
  102a6e:	8b 15 78 89 11 00    	mov    0x118978,%edx
  102a74:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a77:	01 d0                	add    %edx,%eax
  102a79:	a3 78 89 11 00       	mov    %eax,0x118978
}
  102a7e:	c9                   	leave  
  102a7f:	c3                   	ret    

00102a80 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102a80:	55                   	push   %ebp
  102a81:	89 e5                	mov    %esp,%ebp
  102a83:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102a86:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102a8a:	75 24                	jne    102ab0 <default_alloc_pages+0x30>
  102a8c:	c7 44 24 0c d0 66 10 	movl   $0x1066d0,0xc(%esp)
  102a93:	00 
  102a94:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  102a9b:	00 
  102a9c:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
  102aa3:	00 
  102aa4:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  102aab:	e8 14 e2 ff ff       	call   100cc4 <__panic>
    if (n > nr_free) {
  102ab0:	a1 78 89 11 00       	mov    0x118978,%eax
  102ab5:	3b 45 08             	cmp    0x8(%ebp),%eax
  102ab8:	73 0a                	jae    102ac4 <default_alloc_pages+0x44>
        return NULL;
  102aba:	b8 00 00 00 00       	mov    $0x0,%eax
  102abf:	e9 46 01 00 00       	jmp    102c0a <default_alloc_pages+0x18a>
    }
    struct Page *page = NULL;
  102ac4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102acb:	c7 45 f0 70 89 11 00 	movl   $0x118970,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  102ad2:	eb 1c                	jmp    102af0 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  102ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ad7:	83 e8 0c             	sub    $0xc,%eax
  102ada:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
  102add:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ae0:	8b 40 08             	mov    0x8(%eax),%eax
  102ae3:	3b 45 08             	cmp    0x8(%ebp),%eax
  102ae6:	72 08                	jb     102af0 <default_alloc_pages+0x70>
            page = p;
  102ae8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102aeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102aee:	eb 18                	jmp    102b08 <default_alloc_pages+0x88>
  102af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102af3:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102af6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102af9:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  102afc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102aff:	81 7d f0 70 89 11 00 	cmpl   $0x118970,-0x10(%ebp)
  102b06:	75 cc                	jne    102ad4 <default_alloc_pages+0x54>
            page = p;
            break;
        }
    }
    list_entry_t *list_entry_next;
    if (page != NULL) {
  102b08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102b0c:	0f 84 f5 00 00 00    	je     102c07 <default_alloc_pages+0x187>
    	int i;
    	for(i = 0; i < n; ++i){
  102b12:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102b19:	eb 7c                	jmp    102b97 <default_alloc_pages+0x117>
    		struct Page *current_p = le2page(le,page_link);
  102b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b1e:	83 e8 0c             	sub    $0xc,%eax
  102b21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    		SetPageReserved(current_p);
  102b24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b27:	83 c0 04             	add    $0x4,%eax
  102b2a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  102b31:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102b34:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102b37:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102b3a:	0f ab 10             	bts    %edx,(%eax)
    		ClearPageProperty(current_p);
  102b3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b40:	83 c0 04             	add    $0x4,%eax
  102b43:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  102b4a:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102b4d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102b50:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102b53:	0f b3 10             	btr    %edx,(%eax)
  102b56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b59:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  102b5c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102b5f:	8b 40 04             	mov    0x4(%eax),%eax
    		list_entry_next = list_next(le);
  102b62:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102b65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b68:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102b6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102b6e:	8b 40 04             	mov    0x4(%eax),%eax
  102b71:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102b74:	8b 12                	mov    (%edx),%edx
  102b76:	89 55 bc             	mov    %edx,-0x44(%ebp)
  102b79:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102b7c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102b7f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102b82:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102b85:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102b88:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102b8b:	89 10                	mov    %edx,(%eax)
    		list_del(le);
    		le = list_entry_next;
  102b8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b90:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
    }
    list_entry_t *list_entry_next;
    if (page != NULL) {
    	int i;
    	for(i = 0; i < n; ++i){
  102b93:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  102b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b9a:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b9d:	0f 82 78 ff ff ff    	jb     102b1b <default_alloc_pages+0x9b>
    		ClearPageProperty(current_p);
    		list_entry_next = list_next(le);
    		list_del(le);
    		le = list_entry_next;
    	}
    	if(page->property > n){
  102ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ba6:	8b 40 08             	mov    0x8(%eax),%eax
  102ba9:	3b 45 08             	cmp    0x8(%ebp),%eax
  102bac:	76 1a                	jbe    102bc8 <default_alloc_pages+0x148>
    		struct Page *p = le2page(le,page_link);
  102bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bb1:	83 e8 0c             	sub    $0xc,%eax
  102bb4:	89 45 dc             	mov    %eax,-0x24(%ebp)
    		p->property = page->property - n;
  102bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bba:	8b 40 08             	mov    0x8(%eax),%eax
  102bbd:	2b 45 08             	sub    0x8(%ebp),%eax
  102bc0:	89 c2                	mov    %eax,%edx
  102bc2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102bc5:	89 50 08             	mov    %edx,0x8(%eax)
    	}
    	ClearPageProperty(page);
  102bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bcb:	83 c0 04             	add    $0x4,%eax
  102bce:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
  102bd5:	89 45 b0             	mov    %eax,-0x50(%ebp)
  102bd8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102bdb:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102bde:	0f b3 10             	btr    %edx,(%eax)
    	SetPageReserved(page);
  102be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102be4:	83 c0 04             	add    $0x4,%eax
  102be7:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
  102bee:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102bf1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102bf4:	8b 55 ac             	mov    -0x54(%ebp),%edx
  102bf7:	0f ab 10             	bts    %edx,(%eax)
    	nr_free -= n;
  102bfa:	a1 78 89 11 00       	mov    0x118978,%eax
  102bff:	2b 45 08             	sub    0x8(%ebp),%eax
  102c02:	a3 78 89 11 00       	mov    %eax,0x118978
    }
    return page;
  102c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102c0a:	c9                   	leave  
  102c0b:	c3                   	ret    

00102c0c <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102c0c:	55                   	push   %ebp
  102c0d:	89 e5                	mov    %esp,%ebp
  102c0f:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102c12:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c16:	75 24                	jne    102c3c <default_free_pages+0x30>
  102c18:	c7 44 24 0c d0 66 10 	movl   $0x1066d0,0xc(%esp)
  102c1f:	00 
  102c20:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  102c27:	00 
  102c28:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  102c2f:	00 
  102c30:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  102c37:	e8 88 e0 ff ff       	call   100cc4 <__panic>
    assert(PageReserved(base));
  102c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102c3f:	83 c0 04             	add    $0x4,%eax
  102c42:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102c49:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102c4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102c52:	0f a3 10             	bt     %edx,(%eax)
  102c55:	19 c0                	sbb    %eax,%eax
  102c57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  102c5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102c5e:	0f 95 c0             	setne  %al
  102c61:	0f b6 c0             	movzbl %al,%eax
  102c64:	85 c0                	test   %eax,%eax
  102c66:	75 24                	jne    102c8c <default_free_pages+0x80>
  102c68:	c7 44 24 0c 11 67 10 	movl   $0x106711,0xc(%esp)
  102c6f:	00 
  102c70:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  102c77:	00 
  102c78:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  102c7f:	00 
  102c80:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  102c87:	e8 38 e0 ff ff       	call   100cc4 <__panic>

    list_entry_t *le = &free_list;
  102c8c:	c7 45 f4 70 89 11 00 	movl   $0x118970,-0xc(%ebp)
    struct Page *current_p;
    while((le = list_next(le)) != &free_list){
  102c93:	eb 13                	jmp    102ca8 <default_free_pages+0x9c>
    	current_p = le2page(le,page_link);
  102c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c98:	83 e8 0c             	sub    $0xc,%eax
  102c9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	if(current_p > base) {
  102c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ca1:	3b 45 08             	cmp    0x8(%ebp),%eax
  102ca4:	76 02                	jbe    102ca8 <default_free_pages+0x9c>
    		break;
  102ca6:	eb 18                	jmp    102cc0 <default_free_pages+0xb4>
  102ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cab:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102cae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102cb1:	8b 40 04             	mov    0x4(%eax),%eax
    assert(n > 0);
    assert(PageReserved(base));

    list_entry_t *le = &free_list;
    struct Page *current_p;
    while((le = list_next(le)) != &free_list){
  102cb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102cb7:	81 7d f4 70 89 11 00 	cmpl   $0x118970,-0xc(%ebp)
  102cbe:	75 d5                	jne    102c95 <default_free_pages+0x89>
    	current_p = le2page(le,page_link);
    	if(current_p > base) {
    		break;
    	}
    }
    for(current_p = base; current_p < base + n; ++current_p){
  102cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102cc6:	eb 4b                	jmp    102d13 <default_free_pages+0x107>
    	list_add_before(le,&(current_p->page_link));
  102cc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ccb:	8d 50 0c             	lea    0xc(%eax),%edx
  102cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cd1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  102cd4:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102cd7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102cda:	8b 00                	mov    (%eax),%eax
  102cdc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102cdf:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102ce2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102ce5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102ce8:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102ceb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102cee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102cf1:	89 10                	mov    %edx,(%eax)
  102cf3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102cf6:	8b 10                	mov    (%eax),%edx
  102cf8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102cfb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102cfe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102d01:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102d04:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102d07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102d0a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102d0d:	89 10                	mov    %edx,(%eax)
    	current_p = le2page(le,page_link);
    	if(current_p > base) {
    		break;
    	}
    }
    for(current_p = base; current_p < base + n; ++current_p){
  102d0f:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
  102d13:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d16:	89 d0                	mov    %edx,%eax
  102d18:	c1 e0 02             	shl    $0x2,%eax
  102d1b:	01 d0                	add    %edx,%eax
  102d1d:	c1 e0 02             	shl    $0x2,%eax
  102d20:	89 c2                	mov    %eax,%edx
  102d22:	8b 45 08             	mov    0x8(%ebp),%eax
  102d25:	01 d0                	add    %edx,%eax
  102d27:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102d2a:	77 9c                	ja     102cc8 <default_free_pages+0xbc>
    	list_add_before(le,&(current_p->page_link));
    }
    base->flags = 0;
  102d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    ClearPageProperty(base);
  102d36:	8b 45 08             	mov    0x8(%ebp),%eax
  102d39:	83 c0 04             	add    $0x4,%eax
  102d3c:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  102d43:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d46:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102d49:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102d4c:	0f b3 10             	btr    %edx,(%eax)
    set_page_ref(base,0);
  102d4f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102d56:	00 
  102d57:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5a:	89 04 24             	mov    %eax,(%esp)
  102d5d:	e8 93 fb ff ff       	call   1028f5 <set_page_ref>
    SetPageProperty(base);
  102d62:	8b 45 08             	mov    0x8(%ebp),%eax
  102d65:	83 c0 04             	add    $0x4,%eax
  102d68:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  102d6f:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d72:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102d75:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102d78:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
  102d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  102d7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d81:	89 50 08             	mov    %edx,0x8(%eax)

    current_p = le2page(le, page_link);
  102d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d87:	83 e8 0c             	sub    $0xc,%eax
  102d8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(base + n == current_p){
  102d8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d90:	89 d0                	mov    %edx,%eax
  102d92:	c1 e0 02             	shl    $0x2,%eax
  102d95:	01 d0                	add    %edx,%eax
  102d97:	c1 e0 02             	shl    $0x2,%eax
  102d9a:	89 c2                	mov    %eax,%edx
  102d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d9f:	01 d0                	add    %edx,%eax
  102da1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102da4:	75 1e                	jne    102dc4 <default_free_pages+0x1b8>
    	base->property += current_p->property;
  102da6:	8b 45 08             	mov    0x8(%ebp),%eax
  102da9:	8b 50 08             	mov    0x8(%eax),%edx
  102dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102daf:	8b 40 08             	mov    0x8(%eax),%eax
  102db2:	01 c2                	add    %eax,%edx
  102db4:	8b 45 08             	mov    0x8(%ebp),%eax
  102db7:	89 50 08             	mov    %edx,0x8(%eax)
    	current_p->property = 0;
  102dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dbd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le = list_prev(&(base->page_link));
  102dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc7:	83 c0 0c             	add    $0xc,%eax
  102dca:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  102dcd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102dd0:	8b 00                	mov    (%eax),%eax
  102dd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    current_p = le2page(le, page_link);
  102dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dd8:	83 e8 0c             	sub    $0xc,%eax
  102ddb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(current_p + 1 == base && le != &free_list){
  102dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102de1:	83 c0 14             	add    $0x14,%eax
  102de4:	3b 45 08             	cmp    0x8(%ebp),%eax
  102de7:	75 55                	jne    102e3e <default_free_pages+0x232>
  102de9:	81 7d f4 70 89 11 00 	cmpl   $0x118970,-0xc(%ebp)
  102df0:	74 4c                	je     102e3e <default_free_pages+0x232>
    	while(le != &free_list){
  102df2:	eb 41                	jmp    102e35 <default_free_pages+0x229>
    		if(current_p->property > 0){
  102df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102df7:	8b 40 08             	mov    0x8(%eax),%eax
  102dfa:	85 c0                	test   %eax,%eax
  102dfc:	74 20                	je     102e1e <default_free_pages+0x212>
    			current_p->property += base->property;
  102dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e01:	8b 50 08             	mov    0x8(%eax),%edx
  102e04:	8b 45 08             	mov    0x8(%ebp),%eax
  102e07:	8b 40 08             	mov    0x8(%eax),%eax
  102e0a:	01 c2                	add    %eax,%edx
  102e0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e0f:	89 50 08             	mov    %edx,0x8(%eax)
    			base->property = 0;
  102e12:	8b 45 08             	mov    0x8(%ebp),%eax
  102e15:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    			break;
  102e1c:	eb 20                	jmp    102e3e <default_free_pages+0x232>
  102e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e21:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  102e24:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102e27:	8b 00                	mov    (%eax),%eax
    		}
    		le = list_prev(le);
  102e29:	89 45 f4             	mov    %eax,-0xc(%ebp)
    		current_p = le2page(le,page_link);
  102e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e2f:	83 e8 0c             	sub    $0xc,%eax
  102e32:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	current_p->property = 0;
    }
    le = list_prev(&(base->page_link));
    current_p = le2page(le, page_link);
    if(current_p + 1 == base && le != &free_list){
    	while(le != &free_list){
  102e35:	81 7d f4 70 89 11 00 	cmpl   $0x118970,-0xc(%ebp)
  102e3c:	75 b6                	jne    102df4 <default_free_pages+0x1e8>
    		}
    		le = list_prev(le);
    		current_p = le2page(le,page_link);
    	}
    }
    nr_free += n;
  102e3e:	8b 15 78 89 11 00    	mov    0x118978,%edx
  102e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e47:	01 d0                	add    %edx,%eax
  102e49:	a3 78 89 11 00       	mov    %eax,0x118978
    return ;
  102e4e:	90                   	nop
//            list_del(&(p->page_link));
//        }
//    }
//    nr_free += n;
//    list_add(&free_list, &(base->page_link));
}
  102e4f:	c9                   	leave  
  102e50:	c3                   	ret    

00102e51 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102e51:	55                   	push   %ebp
  102e52:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102e54:	a1 78 89 11 00       	mov    0x118978,%eax
}
  102e59:	5d                   	pop    %ebp
  102e5a:	c3                   	ret    

00102e5b <basic_check>:

static void
basic_check(void) {
  102e5b:	55                   	push   %ebp
  102e5c:	89 e5                	mov    %esp,%ebp
  102e5e:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102e61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e71:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102e74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e7b:	e8 85 0e 00 00       	call   103d05 <alloc_pages>
  102e80:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102e83:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102e87:	75 24                	jne    102ead <basic_check+0x52>
  102e89:	c7 44 24 0c 24 67 10 	movl   $0x106724,0xc(%esp)
  102e90:	00 
  102e91:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  102e98:	00 
  102e99:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
  102ea0:	00 
  102ea1:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  102ea8:	e8 17 de ff ff       	call   100cc4 <__panic>
    assert((p1 = alloc_page()) != NULL);
  102ead:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102eb4:	e8 4c 0e 00 00       	call   103d05 <alloc_pages>
  102eb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ebc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102ec0:	75 24                	jne    102ee6 <basic_check+0x8b>
  102ec2:	c7 44 24 0c 40 67 10 	movl   $0x106740,0xc(%esp)
  102ec9:	00 
  102eca:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  102ed1:	00 
  102ed2:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  102ed9:	00 
  102eda:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  102ee1:	e8 de dd ff ff       	call   100cc4 <__panic>
    assert((p2 = alloc_page()) != NULL);
  102ee6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102eed:	e8 13 0e 00 00       	call   103d05 <alloc_pages>
  102ef2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ef5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102ef9:	75 24                	jne    102f1f <basic_check+0xc4>
  102efb:	c7 44 24 0c 5c 67 10 	movl   $0x10675c,0xc(%esp)
  102f02:	00 
  102f03:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  102f0a:	00 
  102f0b:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
  102f12:	00 
  102f13:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  102f1a:	e8 a5 dd ff ff       	call   100cc4 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102f1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f22:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102f25:	74 10                	je     102f37 <basic_check+0xdc>
  102f27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f2a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102f2d:	74 08                	je     102f37 <basic_check+0xdc>
  102f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f32:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102f35:	75 24                	jne    102f5b <basic_check+0x100>
  102f37:	c7 44 24 0c 78 67 10 	movl   $0x106778,0xc(%esp)
  102f3e:	00 
  102f3f:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  102f46:	00 
  102f47:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  102f4e:	00 
  102f4f:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  102f56:	e8 69 dd ff ff       	call   100cc4 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102f5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f5e:	89 04 24             	mov    %eax,(%esp)
  102f61:	e8 85 f9 ff ff       	call   1028eb <page_ref>
  102f66:	85 c0                	test   %eax,%eax
  102f68:	75 1e                	jne    102f88 <basic_check+0x12d>
  102f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f6d:	89 04 24             	mov    %eax,(%esp)
  102f70:	e8 76 f9 ff ff       	call   1028eb <page_ref>
  102f75:	85 c0                	test   %eax,%eax
  102f77:	75 0f                	jne    102f88 <basic_check+0x12d>
  102f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f7c:	89 04 24             	mov    %eax,(%esp)
  102f7f:	e8 67 f9 ff ff       	call   1028eb <page_ref>
  102f84:	85 c0                	test   %eax,%eax
  102f86:	74 24                	je     102fac <basic_check+0x151>
  102f88:	c7 44 24 0c 9c 67 10 	movl   $0x10679c,0xc(%esp)
  102f8f:	00 
  102f90:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  102f97:	00 
  102f98:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  102f9f:	00 
  102fa0:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  102fa7:	e8 18 dd ff ff       	call   100cc4 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  102fac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102faf:	89 04 24             	mov    %eax,(%esp)
  102fb2:	e8 1e f9 ff ff       	call   1028d5 <page2pa>
  102fb7:	8b 15 e0 88 11 00    	mov    0x1188e0,%edx
  102fbd:	c1 e2 0c             	shl    $0xc,%edx
  102fc0:	39 d0                	cmp    %edx,%eax
  102fc2:	72 24                	jb     102fe8 <basic_check+0x18d>
  102fc4:	c7 44 24 0c d8 67 10 	movl   $0x1067d8,0xc(%esp)
  102fcb:	00 
  102fcc:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  102fd3:	00 
  102fd4:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
  102fdb:	00 
  102fdc:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  102fe3:	e8 dc dc ff ff       	call   100cc4 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  102fe8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102feb:	89 04 24             	mov    %eax,(%esp)
  102fee:	e8 e2 f8 ff ff       	call   1028d5 <page2pa>
  102ff3:	8b 15 e0 88 11 00    	mov    0x1188e0,%edx
  102ff9:	c1 e2 0c             	shl    $0xc,%edx
  102ffc:	39 d0                	cmp    %edx,%eax
  102ffe:	72 24                	jb     103024 <basic_check+0x1c9>
  103000:	c7 44 24 0c f5 67 10 	movl   $0x1067f5,0xc(%esp)
  103007:	00 
  103008:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  10300f:	00 
  103010:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
  103017:	00 
  103018:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  10301f:	e8 a0 dc ff ff       	call   100cc4 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  103024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103027:	89 04 24             	mov    %eax,(%esp)
  10302a:	e8 a6 f8 ff ff       	call   1028d5 <page2pa>
  10302f:	8b 15 e0 88 11 00    	mov    0x1188e0,%edx
  103035:	c1 e2 0c             	shl    $0xc,%edx
  103038:	39 d0                	cmp    %edx,%eax
  10303a:	72 24                	jb     103060 <basic_check+0x205>
  10303c:	c7 44 24 0c 12 68 10 	movl   $0x106812,0xc(%esp)
  103043:	00 
  103044:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  10304b:	00 
  10304c:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  103053:	00 
  103054:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  10305b:	e8 64 dc ff ff       	call   100cc4 <__panic>

    list_entry_t free_list_store = free_list;
  103060:	a1 70 89 11 00       	mov    0x118970,%eax
  103065:	8b 15 74 89 11 00    	mov    0x118974,%edx
  10306b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10306e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103071:	c7 45 e0 70 89 11 00 	movl   $0x118970,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103078:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10307b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10307e:	89 50 04             	mov    %edx,0x4(%eax)
  103081:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103084:	8b 50 04             	mov    0x4(%eax),%edx
  103087:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10308a:	89 10                	mov    %edx,(%eax)
  10308c:	c7 45 dc 70 89 11 00 	movl   $0x118970,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103093:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103096:	8b 40 04             	mov    0x4(%eax),%eax
  103099:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10309c:	0f 94 c0             	sete   %al
  10309f:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1030a2:	85 c0                	test   %eax,%eax
  1030a4:	75 24                	jne    1030ca <basic_check+0x26f>
  1030a6:	c7 44 24 0c 2f 68 10 	movl   $0x10682f,0xc(%esp)
  1030ad:	00 
  1030ae:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1030b5:	00 
  1030b6:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
  1030bd:	00 
  1030be:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1030c5:	e8 fa db ff ff       	call   100cc4 <__panic>

    unsigned int nr_free_store = nr_free;
  1030ca:	a1 78 89 11 00       	mov    0x118978,%eax
  1030cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  1030d2:	c7 05 78 89 11 00 00 	movl   $0x0,0x118978
  1030d9:	00 00 00 

    assert(alloc_page() == NULL);
  1030dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030e3:	e8 1d 0c 00 00       	call   103d05 <alloc_pages>
  1030e8:	85 c0                	test   %eax,%eax
  1030ea:	74 24                	je     103110 <basic_check+0x2b5>
  1030ec:	c7 44 24 0c 46 68 10 	movl   $0x106846,0xc(%esp)
  1030f3:	00 
  1030f4:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1030fb:	00 
  1030fc:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  103103:	00 
  103104:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  10310b:	e8 b4 db ff ff       	call   100cc4 <__panic>

    free_page(p0);
  103110:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103117:	00 
  103118:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10311b:	89 04 24             	mov    %eax,(%esp)
  10311e:	e8 1a 0c 00 00       	call   103d3d <free_pages>
    free_page(p1);
  103123:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10312a:	00 
  10312b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10312e:	89 04 24             	mov    %eax,(%esp)
  103131:	e8 07 0c 00 00       	call   103d3d <free_pages>
    free_page(p2);
  103136:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10313d:	00 
  10313e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103141:	89 04 24             	mov    %eax,(%esp)
  103144:	e8 f4 0b 00 00       	call   103d3d <free_pages>
    assert(nr_free == 3);
  103149:	a1 78 89 11 00       	mov    0x118978,%eax
  10314e:	83 f8 03             	cmp    $0x3,%eax
  103151:	74 24                	je     103177 <basic_check+0x31c>
  103153:	c7 44 24 0c 5b 68 10 	movl   $0x10685b,0xc(%esp)
  10315a:	00 
  10315b:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103162:	00 
  103163:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  10316a:	00 
  10316b:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103172:	e8 4d db ff ff       	call   100cc4 <__panic>

    assert((p0 = alloc_page()) != NULL);
  103177:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10317e:	e8 82 0b 00 00       	call   103d05 <alloc_pages>
  103183:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103186:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  10318a:	75 24                	jne    1031b0 <basic_check+0x355>
  10318c:	c7 44 24 0c 24 67 10 	movl   $0x106724,0xc(%esp)
  103193:	00 
  103194:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  10319b:	00 
  10319c:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
  1031a3:	00 
  1031a4:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1031ab:	e8 14 db ff ff       	call   100cc4 <__panic>
    assert((p1 = alloc_page()) != NULL);
  1031b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031b7:	e8 49 0b 00 00       	call   103d05 <alloc_pages>
  1031bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1031c3:	75 24                	jne    1031e9 <basic_check+0x38e>
  1031c5:	c7 44 24 0c 40 67 10 	movl   $0x106740,0xc(%esp)
  1031cc:	00 
  1031cd:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1031d4:	00 
  1031d5:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  1031dc:	00 
  1031dd:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1031e4:	e8 db da ff ff       	call   100cc4 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1031e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031f0:	e8 10 0b 00 00       	call   103d05 <alloc_pages>
  1031f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1031fc:	75 24                	jne    103222 <basic_check+0x3c7>
  1031fe:	c7 44 24 0c 5c 67 10 	movl   $0x10675c,0xc(%esp)
  103205:	00 
  103206:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  10320d:	00 
  10320e:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  103215:	00 
  103216:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  10321d:	e8 a2 da ff ff       	call   100cc4 <__panic>

    assert(alloc_page() == NULL);
  103222:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103229:	e8 d7 0a 00 00       	call   103d05 <alloc_pages>
  10322e:	85 c0                	test   %eax,%eax
  103230:	74 24                	je     103256 <basic_check+0x3fb>
  103232:	c7 44 24 0c 46 68 10 	movl   $0x106846,0xc(%esp)
  103239:	00 
  10323a:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103241:	00 
  103242:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  103249:	00 
  10324a:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103251:	e8 6e da ff ff       	call   100cc4 <__panic>

    free_page(p0);
  103256:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10325d:	00 
  10325e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103261:	89 04 24             	mov    %eax,(%esp)
  103264:	e8 d4 0a 00 00       	call   103d3d <free_pages>
  103269:	c7 45 d8 70 89 11 00 	movl   $0x118970,-0x28(%ebp)
  103270:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103273:	8b 40 04             	mov    0x4(%eax),%eax
  103276:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  103279:	0f 94 c0             	sete   %al
  10327c:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  10327f:	85 c0                	test   %eax,%eax
  103281:	74 24                	je     1032a7 <basic_check+0x44c>
  103283:	c7 44 24 0c 68 68 10 	movl   $0x106868,0xc(%esp)
  10328a:	00 
  10328b:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103292:	00 
  103293:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
  10329a:	00 
  10329b:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1032a2:	e8 1d da ff ff       	call   100cc4 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1032a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032ae:	e8 52 0a 00 00       	call   103d05 <alloc_pages>
  1032b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1032b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1032b9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1032bc:	74 24                	je     1032e2 <basic_check+0x487>
  1032be:	c7 44 24 0c 80 68 10 	movl   $0x106880,0xc(%esp)
  1032c5:	00 
  1032c6:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1032cd:	00 
  1032ce:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
  1032d5:	00 
  1032d6:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1032dd:	e8 e2 d9 ff ff       	call   100cc4 <__panic>
    assert(alloc_page() == NULL);
  1032e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032e9:	e8 17 0a 00 00       	call   103d05 <alloc_pages>
  1032ee:	85 c0                	test   %eax,%eax
  1032f0:	74 24                	je     103316 <basic_check+0x4bb>
  1032f2:	c7 44 24 0c 46 68 10 	movl   $0x106846,0xc(%esp)
  1032f9:	00 
  1032fa:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103301:	00 
  103302:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  103309:	00 
  10330a:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103311:	e8 ae d9 ff ff       	call   100cc4 <__panic>

    assert(nr_free == 0);
  103316:	a1 78 89 11 00       	mov    0x118978,%eax
  10331b:	85 c0                	test   %eax,%eax
  10331d:	74 24                	je     103343 <basic_check+0x4e8>
  10331f:	c7 44 24 0c 99 68 10 	movl   $0x106899,0xc(%esp)
  103326:	00 
  103327:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  10332e:	00 
  10332f:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  103336:	00 
  103337:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  10333e:	e8 81 d9 ff ff       	call   100cc4 <__panic>
    free_list = free_list_store;
  103343:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103346:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103349:	a3 70 89 11 00       	mov    %eax,0x118970
  10334e:	89 15 74 89 11 00    	mov    %edx,0x118974
    nr_free = nr_free_store;
  103354:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103357:	a3 78 89 11 00       	mov    %eax,0x118978

    free_page(p);
  10335c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103363:	00 
  103364:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103367:	89 04 24             	mov    %eax,(%esp)
  10336a:	e8 ce 09 00 00       	call   103d3d <free_pages>
    free_page(p1);
  10336f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103376:	00 
  103377:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10337a:	89 04 24             	mov    %eax,(%esp)
  10337d:	e8 bb 09 00 00       	call   103d3d <free_pages>
    free_page(p2);
  103382:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103389:	00 
  10338a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10338d:	89 04 24             	mov    %eax,(%esp)
  103390:	e8 a8 09 00 00       	call   103d3d <free_pages>
}
  103395:	c9                   	leave  
  103396:	c3                   	ret    

00103397 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  103397:	55                   	push   %ebp
  103398:	89 e5                	mov    %esp,%ebp
  10339a:	53                   	push   %ebx
  10339b:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  1033a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1033a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1033af:	c7 45 ec 70 89 11 00 	movl   $0x118970,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1033b6:	eb 6b                	jmp    103423 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  1033b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033bb:	83 e8 0c             	sub    $0xc,%eax
  1033be:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  1033c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033c4:	83 c0 04             	add    $0x4,%eax
  1033c7:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1033ce:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1033d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1033d4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1033d7:	0f a3 10             	bt     %edx,(%eax)
  1033da:	19 c0                	sbb    %eax,%eax
  1033dc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1033df:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1033e3:	0f 95 c0             	setne  %al
  1033e6:	0f b6 c0             	movzbl %al,%eax
  1033e9:	85 c0                	test   %eax,%eax
  1033eb:	75 24                	jne    103411 <default_check+0x7a>
  1033ed:	c7 44 24 0c a6 68 10 	movl   $0x1068a6,0xc(%esp)
  1033f4:	00 
  1033f5:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1033fc:	00 
  1033fd:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  103404:	00 
  103405:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  10340c:	e8 b3 d8 ff ff       	call   100cc4 <__panic>
        count ++, total += p->property;
  103411:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103415:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103418:	8b 50 08             	mov    0x8(%eax),%edx
  10341b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10341e:	01 d0                	add    %edx,%eax
  103420:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103423:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103426:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103429:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10342c:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  10342f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103432:	81 7d ec 70 89 11 00 	cmpl   $0x118970,-0x14(%ebp)
  103439:	0f 85 79 ff ff ff    	jne    1033b8 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  10343f:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  103442:	e8 28 09 00 00       	call   103d6f <nr_free_pages>
  103447:	39 c3                	cmp    %eax,%ebx
  103449:	74 24                	je     10346f <default_check+0xd8>
  10344b:	c7 44 24 0c b6 68 10 	movl   $0x1068b6,0xc(%esp)
  103452:	00 
  103453:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  10345a:	00 
  10345b:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  103462:	00 
  103463:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  10346a:	e8 55 d8 ff ff       	call   100cc4 <__panic>

    basic_check();
  10346f:	e8 e7 f9 ff ff       	call   102e5b <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  103474:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10347b:	e8 85 08 00 00       	call   103d05 <alloc_pages>
  103480:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  103483:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103487:	75 24                	jne    1034ad <default_check+0x116>
  103489:	c7 44 24 0c cf 68 10 	movl   $0x1068cf,0xc(%esp)
  103490:	00 
  103491:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103498:	00 
  103499:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
  1034a0:	00 
  1034a1:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1034a8:	e8 17 d8 ff ff       	call   100cc4 <__panic>
    assert(!PageProperty(p0));
  1034ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034b0:	83 c0 04             	add    $0x4,%eax
  1034b3:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1034ba:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1034bd:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1034c0:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1034c3:	0f a3 10             	bt     %edx,(%eax)
  1034c6:	19 c0                	sbb    %eax,%eax
  1034c8:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1034cb:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1034cf:	0f 95 c0             	setne  %al
  1034d2:	0f b6 c0             	movzbl %al,%eax
  1034d5:	85 c0                	test   %eax,%eax
  1034d7:	74 24                	je     1034fd <default_check+0x166>
  1034d9:	c7 44 24 0c da 68 10 	movl   $0x1068da,0xc(%esp)
  1034e0:	00 
  1034e1:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1034e8:	00 
  1034e9:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
  1034f0:	00 
  1034f1:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1034f8:	e8 c7 d7 ff ff       	call   100cc4 <__panic>

    list_entry_t free_list_store = free_list;
  1034fd:	a1 70 89 11 00       	mov    0x118970,%eax
  103502:	8b 15 74 89 11 00    	mov    0x118974,%edx
  103508:	89 45 80             	mov    %eax,-0x80(%ebp)
  10350b:	89 55 84             	mov    %edx,-0x7c(%ebp)
  10350e:	c7 45 b4 70 89 11 00 	movl   $0x118970,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103515:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103518:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  10351b:	89 50 04             	mov    %edx,0x4(%eax)
  10351e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103521:	8b 50 04             	mov    0x4(%eax),%edx
  103524:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103527:	89 10                	mov    %edx,(%eax)
  103529:	c7 45 b0 70 89 11 00 	movl   $0x118970,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103530:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103533:	8b 40 04             	mov    0x4(%eax),%eax
  103536:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  103539:	0f 94 c0             	sete   %al
  10353c:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10353f:	85 c0                	test   %eax,%eax
  103541:	75 24                	jne    103567 <default_check+0x1d0>
  103543:	c7 44 24 0c 2f 68 10 	movl   $0x10682f,0xc(%esp)
  10354a:	00 
  10354b:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103552:	00 
  103553:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  10355a:	00 
  10355b:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103562:	e8 5d d7 ff ff       	call   100cc4 <__panic>
    assert(alloc_page() == NULL);
  103567:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10356e:	e8 92 07 00 00       	call   103d05 <alloc_pages>
  103573:	85 c0                	test   %eax,%eax
  103575:	74 24                	je     10359b <default_check+0x204>
  103577:	c7 44 24 0c 46 68 10 	movl   $0x106846,0xc(%esp)
  10357e:	00 
  10357f:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103586:	00 
  103587:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  10358e:	00 
  10358f:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103596:	e8 29 d7 ff ff       	call   100cc4 <__panic>

    unsigned int nr_free_store = nr_free;
  10359b:	a1 78 89 11 00       	mov    0x118978,%eax
  1035a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  1035a3:	c7 05 78 89 11 00 00 	movl   $0x0,0x118978
  1035aa:	00 00 00 

    free_pages(p0 + 2, 3);
  1035ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035b0:	83 c0 28             	add    $0x28,%eax
  1035b3:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1035ba:	00 
  1035bb:	89 04 24             	mov    %eax,(%esp)
  1035be:	e8 7a 07 00 00       	call   103d3d <free_pages>
    assert(alloc_pages(4) == NULL);
  1035c3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1035ca:	e8 36 07 00 00       	call   103d05 <alloc_pages>
  1035cf:	85 c0                	test   %eax,%eax
  1035d1:	74 24                	je     1035f7 <default_check+0x260>
  1035d3:	c7 44 24 0c ec 68 10 	movl   $0x1068ec,0xc(%esp)
  1035da:	00 
  1035db:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1035e2:	00 
  1035e3:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
  1035ea:	00 
  1035eb:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1035f2:	e8 cd d6 ff ff       	call   100cc4 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1035f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035fa:	83 c0 28             	add    $0x28,%eax
  1035fd:	83 c0 04             	add    $0x4,%eax
  103600:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  103607:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10360a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10360d:	8b 55 ac             	mov    -0x54(%ebp),%edx
  103610:	0f a3 10             	bt     %edx,(%eax)
  103613:	19 c0                	sbb    %eax,%eax
  103615:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  103618:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  10361c:	0f 95 c0             	setne  %al
  10361f:	0f b6 c0             	movzbl %al,%eax
  103622:	85 c0                	test   %eax,%eax
  103624:	74 0e                	je     103634 <default_check+0x29d>
  103626:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103629:	83 c0 28             	add    $0x28,%eax
  10362c:	8b 40 08             	mov    0x8(%eax),%eax
  10362f:	83 f8 03             	cmp    $0x3,%eax
  103632:	74 24                	je     103658 <default_check+0x2c1>
  103634:	c7 44 24 0c 04 69 10 	movl   $0x106904,0xc(%esp)
  10363b:	00 
  10363c:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103643:	00 
  103644:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
  10364b:	00 
  10364c:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103653:	e8 6c d6 ff ff       	call   100cc4 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  103658:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10365f:	e8 a1 06 00 00       	call   103d05 <alloc_pages>
  103664:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103667:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10366b:	75 24                	jne    103691 <default_check+0x2fa>
  10366d:	c7 44 24 0c 30 69 10 	movl   $0x106930,0xc(%esp)
  103674:	00 
  103675:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  10367c:	00 
  10367d:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
  103684:	00 
  103685:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  10368c:	e8 33 d6 ff ff       	call   100cc4 <__panic>
    assert(alloc_page() == NULL);
  103691:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103698:	e8 68 06 00 00       	call   103d05 <alloc_pages>
  10369d:	85 c0                	test   %eax,%eax
  10369f:	74 24                	je     1036c5 <default_check+0x32e>
  1036a1:	c7 44 24 0c 46 68 10 	movl   $0x106846,0xc(%esp)
  1036a8:	00 
  1036a9:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1036b0:	00 
  1036b1:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  1036b8:	00 
  1036b9:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1036c0:	e8 ff d5 ff ff       	call   100cc4 <__panic>
    assert(p0 + 2 == p1);
  1036c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036c8:	83 c0 28             	add    $0x28,%eax
  1036cb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1036ce:	74 24                	je     1036f4 <default_check+0x35d>
  1036d0:	c7 44 24 0c 4e 69 10 	movl   $0x10694e,0xc(%esp)
  1036d7:	00 
  1036d8:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1036df:	00 
  1036e0:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1036e7:	00 
  1036e8:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1036ef:	e8 d0 d5 ff ff       	call   100cc4 <__panic>

    p2 = p0 + 1;
  1036f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036f7:	83 c0 14             	add    $0x14,%eax
  1036fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  1036fd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103704:	00 
  103705:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103708:	89 04 24             	mov    %eax,(%esp)
  10370b:	e8 2d 06 00 00       	call   103d3d <free_pages>
    free_pages(p1, 3);
  103710:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103717:	00 
  103718:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10371b:	89 04 24             	mov    %eax,(%esp)
  10371e:	e8 1a 06 00 00       	call   103d3d <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  103723:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103726:	83 c0 04             	add    $0x4,%eax
  103729:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  103730:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103733:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103736:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103739:	0f a3 10             	bt     %edx,(%eax)
  10373c:	19 c0                	sbb    %eax,%eax
  10373e:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  103741:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  103745:	0f 95 c0             	setne  %al
  103748:	0f b6 c0             	movzbl %al,%eax
  10374b:	85 c0                	test   %eax,%eax
  10374d:	74 0b                	je     10375a <default_check+0x3c3>
  10374f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103752:	8b 40 08             	mov    0x8(%eax),%eax
  103755:	83 f8 01             	cmp    $0x1,%eax
  103758:	74 24                	je     10377e <default_check+0x3e7>
  10375a:	c7 44 24 0c 5c 69 10 	movl   $0x10695c,0xc(%esp)
  103761:	00 
  103762:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103769:	00 
  10376a:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
  103771:	00 
  103772:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103779:	e8 46 d5 ff ff       	call   100cc4 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  10377e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103781:	83 c0 04             	add    $0x4,%eax
  103784:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  10378b:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10378e:	8b 45 90             	mov    -0x70(%ebp),%eax
  103791:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103794:	0f a3 10             	bt     %edx,(%eax)
  103797:	19 c0                	sbb    %eax,%eax
  103799:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  10379c:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  1037a0:	0f 95 c0             	setne  %al
  1037a3:	0f b6 c0             	movzbl %al,%eax
  1037a6:	85 c0                	test   %eax,%eax
  1037a8:	74 0b                	je     1037b5 <default_check+0x41e>
  1037aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1037ad:	8b 40 08             	mov    0x8(%eax),%eax
  1037b0:	83 f8 03             	cmp    $0x3,%eax
  1037b3:	74 24                	je     1037d9 <default_check+0x442>
  1037b5:	c7 44 24 0c 84 69 10 	movl   $0x106984,0xc(%esp)
  1037bc:	00 
  1037bd:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1037c4:	00 
  1037c5:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
  1037cc:	00 
  1037cd:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1037d4:	e8 eb d4 ff ff       	call   100cc4 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1037d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1037e0:	e8 20 05 00 00       	call   103d05 <alloc_pages>
  1037e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1037e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1037eb:	83 e8 14             	sub    $0x14,%eax
  1037ee:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1037f1:	74 24                	je     103817 <default_check+0x480>
  1037f3:	c7 44 24 0c aa 69 10 	movl   $0x1069aa,0xc(%esp)
  1037fa:	00 
  1037fb:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103802:	00 
  103803:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
  10380a:	00 
  10380b:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103812:	e8 ad d4 ff ff       	call   100cc4 <__panic>
    free_page(p0);
  103817:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10381e:	00 
  10381f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103822:	89 04 24             	mov    %eax,(%esp)
  103825:	e8 13 05 00 00       	call   103d3d <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  10382a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  103831:	e8 cf 04 00 00       	call   103d05 <alloc_pages>
  103836:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103839:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10383c:	83 c0 14             	add    $0x14,%eax
  10383f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103842:	74 24                	je     103868 <default_check+0x4d1>
  103844:	c7 44 24 0c c8 69 10 	movl   $0x1069c8,0xc(%esp)
  10384b:	00 
  10384c:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103853:	00 
  103854:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
  10385b:	00 
  10385c:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103863:	e8 5c d4 ff ff       	call   100cc4 <__panic>

    free_pages(p0, 2);
  103868:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10386f:	00 
  103870:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103873:	89 04 24             	mov    %eax,(%esp)
  103876:	e8 c2 04 00 00       	call   103d3d <free_pages>
    free_page(p2);
  10387b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103882:	00 
  103883:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103886:	89 04 24             	mov    %eax,(%esp)
  103889:	e8 af 04 00 00       	call   103d3d <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  10388e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103895:	e8 6b 04 00 00       	call   103d05 <alloc_pages>
  10389a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10389d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1038a1:	75 24                	jne    1038c7 <default_check+0x530>
  1038a3:	c7 44 24 0c e8 69 10 	movl   $0x1069e8,0xc(%esp)
  1038aa:	00 
  1038ab:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1038b2:	00 
  1038b3:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
  1038ba:	00 
  1038bb:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1038c2:	e8 fd d3 ff ff       	call   100cc4 <__panic>
    assert(alloc_page() == NULL);
  1038c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1038ce:	e8 32 04 00 00       	call   103d05 <alloc_pages>
  1038d3:	85 c0                	test   %eax,%eax
  1038d5:	74 24                	je     1038fb <default_check+0x564>
  1038d7:	c7 44 24 0c 46 68 10 	movl   $0x106846,0xc(%esp)
  1038de:	00 
  1038df:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1038e6:	00 
  1038e7:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
  1038ee:	00 
  1038ef:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1038f6:	e8 c9 d3 ff ff       	call   100cc4 <__panic>

    assert(nr_free == 0);
  1038fb:	a1 78 89 11 00       	mov    0x118978,%eax
  103900:	85 c0                	test   %eax,%eax
  103902:	74 24                	je     103928 <default_check+0x591>
  103904:	c7 44 24 0c 99 68 10 	movl   $0x106899,0xc(%esp)
  10390b:	00 
  10390c:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103913:	00 
  103914:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
  10391b:	00 
  10391c:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103923:	e8 9c d3 ff ff       	call   100cc4 <__panic>
    nr_free = nr_free_store;
  103928:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10392b:	a3 78 89 11 00       	mov    %eax,0x118978

    free_list = free_list_store;
  103930:	8b 45 80             	mov    -0x80(%ebp),%eax
  103933:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103936:	a3 70 89 11 00       	mov    %eax,0x118970
  10393b:	89 15 74 89 11 00    	mov    %edx,0x118974
    free_pages(p0, 5);
  103941:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103948:	00 
  103949:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10394c:	89 04 24             	mov    %eax,(%esp)
  10394f:	e8 e9 03 00 00       	call   103d3d <free_pages>

    le = &free_list;
  103954:	c7 45 ec 70 89 11 00 	movl   $0x118970,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10395b:	eb 1d                	jmp    10397a <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  10395d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103960:	83 e8 0c             	sub    $0xc,%eax
  103963:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  103966:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10396a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10396d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103970:	8b 40 08             	mov    0x8(%eax),%eax
  103973:	29 c2                	sub    %eax,%edx
  103975:	89 d0                	mov    %edx,%eax
  103977:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10397a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10397d:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103980:	8b 45 88             	mov    -0x78(%ebp),%eax
  103983:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103986:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103989:	81 7d ec 70 89 11 00 	cmpl   $0x118970,-0x14(%ebp)
  103990:	75 cb                	jne    10395d <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  103992:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103996:	74 24                	je     1039bc <default_check+0x625>
  103998:	c7 44 24 0c 06 6a 10 	movl   $0x106a06,0xc(%esp)
  10399f:	00 
  1039a0:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1039a7:	00 
  1039a8:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  1039af:	00 
  1039b0:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1039b7:	e8 08 d3 ff ff       	call   100cc4 <__panic>
    assert(total == 0);
  1039bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1039c0:	74 24                	je     1039e6 <default_check+0x64f>
  1039c2:	c7 44 24 0c 11 6a 10 	movl   $0x106a11,0xc(%esp)
  1039c9:	00 
  1039ca:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1039d1:	00 
  1039d2:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
  1039d9:	00 
  1039da:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1039e1:	e8 de d2 ff ff       	call   100cc4 <__panic>
}
  1039e6:	81 c4 94 00 00 00    	add    $0x94,%esp
  1039ec:	5b                   	pop    %ebx
  1039ed:	5d                   	pop    %ebp
  1039ee:	c3                   	ret    

001039ef <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1039ef:	55                   	push   %ebp
  1039f0:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1039f2:	8b 55 08             	mov    0x8(%ebp),%edx
  1039f5:	a1 84 89 11 00       	mov    0x118984,%eax
  1039fa:	29 c2                	sub    %eax,%edx
  1039fc:	89 d0                	mov    %edx,%eax
  1039fe:	c1 f8 02             	sar    $0x2,%eax
  103a01:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103a07:	5d                   	pop    %ebp
  103a08:	c3                   	ret    

00103a09 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103a09:	55                   	push   %ebp
  103a0a:	89 e5                	mov    %esp,%ebp
  103a0c:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  103a12:	89 04 24             	mov    %eax,(%esp)
  103a15:	e8 d5 ff ff ff       	call   1039ef <page2ppn>
  103a1a:	c1 e0 0c             	shl    $0xc,%eax
}
  103a1d:	c9                   	leave  
  103a1e:	c3                   	ret    

00103a1f <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  103a1f:	55                   	push   %ebp
  103a20:	89 e5                	mov    %esp,%ebp
  103a22:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103a25:	8b 45 08             	mov    0x8(%ebp),%eax
  103a28:	c1 e8 0c             	shr    $0xc,%eax
  103a2b:	89 c2                	mov    %eax,%edx
  103a2d:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  103a32:	39 c2                	cmp    %eax,%edx
  103a34:	72 1c                	jb     103a52 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103a36:	c7 44 24 08 4c 6a 10 	movl   $0x106a4c,0x8(%esp)
  103a3d:	00 
  103a3e:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103a45:	00 
  103a46:	c7 04 24 6b 6a 10 00 	movl   $0x106a6b,(%esp)
  103a4d:	e8 72 d2 ff ff       	call   100cc4 <__panic>
    }
    return &pages[PPN(pa)];
  103a52:	8b 0d 84 89 11 00    	mov    0x118984,%ecx
  103a58:	8b 45 08             	mov    0x8(%ebp),%eax
  103a5b:	c1 e8 0c             	shr    $0xc,%eax
  103a5e:	89 c2                	mov    %eax,%edx
  103a60:	89 d0                	mov    %edx,%eax
  103a62:	c1 e0 02             	shl    $0x2,%eax
  103a65:	01 d0                	add    %edx,%eax
  103a67:	c1 e0 02             	shl    $0x2,%eax
  103a6a:	01 c8                	add    %ecx,%eax
}
  103a6c:	c9                   	leave  
  103a6d:	c3                   	ret    

00103a6e <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103a6e:	55                   	push   %ebp
  103a6f:	89 e5                	mov    %esp,%ebp
  103a71:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103a74:	8b 45 08             	mov    0x8(%ebp),%eax
  103a77:	89 04 24             	mov    %eax,(%esp)
  103a7a:	e8 8a ff ff ff       	call   103a09 <page2pa>
  103a7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a85:	c1 e8 0c             	shr    $0xc,%eax
  103a88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a8b:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  103a90:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103a93:	72 23                	jb     103ab8 <page2kva+0x4a>
  103a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a98:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103a9c:	c7 44 24 08 7c 6a 10 	movl   $0x106a7c,0x8(%esp)
  103aa3:	00 
  103aa4:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103aab:	00 
  103aac:	c7 04 24 6b 6a 10 00 	movl   $0x106a6b,(%esp)
  103ab3:	e8 0c d2 ff ff       	call   100cc4 <__panic>
  103ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103abb:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103ac0:	c9                   	leave  
  103ac1:	c3                   	ret    

00103ac2 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103ac2:	55                   	push   %ebp
  103ac3:	89 e5                	mov    %esp,%ebp
  103ac5:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  103acb:	83 e0 01             	and    $0x1,%eax
  103ace:	85 c0                	test   %eax,%eax
  103ad0:	75 1c                	jne    103aee <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103ad2:	c7 44 24 08 a0 6a 10 	movl   $0x106aa0,0x8(%esp)
  103ad9:	00 
  103ada:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103ae1:	00 
  103ae2:	c7 04 24 6b 6a 10 00 	movl   $0x106a6b,(%esp)
  103ae9:	e8 d6 d1 ff ff       	call   100cc4 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103aee:	8b 45 08             	mov    0x8(%ebp),%eax
  103af1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103af6:	89 04 24             	mov    %eax,(%esp)
  103af9:	e8 21 ff ff ff       	call   103a1f <pa2page>
}
  103afe:	c9                   	leave  
  103aff:	c3                   	ret    

00103b00 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  103b00:	55                   	push   %ebp
  103b01:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103b03:	8b 45 08             	mov    0x8(%ebp),%eax
  103b06:	8b 00                	mov    (%eax),%eax
}
  103b08:	5d                   	pop    %ebp
  103b09:	c3                   	ret    

00103b0a <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103b0a:	55                   	push   %ebp
  103b0b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  103b10:	8b 55 0c             	mov    0xc(%ebp),%edx
  103b13:	89 10                	mov    %edx,(%eax)
}
  103b15:	5d                   	pop    %ebp
  103b16:	c3                   	ret    

00103b17 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103b17:	55                   	push   %ebp
  103b18:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  103b1d:	8b 00                	mov    (%eax),%eax
  103b1f:	8d 50 01             	lea    0x1(%eax),%edx
  103b22:	8b 45 08             	mov    0x8(%ebp),%eax
  103b25:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103b27:	8b 45 08             	mov    0x8(%ebp),%eax
  103b2a:	8b 00                	mov    (%eax),%eax
}
  103b2c:	5d                   	pop    %ebp
  103b2d:	c3                   	ret    

00103b2e <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103b2e:	55                   	push   %ebp
  103b2f:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103b31:	8b 45 08             	mov    0x8(%ebp),%eax
  103b34:	8b 00                	mov    (%eax),%eax
  103b36:	8d 50 ff             	lea    -0x1(%eax),%edx
  103b39:	8b 45 08             	mov    0x8(%ebp),%eax
  103b3c:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  103b41:	8b 00                	mov    (%eax),%eax
}
  103b43:	5d                   	pop    %ebp
  103b44:	c3                   	ret    

00103b45 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103b45:	55                   	push   %ebp
  103b46:	89 e5                	mov    %esp,%ebp
  103b48:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103b4b:	9c                   	pushf  
  103b4c:	58                   	pop    %eax
  103b4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103b53:	25 00 02 00 00       	and    $0x200,%eax
  103b58:	85 c0                	test   %eax,%eax
  103b5a:	74 0c                	je     103b68 <__intr_save+0x23>
        intr_disable();
  103b5c:	e8 46 db ff ff       	call   1016a7 <intr_disable>
        return 1;
  103b61:	b8 01 00 00 00       	mov    $0x1,%eax
  103b66:	eb 05                	jmp    103b6d <__intr_save+0x28>
    }
    return 0;
  103b68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103b6d:	c9                   	leave  
  103b6e:	c3                   	ret    

00103b6f <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103b6f:	55                   	push   %ebp
  103b70:	89 e5                	mov    %esp,%ebp
  103b72:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103b75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103b79:	74 05                	je     103b80 <__intr_restore+0x11>
        intr_enable();
  103b7b:	e8 21 db ff ff       	call   1016a1 <intr_enable>
    }
}
  103b80:	c9                   	leave  
  103b81:	c3                   	ret    

00103b82 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103b82:	55                   	push   %ebp
  103b83:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103b85:	8b 45 08             	mov    0x8(%ebp),%eax
  103b88:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103b8b:	b8 23 00 00 00       	mov    $0x23,%eax
  103b90:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103b92:	b8 23 00 00 00       	mov    $0x23,%eax
  103b97:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103b99:	b8 10 00 00 00       	mov    $0x10,%eax
  103b9e:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103ba0:	b8 10 00 00 00       	mov    $0x10,%eax
  103ba5:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103ba7:	b8 10 00 00 00       	mov    $0x10,%eax
  103bac:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103bae:	ea b5 3b 10 00 08 00 	ljmp   $0x8,$0x103bb5
}
  103bb5:	5d                   	pop    %ebp
  103bb6:	c3                   	ret    

00103bb7 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103bb7:	55                   	push   %ebp
  103bb8:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103bba:	8b 45 08             	mov    0x8(%ebp),%eax
  103bbd:	a3 04 89 11 00       	mov    %eax,0x118904
}
  103bc2:	5d                   	pop    %ebp
  103bc3:	c3                   	ret    

00103bc4 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103bc4:	55                   	push   %ebp
  103bc5:	89 e5                	mov    %esp,%ebp
  103bc7:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103bca:	b8 00 70 11 00       	mov    $0x117000,%eax
  103bcf:	89 04 24             	mov    %eax,(%esp)
  103bd2:	e8 e0 ff ff ff       	call   103bb7 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103bd7:	66 c7 05 08 89 11 00 	movw   $0x10,0x118908
  103bde:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103be0:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103be7:	68 00 
  103be9:	b8 00 89 11 00       	mov    $0x118900,%eax
  103bee:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103bf4:	b8 00 89 11 00       	mov    $0x118900,%eax
  103bf9:	c1 e8 10             	shr    $0x10,%eax
  103bfc:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103c01:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c08:	83 e0 f0             	and    $0xfffffff0,%eax
  103c0b:	83 c8 09             	or     $0x9,%eax
  103c0e:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c13:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c1a:	83 e0 ef             	and    $0xffffffef,%eax
  103c1d:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c22:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c29:	83 e0 9f             	and    $0xffffff9f,%eax
  103c2c:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c31:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c38:	83 c8 80             	or     $0xffffff80,%eax
  103c3b:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c40:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c47:	83 e0 f0             	and    $0xfffffff0,%eax
  103c4a:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c4f:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c56:	83 e0 ef             	and    $0xffffffef,%eax
  103c59:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c5e:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c65:	83 e0 df             	and    $0xffffffdf,%eax
  103c68:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c6d:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c74:	83 c8 40             	or     $0x40,%eax
  103c77:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c7c:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c83:	83 e0 7f             	and    $0x7f,%eax
  103c86:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c8b:	b8 00 89 11 00       	mov    $0x118900,%eax
  103c90:	c1 e8 18             	shr    $0x18,%eax
  103c93:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103c98:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103c9f:	e8 de fe ff ff       	call   103b82 <lgdt>
  103ca4:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103caa:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103cae:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103cb1:	c9                   	leave  
  103cb2:	c3                   	ret    

00103cb3 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103cb3:	55                   	push   %ebp
  103cb4:	89 e5                	mov    %esp,%ebp
  103cb6:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103cb9:	c7 05 7c 89 11 00 30 	movl   $0x106a30,0x11897c
  103cc0:	6a 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103cc3:	a1 7c 89 11 00       	mov    0x11897c,%eax
  103cc8:	8b 00                	mov    (%eax),%eax
  103cca:	89 44 24 04          	mov    %eax,0x4(%esp)
  103cce:	c7 04 24 cc 6a 10 00 	movl   $0x106acc,(%esp)
  103cd5:	e8 62 c6 ff ff       	call   10033c <cprintf>
    pmm_manager->init();
  103cda:	a1 7c 89 11 00       	mov    0x11897c,%eax
  103cdf:	8b 40 04             	mov    0x4(%eax),%eax
  103ce2:	ff d0                	call   *%eax
}
  103ce4:	c9                   	leave  
  103ce5:	c3                   	ret    

00103ce6 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103ce6:	55                   	push   %ebp
  103ce7:	89 e5                	mov    %esp,%ebp
  103ce9:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103cec:	a1 7c 89 11 00       	mov    0x11897c,%eax
  103cf1:	8b 40 08             	mov    0x8(%eax),%eax
  103cf4:	8b 55 0c             	mov    0xc(%ebp),%edx
  103cf7:	89 54 24 04          	mov    %edx,0x4(%esp)
  103cfb:	8b 55 08             	mov    0x8(%ebp),%edx
  103cfe:	89 14 24             	mov    %edx,(%esp)
  103d01:	ff d0                	call   *%eax
}
  103d03:	c9                   	leave  
  103d04:	c3                   	ret    

00103d05 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103d05:	55                   	push   %ebp
  103d06:	89 e5                	mov    %esp,%ebp
  103d08:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103d0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103d12:	e8 2e fe ff ff       	call   103b45 <__intr_save>
  103d17:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103d1a:	a1 7c 89 11 00       	mov    0x11897c,%eax
  103d1f:	8b 40 0c             	mov    0xc(%eax),%eax
  103d22:	8b 55 08             	mov    0x8(%ebp),%edx
  103d25:	89 14 24             	mov    %edx,(%esp)
  103d28:	ff d0                	call   *%eax
  103d2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d30:	89 04 24             	mov    %eax,(%esp)
  103d33:	e8 37 fe ff ff       	call   103b6f <__intr_restore>
    return page;
  103d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103d3b:	c9                   	leave  
  103d3c:	c3                   	ret    

00103d3d <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103d3d:	55                   	push   %ebp
  103d3e:	89 e5                	mov    %esp,%ebp
  103d40:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103d43:	e8 fd fd ff ff       	call   103b45 <__intr_save>
  103d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103d4b:	a1 7c 89 11 00       	mov    0x11897c,%eax
  103d50:	8b 40 10             	mov    0x10(%eax),%eax
  103d53:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d56:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d5a:	8b 55 08             	mov    0x8(%ebp),%edx
  103d5d:	89 14 24             	mov    %edx,(%esp)
  103d60:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d65:	89 04 24             	mov    %eax,(%esp)
  103d68:	e8 02 fe ff ff       	call   103b6f <__intr_restore>
}
  103d6d:	c9                   	leave  
  103d6e:	c3                   	ret    

00103d6f <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103d6f:	55                   	push   %ebp
  103d70:	89 e5                	mov    %esp,%ebp
  103d72:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103d75:	e8 cb fd ff ff       	call   103b45 <__intr_save>
  103d7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103d7d:	a1 7c 89 11 00       	mov    0x11897c,%eax
  103d82:	8b 40 14             	mov    0x14(%eax),%eax
  103d85:	ff d0                	call   *%eax
  103d87:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d8d:	89 04 24             	mov    %eax,(%esp)
  103d90:	e8 da fd ff ff       	call   103b6f <__intr_restore>
    return ret;
  103d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103d98:	c9                   	leave  
  103d99:	c3                   	ret    

00103d9a <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103d9a:	55                   	push   %ebp
  103d9b:	89 e5                	mov    %esp,%ebp
  103d9d:	57                   	push   %edi
  103d9e:	56                   	push   %esi
  103d9f:	53                   	push   %ebx
  103da0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103da6:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103dad:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103db4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103dbb:	c7 04 24 e3 6a 10 00 	movl   $0x106ae3,(%esp)
  103dc2:	e8 75 c5 ff ff       	call   10033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103dc7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103dce:	e9 15 01 00 00       	jmp    103ee8 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103dd3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103dd6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103dd9:	89 d0                	mov    %edx,%eax
  103ddb:	c1 e0 02             	shl    $0x2,%eax
  103dde:	01 d0                	add    %edx,%eax
  103de0:	c1 e0 02             	shl    $0x2,%eax
  103de3:	01 c8                	add    %ecx,%eax
  103de5:	8b 50 08             	mov    0x8(%eax),%edx
  103de8:	8b 40 04             	mov    0x4(%eax),%eax
  103deb:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103dee:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103df1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103df4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103df7:	89 d0                	mov    %edx,%eax
  103df9:	c1 e0 02             	shl    $0x2,%eax
  103dfc:	01 d0                	add    %edx,%eax
  103dfe:	c1 e0 02             	shl    $0x2,%eax
  103e01:	01 c8                	add    %ecx,%eax
  103e03:	8b 48 0c             	mov    0xc(%eax),%ecx
  103e06:	8b 58 10             	mov    0x10(%eax),%ebx
  103e09:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103e0c:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103e0f:	01 c8                	add    %ecx,%eax
  103e11:	11 da                	adc    %ebx,%edx
  103e13:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103e16:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103e19:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e1f:	89 d0                	mov    %edx,%eax
  103e21:	c1 e0 02             	shl    $0x2,%eax
  103e24:	01 d0                	add    %edx,%eax
  103e26:	c1 e0 02             	shl    $0x2,%eax
  103e29:	01 c8                	add    %ecx,%eax
  103e2b:	83 c0 14             	add    $0x14,%eax
  103e2e:	8b 00                	mov    (%eax),%eax
  103e30:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103e36:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103e39:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103e3c:	83 c0 ff             	add    $0xffffffff,%eax
  103e3f:	83 d2 ff             	adc    $0xffffffff,%edx
  103e42:	89 c6                	mov    %eax,%esi
  103e44:	89 d7                	mov    %edx,%edi
  103e46:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e49:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e4c:	89 d0                	mov    %edx,%eax
  103e4e:	c1 e0 02             	shl    $0x2,%eax
  103e51:	01 d0                	add    %edx,%eax
  103e53:	c1 e0 02             	shl    $0x2,%eax
  103e56:	01 c8                	add    %ecx,%eax
  103e58:	8b 48 0c             	mov    0xc(%eax),%ecx
  103e5b:	8b 58 10             	mov    0x10(%eax),%ebx
  103e5e:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103e64:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103e68:	89 74 24 14          	mov    %esi,0x14(%esp)
  103e6c:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103e70:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103e73:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103e76:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103e7a:	89 54 24 10          	mov    %edx,0x10(%esp)
  103e7e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103e82:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103e86:	c7 04 24 f0 6a 10 00 	movl   $0x106af0,(%esp)
  103e8d:	e8 aa c4 ff ff       	call   10033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103e92:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e95:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e98:	89 d0                	mov    %edx,%eax
  103e9a:	c1 e0 02             	shl    $0x2,%eax
  103e9d:	01 d0                	add    %edx,%eax
  103e9f:	c1 e0 02             	shl    $0x2,%eax
  103ea2:	01 c8                	add    %ecx,%eax
  103ea4:	83 c0 14             	add    $0x14,%eax
  103ea7:	8b 00                	mov    (%eax),%eax
  103ea9:	83 f8 01             	cmp    $0x1,%eax
  103eac:	75 36                	jne    103ee4 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  103eae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103eb1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103eb4:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103eb7:	77 2b                	ja     103ee4 <page_init+0x14a>
  103eb9:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103ebc:	72 05                	jb     103ec3 <page_init+0x129>
  103ebe:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103ec1:	73 21                	jae    103ee4 <page_init+0x14a>
  103ec3:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103ec7:	77 1b                	ja     103ee4 <page_init+0x14a>
  103ec9:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103ecd:	72 09                	jb     103ed8 <page_init+0x13e>
  103ecf:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103ed6:	77 0c                	ja     103ee4 <page_init+0x14a>
                maxpa = end;
  103ed8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103edb:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103ede:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103ee1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103ee4:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103ee8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103eeb:	8b 00                	mov    (%eax),%eax
  103eed:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103ef0:	0f 8f dd fe ff ff    	jg     103dd3 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103ef6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103efa:	72 1d                	jb     103f19 <page_init+0x17f>
  103efc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103f00:	77 09                	ja     103f0b <page_init+0x171>
  103f02:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103f09:	76 0e                	jbe    103f19 <page_init+0x17f>
        maxpa = KMEMSIZE;
  103f0b:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103f12:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103f19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103f1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103f1f:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103f23:	c1 ea 0c             	shr    $0xc,%edx
  103f26:	a3 e0 88 11 00       	mov    %eax,0x1188e0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103f2b:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103f32:	b8 88 89 11 00       	mov    $0x118988,%eax
  103f37:	8d 50 ff             	lea    -0x1(%eax),%edx
  103f3a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103f3d:	01 d0                	add    %edx,%eax
  103f3f:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103f42:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103f45:	ba 00 00 00 00       	mov    $0x0,%edx
  103f4a:	f7 75 ac             	divl   -0x54(%ebp)
  103f4d:	89 d0                	mov    %edx,%eax
  103f4f:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103f52:	29 c2                	sub    %eax,%edx
  103f54:	89 d0                	mov    %edx,%eax
  103f56:	a3 84 89 11 00       	mov    %eax,0x118984

    for (i = 0; i < npage; i ++) {
  103f5b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103f62:	eb 2f                	jmp    103f93 <page_init+0x1f9>
        SetPageReserved(pages + i);
  103f64:	8b 0d 84 89 11 00    	mov    0x118984,%ecx
  103f6a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f6d:	89 d0                	mov    %edx,%eax
  103f6f:	c1 e0 02             	shl    $0x2,%eax
  103f72:	01 d0                	add    %edx,%eax
  103f74:	c1 e0 02             	shl    $0x2,%eax
  103f77:	01 c8                	add    %ecx,%eax
  103f79:	83 c0 04             	add    $0x4,%eax
  103f7c:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  103f83:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103f86:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103f89:	8b 55 90             	mov    -0x70(%ebp),%edx
  103f8c:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  103f8f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103f93:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f96:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  103f9b:	39 c2                	cmp    %eax,%edx
  103f9d:	72 c5                	jb     103f64 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103f9f:	8b 15 e0 88 11 00    	mov    0x1188e0,%edx
  103fa5:	89 d0                	mov    %edx,%eax
  103fa7:	c1 e0 02             	shl    $0x2,%eax
  103faa:	01 d0                	add    %edx,%eax
  103fac:	c1 e0 02             	shl    $0x2,%eax
  103faf:	89 c2                	mov    %eax,%edx
  103fb1:	a1 84 89 11 00       	mov    0x118984,%eax
  103fb6:	01 d0                	add    %edx,%eax
  103fb8:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  103fbb:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  103fc2:	77 23                	ja     103fe7 <page_init+0x24d>
  103fc4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103fc7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103fcb:	c7 44 24 08 20 6b 10 	movl   $0x106b20,0x8(%esp)
  103fd2:	00 
  103fd3:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  103fda:	00 
  103fdb:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  103fe2:	e8 dd cc ff ff       	call   100cc4 <__panic>
  103fe7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103fea:	05 00 00 00 40       	add    $0x40000000,%eax
  103fef:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  103ff2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103ff9:	e9 74 01 00 00       	jmp    104172 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103ffe:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104001:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104004:	89 d0                	mov    %edx,%eax
  104006:	c1 e0 02             	shl    $0x2,%eax
  104009:	01 d0                	add    %edx,%eax
  10400b:	c1 e0 02             	shl    $0x2,%eax
  10400e:	01 c8                	add    %ecx,%eax
  104010:	8b 50 08             	mov    0x8(%eax),%edx
  104013:	8b 40 04             	mov    0x4(%eax),%eax
  104016:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104019:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10401c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10401f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104022:	89 d0                	mov    %edx,%eax
  104024:	c1 e0 02             	shl    $0x2,%eax
  104027:	01 d0                	add    %edx,%eax
  104029:	c1 e0 02             	shl    $0x2,%eax
  10402c:	01 c8                	add    %ecx,%eax
  10402e:	8b 48 0c             	mov    0xc(%eax),%ecx
  104031:	8b 58 10             	mov    0x10(%eax),%ebx
  104034:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104037:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10403a:	01 c8                	add    %ecx,%eax
  10403c:	11 da                	adc    %ebx,%edx
  10403e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104041:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  104044:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104047:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10404a:	89 d0                	mov    %edx,%eax
  10404c:	c1 e0 02             	shl    $0x2,%eax
  10404f:	01 d0                	add    %edx,%eax
  104051:	c1 e0 02             	shl    $0x2,%eax
  104054:	01 c8                	add    %ecx,%eax
  104056:	83 c0 14             	add    $0x14,%eax
  104059:	8b 00                	mov    (%eax),%eax
  10405b:	83 f8 01             	cmp    $0x1,%eax
  10405e:	0f 85 0a 01 00 00    	jne    10416e <page_init+0x3d4>
            if (begin < freemem) {
  104064:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104067:	ba 00 00 00 00       	mov    $0x0,%edx
  10406c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10406f:	72 17                	jb     104088 <page_init+0x2ee>
  104071:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104074:	77 05                	ja     10407b <page_init+0x2e1>
  104076:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  104079:	76 0d                	jbe    104088 <page_init+0x2ee>
                begin = freemem;
  10407b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10407e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104081:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  104088:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10408c:	72 1d                	jb     1040ab <page_init+0x311>
  10408e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  104092:	77 09                	ja     10409d <page_init+0x303>
  104094:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  10409b:	76 0e                	jbe    1040ab <page_init+0x311>
                end = KMEMSIZE;
  10409d:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  1040a4:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  1040ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1040ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1040b1:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1040b4:	0f 87 b4 00 00 00    	ja     10416e <page_init+0x3d4>
  1040ba:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1040bd:	72 09                	jb     1040c8 <page_init+0x32e>
  1040bf:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1040c2:	0f 83 a6 00 00 00    	jae    10416e <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  1040c8:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  1040cf:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1040d2:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1040d5:	01 d0                	add    %edx,%eax
  1040d7:	83 e8 01             	sub    $0x1,%eax
  1040da:	89 45 98             	mov    %eax,-0x68(%ebp)
  1040dd:	8b 45 98             	mov    -0x68(%ebp),%eax
  1040e0:	ba 00 00 00 00       	mov    $0x0,%edx
  1040e5:	f7 75 9c             	divl   -0x64(%ebp)
  1040e8:	89 d0                	mov    %edx,%eax
  1040ea:	8b 55 98             	mov    -0x68(%ebp),%edx
  1040ed:	29 c2                	sub    %eax,%edx
  1040ef:	89 d0                	mov    %edx,%eax
  1040f1:	ba 00 00 00 00       	mov    $0x0,%edx
  1040f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1040f9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  1040fc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1040ff:	89 45 94             	mov    %eax,-0x6c(%ebp)
  104102:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104105:	ba 00 00 00 00       	mov    $0x0,%edx
  10410a:	89 c7                	mov    %eax,%edi
  10410c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  104112:	89 7d 80             	mov    %edi,-0x80(%ebp)
  104115:	89 d0                	mov    %edx,%eax
  104117:	83 e0 00             	and    $0x0,%eax
  10411a:	89 45 84             	mov    %eax,-0x7c(%ebp)
  10411d:	8b 45 80             	mov    -0x80(%ebp),%eax
  104120:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104123:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104126:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  104129:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10412c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10412f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104132:	77 3a                	ja     10416e <page_init+0x3d4>
  104134:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104137:	72 05                	jb     10413e <page_init+0x3a4>
  104139:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10413c:	73 30                	jae    10416e <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  10413e:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  104141:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  104144:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104147:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10414a:	29 c8                	sub    %ecx,%eax
  10414c:	19 da                	sbb    %ebx,%edx
  10414e:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104152:	c1 ea 0c             	shr    $0xc,%edx
  104155:	89 c3                	mov    %eax,%ebx
  104157:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10415a:	89 04 24             	mov    %eax,(%esp)
  10415d:	e8 bd f8 ff ff       	call   103a1f <pa2page>
  104162:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104166:	89 04 24             	mov    %eax,(%esp)
  104169:	e8 78 fb ff ff       	call   103ce6 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  10416e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104172:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104175:	8b 00                	mov    (%eax),%eax
  104177:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  10417a:	0f 8f 7e fe ff ff    	jg     103ffe <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  104180:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  104186:	5b                   	pop    %ebx
  104187:	5e                   	pop    %esi
  104188:	5f                   	pop    %edi
  104189:	5d                   	pop    %ebp
  10418a:	c3                   	ret    

0010418b <enable_paging>:

static void
enable_paging(void) {
  10418b:	55                   	push   %ebp
  10418c:	89 e5                	mov    %esp,%ebp
  10418e:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  104191:	a1 80 89 11 00       	mov    0x118980,%eax
  104196:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  104199:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10419c:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  10419f:	0f 20 c0             	mov    %cr0,%eax
  1041a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  1041a5:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  1041a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  1041ab:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  1041b2:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  1041b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1041b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  1041bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1041bf:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  1041c2:	c9                   	leave  
  1041c3:	c3                   	ret    

001041c4 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1041c4:	55                   	push   %ebp
  1041c5:	89 e5                	mov    %esp,%ebp
  1041c7:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1041ca:	8b 45 14             	mov    0x14(%ebp),%eax
  1041cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  1041d0:	31 d0                	xor    %edx,%eax
  1041d2:	25 ff 0f 00 00       	and    $0xfff,%eax
  1041d7:	85 c0                	test   %eax,%eax
  1041d9:	74 24                	je     1041ff <boot_map_segment+0x3b>
  1041db:	c7 44 24 0c 52 6b 10 	movl   $0x106b52,0xc(%esp)
  1041e2:	00 
  1041e3:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  1041ea:	00 
  1041eb:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  1041f2:	00 
  1041f3:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  1041fa:	e8 c5 ca ff ff       	call   100cc4 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1041ff:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  104206:	8b 45 0c             	mov    0xc(%ebp),%eax
  104209:	25 ff 0f 00 00       	and    $0xfff,%eax
  10420e:	89 c2                	mov    %eax,%edx
  104210:	8b 45 10             	mov    0x10(%ebp),%eax
  104213:	01 c2                	add    %eax,%edx
  104215:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104218:	01 d0                	add    %edx,%eax
  10421a:	83 e8 01             	sub    $0x1,%eax
  10421d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104220:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104223:	ba 00 00 00 00       	mov    $0x0,%edx
  104228:	f7 75 f0             	divl   -0x10(%ebp)
  10422b:	89 d0                	mov    %edx,%eax
  10422d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104230:	29 c2                	sub    %eax,%edx
  104232:	89 d0                	mov    %edx,%eax
  104234:	c1 e8 0c             	shr    $0xc,%eax
  104237:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  10423a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10423d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104240:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104243:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104248:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  10424b:	8b 45 14             	mov    0x14(%ebp),%eax
  10424e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104251:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104254:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104259:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10425c:	eb 6b                	jmp    1042c9 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  10425e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104265:	00 
  104266:	8b 45 0c             	mov    0xc(%ebp),%eax
  104269:	89 44 24 04          	mov    %eax,0x4(%esp)
  10426d:	8b 45 08             	mov    0x8(%ebp),%eax
  104270:	89 04 24             	mov    %eax,(%esp)
  104273:	e8 cc 01 00 00       	call   104444 <get_pte>
  104278:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  10427b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10427f:	75 24                	jne    1042a5 <boot_map_segment+0xe1>
  104281:	c7 44 24 0c 7e 6b 10 	movl   $0x106b7e,0xc(%esp)
  104288:	00 
  104289:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104290:	00 
  104291:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  104298:	00 
  104299:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  1042a0:	e8 1f ca ff ff       	call   100cc4 <__panic>
        *ptep = pa | PTE_P | perm;
  1042a5:	8b 45 18             	mov    0x18(%ebp),%eax
  1042a8:	8b 55 14             	mov    0x14(%ebp),%edx
  1042ab:	09 d0                	or     %edx,%eax
  1042ad:	83 c8 01             	or     $0x1,%eax
  1042b0:	89 c2                	mov    %eax,%edx
  1042b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1042b5:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1042b7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1042bb:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1042c2:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1042c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1042cd:	75 8f                	jne    10425e <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  1042cf:	c9                   	leave  
  1042d0:	c3                   	ret    

001042d1 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1042d1:	55                   	push   %ebp
  1042d2:	89 e5                	mov    %esp,%ebp
  1042d4:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1042d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1042de:	e8 22 fa ff ff       	call   103d05 <alloc_pages>
  1042e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1042e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1042ea:	75 1c                	jne    104308 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1042ec:	c7 44 24 08 8b 6b 10 	movl   $0x106b8b,0x8(%esp)
  1042f3:	00 
  1042f4:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1042fb:	00 
  1042fc:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104303:	e8 bc c9 ff ff       	call   100cc4 <__panic>
    }
    return page2kva(p);
  104308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10430b:	89 04 24             	mov    %eax,(%esp)
  10430e:	e8 5b f7 ff ff       	call   103a6e <page2kva>
}
  104313:	c9                   	leave  
  104314:	c3                   	ret    

00104315 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  104315:	55                   	push   %ebp
  104316:	89 e5                	mov    %esp,%ebp
  104318:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  10431b:	e8 93 f9 ff ff       	call   103cb3 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  104320:	e8 75 fa ff ff       	call   103d9a <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  104325:	e8 70 04 00 00       	call   10479a <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  10432a:	e8 a2 ff ff ff       	call   1042d1 <boot_alloc_page>
  10432f:	a3 e4 88 11 00       	mov    %eax,0x1188e4
    memset(boot_pgdir, 0, PGSIZE);
  104334:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104339:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104340:	00 
  104341:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104348:	00 
  104349:	89 04 24             	mov    %eax,(%esp)
  10434c:	e8 b2 1a 00 00       	call   105e03 <memset>
    boot_cr3 = PADDR(boot_pgdir);
  104351:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104356:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104359:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104360:	77 23                	ja     104385 <pmm_init+0x70>
  104362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104365:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104369:	c7 44 24 08 20 6b 10 	movl   $0x106b20,0x8(%esp)
  104370:	00 
  104371:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  104378:	00 
  104379:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104380:	e8 3f c9 ff ff       	call   100cc4 <__panic>
  104385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104388:	05 00 00 00 40       	add    $0x40000000,%eax
  10438d:	a3 80 89 11 00       	mov    %eax,0x118980

    check_pgdir();
  104392:	e8 21 04 00 00       	call   1047b8 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  104397:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  10439c:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  1043a2:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1043a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1043aa:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1043b1:	77 23                	ja     1043d6 <pmm_init+0xc1>
  1043b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1043ba:	c7 44 24 08 20 6b 10 	movl   $0x106b20,0x8(%esp)
  1043c1:	00 
  1043c2:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  1043c9:	00 
  1043ca:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  1043d1:	e8 ee c8 ff ff       	call   100cc4 <__panic>
  1043d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043d9:	05 00 00 00 40       	add    $0x40000000,%eax
  1043de:	83 c8 03             	or     $0x3,%eax
  1043e1:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1043e3:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1043e8:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1043ef:	00 
  1043f0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1043f7:	00 
  1043f8:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1043ff:	38 
  104400:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  104407:	c0 
  104408:	89 04 24             	mov    %eax,(%esp)
  10440b:	e8 b4 fd ff ff       	call   1041c4 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  104410:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104415:	8b 15 e4 88 11 00    	mov    0x1188e4,%edx
  10441b:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  104421:	89 10                	mov    %edx,(%eax)

    enable_paging();
  104423:	e8 63 fd ff ff       	call   10418b <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  104428:	e8 97 f7 ff ff       	call   103bc4 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  10442d:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104432:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  104438:	e8 16 0a 00 00       	call   104e53 <check_boot_pgdir>

    print_pgdir();
  10443d:	e8 a3 0e 00 00       	call   1052e5 <print_pgdir>

}
  104442:	c9                   	leave  
  104443:	c3                   	ret    

00104444 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  104444:	55                   	push   %ebp
  104445:	89 e5                	mov    %esp,%ebp
  104447:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
  10444a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10444d:	c1 e8 16             	shr    $0x16,%eax
  104450:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104457:	8b 45 08             	mov    0x8(%ebp),%eax
  10445a:	01 d0                	add    %edx,%eax
  10445c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
  10445f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104462:	8b 00                	mov    (%eax),%eax
  104464:	83 e0 01             	and    $0x1,%eax
  104467:	85 c0                	test   %eax,%eax
  104469:	0f 85 b9 00 00 00    	jne    104528 <get_pte+0xe4>
    	if(!create) return NULL;
  10446f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104473:	75 0a                	jne    10447f <get_pte+0x3b>
  104475:	b8 00 00 00 00       	mov    $0x0,%eax
  10447a:	e9 05 01 00 00       	jmp    104584 <get_pte+0x140>
    	struct Page *new_page = alloc_page();
  10447f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104486:	e8 7a f8 ff ff       	call   103d05 <alloc_pages>
  10448b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	if(new_page == NULL) return NULL;
  10448e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104492:	75 0a                	jne    10449e <get_pte+0x5a>
  104494:	b8 00 00 00 00       	mov    $0x0,%eax
  104499:	e9 e6 00 00 00       	jmp    104584 <get_pte+0x140>
    	set_page_ref(new_page,1);
  10449e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1044a5:	00 
  1044a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1044a9:	89 04 24             	mov    %eax,(%esp)
  1044ac:	e8 59 f6 ff ff       	call   103b0a <set_page_ref>
    	uintptr_t pa = page2pa(new_page);
  1044b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1044b4:	89 04 24             	mov    %eax,(%esp)
  1044b7:	e8 4d f5 ff ff       	call   103a09 <page2pa>
  1044bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	memset(KADDR(pa), 0, PGSIZE);
  1044bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1044c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1044c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1044c8:	c1 e8 0c             	shr    $0xc,%eax
  1044cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1044ce:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  1044d3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1044d6:	72 23                	jb     1044fb <get_pte+0xb7>
  1044d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1044db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1044df:	c7 44 24 08 7c 6a 10 	movl   $0x106a7c,0x8(%esp)
  1044e6:	00 
  1044e7:	c7 44 24 04 86 01 00 	movl   $0x186,0x4(%esp)
  1044ee:	00 
  1044ef:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  1044f6:	e8 c9 c7 ff ff       	call   100cc4 <__panic>
  1044fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1044fe:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104503:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10450a:	00 
  10450b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104512:	00 
  104513:	89 04 24             	mov    %eax,(%esp)
  104516:	e8 e8 18 00 00       	call   105e03 <memset>
    	*pdep = pa | PTE_P | PTE_W | PTE_U;
  10451b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10451e:	83 c8 07             	or     $0x7,%eax
  104521:	89 c2                	mov    %eax,%edx
  104523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104526:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
  104528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10452b:	8b 00                	mov    (%eax),%eax
  10452d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104532:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104535:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104538:	c1 e8 0c             	shr    $0xc,%eax
  10453b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10453e:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  104543:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104546:	72 23                	jb     10456b <get_pte+0x127>
  104548:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10454b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10454f:	c7 44 24 08 7c 6a 10 	movl   $0x106a7c,0x8(%esp)
  104556:	00 
  104557:	c7 44 24 04 89 01 00 	movl   $0x189,0x4(%esp)
  10455e:	00 
  10455f:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104566:	e8 59 c7 ff ff       	call   100cc4 <__panic>
  10456b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10456e:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104573:	8b 55 0c             	mov    0xc(%ebp),%edx
  104576:	c1 ea 0c             	shr    $0xc,%edx
  104579:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  10457f:	c1 e2 02             	shl    $0x2,%edx
  104582:	01 d0                	add    %edx,%eax
}
  104584:	c9                   	leave  
  104585:	c3                   	ret    

00104586 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  104586:	55                   	push   %ebp
  104587:	89 e5                	mov    %esp,%ebp
  104589:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10458c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104593:	00 
  104594:	8b 45 0c             	mov    0xc(%ebp),%eax
  104597:	89 44 24 04          	mov    %eax,0x4(%esp)
  10459b:	8b 45 08             	mov    0x8(%ebp),%eax
  10459e:	89 04 24             	mov    %eax,(%esp)
  1045a1:	e8 9e fe ff ff       	call   104444 <get_pte>
  1045a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1045a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1045ad:	74 08                	je     1045b7 <get_page+0x31>
        *ptep_store = ptep;
  1045af:	8b 45 10             	mov    0x10(%ebp),%eax
  1045b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1045b5:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1045b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1045bb:	74 1b                	je     1045d8 <get_page+0x52>
  1045bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045c0:	8b 00                	mov    (%eax),%eax
  1045c2:	83 e0 01             	and    $0x1,%eax
  1045c5:	85 c0                	test   %eax,%eax
  1045c7:	74 0f                	je     1045d8 <get_page+0x52>
        return pa2page(*ptep);
  1045c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045cc:	8b 00                	mov    (%eax),%eax
  1045ce:	89 04 24             	mov    %eax,(%esp)
  1045d1:	e8 49 f4 ff ff       	call   103a1f <pa2page>
  1045d6:	eb 05                	jmp    1045dd <get_page+0x57>
    }
    return NULL;
  1045d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1045dd:	c9                   	leave  
  1045de:	c3                   	ret    

001045df <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1045df:	55                   	push   %ebp
  1045e0:	89 e5                	mov    %esp,%ebp
  1045e2:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
  1045e5:	8b 45 10             	mov    0x10(%ebp),%eax
  1045e8:	8b 00                	mov    (%eax),%eax
  1045ea:	83 e0 01             	and    $0x1,%eax
  1045ed:	85 c0                	test   %eax,%eax
  1045ef:	74 4d                	je     10463e <page_remove_pte+0x5f>
    	struct Page *page = pte2page(*ptep);
  1045f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1045f4:	8b 00                	mov    (%eax),%eax
  1045f6:	89 04 24             	mov    %eax,(%esp)
  1045f9:	e8 c4 f4 ff ff       	call   103ac2 <pte2page>
  1045fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	if (page_ref_dec(page) == 0) {
  104601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104604:	89 04 24             	mov    %eax,(%esp)
  104607:	e8 22 f5 ff ff       	call   103b2e <page_ref_dec>
  10460c:	85 c0                	test   %eax,%eax
  10460e:	75 13                	jne    104623 <page_remove_pte+0x44>
    		free_page(page);
  104610:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104617:	00 
  104618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10461b:	89 04 24             	mov    %eax,(%esp)
  10461e:	e8 1a f7 ff ff       	call   103d3d <free_pages>
    	}
    	*ptep = 0;
  104623:	8b 45 10             	mov    0x10(%ebp),%eax
  104626:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    	tlb_invalidate(pgdir,la);
  10462c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10462f:	89 44 24 04          	mov    %eax,0x4(%esp)
  104633:	8b 45 08             	mov    0x8(%ebp),%eax
  104636:	89 04 24             	mov    %eax,(%esp)
  104639:	e8 ff 00 00 00       	call   10473d <tlb_invalidate>
    }
}
  10463e:	c9                   	leave  
  10463f:	c3                   	ret    

00104640 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  104640:	55                   	push   %ebp
  104641:	89 e5                	mov    %esp,%ebp
  104643:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104646:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10464d:	00 
  10464e:	8b 45 0c             	mov    0xc(%ebp),%eax
  104651:	89 44 24 04          	mov    %eax,0x4(%esp)
  104655:	8b 45 08             	mov    0x8(%ebp),%eax
  104658:	89 04 24             	mov    %eax,(%esp)
  10465b:	e8 e4 fd ff ff       	call   104444 <get_pte>
  104660:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  104663:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104667:	74 19                	je     104682 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  104669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10466c:	89 44 24 08          	mov    %eax,0x8(%esp)
  104670:	8b 45 0c             	mov    0xc(%ebp),%eax
  104673:	89 44 24 04          	mov    %eax,0x4(%esp)
  104677:	8b 45 08             	mov    0x8(%ebp),%eax
  10467a:	89 04 24             	mov    %eax,(%esp)
  10467d:	e8 5d ff ff ff       	call   1045df <page_remove_pte>
    }
}
  104682:	c9                   	leave  
  104683:	c3                   	ret    

00104684 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  104684:	55                   	push   %ebp
  104685:	89 e5                	mov    %esp,%ebp
  104687:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  10468a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104691:	00 
  104692:	8b 45 10             	mov    0x10(%ebp),%eax
  104695:	89 44 24 04          	mov    %eax,0x4(%esp)
  104699:	8b 45 08             	mov    0x8(%ebp),%eax
  10469c:	89 04 24             	mov    %eax,(%esp)
  10469f:	e8 a0 fd ff ff       	call   104444 <get_pte>
  1046a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1046a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1046ab:	75 0a                	jne    1046b7 <page_insert+0x33>
        return -E_NO_MEM;
  1046ad:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1046b2:	e9 84 00 00 00       	jmp    10473b <page_insert+0xb7>
    }
    page_ref_inc(page);
  1046b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046ba:	89 04 24             	mov    %eax,(%esp)
  1046bd:	e8 55 f4 ff ff       	call   103b17 <page_ref_inc>
    if (*ptep & PTE_P) {
  1046c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046c5:	8b 00                	mov    (%eax),%eax
  1046c7:	83 e0 01             	and    $0x1,%eax
  1046ca:	85 c0                	test   %eax,%eax
  1046cc:	74 3e                	je     10470c <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1046ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046d1:	8b 00                	mov    (%eax),%eax
  1046d3:	89 04 24             	mov    %eax,(%esp)
  1046d6:	e8 e7 f3 ff ff       	call   103ac2 <pte2page>
  1046db:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1046de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046e1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1046e4:	75 0d                	jne    1046f3 <page_insert+0x6f>
            page_ref_dec(page);
  1046e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046e9:	89 04 24             	mov    %eax,(%esp)
  1046ec:	e8 3d f4 ff ff       	call   103b2e <page_ref_dec>
  1046f1:	eb 19                	jmp    10470c <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1046f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1046fa:	8b 45 10             	mov    0x10(%ebp),%eax
  1046fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  104701:	8b 45 08             	mov    0x8(%ebp),%eax
  104704:	89 04 24             	mov    %eax,(%esp)
  104707:	e8 d3 fe ff ff       	call   1045df <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  10470c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10470f:	89 04 24             	mov    %eax,(%esp)
  104712:	e8 f2 f2 ff ff       	call   103a09 <page2pa>
  104717:	0b 45 14             	or     0x14(%ebp),%eax
  10471a:	83 c8 01             	or     $0x1,%eax
  10471d:	89 c2                	mov    %eax,%edx
  10471f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104722:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  104724:	8b 45 10             	mov    0x10(%ebp),%eax
  104727:	89 44 24 04          	mov    %eax,0x4(%esp)
  10472b:	8b 45 08             	mov    0x8(%ebp),%eax
  10472e:	89 04 24             	mov    %eax,(%esp)
  104731:	e8 07 00 00 00       	call   10473d <tlb_invalidate>
    return 0;
  104736:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10473b:	c9                   	leave  
  10473c:	c3                   	ret    

0010473d <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  10473d:	55                   	push   %ebp
  10473e:	89 e5                	mov    %esp,%ebp
  104740:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  104743:	0f 20 d8             	mov    %cr3,%eax
  104746:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  104749:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  10474c:	89 c2                	mov    %eax,%edx
  10474e:	8b 45 08             	mov    0x8(%ebp),%eax
  104751:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104754:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10475b:	77 23                	ja     104780 <tlb_invalidate+0x43>
  10475d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104760:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104764:	c7 44 24 08 20 6b 10 	movl   $0x106b20,0x8(%esp)
  10476b:	00 
  10476c:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  104773:	00 
  104774:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  10477b:	e8 44 c5 ff ff       	call   100cc4 <__panic>
  104780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104783:	05 00 00 00 40       	add    $0x40000000,%eax
  104788:	39 c2                	cmp    %eax,%edx
  10478a:	75 0c                	jne    104798 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  10478c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10478f:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  104792:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104795:	0f 01 38             	invlpg (%eax)
    }
}
  104798:	c9                   	leave  
  104799:	c3                   	ret    

0010479a <check_alloc_page>:

static void
check_alloc_page(void) {
  10479a:	55                   	push   %ebp
  10479b:	89 e5                	mov    %esp,%ebp
  10479d:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  1047a0:	a1 7c 89 11 00       	mov    0x11897c,%eax
  1047a5:	8b 40 18             	mov    0x18(%eax),%eax
  1047a8:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1047aa:	c7 04 24 a4 6b 10 00 	movl   $0x106ba4,(%esp)
  1047b1:	e8 86 bb ff ff       	call   10033c <cprintf>
}
  1047b6:	c9                   	leave  
  1047b7:	c3                   	ret    

001047b8 <check_pgdir>:

static void
check_pgdir(void) {
  1047b8:	55                   	push   %ebp
  1047b9:	89 e5                	mov    %esp,%ebp
  1047bb:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1047be:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  1047c3:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1047c8:	76 24                	jbe    1047ee <check_pgdir+0x36>
  1047ca:	c7 44 24 0c c3 6b 10 	movl   $0x106bc3,0xc(%esp)
  1047d1:	00 
  1047d2:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  1047d9:	00 
  1047da:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  1047e1:	00 
  1047e2:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  1047e9:	e8 d6 c4 ff ff       	call   100cc4 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1047ee:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1047f3:	85 c0                	test   %eax,%eax
  1047f5:	74 0e                	je     104805 <check_pgdir+0x4d>
  1047f7:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1047fc:	25 ff 0f 00 00       	and    $0xfff,%eax
  104801:	85 c0                	test   %eax,%eax
  104803:	74 24                	je     104829 <check_pgdir+0x71>
  104805:	c7 44 24 0c e0 6b 10 	movl   $0x106be0,0xc(%esp)
  10480c:	00 
  10480d:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104814:	00 
  104815:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  10481c:	00 
  10481d:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104824:	e8 9b c4 ff ff       	call   100cc4 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  104829:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  10482e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104835:	00 
  104836:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10483d:	00 
  10483e:	89 04 24             	mov    %eax,(%esp)
  104841:	e8 40 fd ff ff       	call   104586 <get_page>
  104846:	85 c0                	test   %eax,%eax
  104848:	74 24                	je     10486e <check_pgdir+0xb6>
  10484a:	c7 44 24 0c 18 6c 10 	movl   $0x106c18,0xc(%esp)
  104851:	00 
  104852:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104859:	00 
  10485a:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  104861:	00 
  104862:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104869:	e8 56 c4 ff ff       	call   100cc4 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  10486e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104875:	e8 8b f4 ff ff       	call   103d05 <alloc_pages>
  10487a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  10487d:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104882:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104889:	00 
  10488a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104891:	00 
  104892:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104895:	89 54 24 04          	mov    %edx,0x4(%esp)
  104899:	89 04 24             	mov    %eax,(%esp)
  10489c:	e8 e3 fd ff ff       	call   104684 <page_insert>
  1048a1:	85 c0                	test   %eax,%eax
  1048a3:	74 24                	je     1048c9 <check_pgdir+0x111>
  1048a5:	c7 44 24 0c 40 6c 10 	movl   $0x106c40,0xc(%esp)
  1048ac:	00 
  1048ad:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  1048b4:	00 
  1048b5:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  1048bc:	00 
  1048bd:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  1048c4:	e8 fb c3 ff ff       	call   100cc4 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1048c9:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1048ce:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048d5:	00 
  1048d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1048dd:	00 
  1048de:	89 04 24             	mov    %eax,(%esp)
  1048e1:	e8 5e fb ff ff       	call   104444 <get_pte>
  1048e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1048e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1048ed:	75 24                	jne    104913 <check_pgdir+0x15b>
  1048ef:	c7 44 24 0c 6c 6c 10 	movl   $0x106c6c,0xc(%esp)
  1048f6:	00 
  1048f7:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  1048fe:	00 
  1048ff:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  104906:	00 
  104907:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  10490e:	e8 b1 c3 ff ff       	call   100cc4 <__panic>
    assert(pa2page(*ptep) == p1);
  104913:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104916:	8b 00                	mov    (%eax),%eax
  104918:	89 04 24             	mov    %eax,(%esp)
  10491b:	e8 ff f0 ff ff       	call   103a1f <pa2page>
  104920:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104923:	74 24                	je     104949 <check_pgdir+0x191>
  104925:	c7 44 24 0c 99 6c 10 	movl   $0x106c99,0xc(%esp)
  10492c:	00 
  10492d:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104934:	00 
  104935:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  10493c:	00 
  10493d:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104944:	e8 7b c3 ff ff       	call   100cc4 <__panic>
    assert(page_ref(p1) == 1);
  104949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10494c:	89 04 24             	mov    %eax,(%esp)
  10494f:	e8 ac f1 ff ff       	call   103b00 <page_ref>
  104954:	83 f8 01             	cmp    $0x1,%eax
  104957:	74 24                	je     10497d <check_pgdir+0x1c5>
  104959:	c7 44 24 0c ae 6c 10 	movl   $0x106cae,0xc(%esp)
  104960:	00 
  104961:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104968:	00 
  104969:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104970:	00 
  104971:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104978:	e8 47 c3 ff ff       	call   100cc4 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  10497d:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104982:	8b 00                	mov    (%eax),%eax
  104984:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104989:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10498c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10498f:	c1 e8 0c             	shr    $0xc,%eax
  104992:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104995:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  10499a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10499d:	72 23                	jb     1049c2 <check_pgdir+0x20a>
  10499f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1049a6:	c7 44 24 08 7c 6a 10 	movl   $0x106a7c,0x8(%esp)
  1049ad:	00 
  1049ae:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  1049b5:	00 
  1049b6:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  1049bd:	e8 02 c3 ff ff       	call   100cc4 <__panic>
  1049c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049c5:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1049ca:	83 c0 04             	add    $0x4,%eax
  1049cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1049d0:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1049d5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1049dc:	00 
  1049dd:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1049e4:	00 
  1049e5:	89 04 24             	mov    %eax,(%esp)
  1049e8:	e8 57 fa ff ff       	call   104444 <get_pte>
  1049ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1049f0:	74 24                	je     104a16 <check_pgdir+0x25e>
  1049f2:	c7 44 24 0c c0 6c 10 	movl   $0x106cc0,0xc(%esp)
  1049f9:	00 
  1049fa:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104a01:	00 
  104a02:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  104a09:	00 
  104a0a:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104a11:	e8 ae c2 ff ff       	call   100cc4 <__panic>

    p2 = alloc_page();
  104a16:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a1d:	e8 e3 f2 ff ff       	call   103d05 <alloc_pages>
  104a22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104a25:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104a2a:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104a31:	00 
  104a32:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104a39:	00 
  104a3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104a3d:	89 54 24 04          	mov    %edx,0x4(%esp)
  104a41:	89 04 24             	mov    %eax,(%esp)
  104a44:	e8 3b fc ff ff       	call   104684 <page_insert>
  104a49:	85 c0                	test   %eax,%eax
  104a4b:	74 24                	je     104a71 <check_pgdir+0x2b9>
  104a4d:	c7 44 24 0c e8 6c 10 	movl   $0x106ce8,0xc(%esp)
  104a54:	00 
  104a55:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104a5c:	00 
  104a5d:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104a64:	00 
  104a65:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104a6c:	e8 53 c2 ff ff       	call   100cc4 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104a71:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104a76:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a7d:	00 
  104a7e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104a85:	00 
  104a86:	89 04 24             	mov    %eax,(%esp)
  104a89:	e8 b6 f9 ff ff       	call   104444 <get_pte>
  104a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104a95:	75 24                	jne    104abb <check_pgdir+0x303>
  104a97:	c7 44 24 0c 20 6d 10 	movl   $0x106d20,0xc(%esp)
  104a9e:	00 
  104a9f:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104aa6:	00 
  104aa7:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  104aae:	00 
  104aaf:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104ab6:	e8 09 c2 ff ff       	call   100cc4 <__panic>
    assert(*ptep & PTE_U);
  104abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104abe:	8b 00                	mov    (%eax),%eax
  104ac0:	83 e0 04             	and    $0x4,%eax
  104ac3:	85 c0                	test   %eax,%eax
  104ac5:	75 24                	jne    104aeb <check_pgdir+0x333>
  104ac7:	c7 44 24 0c 50 6d 10 	movl   $0x106d50,0xc(%esp)
  104ace:	00 
  104acf:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104ad6:	00 
  104ad7:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  104ade:	00 
  104adf:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104ae6:	e8 d9 c1 ff ff       	call   100cc4 <__panic>
    assert(*ptep & PTE_W);
  104aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104aee:	8b 00                	mov    (%eax),%eax
  104af0:	83 e0 02             	and    $0x2,%eax
  104af3:	85 c0                	test   %eax,%eax
  104af5:	75 24                	jne    104b1b <check_pgdir+0x363>
  104af7:	c7 44 24 0c 5e 6d 10 	movl   $0x106d5e,0xc(%esp)
  104afe:	00 
  104aff:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104b06:	00 
  104b07:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  104b0e:	00 
  104b0f:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104b16:	e8 a9 c1 ff ff       	call   100cc4 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104b1b:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104b20:	8b 00                	mov    (%eax),%eax
  104b22:	83 e0 04             	and    $0x4,%eax
  104b25:	85 c0                	test   %eax,%eax
  104b27:	75 24                	jne    104b4d <check_pgdir+0x395>
  104b29:	c7 44 24 0c 6c 6d 10 	movl   $0x106d6c,0xc(%esp)
  104b30:	00 
  104b31:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104b38:	00 
  104b39:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  104b40:	00 
  104b41:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104b48:	e8 77 c1 ff ff       	call   100cc4 <__panic>
    assert(page_ref(p2) == 1);
  104b4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b50:	89 04 24             	mov    %eax,(%esp)
  104b53:	e8 a8 ef ff ff       	call   103b00 <page_ref>
  104b58:	83 f8 01             	cmp    $0x1,%eax
  104b5b:	74 24                	je     104b81 <check_pgdir+0x3c9>
  104b5d:	c7 44 24 0c 82 6d 10 	movl   $0x106d82,0xc(%esp)
  104b64:	00 
  104b65:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104b6c:	00 
  104b6d:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  104b74:	00 
  104b75:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104b7c:	e8 43 c1 ff ff       	call   100cc4 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104b81:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104b86:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104b8d:	00 
  104b8e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104b95:	00 
  104b96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104b99:	89 54 24 04          	mov    %edx,0x4(%esp)
  104b9d:	89 04 24             	mov    %eax,(%esp)
  104ba0:	e8 df fa ff ff       	call   104684 <page_insert>
  104ba5:	85 c0                	test   %eax,%eax
  104ba7:	74 24                	je     104bcd <check_pgdir+0x415>
  104ba9:	c7 44 24 0c 94 6d 10 	movl   $0x106d94,0xc(%esp)
  104bb0:	00 
  104bb1:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104bb8:	00 
  104bb9:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  104bc0:	00 
  104bc1:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104bc8:	e8 f7 c0 ff ff       	call   100cc4 <__panic>
    assert(page_ref(p1) == 2);
  104bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bd0:	89 04 24             	mov    %eax,(%esp)
  104bd3:	e8 28 ef ff ff       	call   103b00 <page_ref>
  104bd8:	83 f8 02             	cmp    $0x2,%eax
  104bdb:	74 24                	je     104c01 <check_pgdir+0x449>
  104bdd:	c7 44 24 0c c0 6d 10 	movl   $0x106dc0,0xc(%esp)
  104be4:	00 
  104be5:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104bec:	00 
  104bed:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  104bf4:	00 
  104bf5:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104bfc:	e8 c3 c0 ff ff       	call   100cc4 <__panic>
    assert(page_ref(p2) == 0);
  104c01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c04:	89 04 24             	mov    %eax,(%esp)
  104c07:	e8 f4 ee ff ff       	call   103b00 <page_ref>
  104c0c:	85 c0                	test   %eax,%eax
  104c0e:	74 24                	je     104c34 <check_pgdir+0x47c>
  104c10:	c7 44 24 0c d2 6d 10 	movl   $0x106dd2,0xc(%esp)
  104c17:	00 
  104c18:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104c1f:	00 
  104c20:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  104c27:	00 
  104c28:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104c2f:	e8 90 c0 ff ff       	call   100cc4 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104c34:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104c39:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104c40:	00 
  104c41:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104c48:	00 
  104c49:	89 04 24             	mov    %eax,(%esp)
  104c4c:	e8 f3 f7 ff ff       	call   104444 <get_pte>
  104c51:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104c58:	75 24                	jne    104c7e <check_pgdir+0x4c6>
  104c5a:	c7 44 24 0c 20 6d 10 	movl   $0x106d20,0xc(%esp)
  104c61:	00 
  104c62:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104c69:	00 
  104c6a:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  104c71:	00 
  104c72:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104c79:	e8 46 c0 ff ff       	call   100cc4 <__panic>
    assert(pa2page(*ptep) == p1);
  104c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c81:	8b 00                	mov    (%eax),%eax
  104c83:	89 04 24             	mov    %eax,(%esp)
  104c86:	e8 94 ed ff ff       	call   103a1f <pa2page>
  104c8b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104c8e:	74 24                	je     104cb4 <check_pgdir+0x4fc>
  104c90:	c7 44 24 0c 99 6c 10 	movl   $0x106c99,0xc(%esp)
  104c97:	00 
  104c98:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104c9f:	00 
  104ca0:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104ca7:	00 
  104ca8:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104caf:	e8 10 c0 ff ff       	call   100cc4 <__panic>
    assert((*ptep & PTE_U) == 0);
  104cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cb7:	8b 00                	mov    (%eax),%eax
  104cb9:	83 e0 04             	and    $0x4,%eax
  104cbc:	85 c0                	test   %eax,%eax
  104cbe:	74 24                	je     104ce4 <check_pgdir+0x52c>
  104cc0:	c7 44 24 0c e4 6d 10 	movl   $0x106de4,0xc(%esp)
  104cc7:	00 
  104cc8:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104ccf:	00 
  104cd0:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
  104cd7:	00 
  104cd8:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104cdf:	e8 e0 bf ff ff       	call   100cc4 <__panic>

    page_remove(boot_pgdir, 0x0);
  104ce4:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104ce9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104cf0:	00 
  104cf1:	89 04 24             	mov    %eax,(%esp)
  104cf4:	e8 47 f9 ff ff       	call   104640 <page_remove>
    assert(page_ref(p1) == 1);
  104cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104cfc:	89 04 24             	mov    %eax,(%esp)
  104cff:	e8 fc ed ff ff       	call   103b00 <page_ref>
  104d04:	83 f8 01             	cmp    $0x1,%eax
  104d07:	74 24                	je     104d2d <check_pgdir+0x575>
  104d09:	c7 44 24 0c ae 6c 10 	movl   $0x106cae,0xc(%esp)
  104d10:	00 
  104d11:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104d18:	00 
  104d19:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104d20:	00 
  104d21:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104d28:	e8 97 bf ff ff       	call   100cc4 <__panic>
    assert(page_ref(p2) == 0);
  104d2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d30:	89 04 24             	mov    %eax,(%esp)
  104d33:	e8 c8 ed ff ff       	call   103b00 <page_ref>
  104d38:	85 c0                	test   %eax,%eax
  104d3a:	74 24                	je     104d60 <check_pgdir+0x5a8>
  104d3c:	c7 44 24 0c d2 6d 10 	movl   $0x106dd2,0xc(%esp)
  104d43:	00 
  104d44:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104d4b:	00 
  104d4c:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104d53:	00 
  104d54:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104d5b:	e8 64 bf ff ff       	call   100cc4 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104d60:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104d65:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104d6c:	00 
  104d6d:	89 04 24             	mov    %eax,(%esp)
  104d70:	e8 cb f8 ff ff       	call   104640 <page_remove>
    assert(page_ref(p1) == 0);
  104d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d78:	89 04 24             	mov    %eax,(%esp)
  104d7b:	e8 80 ed ff ff       	call   103b00 <page_ref>
  104d80:	85 c0                	test   %eax,%eax
  104d82:	74 24                	je     104da8 <check_pgdir+0x5f0>
  104d84:	c7 44 24 0c f9 6d 10 	movl   $0x106df9,0xc(%esp)
  104d8b:	00 
  104d8c:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104d93:	00 
  104d94:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  104d9b:	00 
  104d9c:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104da3:	e8 1c bf ff ff       	call   100cc4 <__panic>
    assert(page_ref(p2) == 0);
  104da8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104dab:	89 04 24             	mov    %eax,(%esp)
  104dae:	e8 4d ed ff ff       	call   103b00 <page_ref>
  104db3:	85 c0                	test   %eax,%eax
  104db5:	74 24                	je     104ddb <check_pgdir+0x623>
  104db7:	c7 44 24 0c d2 6d 10 	movl   $0x106dd2,0xc(%esp)
  104dbe:	00 
  104dbf:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104dc6:	00 
  104dc7:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  104dce:	00 
  104dcf:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104dd6:	e8 e9 be ff ff       	call   100cc4 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  104ddb:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104de0:	8b 00                	mov    (%eax),%eax
  104de2:	89 04 24             	mov    %eax,(%esp)
  104de5:	e8 35 ec ff ff       	call   103a1f <pa2page>
  104dea:	89 04 24             	mov    %eax,(%esp)
  104ded:	e8 0e ed ff ff       	call   103b00 <page_ref>
  104df2:	83 f8 01             	cmp    $0x1,%eax
  104df5:	74 24                	je     104e1b <check_pgdir+0x663>
  104df7:	c7 44 24 0c 0c 6e 10 	movl   $0x106e0c,0xc(%esp)
  104dfe:	00 
  104dff:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104e06:	00 
  104e07:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  104e0e:	00 
  104e0f:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104e16:	e8 a9 be ff ff       	call   100cc4 <__panic>
    free_page(pa2page(boot_pgdir[0]));
  104e1b:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104e20:	8b 00                	mov    (%eax),%eax
  104e22:	89 04 24             	mov    %eax,(%esp)
  104e25:	e8 f5 eb ff ff       	call   103a1f <pa2page>
  104e2a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104e31:	00 
  104e32:	89 04 24             	mov    %eax,(%esp)
  104e35:	e8 03 ef ff ff       	call   103d3d <free_pages>
    boot_pgdir[0] = 0;
  104e3a:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104e3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104e45:	c7 04 24 32 6e 10 00 	movl   $0x106e32,(%esp)
  104e4c:	e8 eb b4 ff ff       	call   10033c <cprintf>
}
  104e51:	c9                   	leave  
  104e52:	c3                   	ret    

00104e53 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104e53:	55                   	push   %ebp
  104e54:	89 e5                	mov    %esp,%ebp
  104e56:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104e59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104e60:	e9 ca 00 00 00       	jmp    104f2f <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104e6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e6e:	c1 e8 0c             	shr    $0xc,%eax
  104e71:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104e74:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  104e79:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104e7c:	72 23                	jb     104ea1 <check_boot_pgdir+0x4e>
  104e7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e81:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104e85:	c7 44 24 08 7c 6a 10 	movl   $0x106a7c,0x8(%esp)
  104e8c:	00 
  104e8d:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
  104e94:	00 
  104e95:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104e9c:	e8 23 be ff ff       	call   100cc4 <__panic>
  104ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ea4:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104ea9:	89 c2                	mov    %eax,%edx
  104eab:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104eb0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104eb7:	00 
  104eb8:	89 54 24 04          	mov    %edx,0x4(%esp)
  104ebc:	89 04 24             	mov    %eax,(%esp)
  104ebf:	e8 80 f5 ff ff       	call   104444 <get_pte>
  104ec4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104ec7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104ecb:	75 24                	jne    104ef1 <check_boot_pgdir+0x9e>
  104ecd:	c7 44 24 0c 4c 6e 10 	movl   $0x106e4c,0xc(%esp)
  104ed4:	00 
  104ed5:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104edc:	00 
  104edd:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
  104ee4:	00 
  104ee5:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104eec:	e8 d3 bd ff ff       	call   100cc4 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104ef1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104ef4:	8b 00                	mov    (%eax),%eax
  104ef6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104efb:	89 c2                	mov    %eax,%edx
  104efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f00:	39 c2                	cmp    %eax,%edx
  104f02:	74 24                	je     104f28 <check_boot_pgdir+0xd5>
  104f04:	c7 44 24 0c 89 6e 10 	movl   $0x106e89,0xc(%esp)
  104f0b:	00 
  104f0c:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104f13:	00 
  104f14:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
  104f1b:	00 
  104f1c:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104f23:	e8 9c bd ff ff       	call   100cc4 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104f28:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104f2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104f32:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  104f37:	39 c2                	cmp    %eax,%edx
  104f39:	0f 82 26 ff ff ff    	jb     104e65 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104f3f:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104f44:	05 ac 0f 00 00       	add    $0xfac,%eax
  104f49:	8b 00                	mov    (%eax),%eax
  104f4b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104f50:	89 c2                	mov    %eax,%edx
  104f52:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104f57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104f5a:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  104f61:	77 23                	ja     104f86 <check_boot_pgdir+0x133>
  104f63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f66:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104f6a:	c7 44 24 08 20 6b 10 	movl   $0x106b20,0x8(%esp)
  104f71:	00 
  104f72:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
  104f79:	00 
  104f7a:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104f81:	e8 3e bd ff ff       	call   100cc4 <__panic>
  104f86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f89:	05 00 00 00 40       	add    $0x40000000,%eax
  104f8e:	39 c2                	cmp    %eax,%edx
  104f90:	74 24                	je     104fb6 <check_boot_pgdir+0x163>
  104f92:	c7 44 24 0c a0 6e 10 	movl   $0x106ea0,0xc(%esp)
  104f99:	00 
  104f9a:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104fa1:	00 
  104fa2:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
  104fa9:	00 
  104faa:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104fb1:	e8 0e bd ff ff       	call   100cc4 <__panic>

    assert(boot_pgdir[0] == 0);
  104fb6:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104fbb:	8b 00                	mov    (%eax),%eax
  104fbd:	85 c0                	test   %eax,%eax
  104fbf:	74 24                	je     104fe5 <check_boot_pgdir+0x192>
  104fc1:	c7 44 24 0c d4 6e 10 	movl   $0x106ed4,0xc(%esp)
  104fc8:	00 
  104fc9:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104fd0:	00 
  104fd1:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
  104fd8:	00 
  104fd9:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104fe0:	e8 df bc ff ff       	call   100cc4 <__panic>

    struct Page *p;
    p = alloc_page();
  104fe5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104fec:	e8 14 ed ff ff       	call   103d05 <alloc_pages>
  104ff1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104ff4:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104ff9:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105000:	00 
  105001:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  105008:	00 
  105009:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10500c:	89 54 24 04          	mov    %edx,0x4(%esp)
  105010:	89 04 24             	mov    %eax,(%esp)
  105013:	e8 6c f6 ff ff       	call   104684 <page_insert>
  105018:	85 c0                	test   %eax,%eax
  10501a:	74 24                	je     105040 <check_boot_pgdir+0x1ed>
  10501c:	c7 44 24 0c e8 6e 10 	movl   $0x106ee8,0xc(%esp)
  105023:	00 
  105024:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  10502b:	00 
  10502c:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
  105033:	00 
  105034:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  10503b:	e8 84 bc ff ff       	call   100cc4 <__panic>
    assert(page_ref(p) == 1);
  105040:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105043:	89 04 24             	mov    %eax,(%esp)
  105046:	e8 b5 ea ff ff       	call   103b00 <page_ref>
  10504b:	83 f8 01             	cmp    $0x1,%eax
  10504e:	74 24                	je     105074 <check_boot_pgdir+0x221>
  105050:	c7 44 24 0c 16 6f 10 	movl   $0x106f16,0xc(%esp)
  105057:	00 
  105058:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  10505f:	00 
  105060:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  105067:	00 
  105068:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  10506f:	e8 50 bc ff ff       	call   100cc4 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  105074:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  105079:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105080:	00 
  105081:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  105088:	00 
  105089:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10508c:	89 54 24 04          	mov    %edx,0x4(%esp)
  105090:	89 04 24             	mov    %eax,(%esp)
  105093:	e8 ec f5 ff ff       	call   104684 <page_insert>
  105098:	85 c0                	test   %eax,%eax
  10509a:	74 24                	je     1050c0 <check_boot_pgdir+0x26d>
  10509c:	c7 44 24 0c 28 6f 10 	movl   $0x106f28,0xc(%esp)
  1050a3:	00 
  1050a4:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  1050ab:	00 
  1050ac:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
  1050b3:	00 
  1050b4:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  1050bb:	e8 04 bc ff ff       	call   100cc4 <__panic>
    assert(page_ref(p) == 2);
  1050c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1050c3:	89 04 24             	mov    %eax,(%esp)
  1050c6:	e8 35 ea ff ff       	call   103b00 <page_ref>
  1050cb:	83 f8 02             	cmp    $0x2,%eax
  1050ce:	74 24                	je     1050f4 <check_boot_pgdir+0x2a1>
  1050d0:	c7 44 24 0c 5f 6f 10 	movl   $0x106f5f,0xc(%esp)
  1050d7:	00 
  1050d8:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  1050df:	00 
  1050e0:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
  1050e7:	00 
  1050e8:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  1050ef:	e8 d0 bb ff ff       	call   100cc4 <__panic>

    const char *str = "ucore: Hello world!!";
  1050f4:	c7 45 dc 70 6f 10 00 	movl   $0x106f70,-0x24(%ebp)
    strcpy((void *)0x100, str);
  1050fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1050fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  105102:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105109:	e8 1e 0a 00 00       	call   105b2c <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  10510e:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  105115:	00 
  105116:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10511d:	e8 83 0a 00 00       	call   105ba5 <strcmp>
  105122:	85 c0                	test   %eax,%eax
  105124:	74 24                	je     10514a <check_boot_pgdir+0x2f7>
  105126:	c7 44 24 0c 88 6f 10 	movl   $0x106f88,0xc(%esp)
  10512d:	00 
  10512e:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  105135:	00 
  105136:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
  10513d:	00 
  10513e:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  105145:	e8 7a bb ff ff       	call   100cc4 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  10514a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10514d:	89 04 24             	mov    %eax,(%esp)
  105150:	e8 19 e9 ff ff       	call   103a6e <page2kva>
  105155:	05 00 01 00 00       	add    $0x100,%eax
  10515a:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  10515d:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105164:	e8 6b 09 00 00       	call   105ad4 <strlen>
  105169:	85 c0                	test   %eax,%eax
  10516b:	74 24                	je     105191 <check_boot_pgdir+0x33e>
  10516d:	c7 44 24 0c c0 6f 10 	movl   $0x106fc0,0xc(%esp)
  105174:	00 
  105175:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  10517c:	00 
  10517d:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
  105184:	00 
  105185:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  10518c:	e8 33 bb ff ff       	call   100cc4 <__panic>

    free_page(p);
  105191:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105198:	00 
  105199:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10519c:	89 04 24             	mov    %eax,(%esp)
  10519f:	e8 99 eb ff ff       	call   103d3d <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  1051a4:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1051a9:	8b 00                	mov    (%eax),%eax
  1051ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1051b0:	89 04 24             	mov    %eax,(%esp)
  1051b3:	e8 67 e8 ff ff       	call   103a1f <pa2page>
  1051b8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1051bf:	00 
  1051c0:	89 04 24             	mov    %eax,(%esp)
  1051c3:	e8 75 eb ff ff       	call   103d3d <free_pages>
    boot_pgdir[0] = 0;
  1051c8:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1051cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  1051d3:	c7 04 24 e4 6f 10 00 	movl   $0x106fe4,(%esp)
  1051da:	e8 5d b1 ff ff       	call   10033c <cprintf>
}
  1051df:	c9                   	leave  
  1051e0:	c3                   	ret    

001051e1 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  1051e1:	55                   	push   %ebp
  1051e2:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  1051e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1051e7:	83 e0 04             	and    $0x4,%eax
  1051ea:	85 c0                	test   %eax,%eax
  1051ec:	74 07                	je     1051f5 <perm2str+0x14>
  1051ee:	b8 75 00 00 00       	mov    $0x75,%eax
  1051f3:	eb 05                	jmp    1051fa <perm2str+0x19>
  1051f5:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1051fa:	a2 68 89 11 00       	mov    %al,0x118968
    str[1] = 'r';
  1051ff:	c6 05 69 89 11 00 72 	movb   $0x72,0x118969
    str[2] = (perm & PTE_W) ? 'w' : '-';
  105206:	8b 45 08             	mov    0x8(%ebp),%eax
  105209:	83 e0 02             	and    $0x2,%eax
  10520c:	85 c0                	test   %eax,%eax
  10520e:	74 07                	je     105217 <perm2str+0x36>
  105210:	b8 77 00 00 00       	mov    $0x77,%eax
  105215:	eb 05                	jmp    10521c <perm2str+0x3b>
  105217:	b8 2d 00 00 00       	mov    $0x2d,%eax
  10521c:	a2 6a 89 11 00       	mov    %al,0x11896a
    str[3] = '\0';
  105221:	c6 05 6b 89 11 00 00 	movb   $0x0,0x11896b
    return str;
  105228:	b8 68 89 11 00       	mov    $0x118968,%eax
}
  10522d:	5d                   	pop    %ebp
  10522e:	c3                   	ret    

0010522f <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  10522f:	55                   	push   %ebp
  105230:	89 e5                	mov    %esp,%ebp
  105232:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  105235:	8b 45 10             	mov    0x10(%ebp),%eax
  105238:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10523b:	72 0a                	jb     105247 <get_pgtable_items+0x18>
        return 0;
  10523d:	b8 00 00 00 00       	mov    $0x0,%eax
  105242:	e9 9c 00 00 00       	jmp    1052e3 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  105247:	eb 04                	jmp    10524d <get_pgtable_items+0x1e>
        start ++;
  105249:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  10524d:	8b 45 10             	mov    0x10(%ebp),%eax
  105250:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105253:	73 18                	jae    10526d <get_pgtable_items+0x3e>
  105255:	8b 45 10             	mov    0x10(%ebp),%eax
  105258:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10525f:	8b 45 14             	mov    0x14(%ebp),%eax
  105262:	01 d0                	add    %edx,%eax
  105264:	8b 00                	mov    (%eax),%eax
  105266:	83 e0 01             	and    $0x1,%eax
  105269:	85 c0                	test   %eax,%eax
  10526b:	74 dc                	je     105249 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  10526d:	8b 45 10             	mov    0x10(%ebp),%eax
  105270:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105273:	73 69                	jae    1052de <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  105275:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  105279:	74 08                	je     105283 <get_pgtable_items+0x54>
            *left_store = start;
  10527b:	8b 45 18             	mov    0x18(%ebp),%eax
  10527e:	8b 55 10             	mov    0x10(%ebp),%edx
  105281:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  105283:	8b 45 10             	mov    0x10(%ebp),%eax
  105286:	8d 50 01             	lea    0x1(%eax),%edx
  105289:	89 55 10             	mov    %edx,0x10(%ebp)
  10528c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105293:	8b 45 14             	mov    0x14(%ebp),%eax
  105296:	01 d0                	add    %edx,%eax
  105298:	8b 00                	mov    (%eax),%eax
  10529a:	83 e0 07             	and    $0x7,%eax
  10529d:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1052a0:	eb 04                	jmp    1052a6 <get_pgtable_items+0x77>
            start ++;
  1052a2:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  1052a6:	8b 45 10             	mov    0x10(%ebp),%eax
  1052a9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1052ac:	73 1d                	jae    1052cb <get_pgtable_items+0x9c>
  1052ae:	8b 45 10             	mov    0x10(%ebp),%eax
  1052b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1052b8:	8b 45 14             	mov    0x14(%ebp),%eax
  1052bb:	01 d0                	add    %edx,%eax
  1052bd:	8b 00                	mov    (%eax),%eax
  1052bf:	83 e0 07             	and    $0x7,%eax
  1052c2:	89 c2                	mov    %eax,%edx
  1052c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1052c7:	39 c2                	cmp    %eax,%edx
  1052c9:	74 d7                	je     1052a2 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  1052cb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1052cf:	74 08                	je     1052d9 <get_pgtable_items+0xaa>
            *right_store = start;
  1052d1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1052d4:	8b 55 10             	mov    0x10(%ebp),%edx
  1052d7:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1052d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1052dc:	eb 05                	jmp    1052e3 <get_pgtable_items+0xb4>
    }
    return 0;
  1052de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1052e3:	c9                   	leave  
  1052e4:	c3                   	ret    

001052e5 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1052e5:	55                   	push   %ebp
  1052e6:	89 e5                	mov    %esp,%ebp
  1052e8:	57                   	push   %edi
  1052e9:	56                   	push   %esi
  1052ea:	53                   	push   %ebx
  1052eb:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1052ee:	c7 04 24 04 70 10 00 	movl   $0x107004,(%esp)
  1052f5:	e8 42 b0 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
  1052fa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105301:	e9 fa 00 00 00       	jmp    105400 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105306:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105309:	89 04 24             	mov    %eax,(%esp)
  10530c:	e8 d0 fe ff ff       	call   1051e1 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  105311:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105314:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105317:	29 d1                	sub    %edx,%ecx
  105319:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10531b:	89 d6                	mov    %edx,%esi
  10531d:	c1 e6 16             	shl    $0x16,%esi
  105320:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105323:	89 d3                	mov    %edx,%ebx
  105325:	c1 e3 16             	shl    $0x16,%ebx
  105328:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10532b:	89 d1                	mov    %edx,%ecx
  10532d:	c1 e1 16             	shl    $0x16,%ecx
  105330:	8b 7d dc             	mov    -0x24(%ebp),%edi
  105333:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105336:	29 d7                	sub    %edx,%edi
  105338:	89 fa                	mov    %edi,%edx
  10533a:	89 44 24 14          	mov    %eax,0x14(%esp)
  10533e:	89 74 24 10          	mov    %esi,0x10(%esp)
  105342:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105346:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10534a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10534e:	c7 04 24 35 70 10 00 	movl   $0x107035,(%esp)
  105355:	e8 e2 af ff ff       	call   10033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  10535a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10535d:	c1 e0 0a             	shl    $0xa,%eax
  105360:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105363:	eb 54                	jmp    1053b9 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105365:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105368:	89 04 24             	mov    %eax,(%esp)
  10536b:	e8 71 fe ff ff       	call   1051e1 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  105370:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  105373:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105376:	29 d1                	sub    %edx,%ecx
  105378:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10537a:	89 d6                	mov    %edx,%esi
  10537c:	c1 e6 0c             	shl    $0xc,%esi
  10537f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105382:	89 d3                	mov    %edx,%ebx
  105384:	c1 e3 0c             	shl    $0xc,%ebx
  105387:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10538a:	c1 e2 0c             	shl    $0xc,%edx
  10538d:	89 d1                	mov    %edx,%ecx
  10538f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  105392:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105395:	29 d7                	sub    %edx,%edi
  105397:	89 fa                	mov    %edi,%edx
  105399:	89 44 24 14          	mov    %eax,0x14(%esp)
  10539d:	89 74 24 10          	mov    %esi,0x10(%esp)
  1053a1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1053a5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1053a9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1053ad:	c7 04 24 54 70 10 00 	movl   $0x107054,(%esp)
  1053b4:	e8 83 af ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1053b9:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  1053be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1053c1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1053c4:	89 ce                	mov    %ecx,%esi
  1053c6:	c1 e6 0a             	shl    $0xa,%esi
  1053c9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1053cc:	89 cb                	mov    %ecx,%ebx
  1053ce:	c1 e3 0a             	shl    $0xa,%ebx
  1053d1:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  1053d4:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1053d8:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  1053db:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1053df:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1053e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1053e7:	89 74 24 04          	mov    %esi,0x4(%esp)
  1053eb:	89 1c 24             	mov    %ebx,(%esp)
  1053ee:	e8 3c fe ff ff       	call   10522f <get_pgtable_items>
  1053f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1053f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1053fa:	0f 85 65 ff ff ff    	jne    105365 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105400:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  105405:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105408:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  10540b:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  10540f:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  105412:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  105416:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10541a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10541e:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  105425:	00 
  105426:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10542d:	e8 fd fd ff ff       	call   10522f <get_pgtable_items>
  105432:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105435:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105439:	0f 85 c7 fe ff ff    	jne    105306 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  10543f:	c7 04 24 78 70 10 00 	movl   $0x107078,(%esp)
  105446:	e8 f1 ae ff ff       	call   10033c <cprintf>
}
  10544b:	83 c4 4c             	add    $0x4c,%esp
  10544e:	5b                   	pop    %ebx
  10544f:	5e                   	pop    %esi
  105450:	5f                   	pop    %edi
  105451:	5d                   	pop    %ebp
  105452:	c3                   	ret    

00105453 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105453:	55                   	push   %ebp
  105454:	89 e5                	mov    %esp,%ebp
  105456:	83 ec 58             	sub    $0x58,%esp
  105459:	8b 45 10             	mov    0x10(%ebp),%eax
  10545c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10545f:	8b 45 14             	mov    0x14(%ebp),%eax
  105462:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105465:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105468:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10546b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10546e:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105471:	8b 45 18             	mov    0x18(%ebp),%eax
  105474:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105477:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10547a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10547d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105480:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105483:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105486:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105489:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10548d:	74 1c                	je     1054ab <printnum+0x58>
  10548f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105492:	ba 00 00 00 00       	mov    $0x0,%edx
  105497:	f7 75 e4             	divl   -0x1c(%ebp)
  10549a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10549d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054a0:	ba 00 00 00 00       	mov    $0x0,%edx
  1054a5:	f7 75 e4             	divl   -0x1c(%ebp)
  1054a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1054ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1054b1:	f7 75 e4             	divl   -0x1c(%ebp)
  1054b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1054b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1054ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1054c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1054c3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1054c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1054c9:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1054cc:	8b 45 18             	mov    0x18(%ebp),%eax
  1054cf:	ba 00 00 00 00       	mov    $0x0,%edx
  1054d4:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1054d7:	77 56                	ja     10552f <printnum+0xdc>
  1054d9:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1054dc:	72 05                	jb     1054e3 <printnum+0x90>
  1054de:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1054e1:	77 4c                	ja     10552f <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1054e3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1054e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  1054e9:	8b 45 20             	mov    0x20(%ebp),%eax
  1054ec:	89 44 24 18          	mov    %eax,0x18(%esp)
  1054f0:	89 54 24 14          	mov    %edx,0x14(%esp)
  1054f4:	8b 45 18             	mov    0x18(%ebp),%eax
  1054f7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1054fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1054fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105501:	89 44 24 08          	mov    %eax,0x8(%esp)
  105505:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105509:	8b 45 0c             	mov    0xc(%ebp),%eax
  10550c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105510:	8b 45 08             	mov    0x8(%ebp),%eax
  105513:	89 04 24             	mov    %eax,(%esp)
  105516:	e8 38 ff ff ff       	call   105453 <printnum>
  10551b:	eb 1c                	jmp    105539 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  10551d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105520:	89 44 24 04          	mov    %eax,0x4(%esp)
  105524:	8b 45 20             	mov    0x20(%ebp),%eax
  105527:	89 04 24             	mov    %eax,(%esp)
  10552a:	8b 45 08             	mov    0x8(%ebp),%eax
  10552d:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  10552f:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  105533:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105537:	7f e4                	jg     10551d <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105539:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10553c:	05 2c 71 10 00       	add    $0x10712c,%eax
  105541:	0f b6 00             	movzbl (%eax),%eax
  105544:	0f be c0             	movsbl %al,%eax
  105547:	8b 55 0c             	mov    0xc(%ebp),%edx
  10554a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10554e:	89 04 24             	mov    %eax,(%esp)
  105551:	8b 45 08             	mov    0x8(%ebp),%eax
  105554:	ff d0                	call   *%eax
}
  105556:	c9                   	leave  
  105557:	c3                   	ret    

00105558 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105558:	55                   	push   %ebp
  105559:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10555b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10555f:	7e 14                	jle    105575 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105561:	8b 45 08             	mov    0x8(%ebp),%eax
  105564:	8b 00                	mov    (%eax),%eax
  105566:	8d 48 08             	lea    0x8(%eax),%ecx
  105569:	8b 55 08             	mov    0x8(%ebp),%edx
  10556c:	89 0a                	mov    %ecx,(%edx)
  10556e:	8b 50 04             	mov    0x4(%eax),%edx
  105571:	8b 00                	mov    (%eax),%eax
  105573:	eb 30                	jmp    1055a5 <getuint+0x4d>
    }
    else if (lflag) {
  105575:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105579:	74 16                	je     105591 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  10557b:	8b 45 08             	mov    0x8(%ebp),%eax
  10557e:	8b 00                	mov    (%eax),%eax
  105580:	8d 48 04             	lea    0x4(%eax),%ecx
  105583:	8b 55 08             	mov    0x8(%ebp),%edx
  105586:	89 0a                	mov    %ecx,(%edx)
  105588:	8b 00                	mov    (%eax),%eax
  10558a:	ba 00 00 00 00       	mov    $0x0,%edx
  10558f:	eb 14                	jmp    1055a5 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105591:	8b 45 08             	mov    0x8(%ebp),%eax
  105594:	8b 00                	mov    (%eax),%eax
  105596:	8d 48 04             	lea    0x4(%eax),%ecx
  105599:	8b 55 08             	mov    0x8(%ebp),%edx
  10559c:	89 0a                	mov    %ecx,(%edx)
  10559e:	8b 00                	mov    (%eax),%eax
  1055a0:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1055a5:	5d                   	pop    %ebp
  1055a6:	c3                   	ret    

001055a7 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1055a7:	55                   	push   %ebp
  1055a8:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1055aa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1055ae:	7e 14                	jle    1055c4 <getint+0x1d>
        return va_arg(*ap, long long);
  1055b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1055b3:	8b 00                	mov    (%eax),%eax
  1055b5:	8d 48 08             	lea    0x8(%eax),%ecx
  1055b8:	8b 55 08             	mov    0x8(%ebp),%edx
  1055bb:	89 0a                	mov    %ecx,(%edx)
  1055bd:	8b 50 04             	mov    0x4(%eax),%edx
  1055c0:	8b 00                	mov    (%eax),%eax
  1055c2:	eb 28                	jmp    1055ec <getint+0x45>
    }
    else if (lflag) {
  1055c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1055c8:	74 12                	je     1055dc <getint+0x35>
        return va_arg(*ap, long);
  1055ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1055cd:	8b 00                	mov    (%eax),%eax
  1055cf:	8d 48 04             	lea    0x4(%eax),%ecx
  1055d2:	8b 55 08             	mov    0x8(%ebp),%edx
  1055d5:	89 0a                	mov    %ecx,(%edx)
  1055d7:	8b 00                	mov    (%eax),%eax
  1055d9:	99                   	cltd   
  1055da:	eb 10                	jmp    1055ec <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1055dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1055df:	8b 00                	mov    (%eax),%eax
  1055e1:	8d 48 04             	lea    0x4(%eax),%ecx
  1055e4:	8b 55 08             	mov    0x8(%ebp),%edx
  1055e7:	89 0a                	mov    %ecx,(%edx)
  1055e9:	8b 00                	mov    (%eax),%eax
  1055eb:	99                   	cltd   
    }
}
  1055ec:	5d                   	pop    %ebp
  1055ed:	c3                   	ret    

001055ee <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1055ee:	55                   	push   %ebp
  1055ef:	89 e5                	mov    %esp,%ebp
  1055f1:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1055f4:	8d 45 14             	lea    0x14(%ebp),%eax
  1055f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1055fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1055fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105601:	8b 45 10             	mov    0x10(%ebp),%eax
  105604:	89 44 24 08          	mov    %eax,0x8(%esp)
  105608:	8b 45 0c             	mov    0xc(%ebp),%eax
  10560b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10560f:	8b 45 08             	mov    0x8(%ebp),%eax
  105612:	89 04 24             	mov    %eax,(%esp)
  105615:	e8 02 00 00 00       	call   10561c <vprintfmt>
    va_end(ap);
}
  10561a:	c9                   	leave  
  10561b:	c3                   	ret    

0010561c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10561c:	55                   	push   %ebp
  10561d:	89 e5                	mov    %esp,%ebp
  10561f:	56                   	push   %esi
  105620:	53                   	push   %ebx
  105621:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105624:	eb 18                	jmp    10563e <vprintfmt+0x22>
            if (ch == '\0') {
  105626:	85 db                	test   %ebx,%ebx
  105628:	75 05                	jne    10562f <vprintfmt+0x13>
                return;
  10562a:	e9 d1 03 00 00       	jmp    105a00 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  10562f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105632:	89 44 24 04          	mov    %eax,0x4(%esp)
  105636:	89 1c 24             	mov    %ebx,(%esp)
  105639:	8b 45 08             	mov    0x8(%ebp),%eax
  10563c:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10563e:	8b 45 10             	mov    0x10(%ebp),%eax
  105641:	8d 50 01             	lea    0x1(%eax),%edx
  105644:	89 55 10             	mov    %edx,0x10(%ebp)
  105647:	0f b6 00             	movzbl (%eax),%eax
  10564a:	0f b6 d8             	movzbl %al,%ebx
  10564d:	83 fb 25             	cmp    $0x25,%ebx
  105650:	75 d4                	jne    105626 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  105652:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105656:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10565d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105660:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105663:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10566a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10566d:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105670:	8b 45 10             	mov    0x10(%ebp),%eax
  105673:	8d 50 01             	lea    0x1(%eax),%edx
  105676:	89 55 10             	mov    %edx,0x10(%ebp)
  105679:	0f b6 00             	movzbl (%eax),%eax
  10567c:	0f b6 d8             	movzbl %al,%ebx
  10567f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105682:	83 f8 55             	cmp    $0x55,%eax
  105685:	0f 87 44 03 00 00    	ja     1059cf <vprintfmt+0x3b3>
  10568b:	8b 04 85 50 71 10 00 	mov    0x107150(,%eax,4),%eax
  105692:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105694:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105698:	eb d6                	jmp    105670 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10569a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10569e:	eb d0                	jmp    105670 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1056a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1056a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1056aa:	89 d0                	mov    %edx,%eax
  1056ac:	c1 e0 02             	shl    $0x2,%eax
  1056af:	01 d0                	add    %edx,%eax
  1056b1:	01 c0                	add    %eax,%eax
  1056b3:	01 d8                	add    %ebx,%eax
  1056b5:	83 e8 30             	sub    $0x30,%eax
  1056b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1056bb:	8b 45 10             	mov    0x10(%ebp),%eax
  1056be:	0f b6 00             	movzbl (%eax),%eax
  1056c1:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1056c4:	83 fb 2f             	cmp    $0x2f,%ebx
  1056c7:	7e 0b                	jle    1056d4 <vprintfmt+0xb8>
  1056c9:	83 fb 39             	cmp    $0x39,%ebx
  1056cc:	7f 06                	jg     1056d4 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1056ce:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  1056d2:	eb d3                	jmp    1056a7 <vprintfmt+0x8b>
            goto process_precision;
  1056d4:	eb 33                	jmp    105709 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  1056d6:	8b 45 14             	mov    0x14(%ebp),%eax
  1056d9:	8d 50 04             	lea    0x4(%eax),%edx
  1056dc:	89 55 14             	mov    %edx,0x14(%ebp)
  1056df:	8b 00                	mov    (%eax),%eax
  1056e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1056e4:	eb 23                	jmp    105709 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  1056e6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056ea:	79 0c                	jns    1056f8 <vprintfmt+0xdc>
                width = 0;
  1056ec:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1056f3:	e9 78 ff ff ff       	jmp    105670 <vprintfmt+0x54>
  1056f8:	e9 73 ff ff ff       	jmp    105670 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  1056fd:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105704:	e9 67 ff ff ff       	jmp    105670 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  105709:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10570d:	79 12                	jns    105721 <vprintfmt+0x105>
                width = precision, precision = -1;
  10570f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105712:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105715:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10571c:	e9 4f ff ff ff       	jmp    105670 <vprintfmt+0x54>
  105721:	e9 4a ff ff ff       	jmp    105670 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105726:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  10572a:	e9 41 ff ff ff       	jmp    105670 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10572f:	8b 45 14             	mov    0x14(%ebp),%eax
  105732:	8d 50 04             	lea    0x4(%eax),%edx
  105735:	89 55 14             	mov    %edx,0x14(%ebp)
  105738:	8b 00                	mov    (%eax),%eax
  10573a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10573d:	89 54 24 04          	mov    %edx,0x4(%esp)
  105741:	89 04 24             	mov    %eax,(%esp)
  105744:	8b 45 08             	mov    0x8(%ebp),%eax
  105747:	ff d0                	call   *%eax
            break;
  105749:	e9 ac 02 00 00       	jmp    1059fa <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  10574e:	8b 45 14             	mov    0x14(%ebp),%eax
  105751:	8d 50 04             	lea    0x4(%eax),%edx
  105754:	89 55 14             	mov    %edx,0x14(%ebp)
  105757:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105759:	85 db                	test   %ebx,%ebx
  10575b:	79 02                	jns    10575f <vprintfmt+0x143>
                err = -err;
  10575d:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10575f:	83 fb 06             	cmp    $0x6,%ebx
  105762:	7f 0b                	jg     10576f <vprintfmt+0x153>
  105764:	8b 34 9d 10 71 10 00 	mov    0x107110(,%ebx,4),%esi
  10576b:	85 f6                	test   %esi,%esi
  10576d:	75 23                	jne    105792 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  10576f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105773:	c7 44 24 08 3d 71 10 	movl   $0x10713d,0x8(%esp)
  10577a:	00 
  10577b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10577e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105782:	8b 45 08             	mov    0x8(%ebp),%eax
  105785:	89 04 24             	mov    %eax,(%esp)
  105788:	e8 61 fe ff ff       	call   1055ee <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10578d:	e9 68 02 00 00       	jmp    1059fa <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  105792:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105796:	c7 44 24 08 46 71 10 	movl   $0x107146,0x8(%esp)
  10579d:	00 
  10579e:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1057a8:	89 04 24             	mov    %eax,(%esp)
  1057ab:	e8 3e fe ff ff       	call   1055ee <printfmt>
            }
            break;
  1057b0:	e9 45 02 00 00       	jmp    1059fa <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1057b5:	8b 45 14             	mov    0x14(%ebp),%eax
  1057b8:	8d 50 04             	lea    0x4(%eax),%edx
  1057bb:	89 55 14             	mov    %edx,0x14(%ebp)
  1057be:	8b 30                	mov    (%eax),%esi
  1057c0:	85 f6                	test   %esi,%esi
  1057c2:	75 05                	jne    1057c9 <vprintfmt+0x1ad>
                p = "(null)";
  1057c4:	be 49 71 10 00       	mov    $0x107149,%esi
            }
            if (width > 0 && padc != '-') {
  1057c9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057cd:	7e 3e                	jle    10580d <vprintfmt+0x1f1>
  1057cf:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1057d3:	74 38                	je     10580d <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1057d5:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  1057d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1057db:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057df:	89 34 24             	mov    %esi,(%esp)
  1057e2:	e8 15 03 00 00       	call   105afc <strnlen>
  1057e7:	29 c3                	sub    %eax,%ebx
  1057e9:	89 d8                	mov    %ebx,%eax
  1057eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1057ee:	eb 17                	jmp    105807 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  1057f0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1057f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1057f7:	89 54 24 04          	mov    %edx,0x4(%esp)
  1057fb:	89 04 24             	mov    %eax,(%esp)
  1057fe:	8b 45 08             	mov    0x8(%ebp),%eax
  105801:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  105803:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105807:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10580b:	7f e3                	jg     1057f0 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10580d:	eb 38                	jmp    105847 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  10580f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105813:	74 1f                	je     105834 <vprintfmt+0x218>
  105815:	83 fb 1f             	cmp    $0x1f,%ebx
  105818:	7e 05                	jle    10581f <vprintfmt+0x203>
  10581a:	83 fb 7e             	cmp    $0x7e,%ebx
  10581d:	7e 15                	jle    105834 <vprintfmt+0x218>
                    putch('?', putdat);
  10581f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105822:	89 44 24 04          	mov    %eax,0x4(%esp)
  105826:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  10582d:	8b 45 08             	mov    0x8(%ebp),%eax
  105830:	ff d0                	call   *%eax
  105832:	eb 0f                	jmp    105843 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  105834:	8b 45 0c             	mov    0xc(%ebp),%eax
  105837:	89 44 24 04          	mov    %eax,0x4(%esp)
  10583b:	89 1c 24             	mov    %ebx,(%esp)
  10583e:	8b 45 08             	mov    0x8(%ebp),%eax
  105841:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105843:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105847:	89 f0                	mov    %esi,%eax
  105849:	8d 70 01             	lea    0x1(%eax),%esi
  10584c:	0f b6 00             	movzbl (%eax),%eax
  10584f:	0f be d8             	movsbl %al,%ebx
  105852:	85 db                	test   %ebx,%ebx
  105854:	74 10                	je     105866 <vprintfmt+0x24a>
  105856:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10585a:	78 b3                	js     10580f <vprintfmt+0x1f3>
  10585c:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105860:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105864:	79 a9                	jns    10580f <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105866:	eb 17                	jmp    10587f <vprintfmt+0x263>
                putch(' ', putdat);
  105868:	8b 45 0c             	mov    0xc(%ebp),%eax
  10586b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10586f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105876:	8b 45 08             	mov    0x8(%ebp),%eax
  105879:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  10587b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10587f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105883:	7f e3                	jg     105868 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  105885:	e9 70 01 00 00       	jmp    1059fa <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10588a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10588d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105891:	8d 45 14             	lea    0x14(%ebp),%eax
  105894:	89 04 24             	mov    %eax,(%esp)
  105897:	e8 0b fd ff ff       	call   1055a7 <getint>
  10589c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10589f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1058a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1058a8:	85 d2                	test   %edx,%edx
  1058aa:	79 26                	jns    1058d2 <vprintfmt+0x2b6>
                putch('-', putdat);
  1058ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058b3:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1058ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1058bd:	ff d0                	call   *%eax
                num = -(long long)num;
  1058bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1058c5:	f7 d8                	neg    %eax
  1058c7:	83 d2 00             	adc    $0x0,%edx
  1058ca:	f7 da                	neg    %edx
  1058cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1058d2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1058d9:	e9 a8 00 00 00       	jmp    105986 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1058de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058e5:	8d 45 14             	lea    0x14(%ebp),%eax
  1058e8:	89 04 24             	mov    %eax,(%esp)
  1058eb:	e8 68 fc ff ff       	call   105558 <getuint>
  1058f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1058f6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1058fd:	e9 84 00 00 00       	jmp    105986 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105902:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105905:	89 44 24 04          	mov    %eax,0x4(%esp)
  105909:	8d 45 14             	lea    0x14(%ebp),%eax
  10590c:	89 04 24             	mov    %eax,(%esp)
  10590f:	e8 44 fc ff ff       	call   105558 <getuint>
  105914:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105917:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  10591a:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105921:	eb 63                	jmp    105986 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  105923:	8b 45 0c             	mov    0xc(%ebp),%eax
  105926:	89 44 24 04          	mov    %eax,0x4(%esp)
  10592a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105931:	8b 45 08             	mov    0x8(%ebp),%eax
  105934:	ff d0                	call   *%eax
            putch('x', putdat);
  105936:	8b 45 0c             	mov    0xc(%ebp),%eax
  105939:	89 44 24 04          	mov    %eax,0x4(%esp)
  10593d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105944:	8b 45 08             	mov    0x8(%ebp),%eax
  105947:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105949:	8b 45 14             	mov    0x14(%ebp),%eax
  10594c:	8d 50 04             	lea    0x4(%eax),%edx
  10594f:	89 55 14             	mov    %edx,0x14(%ebp)
  105952:	8b 00                	mov    (%eax),%eax
  105954:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105957:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10595e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105965:	eb 1f                	jmp    105986 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105967:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10596a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10596e:	8d 45 14             	lea    0x14(%ebp),%eax
  105971:	89 04 24             	mov    %eax,(%esp)
  105974:	e8 df fb ff ff       	call   105558 <getuint>
  105979:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10597c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  10597f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105986:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10598a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10598d:	89 54 24 18          	mov    %edx,0x18(%esp)
  105991:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105994:	89 54 24 14          	mov    %edx,0x14(%esp)
  105998:	89 44 24 10          	mov    %eax,0x10(%esp)
  10599c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10599f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1059a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1059a6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1059aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1059b4:	89 04 24             	mov    %eax,(%esp)
  1059b7:	e8 97 fa ff ff       	call   105453 <printnum>
            break;
  1059bc:	eb 3c                	jmp    1059fa <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1059be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059c5:	89 1c 24             	mov    %ebx,(%esp)
  1059c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1059cb:	ff d0                	call   *%eax
            break;
  1059cd:	eb 2b                	jmp    1059fa <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1059cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059d6:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1059dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1059e0:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1059e2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1059e6:	eb 04                	jmp    1059ec <vprintfmt+0x3d0>
  1059e8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1059ec:	8b 45 10             	mov    0x10(%ebp),%eax
  1059ef:	83 e8 01             	sub    $0x1,%eax
  1059f2:	0f b6 00             	movzbl (%eax),%eax
  1059f5:	3c 25                	cmp    $0x25,%al
  1059f7:	75 ef                	jne    1059e8 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  1059f9:	90                   	nop
        }
    }
  1059fa:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1059fb:	e9 3e fc ff ff       	jmp    10563e <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105a00:	83 c4 40             	add    $0x40,%esp
  105a03:	5b                   	pop    %ebx
  105a04:	5e                   	pop    %esi
  105a05:	5d                   	pop    %ebp
  105a06:	c3                   	ret    

00105a07 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105a07:	55                   	push   %ebp
  105a08:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105a0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a0d:	8b 40 08             	mov    0x8(%eax),%eax
  105a10:	8d 50 01             	lea    0x1(%eax),%edx
  105a13:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a16:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105a19:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a1c:	8b 10                	mov    (%eax),%edx
  105a1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a21:	8b 40 04             	mov    0x4(%eax),%eax
  105a24:	39 c2                	cmp    %eax,%edx
  105a26:	73 12                	jae    105a3a <sprintputch+0x33>
        *b->buf ++ = ch;
  105a28:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a2b:	8b 00                	mov    (%eax),%eax
  105a2d:	8d 48 01             	lea    0x1(%eax),%ecx
  105a30:	8b 55 0c             	mov    0xc(%ebp),%edx
  105a33:	89 0a                	mov    %ecx,(%edx)
  105a35:	8b 55 08             	mov    0x8(%ebp),%edx
  105a38:	88 10                	mov    %dl,(%eax)
    }
}
  105a3a:	5d                   	pop    %ebp
  105a3b:	c3                   	ret    

00105a3c <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105a3c:	55                   	push   %ebp
  105a3d:	89 e5                	mov    %esp,%ebp
  105a3f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105a42:	8d 45 14             	lea    0x14(%ebp),%eax
  105a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a4b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105a4f:	8b 45 10             	mov    0x10(%ebp),%eax
  105a52:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a56:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a59:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  105a60:	89 04 24             	mov    %eax,(%esp)
  105a63:	e8 08 00 00 00       	call   105a70 <vsnprintf>
  105a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105a6e:	c9                   	leave  
  105a6f:	c3                   	ret    

00105a70 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105a70:	55                   	push   %ebp
  105a71:	89 e5                	mov    %esp,%ebp
  105a73:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105a76:	8b 45 08             	mov    0x8(%ebp),%eax
  105a79:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  105a82:	8b 45 08             	mov    0x8(%ebp),%eax
  105a85:	01 d0                	add    %edx,%eax
  105a87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105a91:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105a95:	74 0a                	je     105aa1 <vsnprintf+0x31>
  105a97:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a9d:	39 c2                	cmp    %eax,%edx
  105a9f:	76 07                	jbe    105aa8 <vsnprintf+0x38>
        return -E_INVAL;
  105aa1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105aa6:	eb 2a                	jmp    105ad2 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105aa8:	8b 45 14             	mov    0x14(%ebp),%eax
  105aab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105aaf:	8b 45 10             	mov    0x10(%ebp),%eax
  105ab2:	89 44 24 08          	mov    %eax,0x8(%esp)
  105ab6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105ab9:	89 44 24 04          	mov    %eax,0x4(%esp)
  105abd:	c7 04 24 07 5a 10 00 	movl   $0x105a07,(%esp)
  105ac4:	e8 53 fb ff ff       	call   10561c <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105ac9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105acc:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105ad2:	c9                   	leave  
  105ad3:	c3                   	ret    

00105ad4 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105ad4:	55                   	push   %ebp
  105ad5:	89 e5                	mov    %esp,%ebp
  105ad7:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105ada:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105ae1:	eb 04                	jmp    105ae7 <strlen+0x13>
        cnt ++;
  105ae3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  105aea:	8d 50 01             	lea    0x1(%eax),%edx
  105aed:	89 55 08             	mov    %edx,0x8(%ebp)
  105af0:	0f b6 00             	movzbl (%eax),%eax
  105af3:	84 c0                	test   %al,%al
  105af5:	75 ec                	jne    105ae3 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105af7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105afa:	c9                   	leave  
  105afb:	c3                   	ret    

00105afc <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105afc:	55                   	push   %ebp
  105afd:	89 e5                	mov    %esp,%ebp
  105aff:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105b02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105b09:	eb 04                	jmp    105b0f <strnlen+0x13>
        cnt ++;
  105b0b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105b0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b12:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105b15:	73 10                	jae    105b27 <strnlen+0x2b>
  105b17:	8b 45 08             	mov    0x8(%ebp),%eax
  105b1a:	8d 50 01             	lea    0x1(%eax),%edx
  105b1d:	89 55 08             	mov    %edx,0x8(%ebp)
  105b20:	0f b6 00             	movzbl (%eax),%eax
  105b23:	84 c0                	test   %al,%al
  105b25:	75 e4                	jne    105b0b <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105b27:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105b2a:	c9                   	leave  
  105b2b:	c3                   	ret    

00105b2c <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105b2c:	55                   	push   %ebp
  105b2d:	89 e5                	mov    %esp,%ebp
  105b2f:	57                   	push   %edi
  105b30:	56                   	push   %esi
  105b31:	83 ec 20             	sub    $0x20,%esp
  105b34:	8b 45 08             	mov    0x8(%ebp),%eax
  105b37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105b40:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b46:	89 d1                	mov    %edx,%ecx
  105b48:	89 c2                	mov    %eax,%edx
  105b4a:	89 ce                	mov    %ecx,%esi
  105b4c:	89 d7                	mov    %edx,%edi
  105b4e:	ac                   	lods   %ds:(%esi),%al
  105b4f:	aa                   	stos   %al,%es:(%edi)
  105b50:	84 c0                	test   %al,%al
  105b52:	75 fa                	jne    105b4e <strcpy+0x22>
  105b54:	89 fa                	mov    %edi,%edx
  105b56:	89 f1                	mov    %esi,%ecx
  105b58:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105b5b:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105b5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105b64:	83 c4 20             	add    $0x20,%esp
  105b67:	5e                   	pop    %esi
  105b68:	5f                   	pop    %edi
  105b69:	5d                   	pop    %ebp
  105b6a:	c3                   	ret    

00105b6b <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105b6b:	55                   	push   %ebp
  105b6c:	89 e5                	mov    %esp,%ebp
  105b6e:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105b71:	8b 45 08             	mov    0x8(%ebp),%eax
  105b74:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105b77:	eb 21                	jmp    105b9a <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b7c:	0f b6 10             	movzbl (%eax),%edx
  105b7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b82:	88 10                	mov    %dl,(%eax)
  105b84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b87:	0f b6 00             	movzbl (%eax),%eax
  105b8a:	84 c0                	test   %al,%al
  105b8c:	74 04                	je     105b92 <strncpy+0x27>
            src ++;
  105b8e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105b92:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105b96:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105b9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b9e:	75 d9                	jne    105b79 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105ba0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105ba3:	c9                   	leave  
  105ba4:	c3                   	ret    

00105ba5 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105ba5:	55                   	push   %ebp
  105ba6:	89 e5                	mov    %esp,%ebp
  105ba8:	57                   	push   %edi
  105ba9:	56                   	push   %esi
  105baa:	83 ec 20             	sub    $0x20,%esp
  105bad:	8b 45 08             	mov    0x8(%ebp),%eax
  105bb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105bb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105bbf:	89 d1                	mov    %edx,%ecx
  105bc1:	89 c2                	mov    %eax,%edx
  105bc3:	89 ce                	mov    %ecx,%esi
  105bc5:	89 d7                	mov    %edx,%edi
  105bc7:	ac                   	lods   %ds:(%esi),%al
  105bc8:	ae                   	scas   %es:(%edi),%al
  105bc9:	75 08                	jne    105bd3 <strcmp+0x2e>
  105bcb:	84 c0                	test   %al,%al
  105bcd:	75 f8                	jne    105bc7 <strcmp+0x22>
  105bcf:	31 c0                	xor    %eax,%eax
  105bd1:	eb 04                	jmp    105bd7 <strcmp+0x32>
  105bd3:	19 c0                	sbb    %eax,%eax
  105bd5:	0c 01                	or     $0x1,%al
  105bd7:	89 fa                	mov    %edi,%edx
  105bd9:	89 f1                	mov    %esi,%ecx
  105bdb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105bde:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105be1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105be4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105be7:	83 c4 20             	add    $0x20,%esp
  105bea:	5e                   	pop    %esi
  105beb:	5f                   	pop    %edi
  105bec:	5d                   	pop    %ebp
  105bed:	c3                   	ret    

00105bee <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105bee:	55                   	push   %ebp
  105bef:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105bf1:	eb 0c                	jmp    105bff <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105bf3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105bf7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105bfb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105bff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c03:	74 1a                	je     105c1f <strncmp+0x31>
  105c05:	8b 45 08             	mov    0x8(%ebp),%eax
  105c08:	0f b6 00             	movzbl (%eax),%eax
  105c0b:	84 c0                	test   %al,%al
  105c0d:	74 10                	je     105c1f <strncmp+0x31>
  105c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  105c12:	0f b6 10             	movzbl (%eax),%edx
  105c15:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c18:	0f b6 00             	movzbl (%eax),%eax
  105c1b:	38 c2                	cmp    %al,%dl
  105c1d:	74 d4                	je     105bf3 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105c1f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c23:	74 18                	je     105c3d <strncmp+0x4f>
  105c25:	8b 45 08             	mov    0x8(%ebp),%eax
  105c28:	0f b6 00             	movzbl (%eax),%eax
  105c2b:	0f b6 d0             	movzbl %al,%edx
  105c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c31:	0f b6 00             	movzbl (%eax),%eax
  105c34:	0f b6 c0             	movzbl %al,%eax
  105c37:	29 c2                	sub    %eax,%edx
  105c39:	89 d0                	mov    %edx,%eax
  105c3b:	eb 05                	jmp    105c42 <strncmp+0x54>
  105c3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105c42:	5d                   	pop    %ebp
  105c43:	c3                   	ret    

00105c44 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105c44:	55                   	push   %ebp
  105c45:	89 e5                	mov    %esp,%ebp
  105c47:	83 ec 04             	sub    $0x4,%esp
  105c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c4d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105c50:	eb 14                	jmp    105c66 <strchr+0x22>
        if (*s == c) {
  105c52:	8b 45 08             	mov    0x8(%ebp),%eax
  105c55:	0f b6 00             	movzbl (%eax),%eax
  105c58:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105c5b:	75 05                	jne    105c62 <strchr+0x1e>
            return (char *)s;
  105c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  105c60:	eb 13                	jmp    105c75 <strchr+0x31>
        }
        s ++;
  105c62:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105c66:	8b 45 08             	mov    0x8(%ebp),%eax
  105c69:	0f b6 00             	movzbl (%eax),%eax
  105c6c:	84 c0                	test   %al,%al
  105c6e:	75 e2                	jne    105c52 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105c70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105c75:	c9                   	leave  
  105c76:	c3                   	ret    

00105c77 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105c77:	55                   	push   %ebp
  105c78:	89 e5                	mov    %esp,%ebp
  105c7a:	83 ec 04             	sub    $0x4,%esp
  105c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c80:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105c83:	eb 11                	jmp    105c96 <strfind+0x1f>
        if (*s == c) {
  105c85:	8b 45 08             	mov    0x8(%ebp),%eax
  105c88:	0f b6 00             	movzbl (%eax),%eax
  105c8b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105c8e:	75 02                	jne    105c92 <strfind+0x1b>
            break;
  105c90:	eb 0e                	jmp    105ca0 <strfind+0x29>
        }
        s ++;
  105c92:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105c96:	8b 45 08             	mov    0x8(%ebp),%eax
  105c99:	0f b6 00             	movzbl (%eax),%eax
  105c9c:	84 c0                	test   %al,%al
  105c9e:	75 e5                	jne    105c85 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105ca0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105ca3:	c9                   	leave  
  105ca4:	c3                   	ret    

00105ca5 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105ca5:	55                   	push   %ebp
  105ca6:	89 e5                	mov    %esp,%ebp
  105ca8:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105cab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105cb2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105cb9:	eb 04                	jmp    105cbf <strtol+0x1a>
        s ++;
  105cbb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  105cc2:	0f b6 00             	movzbl (%eax),%eax
  105cc5:	3c 20                	cmp    $0x20,%al
  105cc7:	74 f2                	je     105cbb <strtol+0x16>
  105cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  105ccc:	0f b6 00             	movzbl (%eax),%eax
  105ccf:	3c 09                	cmp    $0x9,%al
  105cd1:	74 e8                	je     105cbb <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  105cd6:	0f b6 00             	movzbl (%eax),%eax
  105cd9:	3c 2b                	cmp    $0x2b,%al
  105cdb:	75 06                	jne    105ce3 <strtol+0x3e>
        s ++;
  105cdd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105ce1:	eb 15                	jmp    105cf8 <strtol+0x53>
    }
    else if (*s == '-') {
  105ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  105ce6:	0f b6 00             	movzbl (%eax),%eax
  105ce9:	3c 2d                	cmp    $0x2d,%al
  105ceb:	75 0b                	jne    105cf8 <strtol+0x53>
        s ++, neg = 1;
  105ced:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105cf1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105cf8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105cfc:	74 06                	je     105d04 <strtol+0x5f>
  105cfe:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105d02:	75 24                	jne    105d28 <strtol+0x83>
  105d04:	8b 45 08             	mov    0x8(%ebp),%eax
  105d07:	0f b6 00             	movzbl (%eax),%eax
  105d0a:	3c 30                	cmp    $0x30,%al
  105d0c:	75 1a                	jne    105d28 <strtol+0x83>
  105d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  105d11:	83 c0 01             	add    $0x1,%eax
  105d14:	0f b6 00             	movzbl (%eax),%eax
  105d17:	3c 78                	cmp    $0x78,%al
  105d19:	75 0d                	jne    105d28 <strtol+0x83>
        s += 2, base = 16;
  105d1b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105d1f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105d26:	eb 2a                	jmp    105d52 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105d28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d2c:	75 17                	jne    105d45 <strtol+0xa0>
  105d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  105d31:	0f b6 00             	movzbl (%eax),%eax
  105d34:	3c 30                	cmp    $0x30,%al
  105d36:	75 0d                	jne    105d45 <strtol+0xa0>
        s ++, base = 8;
  105d38:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105d3c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105d43:	eb 0d                	jmp    105d52 <strtol+0xad>
    }
    else if (base == 0) {
  105d45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d49:	75 07                	jne    105d52 <strtol+0xad>
        base = 10;
  105d4b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105d52:	8b 45 08             	mov    0x8(%ebp),%eax
  105d55:	0f b6 00             	movzbl (%eax),%eax
  105d58:	3c 2f                	cmp    $0x2f,%al
  105d5a:	7e 1b                	jle    105d77 <strtol+0xd2>
  105d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  105d5f:	0f b6 00             	movzbl (%eax),%eax
  105d62:	3c 39                	cmp    $0x39,%al
  105d64:	7f 11                	jg     105d77 <strtol+0xd2>
            dig = *s - '0';
  105d66:	8b 45 08             	mov    0x8(%ebp),%eax
  105d69:	0f b6 00             	movzbl (%eax),%eax
  105d6c:	0f be c0             	movsbl %al,%eax
  105d6f:	83 e8 30             	sub    $0x30,%eax
  105d72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d75:	eb 48                	jmp    105dbf <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105d77:	8b 45 08             	mov    0x8(%ebp),%eax
  105d7a:	0f b6 00             	movzbl (%eax),%eax
  105d7d:	3c 60                	cmp    $0x60,%al
  105d7f:	7e 1b                	jle    105d9c <strtol+0xf7>
  105d81:	8b 45 08             	mov    0x8(%ebp),%eax
  105d84:	0f b6 00             	movzbl (%eax),%eax
  105d87:	3c 7a                	cmp    $0x7a,%al
  105d89:	7f 11                	jg     105d9c <strtol+0xf7>
            dig = *s - 'a' + 10;
  105d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  105d8e:	0f b6 00             	movzbl (%eax),%eax
  105d91:	0f be c0             	movsbl %al,%eax
  105d94:	83 e8 57             	sub    $0x57,%eax
  105d97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d9a:	eb 23                	jmp    105dbf <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  105d9f:	0f b6 00             	movzbl (%eax),%eax
  105da2:	3c 40                	cmp    $0x40,%al
  105da4:	7e 3d                	jle    105de3 <strtol+0x13e>
  105da6:	8b 45 08             	mov    0x8(%ebp),%eax
  105da9:	0f b6 00             	movzbl (%eax),%eax
  105dac:	3c 5a                	cmp    $0x5a,%al
  105dae:	7f 33                	jg     105de3 <strtol+0x13e>
            dig = *s - 'A' + 10;
  105db0:	8b 45 08             	mov    0x8(%ebp),%eax
  105db3:	0f b6 00             	movzbl (%eax),%eax
  105db6:	0f be c0             	movsbl %al,%eax
  105db9:	83 e8 37             	sub    $0x37,%eax
  105dbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105dc2:	3b 45 10             	cmp    0x10(%ebp),%eax
  105dc5:	7c 02                	jl     105dc9 <strtol+0x124>
            break;
  105dc7:	eb 1a                	jmp    105de3 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105dc9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105dcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105dd0:	0f af 45 10          	imul   0x10(%ebp),%eax
  105dd4:	89 c2                	mov    %eax,%edx
  105dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105dd9:	01 d0                	add    %edx,%eax
  105ddb:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105dde:	e9 6f ff ff ff       	jmp    105d52 <strtol+0xad>

    if (endptr) {
  105de3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105de7:	74 08                	je     105df1 <strtol+0x14c>
        *endptr = (char *) s;
  105de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dec:	8b 55 08             	mov    0x8(%ebp),%edx
  105def:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105df1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105df5:	74 07                	je     105dfe <strtol+0x159>
  105df7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105dfa:	f7 d8                	neg    %eax
  105dfc:	eb 03                	jmp    105e01 <strtol+0x15c>
  105dfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105e01:	c9                   	leave  
  105e02:	c3                   	ret    

00105e03 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105e03:	55                   	push   %ebp
  105e04:	89 e5                	mov    %esp,%ebp
  105e06:	57                   	push   %edi
  105e07:	83 ec 24             	sub    $0x24,%esp
  105e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e0d:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105e10:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105e14:	8b 55 08             	mov    0x8(%ebp),%edx
  105e17:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105e1a:	88 45 f7             	mov    %al,-0x9(%ebp)
  105e1d:	8b 45 10             	mov    0x10(%ebp),%eax
  105e20:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105e23:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105e26:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105e2a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105e2d:	89 d7                	mov    %edx,%edi
  105e2f:	f3 aa                	rep stos %al,%es:(%edi)
  105e31:	89 fa                	mov    %edi,%edx
  105e33:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105e36:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105e39:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105e3c:	83 c4 24             	add    $0x24,%esp
  105e3f:	5f                   	pop    %edi
  105e40:	5d                   	pop    %ebp
  105e41:	c3                   	ret    

00105e42 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105e42:	55                   	push   %ebp
  105e43:	89 e5                	mov    %esp,%ebp
  105e45:	57                   	push   %edi
  105e46:	56                   	push   %esi
  105e47:	53                   	push   %ebx
  105e48:	83 ec 30             	sub    $0x30,%esp
  105e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  105e4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e51:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e54:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105e57:	8b 45 10             	mov    0x10(%ebp),%eax
  105e5a:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105e5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e60:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105e63:	73 42                	jae    105ea7 <memmove+0x65>
  105e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e68:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105e6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105e71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e74:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105e77:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105e7a:	c1 e8 02             	shr    $0x2,%eax
  105e7d:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105e7f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105e82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105e85:	89 d7                	mov    %edx,%edi
  105e87:	89 c6                	mov    %eax,%esi
  105e89:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105e8b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105e8e:	83 e1 03             	and    $0x3,%ecx
  105e91:	74 02                	je     105e95 <memmove+0x53>
  105e93:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105e95:	89 f0                	mov    %esi,%eax
  105e97:	89 fa                	mov    %edi,%edx
  105e99:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105e9c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105e9f:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105ea2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105ea5:	eb 36                	jmp    105edd <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105ea7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105eaa:	8d 50 ff             	lea    -0x1(%eax),%edx
  105ead:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105eb0:	01 c2                	add    %eax,%edx
  105eb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105eb5:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ebb:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105ebe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105ec1:	89 c1                	mov    %eax,%ecx
  105ec3:	89 d8                	mov    %ebx,%eax
  105ec5:	89 d6                	mov    %edx,%esi
  105ec7:	89 c7                	mov    %eax,%edi
  105ec9:	fd                   	std    
  105eca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105ecc:	fc                   	cld    
  105ecd:	89 f8                	mov    %edi,%eax
  105ecf:	89 f2                	mov    %esi,%edx
  105ed1:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105ed4:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105ed7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105edd:	83 c4 30             	add    $0x30,%esp
  105ee0:	5b                   	pop    %ebx
  105ee1:	5e                   	pop    %esi
  105ee2:	5f                   	pop    %edi
  105ee3:	5d                   	pop    %ebp
  105ee4:	c3                   	ret    

00105ee5 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105ee5:	55                   	push   %ebp
  105ee6:	89 e5                	mov    %esp,%ebp
  105ee8:	57                   	push   %edi
  105ee9:	56                   	push   %esi
  105eea:	83 ec 20             	sub    $0x20,%esp
  105eed:	8b 45 08             	mov    0x8(%ebp),%eax
  105ef0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ef6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ef9:	8b 45 10             	mov    0x10(%ebp),%eax
  105efc:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105eff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f02:	c1 e8 02             	shr    $0x2,%eax
  105f05:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105f07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105f0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f0d:	89 d7                	mov    %edx,%edi
  105f0f:	89 c6                	mov    %eax,%esi
  105f11:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105f13:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105f16:	83 e1 03             	and    $0x3,%ecx
  105f19:	74 02                	je     105f1d <memcpy+0x38>
  105f1b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105f1d:	89 f0                	mov    %esi,%eax
  105f1f:	89 fa                	mov    %edi,%edx
  105f21:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105f24:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105f27:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105f2d:	83 c4 20             	add    $0x20,%esp
  105f30:	5e                   	pop    %esi
  105f31:	5f                   	pop    %edi
  105f32:	5d                   	pop    %ebp
  105f33:	c3                   	ret    

00105f34 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105f34:	55                   	push   %ebp
  105f35:	89 e5                	mov    %esp,%ebp
  105f37:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  105f3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105f40:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f43:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105f46:	eb 30                	jmp    105f78 <memcmp+0x44>
        if (*s1 != *s2) {
  105f48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105f4b:	0f b6 10             	movzbl (%eax),%edx
  105f4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f51:	0f b6 00             	movzbl (%eax),%eax
  105f54:	38 c2                	cmp    %al,%dl
  105f56:	74 18                	je     105f70 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105f58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105f5b:	0f b6 00             	movzbl (%eax),%eax
  105f5e:	0f b6 d0             	movzbl %al,%edx
  105f61:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f64:	0f b6 00             	movzbl (%eax),%eax
  105f67:	0f b6 c0             	movzbl %al,%eax
  105f6a:	29 c2                	sub    %eax,%edx
  105f6c:	89 d0                	mov    %edx,%eax
  105f6e:	eb 1a                	jmp    105f8a <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105f70:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105f74:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105f78:	8b 45 10             	mov    0x10(%ebp),%eax
  105f7b:	8d 50 ff             	lea    -0x1(%eax),%edx
  105f7e:	89 55 10             	mov    %edx,0x10(%ebp)
  105f81:	85 c0                	test   %eax,%eax
  105f83:	75 c3                	jne    105f48 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105f85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105f8a:	c9                   	leave  
  105f8b:	c3                   	ret    
