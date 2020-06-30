
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 88 89 11 c0       	mov    $0xc0118988,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 7a 11 c0 	movl   $0xc0117a36,(%esp)
c0100051:	e8 ad 5d 00 00       	call   c0105e03 <memset>

    cons_init();                // init the console
c0100056:	e8 6f 15 00 00       	call   c01015ca <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 a0 5f 10 c0 	movl   $0xc0105fa0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 bc 5f 10 c0 	movl   $0xc0105fbc,(%esp)
c0100070:	e8 c7 02 00 00       	call   c010033c <cprintf>

    print_kerninfo();
c0100075:	e8 f6 07 00 00       	call   c0100870 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 91 42 00 00       	call   c0104315 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 aa 16 00 00       	call   c0101733 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 22 18 00 00       	call   c01018b0 <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 ed 0c 00 00       	call   c0100d80 <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 09 16 00 00       	call   c01016a1 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 f6 0b 00 00       	call   c0100cb2 <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 c1 5f 10 c0 	movl   $0xc0105fc1,(%esp)
c010015c:	e8 db 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 cf 5f 10 c0 	movl   $0xc0105fcf,(%esp)
c010017c:	e8 bb 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 dd 5f 10 c0 	movl   $0xc0105fdd,(%esp)
c010019c:	e8 9b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 eb 5f 10 c0 	movl   $0xc0105feb,(%esp)
c01001bc:	e8 7b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 f9 5f 10 c0 	movl   $0xc0105ff9,(%esp)
c01001dc:	e8 5b 01 00 00       	call   c010033c <cprintf>
    round ++;
c01001e1:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f3:	5d                   	pop    %ebp
c01001f4:	c3                   	ret    

c01001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f5:	55                   	push   %ebp
c01001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001f8:	5d                   	pop    %ebp
c01001f9:	c3                   	ret    

c01001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
c01001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100200:	e8 25 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100205:	c7 04 24 08 60 10 c0 	movl   $0xc0106008,(%esp)
c010020c:	e8 2b 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_user();
c0100211:	e8 da ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100216:	e8 0f ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021b:	c7 04 24 28 60 10 c0 	movl   $0xc0106028,(%esp)
c0100222:	e8 15 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_kernel();
c0100227:	e8 c9 ff ff ff       	call   c01001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010022c:	e8 f9 fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c0100231:	c9                   	leave  
c0100232:	c3                   	ret    

c0100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100233:	55                   	push   %ebp
c0100234:	89 e5                	mov    %esp,%ebp
c0100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010023d:	74 13                	je     c0100252 <readline+0x1f>
        cprintf("%s", prompt);
c010023f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100246:	c7 04 24 47 60 10 c0 	movl   $0xc0106047,(%esp)
c010024d:	e8 ea 00 00 00       	call   c010033c <cprintf>
    }
    int i = 0, c;
c0100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100259:	e8 66 01 00 00       	call   c01003c4 <getchar>
c010025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100265:	79 07                	jns    c010026e <readline+0x3b>
            return NULL;
c0100267:	b8 00 00 00 00       	mov    $0x0,%eax
c010026c:	eb 79                	jmp    c01002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100272:	7e 28                	jle    c010029c <readline+0x69>
c0100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010027b:	7f 1f                	jg     c010029c <readline+0x69>
            cputchar(c);
c010027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100280:	89 04 24             	mov    %eax,(%esp)
c0100283:	e8 da 00 00 00       	call   c0100362 <cputchar>
            buf[i ++] = c;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010028b:	8d 50 01             	lea    0x1(%eax),%edx
c010028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100294:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c010029a:	eb 46                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c010029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a0:	75 17                	jne    c01002b9 <readline+0x86>
c01002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002a6:	7e 11                	jle    c01002b9 <readline+0x86>
            cputchar(c);
c01002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ab:	89 04 24             	mov    %eax,(%esp)
c01002ae:	e8 af 00 00 00       	call   c0100362 <cputchar>
            i --;
c01002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002b7:	eb 29                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002bd:	74 06                	je     c01002c5 <readline+0x92>
c01002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002c3:	75 1d                	jne    c01002e2 <readline+0xaf>
            cputchar(c);
c01002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c8:	89 04 24             	mov    %eax,(%esp)
c01002cb:	e8 92 00 00 00       	call   c0100362 <cputchar>
            buf[i] = '\0';
c01002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002d3:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002db:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01002e0:	eb 05                	jmp    c01002e7 <readline+0xb4>
        }
    }
c01002e2:	e9 72 ff ff ff       	jmp    c0100259 <readline+0x26>
}
c01002e7:	c9                   	leave  
c01002e8:	c3                   	ret    

c01002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002e9:	55                   	push   %ebp
c01002ea:	89 e5                	mov    %esp,%ebp
c01002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f2:	89 04 24             	mov    %eax,(%esp)
c01002f5:	e8 fc 12 00 00       	call   c01015f6 <cons_putc>
    (*cnt) ++;
c01002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002fd:	8b 00                	mov    (%eax),%eax
c01002ff:	8d 50 01             	lea    0x1(%eax),%edx
c0100302:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100305:	89 10                	mov    %edx,(%eax)
}
c0100307:	c9                   	leave  
c0100308:	c3                   	ret    

c0100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100309:	55                   	push   %ebp
c010030a:	89 e5                	mov    %esp,%ebp
c010030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100316:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010031d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100320:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100327:	89 44 24 04          	mov    %eax,0x4(%esp)
c010032b:	c7 04 24 e9 02 10 c0 	movl   $0xc01002e9,(%esp)
c0100332:	e8 e5 52 00 00       	call   c010561c <vprintfmt>
    return cnt;
c0100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010033a:	c9                   	leave  
c010033b:	c3                   	ret    

c010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010033c:	55                   	push   %ebp
c010033d:	89 e5                	mov    %esp,%ebp
c010033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100342:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010034b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100352:	89 04 24             	mov    %eax,(%esp)
c0100355:	e8 af ff ff ff       	call   c0100309 <vcprintf>
c010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100360:	c9                   	leave  
c0100361:	c3                   	ret    

c0100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100362:	55                   	push   %ebp
c0100363:	89 e5                	mov    %esp,%ebp
c0100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100368:	8b 45 08             	mov    0x8(%ebp),%eax
c010036b:	89 04 24             	mov    %eax,(%esp)
c010036e:	e8 83 12 00 00       	call   c01015f6 <cons_putc>
}
c0100373:	c9                   	leave  
c0100374:	c3                   	ret    

c0100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100375:	55                   	push   %ebp
c0100376:	89 e5                	mov    %esp,%ebp
c0100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100382:	eb 13                	jmp    c0100397 <cputs+0x22>
        cputch(c, &cnt);
c0100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010038b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010038f:	89 04 24             	mov    %eax,(%esp)
c0100392:	e8 52 ff ff ff       	call   c01002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c0100397:	8b 45 08             	mov    0x8(%ebp),%eax
c010039a:	8d 50 01             	lea    0x1(%eax),%edx
c010039d:	89 55 08             	mov    %edx,0x8(%ebp)
c01003a0:	0f b6 00             	movzbl (%eax),%eax
c01003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003aa:	75 d8                	jne    c0100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ba:	e8 2a ff ff ff       	call   c01002e9 <cputch>
    return cnt;
c01003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003c2:	c9                   	leave  
c01003c3:	c3                   	ret    

c01003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003c4:	55                   	push   %ebp
c01003c5:	89 e5                	mov    %esp,%ebp
c01003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003ca:	e8 63 12 00 00       	call   c0101632 <cons_getc>
c01003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003d6:	74 f2                	je     c01003ca <getchar+0x6>
        /* do nothing */;
    return c;
c01003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003db:	c9                   	leave  
c01003dc:	c3                   	ret    

c01003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003dd:	55                   	push   %ebp
c01003de:	89 e5                	mov    %esp,%ebp
c01003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003e6:	8b 00                	mov    (%eax),%eax
c01003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01003ee:	8b 00                	mov    (%eax),%eax
c01003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01003fa:	e9 d2 00 00 00       	jmp    c01004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100405:	01 d0                	add    %edx,%eax
c0100407:	89 c2                	mov    %eax,%edx
c0100409:	c1 ea 1f             	shr    $0x1f,%edx
c010040c:	01 d0                	add    %edx,%eax
c010040e:	d1 f8                	sar    %eax
c0100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100419:	eb 04                	jmp    c010041f <stab_binsearch+0x42>
            m --;
c010041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100425:	7c 1f                	jl     c0100446 <stab_binsearch+0x69>
c0100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010042a:	89 d0                	mov    %edx,%eax
c010042c:	01 c0                	add    %eax,%eax
c010042e:	01 d0                	add    %edx,%eax
c0100430:	c1 e0 02             	shl    $0x2,%eax
c0100433:	89 c2                	mov    %eax,%edx
c0100435:	8b 45 08             	mov    0x8(%ebp),%eax
c0100438:	01 d0                	add    %edx,%eax
c010043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010043e:	0f b6 c0             	movzbl %al,%eax
c0100441:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100444:	75 d5                	jne    c010041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010044c:	7d 0b                	jge    c0100459 <stab_binsearch+0x7c>
            l = true_m + 1;
c010044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100451:	83 c0 01             	add    $0x1,%eax
c0100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100457:	eb 78                	jmp    c01004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100463:	89 d0                	mov    %edx,%eax
c0100465:	01 c0                	add    %eax,%eax
c0100467:	01 d0                	add    %edx,%eax
c0100469:	c1 e0 02             	shl    $0x2,%eax
c010046c:	89 c2                	mov    %eax,%edx
c010046e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100471:	01 d0                	add    %edx,%eax
c0100473:	8b 40 08             	mov    0x8(%eax),%eax
c0100476:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100479:	73 13                	jae    c010048e <stab_binsearch+0xb1>
            *region_left = m;
c010047b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100486:	83 c0 01             	add    $0x1,%eax
c0100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010048c:	eb 43                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100491:	89 d0                	mov    %edx,%eax
c0100493:	01 c0                	add    %eax,%eax
c0100495:	01 d0                	add    %edx,%eax
c0100497:	c1 e0 02             	shl    $0x2,%eax
c010049a:	89 c2                	mov    %eax,%edx
c010049c:	8b 45 08             	mov    0x8(%ebp),%eax
c010049f:	01 d0                	add    %edx,%eax
c01004a1:	8b 40 08             	mov    0x8(%eax),%eax
c01004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004a7:	76 16                	jbe    c01004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004af:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b7:	83 e8 01             	sub    $0x1,%eax
c01004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004bd:	eb 12                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004c5:	89 10                	mov    %edx,(%eax)
            l = m;
c01004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004d7:	0f 8e 22 ff ff ff    	jle    c01003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e1:	75 0f                	jne    c01004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004e6:	8b 00                	mov    (%eax),%eax
c01004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ee:	89 10                	mov    %edx,(%eax)
c01004f0:	eb 3f                	jmp    c0100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01004fa:	eb 04                	jmp    c0100500 <stab_binsearch+0x123>
c01004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100503:	8b 00                	mov    (%eax),%eax
c0100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100508:	7d 1f                	jge    c0100529 <stab_binsearch+0x14c>
c010050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010050d:	89 d0                	mov    %edx,%eax
c010050f:	01 c0                	add    %eax,%eax
c0100511:	01 d0                	add    %edx,%eax
c0100513:	c1 e0 02             	shl    $0x2,%eax
c0100516:	89 c2                	mov    %eax,%edx
c0100518:	8b 45 08             	mov    0x8(%ebp),%eax
c010051b:	01 d0                	add    %edx,%eax
c010051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100521:	0f b6 c0             	movzbl %al,%eax
c0100524:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100527:	75 d3                	jne    c01004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100529:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010052f:	89 10                	mov    %edx,(%eax)
    }
}
c0100531:	c9                   	leave  
c0100532:	c3                   	ret    

c0100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100533:	55                   	push   %ebp
c0100534:	89 e5                	mov    %esp,%ebp
c0100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100539:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053c:	c7 00 4c 60 10 c0    	movl   $0xc010604c,(%eax)
    info->eip_line = 0;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010054c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054f:	c7 40 08 4c 60 10 c0 	movl   $0xc010604c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100556:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	8b 55 08             	mov    0x8(%ebp),%edx
c0100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100569:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100573:	c7 45 f4 a8 72 10 c0 	movl   $0xc01072a8,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057a:	c7 45 f0 1c 1f 11 c0 	movl   $0xc0111f1c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100581:	c7 45 ec 1d 1f 11 c0 	movl   $0xc0111f1d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100588:	c7 45 e8 99 49 11 c0 	movl   $0xc0114999,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100595:	76 0d                	jbe    c01005a4 <debuginfo_eip+0x71>
c0100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059a:	83 e8 01             	sub    $0x1,%eax
c010059d:	0f b6 00             	movzbl (%eax),%eax
c01005a0:	84 c0                	test   %al,%al
c01005a2:	74 0a                	je     c01005ae <debuginfo_eip+0x7b>
        return -1;
c01005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005a9:	e9 c0 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005bb:	29 c2                	sub    %eax,%edx
c01005bd:	89 d0                	mov    %edx,%eax
c01005bf:	c1 f8 02             	sar    $0x2,%eax
c01005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005c8:	83 e8 01             	sub    $0x1,%eax
c01005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005dc:	00 
c01005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ee:	89 04 24             	mov    %eax,(%esp)
c01005f1:	e8 e7 fd ff ff       	call   c01003dd <stab_binsearch>
    if (lfile == 0)
c01005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005f9:	85 c0                	test   %eax,%eax
c01005fb:	75 0a                	jne    c0100607 <debuginfo_eip+0xd4>
        return -1;
c01005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100602:	e9 67 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100613:	8b 45 08             	mov    0x8(%ebp),%eax
c0100616:	89 44 24 10          	mov    %eax,0x10(%esp)
c010061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100621:	00 
c0100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100625:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010062c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100633:	89 04 24             	mov    %eax,(%esp)
c0100636:	e8 a2 fd ff ff       	call   c01003dd <stab_binsearch>

    if (lfun <= rfun) {
c010063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100641:	39 c2                	cmp    %eax,%edx
c0100643:	7f 7c                	jg     c01006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100648:	89 c2                	mov    %eax,%edx
c010064a:	89 d0                	mov    %edx,%eax
c010064c:	01 c0                	add    %eax,%eax
c010064e:	01 d0                	add    %edx,%eax
c0100650:	c1 e0 02             	shl    $0x2,%eax
c0100653:	89 c2                	mov    %eax,%edx
c0100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100658:	01 d0                	add    %edx,%eax
c010065a:	8b 10                	mov    (%eax),%edx
c010065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100662:	29 c1                	sub    %eax,%ecx
c0100664:	89 c8                	mov    %ecx,%eax
c0100666:	39 c2                	cmp    %eax,%edx
c0100668:	73 22                	jae    c010068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010066d:	89 c2                	mov    %eax,%edx
c010066f:	89 d0                	mov    %edx,%eax
c0100671:	01 c0                	add    %eax,%eax
c0100673:	01 d0                	add    %edx,%eax
c0100675:	c1 e0 02             	shl    $0x2,%eax
c0100678:	89 c2                	mov    %eax,%edx
c010067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010067d:	01 d0                	add    %edx,%eax
c010067f:	8b 10                	mov    (%eax),%edx
c0100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100684:	01 c2                	add    %eax,%edx
c0100686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	89 d0                	mov    %edx,%eax
c0100693:	01 c0                	add    %eax,%eax
c0100695:	01 d0                	add    %edx,%eax
c0100697:	c1 e0 02             	shl    $0x2,%eax
c010069a:	89 c2                	mov    %eax,%edx
c010069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069f:	01 d0                	add    %edx,%eax
c01006a1:	8b 50 08             	mov    0x8(%eax),%edx
c01006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ad:	8b 40 10             	mov    0x10(%eax),%eax
c01006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006bf:	eb 15                	jmp    c01006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d9:	8b 40 08             	mov    0x8(%eax),%eax
c01006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006e3:	00 
c01006e4:	89 04 24             	mov    %eax,(%esp)
c01006e7:	e8 8b 55 00 00       	call   c0105c77 <strfind>
c01006ec:	89 c2                	mov    %eax,%edx
c01006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f1:	8b 40 08             	mov    0x8(%eax),%eax
c01006f4:	29 c2                	sub    %eax,%edx
c01006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010070a:	00 
c010070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010070e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071c:	89 04 24             	mov    %eax,(%esp)
c010071f:	e8 b9 fc ff ff       	call   c01003dd <stab_binsearch>
    if (lline <= rline) {
c0100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010072a:	39 c2                	cmp    %eax,%edx
c010072c:	7f 24                	jg     c0100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100731:	89 c2                	mov    %eax,%edx
c0100733:	89 d0                	mov    %edx,%eax
c0100735:	01 c0                	add    %eax,%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	c1 e0 02             	shl    $0x2,%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100741:	01 d0                	add    %edx,%eax
c0100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100747:	0f b7 d0             	movzwl %ax,%edx
c010074a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100750:	eb 13                	jmp    c0100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100757:	e9 12 01 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010075f:	83 e8 01             	sub    $0x1,%eax
c0100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010076b:	39 c2                	cmp    %eax,%edx
c010076d:	7c 56                	jl     c01007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100772:	89 c2                	mov    %eax,%edx
c0100774:	89 d0                	mov    %edx,%eax
c0100776:	01 c0                	add    %eax,%eax
c0100778:	01 d0                	add    %edx,%eax
c010077a:	c1 e0 02             	shl    $0x2,%eax
c010077d:	89 c2                	mov    %eax,%edx
c010077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100788:	3c 84                	cmp    $0x84,%al
c010078a:	74 39                	je     c01007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078f:	89 c2                	mov    %eax,%edx
c0100791:	89 d0                	mov    %edx,%eax
c0100793:	01 c0                	add    %eax,%eax
c0100795:	01 d0                	add    %edx,%eax
c0100797:	c1 e0 02             	shl    $0x2,%eax
c010079a:	89 c2                	mov    %eax,%edx
c010079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079f:	01 d0                	add    %edx,%eax
c01007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a5:	3c 64                	cmp    $0x64,%al
c01007a7:	75 b3                	jne    c010075c <debuginfo_eip+0x229>
c01007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ac:	89 c2                	mov    %eax,%edx
c01007ae:	89 d0                	mov    %edx,%eax
c01007b0:	01 c0                	add    %eax,%eax
c01007b2:	01 d0                	add    %edx,%eax
c01007b4:	c1 e0 02             	shl    $0x2,%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	8b 40 08             	mov    0x8(%eax),%eax
c01007c1:	85 c0                	test   %eax,%eax
c01007c3:	74 97                	je     c010075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007cb:	39 c2                	cmp    %eax,%edx
c01007cd:	7c 46                	jl     c0100815 <debuginfo_eip+0x2e2>
c01007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	89 d0                	mov    %edx,%eax
c01007d6:	01 c0                	add    %eax,%eax
c01007d8:	01 d0                	add    %edx,%eax
c01007da:	c1 e0 02             	shl    $0x2,%eax
c01007dd:	89 c2                	mov    %eax,%edx
c01007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e2:	01 d0                	add    %edx,%eax
c01007e4:	8b 10                	mov    (%eax),%edx
c01007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007ec:	29 c1                	sub    %eax,%ecx
c01007ee:	89 c8                	mov    %ecx,%eax
c01007f0:	39 c2                	cmp    %eax,%edx
c01007f2:	73 21                	jae    c0100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f7:	89 c2                	mov    %eax,%edx
c01007f9:	89 d0                	mov    %edx,%eax
c01007fb:	01 c0                	add    %eax,%eax
c01007fd:	01 d0                	add    %edx,%eax
c01007ff:	c1 e0 02             	shl    $0x2,%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100807:	01 d0                	add    %edx,%eax
c0100809:	8b 10                	mov    (%eax),%edx
c010080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010080e:	01 c2                	add    %eax,%edx
c0100810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010081b:	39 c2                	cmp    %eax,%edx
c010081d:	7d 4a                	jge    c0100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100822:	83 c0 01             	add    $0x1,%eax
c0100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100828:	eb 18                	jmp    c0100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010082a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082d:	8b 40 14             	mov    0x14(%eax),%eax
c0100830:	8d 50 01             	lea    0x1(%eax),%edx
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083c:	83 c0 01             	add    $0x1,%eax
c010083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100848:	39 c2                	cmp    %eax,%edx
c010084a:	7d 1d                	jge    c0100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084f:	89 c2                	mov    %eax,%edx
c0100851:	89 d0                	mov    %edx,%eax
c0100853:	01 c0                	add    %eax,%eax
c0100855:	01 d0                	add    %edx,%eax
c0100857:	c1 e0 02             	shl    $0x2,%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085f:	01 d0                	add    %edx,%eax
c0100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100865:	3c a0                	cmp    $0xa0,%al
c0100867:	74 c1                	je     c010082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010086e:	c9                   	leave  
c010086f:	c3                   	ret    

c0100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100870:	55                   	push   %ebp
c0100871:	89 e5                	mov    %esp,%ebp
c0100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100876:	c7 04 24 56 60 10 c0 	movl   $0xc0106056,(%esp)
c010087d:	e8 ba fa ff ff       	call   c010033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100882:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100889:	c0 
c010088a:	c7 04 24 6f 60 10 c0 	movl   $0xc010606f,(%esp)
c0100891:	e8 a6 fa ff ff       	call   c010033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100896:	c7 44 24 04 8c 5f 10 	movl   $0xc0105f8c,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 87 60 10 c0 	movl   $0xc0106087,(%esp)
c01008a5:	e8 92 fa ff ff       	call   c010033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008aa:	c7 44 24 04 36 7a 11 	movl   $0xc0117a36,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 9f 60 10 c0 	movl   $0xc010609f,(%esp)
c01008b9:	e8 7e fa ff ff       	call   c010033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008be:	c7 44 24 04 88 89 11 	movl   $0xc0118988,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 b7 60 10 c0 	movl   $0xc01060b7,(%esp)
c01008cd:	e8 6a fa ff ff       	call   c010033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008d2:	b8 88 89 11 c0       	mov    $0xc0118988,%eax
c01008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008dd:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008e2:	29 c2                	sub    %eax,%edx
c01008e4:	89 d0                	mov    %edx,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	85 c0                	test   %eax,%eax
c01008ee:	0f 48 c2             	cmovs  %edx,%eax
c01008f1:	c1 f8 0a             	sar    $0xa,%eax
c01008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008f8:	c7 04 24 d0 60 10 c0 	movl   $0xc01060d0,(%esp)
c01008ff:	e8 38 fa ff ff       	call   c010033c <cprintf>
}
c0100904:	c9                   	leave  
c0100905:	c3                   	ret    

c0100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100906:	55                   	push   %ebp
c0100907:	89 e5                	mov    %esp,%ebp
c0100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100912:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100916:	8b 45 08             	mov    0x8(%ebp),%eax
c0100919:	89 04 24             	mov    %eax,(%esp)
c010091c:	e8 12 fc ff ff       	call   c0100533 <debuginfo_eip>
c0100921:	85 c0                	test   %eax,%eax
c0100923:	74 15                	je     c010093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	c7 04 24 fa 60 10 c0 	movl   $0xc01060fa,(%esp)
c0100933:	e8 04 fa ff ff       	call   c010033c <cprintf>
c0100938:	eb 6d                	jmp    c01009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100941:	eb 1c                	jmp    c010095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100949:	01 d0                	add    %edx,%eax
c010094b:	0f b6 00             	movzbl (%eax),%eax
c010094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100957:	01 ca                	add    %ecx,%edx
c0100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100965:	7f dc                	jg     c0100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100970:	01 d0                	add    %edx,%eax
c0100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100978:	8b 55 08             	mov    0x8(%ebp),%edx
c010097b:	89 d1                	mov    %edx,%ecx
c010097d:	29 c1                	sub    %eax,%ecx
c010097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100993:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010099b:	c7 04 24 16 61 10 c0 	movl   $0xc0106116,(%esp)
c01009a2:	e8 95 f9 ff ff       	call   c010033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009a7:	c9                   	leave  
c01009a8:	c3                   	ret    

c01009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009a9:	55                   	push   %ebp
c01009aa:	89 e5                	mov    %esp,%ebp
c01009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009af:	8b 45 04             	mov    0x4(%ebp),%eax
c01009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009b8:	c9                   	leave  
c01009b9:	c3                   	ret    

c01009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009ba:	55                   	push   %ebp
c01009bb:	89 e5                	mov    %esp,%ebp
c01009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009c0:	89 e8                	mov    %ebp,%eax
c01009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp;
	uint32_t eip;
	ebp = read_ebp();
c01009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	eip = read_eip();
c01009cb:	e8 d9 ff ff ff       	call   c01009a9 <read_eip>
c01009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i;
	int j;
	for(i = 0; i < STACKFRAME_DEPTH && ebp ; ++i){
c01009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009da:	e9 86 00 00 00       	jmp    c0100a65 <print_stackframe+0xab>
		cprintf("ebp:0x%08x eip:0x%08x args:",ebp,eip);
c01009df:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009e2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009ed:	c7 04 24 28 61 10 c0 	movl   $0xc0106128,(%esp)
c01009f4:	e8 43 f9 ff ff       	call   c010033c <cprintf>
		uint32_t *ebp_pointer = (uint32_t*)ebp;
c01009f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for(j = 0; j < 4; ++j){
c01009ff:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a06:	eb 28                	jmp    c0100a30 <print_stackframe+0x76>
			cprintf("0x%08x ",ebp_pointer[j+2]);
c0100a08:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a0b:	83 c0 02             	add    $0x2,%eax
c0100a0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a18:	01 d0                	add    %edx,%eax
c0100a1a:	8b 00                	mov    (%eax),%eax
c0100a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a20:	c7 04 24 44 61 10 c0 	movl   $0xc0106144,(%esp)
c0100a27:	e8 10 f9 ff ff       	call   c010033c <cprintf>
	int i;
	int j;
	for(i = 0; i < STACKFRAME_DEPTH && ebp ; ++i){
		cprintf("ebp:0x%08x eip:0x%08x args:",ebp,eip);
		uint32_t *ebp_pointer = (uint32_t*)ebp;
		for(j = 0; j < 4; ++j){
c0100a2c:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a30:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a34:	7e d2                	jle    c0100a08 <print_stackframe+0x4e>
			cprintf("0x%08x ",ebp_pointer[j+2]);
		}
		cprintf("\n");
c0100a36:	c7 04 24 4c 61 10 c0 	movl   $0xc010614c,(%esp)
c0100a3d:	e8 fa f8 ff ff       	call   c010033c <cprintf>
		print_debuginfo(eip-1);
c0100a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a45:	83 e8 01             	sub    $0x1,%eax
c0100a48:	89 04 24             	mov    %eax,(%esp)
c0100a4b:	e8 b6 fe ff ff       	call   c0100906 <print_debuginfo>
		eip = ebp_pointer[1];
c0100a50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a53:	8b 40 04             	mov    0x4(%eax),%eax
c0100a56:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = ebp_pointer[0];
c0100a59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a5c:	8b 00                	mov    (%eax),%eax
c0100a5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip;
	ebp = read_ebp();
	eip = read_eip();
	int i;
	int j;
	for(i = 0; i < STACKFRAME_DEPTH && ebp ; ++i){
c0100a61:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a65:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a69:	7f 0a                	jg     c0100a75 <print_stackframe+0xbb>
c0100a6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a6f:	0f 85 6a ff ff ff    	jne    c01009df <print_stackframe+0x25>
		cprintf("\n");
		print_debuginfo(eip-1);
		eip = ebp_pointer[1];
		ebp = ebp_pointer[0];
	}
}
c0100a75:	c9                   	leave  
c0100a76:	c3                   	ret    

c0100a77 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a77:	55                   	push   %ebp
c0100a78:	89 e5                	mov    %esp,%ebp
c0100a7a:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a84:	eb 0c                	jmp    c0100a92 <parse+0x1b>
            *buf ++ = '\0';
c0100a86:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a89:	8d 50 01             	lea    0x1(%eax),%edx
c0100a8c:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a8f:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a92:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a95:	0f b6 00             	movzbl (%eax),%eax
c0100a98:	84 c0                	test   %al,%al
c0100a9a:	74 1d                	je     c0100ab9 <parse+0x42>
c0100a9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a9f:	0f b6 00             	movzbl (%eax),%eax
c0100aa2:	0f be c0             	movsbl %al,%eax
c0100aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aa9:	c7 04 24 d0 61 10 c0 	movl   $0xc01061d0,(%esp)
c0100ab0:	e8 8f 51 00 00       	call   c0105c44 <strchr>
c0100ab5:	85 c0                	test   %eax,%eax
c0100ab7:	75 cd                	jne    c0100a86 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ab9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100abc:	0f b6 00             	movzbl (%eax),%eax
c0100abf:	84 c0                	test   %al,%al
c0100ac1:	75 02                	jne    c0100ac5 <parse+0x4e>
            break;
c0100ac3:	eb 67                	jmp    c0100b2c <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ac5:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ac9:	75 14                	jne    c0100adf <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100acb:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ad2:	00 
c0100ad3:	c7 04 24 d5 61 10 c0 	movl   $0xc01061d5,(%esp)
c0100ada:	e8 5d f8 ff ff       	call   c010033c <cprintf>
        }
        argv[argc ++] = buf;
c0100adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ae2:	8d 50 01             	lea    0x1(%eax),%edx
c0100ae5:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100ae8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100aef:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100af2:	01 c2                	add    %eax,%edx
c0100af4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100af7:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100af9:	eb 04                	jmp    c0100aff <parse+0x88>
            buf ++;
c0100afb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100aff:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b02:	0f b6 00             	movzbl (%eax),%eax
c0100b05:	84 c0                	test   %al,%al
c0100b07:	74 1d                	je     c0100b26 <parse+0xaf>
c0100b09:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0c:	0f b6 00             	movzbl (%eax),%eax
c0100b0f:	0f be c0             	movsbl %al,%eax
c0100b12:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b16:	c7 04 24 d0 61 10 c0 	movl   $0xc01061d0,(%esp)
c0100b1d:	e8 22 51 00 00       	call   c0105c44 <strchr>
c0100b22:	85 c0                	test   %eax,%eax
c0100b24:	74 d5                	je     c0100afb <parse+0x84>
            buf ++;
        }
    }
c0100b26:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b27:	e9 66 ff ff ff       	jmp    c0100a92 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b2f:	c9                   	leave  
c0100b30:	c3                   	ret    

c0100b31 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b31:	55                   	push   %ebp
c0100b32:	89 e5                	mov    %esp,%ebp
c0100b34:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b37:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b3a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b41:	89 04 24             	mov    %eax,(%esp)
c0100b44:	e8 2e ff ff ff       	call   c0100a77 <parse>
c0100b49:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b50:	75 0a                	jne    c0100b5c <runcmd+0x2b>
        return 0;
c0100b52:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b57:	e9 85 00 00 00       	jmp    c0100be1 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b63:	eb 5c                	jmp    c0100bc1 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b65:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b68:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b6b:	89 d0                	mov    %edx,%eax
c0100b6d:	01 c0                	add    %eax,%eax
c0100b6f:	01 d0                	add    %edx,%eax
c0100b71:	c1 e0 02             	shl    $0x2,%eax
c0100b74:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b79:	8b 00                	mov    (%eax),%eax
c0100b7b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b7f:	89 04 24             	mov    %eax,(%esp)
c0100b82:	e8 1e 50 00 00       	call   c0105ba5 <strcmp>
c0100b87:	85 c0                	test   %eax,%eax
c0100b89:	75 32                	jne    c0100bbd <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b8e:	89 d0                	mov    %edx,%eax
c0100b90:	01 c0                	add    %eax,%eax
c0100b92:	01 d0                	add    %edx,%eax
c0100b94:	c1 e0 02             	shl    $0x2,%eax
c0100b97:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b9c:	8b 40 08             	mov    0x8(%eax),%eax
c0100b9f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100ba2:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100ba5:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100ba8:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bac:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100baf:	83 c2 04             	add    $0x4,%edx
c0100bb2:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bb6:	89 0c 24             	mov    %ecx,(%esp)
c0100bb9:	ff d0                	call   *%eax
c0100bbb:	eb 24                	jmp    c0100be1 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bbd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bc4:	83 f8 02             	cmp    $0x2,%eax
c0100bc7:	76 9c                	jbe    c0100b65 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bc9:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bd0:	c7 04 24 f3 61 10 c0 	movl   $0xc01061f3,(%esp)
c0100bd7:	e8 60 f7 ff ff       	call   c010033c <cprintf>
    return 0;
c0100bdc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100be1:	c9                   	leave  
c0100be2:	c3                   	ret    

c0100be3 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100be3:	55                   	push   %ebp
c0100be4:	89 e5                	mov    %esp,%ebp
c0100be6:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100be9:	c7 04 24 0c 62 10 c0 	movl   $0xc010620c,(%esp)
c0100bf0:	e8 47 f7 ff ff       	call   c010033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100bf5:	c7 04 24 34 62 10 c0 	movl   $0xc0106234,(%esp)
c0100bfc:	e8 3b f7 ff ff       	call   c010033c <cprintf>

    if (tf != NULL) {
c0100c01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c05:	74 0b                	je     c0100c12 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c07:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c0a:	89 04 24             	mov    %eax,(%esp)
c0100c0d:	e8 56 0e 00 00       	call   c0101a68 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c12:	c7 04 24 59 62 10 c0 	movl   $0xc0106259,(%esp)
c0100c19:	e8 15 f6 ff ff       	call   c0100233 <readline>
c0100c1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c25:	74 18                	je     c0100c3f <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c27:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c2a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c31:	89 04 24             	mov    %eax,(%esp)
c0100c34:	e8 f8 fe ff ff       	call   c0100b31 <runcmd>
c0100c39:	85 c0                	test   %eax,%eax
c0100c3b:	79 02                	jns    c0100c3f <kmonitor+0x5c>
                break;
c0100c3d:	eb 02                	jmp    c0100c41 <kmonitor+0x5e>
            }
        }
    }
c0100c3f:	eb d1                	jmp    c0100c12 <kmonitor+0x2f>
}
c0100c41:	c9                   	leave  
c0100c42:	c3                   	ret    

c0100c43 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c43:	55                   	push   %ebp
c0100c44:	89 e5                	mov    %esp,%ebp
c0100c46:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c50:	eb 3f                	jmp    c0100c91 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c52:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c55:	89 d0                	mov    %edx,%eax
c0100c57:	01 c0                	add    %eax,%eax
c0100c59:	01 d0                	add    %edx,%eax
c0100c5b:	c1 e0 02             	shl    $0x2,%eax
c0100c5e:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c63:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c66:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c69:	89 d0                	mov    %edx,%eax
c0100c6b:	01 c0                	add    %eax,%eax
c0100c6d:	01 d0                	add    %edx,%eax
c0100c6f:	c1 e0 02             	shl    $0x2,%eax
c0100c72:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c77:	8b 00                	mov    (%eax),%eax
c0100c79:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c7d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c81:	c7 04 24 5d 62 10 c0 	movl   $0xc010625d,(%esp)
c0100c88:	e8 af f6 ff ff       	call   c010033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c8d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c94:	83 f8 02             	cmp    $0x2,%eax
c0100c97:	76 b9                	jbe    c0100c52 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100c99:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c9e:	c9                   	leave  
c0100c9f:	c3                   	ret    

c0100ca0 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100ca0:	55                   	push   %ebp
c0100ca1:	89 e5                	mov    %esp,%ebp
c0100ca3:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100ca6:	e8 c5 fb ff ff       	call   c0100870 <print_kerninfo>
    return 0;
c0100cab:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb0:	c9                   	leave  
c0100cb1:	c3                   	ret    

c0100cb2 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cb2:	55                   	push   %ebp
c0100cb3:	89 e5                	mov    %esp,%ebp
c0100cb5:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cb8:	e8 fd fc ff ff       	call   c01009ba <print_stackframe>
    return 0;
c0100cbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc2:	c9                   	leave  
c0100cc3:	c3                   	ret    

c0100cc4 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cc4:	55                   	push   %ebp
c0100cc5:	89 e5                	mov    %esp,%ebp
c0100cc7:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cca:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c0100ccf:	85 c0                	test   %eax,%eax
c0100cd1:	74 02                	je     c0100cd5 <__panic+0x11>
        goto panic_dead;
c0100cd3:	eb 48                	jmp    c0100d1d <__panic+0x59>
    }
    is_panic = 1;
c0100cd5:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c0100cdc:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cdf:	8d 45 14             	lea    0x14(%ebp),%eax
c0100ce2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100ce5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100ce8:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cec:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cef:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cf3:	c7 04 24 66 62 10 c0 	movl   $0xc0106266,(%esp)
c0100cfa:	e8 3d f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d02:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d06:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d09:	89 04 24             	mov    %eax,(%esp)
c0100d0c:	e8 f8 f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d11:	c7 04 24 82 62 10 c0 	movl   $0xc0106282,(%esp)
c0100d18:	e8 1f f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d1d:	e8 85 09 00 00       	call   c01016a7 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d22:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d29:	e8 b5 fe ff ff       	call   c0100be3 <kmonitor>
    }
c0100d2e:	eb f2                	jmp    c0100d22 <__panic+0x5e>

c0100d30 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d30:	55                   	push   %ebp
c0100d31:	89 e5                	mov    %esp,%ebp
c0100d33:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d36:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d39:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d3f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d43:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d46:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d4a:	c7 04 24 84 62 10 c0 	movl   $0xc0106284,(%esp)
c0100d51:	e8 e6 f5 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d59:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d5d:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d60:	89 04 24             	mov    %eax,(%esp)
c0100d63:	e8 a1 f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d68:	c7 04 24 82 62 10 c0 	movl   $0xc0106282,(%esp)
c0100d6f:	e8 c8 f5 ff ff       	call   c010033c <cprintf>
    va_end(ap);
}
c0100d74:	c9                   	leave  
c0100d75:	c3                   	ret    

c0100d76 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d76:	55                   	push   %ebp
c0100d77:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d79:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c0100d7e:	5d                   	pop    %ebp
c0100d7f:	c3                   	ret    

c0100d80 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d80:	55                   	push   %ebp
c0100d81:	89 e5                	mov    %esp,%ebp
c0100d83:	83 ec 28             	sub    $0x28,%esp
c0100d86:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d8c:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d90:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d94:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d98:	ee                   	out    %al,(%dx)
c0100d99:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100d9f:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100da3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100da7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dab:	ee                   	out    %al,(%dx)
c0100dac:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100db2:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100db6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dba:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dbe:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dbf:	c7 05 6c 89 11 c0 00 	movl   $0x0,0xc011896c
c0100dc6:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dc9:	c7 04 24 a2 62 10 c0 	movl   $0xc01062a2,(%esp)
c0100dd0:	e8 67 f5 ff ff       	call   c010033c <cprintf>
    pic_enable(IRQ_TIMER);
c0100dd5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100ddc:	e8 24 09 00 00       	call   c0101705 <pic_enable>
}
c0100de1:	c9                   	leave  
c0100de2:	c3                   	ret    

c0100de3 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100de3:	55                   	push   %ebp
c0100de4:	89 e5                	mov    %esp,%ebp
c0100de6:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100de9:	9c                   	pushf  
c0100dea:	58                   	pop    %eax
c0100deb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100df1:	25 00 02 00 00       	and    $0x200,%eax
c0100df6:	85 c0                	test   %eax,%eax
c0100df8:	74 0c                	je     c0100e06 <__intr_save+0x23>
        intr_disable();
c0100dfa:	e8 a8 08 00 00       	call   c01016a7 <intr_disable>
        return 1;
c0100dff:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e04:	eb 05                	jmp    c0100e0b <__intr_save+0x28>
    }
    return 0;
c0100e06:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e0b:	c9                   	leave  
c0100e0c:	c3                   	ret    

c0100e0d <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e0d:	55                   	push   %ebp
c0100e0e:	89 e5                	mov    %esp,%ebp
c0100e10:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e17:	74 05                	je     c0100e1e <__intr_restore+0x11>
        intr_enable();
c0100e19:	e8 83 08 00 00       	call   c01016a1 <intr_enable>
    }
}
c0100e1e:	c9                   	leave  
c0100e1f:	c3                   	ret    

c0100e20 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e20:	55                   	push   %ebp
c0100e21:	89 e5                	mov    %esp,%ebp
c0100e23:	83 ec 10             	sub    $0x10,%esp
c0100e26:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e2c:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e30:	89 c2                	mov    %eax,%edx
c0100e32:	ec                   	in     (%dx),%al
c0100e33:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e36:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e3c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e40:	89 c2                	mov    %eax,%edx
c0100e42:	ec                   	in     (%dx),%al
c0100e43:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e46:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e4c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e50:	89 c2                	mov    %eax,%edx
c0100e52:	ec                   	in     (%dx),%al
c0100e53:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e56:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e5c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e60:	89 c2                	mov    %eax,%edx
c0100e62:	ec                   	in     (%dx),%al
c0100e63:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e66:	c9                   	leave  
c0100e67:	c3                   	ret    

c0100e68 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e68:	55                   	push   %ebp
c0100e69:	89 e5                	mov    %esp,%ebp
c0100e6b:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e6e:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e75:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e78:	0f b7 00             	movzwl (%eax),%eax
c0100e7b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e82:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e87:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8a:	0f b7 00             	movzwl (%eax),%eax
c0100e8d:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e91:	74 12                	je     c0100ea5 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e93:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e9a:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100ea1:	b4 03 
c0100ea3:	eb 13                	jmp    c0100eb8 <cga_init+0x50>
    } else {
        *cp = was;
c0100ea5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea8:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100eac:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eaf:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100eb6:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100eb8:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ebf:	0f b7 c0             	movzwl %ax,%eax
c0100ec2:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ec6:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100eca:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ece:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ed2:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ed3:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100eda:	83 c0 01             	add    $0x1,%eax
c0100edd:	0f b7 c0             	movzwl %ax,%eax
c0100ee0:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ee4:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ee8:	89 c2                	mov    %eax,%edx
c0100eea:	ec                   	in     (%dx),%al
c0100eeb:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100eee:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ef2:	0f b6 c0             	movzbl %al,%eax
c0100ef5:	c1 e0 08             	shl    $0x8,%eax
c0100ef8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100efb:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f02:	0f b7 c0             	movzwl %ax,%eax
c0100f05:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f09:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f0d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f11:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f15:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f16:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f1d:	83 c0 01             	add    $0x1,%eax
c0100f20:	0f b7 c0             	movzwl %ax,%eax
c0100f23:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f27:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f2b:	89 c2                	mov    %eax,%edx
c0100f2d:	ec                   	in     (%dx),%al
c0100f2e:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f31:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f35:	0f b6 c0             	movzbl %al,%eax
c0100f38:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f3e:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f46:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f4c:	c9                   	leave  
c0100f4d:	c3                   	ret    

c0100f4e <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f4e:	55                   	push   %ebp
c0100f4f:	89 e5                	mov    %esp,%ebp
c0100f51:	83 ec 48             	sub    $0x48,%esp
c0100f54:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f5a:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f5e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f62:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f66:	ee                   	out    %al,(%dx)
c0100f67:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f6d:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f71:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f75:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f79:	ee                   	out    %al,(%dx)
c0100f7a:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f80:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f84:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f88:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f8c:	ee                   	out    %al,(%dx)
c0100f8d:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100f93:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100f97:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f9b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f9f:	ee                   	out    %al,(%dx)
c0100fa0:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fa6:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100faa:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fae:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fb2:	ee                   	out    %al,(%dx)
c0100fb3:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fb9:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fbd:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fc1:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fc5:	ee                   	out    %al,(%dx)
c0100fc6:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fcc:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fd0:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fd4:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fd8:	ee                   	out    %al,(%dx)
c0100fd9:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fdf:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100fe3:	89 c2                	mov    %eax,%edx
c0100fe5:	ec                   	in     (%dx),%al
c0100fe6:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100fe9:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100fed:	3c ff                	cmp    $0xff,%al
c0100fef:	0f 95 c0             	setne  %al
c0100ff2:	0f b6 c0             	movzbl %al,%eax
c0100ff5:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0100ffa:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101000:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101004:	89 c2                	mov    %eax,%edx
c0101006:	ec                   	in     (%dx),%al
c0101007:	88 45 d5             	mov    %al,-0x2b(%ebp)
c010100a:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101010:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101014:	89 c2                	mov    %eax,%edx
c0101016:	ec                   	in     (%dx),%al
c0101017:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010101a:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c010101f:	85 c0                	test   %eax,%eax
c0101021:	74 0c                	je     c010102f <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101023:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010102a:	e8 d6 06 00 00       	call   c0101705 <pic_enable>
    }
}
c010102f:	c9                   	leave  
c0101030:	c3                   	ret    

c0101031 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101031:	55                   	push   %ebp
c0101032:	89 e5                	mov    %esp,%ebp
c0101034:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101037:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010103e:	eb 09                	jmp    c0101049 <lpt_putc_sub+0x18>
        delay();
c0101040:	e8 db fd ff ff       	call   c0100e20 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101045:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101049:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c010104f:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101053:	89 c2                	mov    %eax,%edx
c0101055:	ec                   	in     (%dx),%al
c0101056:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101059:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010105d:	84 c0                	test   %al,%al
c010105f:	78 09                	js     c010106a <lpt_putc_sub+0x39>
c0101061:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101068:	7e d6                	jle    c0101040 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010106a:	8b 45 08             	mov    0x8(%ebp),%eax
c010106d:	0f b6 c0             	movzbl %al,%eax
c0101070:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101076:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101079:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010107d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101081:	ee                   	out    %al,(%dx)
c0101082:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101088:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010108c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101090:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101094:	ee                   	out    %al,(%dx)
c0101095:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c010109b:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c010109f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010a3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010a7:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010a8:	c9                   	leave  
c01010a9:	c3                   	ret    

c01010aa <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010aa:	55                   	push   %ebp
c01010ab:	89 e5                	mov    %esp,%ebp
c01010ad:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010b0:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010b4:	74 0d                	je     c01010c3 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01010b9:	89 04 24             	mov    %eax,(%esp)
c01010bc:	e8 70 ff ff ff       	call   c0101031 <lpt_putc_sub>
c01010c1:	eb 24                	jmp    c01010e7 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010c3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010ca:	e8 62 ff ff ff       	call   c0101031 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010cf:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010d6:	e8 56 ff ff ff       	call   c0101031 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010db:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010e2:	e8 4a ff ff ff       	call   c0101031 <lpt_putc_sub>
    }
}
c01010e7:	c9                   	leave  
c01010e8:	c3                   	ret    

c01010e9 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010e9:	55                   	push   %ebp
c01010ea:	89 e5                	mov    %esp,%ebp
c01010ec:	53                   	push   %ebx
c01010ed:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01010f3:	b0 00                	mov    $0x0,%al
c01010f5:	85 c0                	test   %eax,%eax
c01010f7:	75 07                	jne    c0101100 <cga_putc+0x17>
        c |= 0x0700;
c01010f9:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101100:	8b 45 08             	mov    0x8(%ebp),%eax
c0101103:	0f b6 c0             	movzbl %al,%eax
c0101106:	83 f8 0a             	cmp    $0xa,%eax
c0101109:	74 4c                	je     c0101157 <cga_putc+0x6e>
c010110b:	83 f8 0d             	cmp    $0xd,%eax
c010110e:	74 57                	je     c0101167 <cga_putc+0x7e>
c0101110:	83 f8 08             	cmp    $0x8,%eax
c0101113:	0f 85 88 00 00 00    	jne    c01011a1 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101119:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101120:	66 85 c0             	test   %ax,%ax
c0101123:	74 30                	je     c0101155 <cga_putc+0x6c>
            crt_pos --;
c0101125:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010112c:	83 e8 01             	sub    $0x1,%eax
c010112f:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101135:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c010113a:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c0101141:	0f b7 d2             	movzwl %dx,%edx
c0101144:	01 d2                	add    %edx,%edx
c0101146:	01 c2                	add    %eax,%edx
c0101148:	8b 45 08             	mov    0x8(%ebp),%eax
c010114b:	b0 00                	mov    $0x0,%al
c010114d:	83 c8 20             	or     $0x20,%eax
c0101150:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101153:	eb 72                	jmp    c01011c7 <cga_putc+0xde>
c0101155:	eb 70                	jmp    c01011c7 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101157:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010115e:	83 c0 50             	add    $0x50,%eax
c0101161:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101167:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c010116e:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c0101175:	0f b7 c1             	movzwl %cx,%eax
c0101178:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c010117e:	c1 e8 10             	shr    $0x10,%eax
c0101181:	89 c2                	mov    %eax,%edx
c0101183:	66 c1 ea 06          	shr    $0x6,%dx
c0101187:	89 d0                	mov    %edx,%eax
c0101189:	c1 e0 02             	shl    $0x2,%eax
c010118c:	01 d0                	add    %edx,%eax
c010118e:	c1 e0 04             	shl    $0x4,%eax
c0101191:	29 c1                	sub    %eax,%ecx
c0101193:	89 ca                	mov    %ecx,%edx
c0101195:	89 d8                	mov    %ebx,%eax
c0101197:	29 d0                	sub    %edx,%eax
c0101199:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c010119f:	eb 26                	jmp    c01011c7 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011a1:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c01011a7:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011ae:	8d 50 01             	lea    0x1(%eax),%edx
c01011b1:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c01011b8:	0f b7 c0             	movzwl %ax,%eax
c01011bb:	01 c0                	add    %eax,%eax
c01011bd:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01011c3:	66 89 02             	mov    %ax,(%edx)
        break;
c01011c6:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011c7:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011ce:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011d2:	76 5b                	jbe    c010122f <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011d4:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011d9:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011df:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011e4:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011eb:	00 
c01011ec:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011f0:	89 04 24             	mov    %eax,(%esp)
c01011f3:	e8 4a 4c 00 00       	call   c0105e42 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011f8:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01011ff:	eb 15                	jmp    c0101216 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101201:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101206:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101209:	01 d2                	add    %edx,%edx
c010120b:	01 d0                	add    %edx,%eax
c010120d:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101212:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101216:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010121d:	7e e2                	jle    c0101201 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c010121f:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101226:	83 e8 50             	sub    $0x50,%eax
c0101229:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010122f:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101236:	0f b7 c0             	movzwl %ax,%eax
c0101239:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010123d:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101241:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101245:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101249:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010124a:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101251:	66 c1 e8 08          	shr    $0x8,%ax
c0101255:	0f b6 c0             	movzbl %al,%eax
c0101258:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c010125f:	83 c2 01             	add    $0x1,%edx
c0101262:	0f b7 d2             	movzwl %dx,%edx
c0101265:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101269:	88 45 ed             	mov    %al,-0x13(%ebp)
c010126c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101270:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101274:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101275:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c010127c:	0f b7 c0             	movzwl %ax,%eax
c010127f:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101283:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101287:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010128b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010128f:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101290:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101297:	0f b6 c0             	movzbl %al,%eax
c010129a:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01012a1:	83 c2 01             	add    $0x1,%edx
c01012a4:	0f b7 d2             	movzwl %dx,%edx
c01012a7:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012ab:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012ae:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012b2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012b6:	ee                   	out    %al,(%dx)
}
c01012b7:	83 c4 34             	add    $0x34,%esp
c01012ba:	5b                   	pop    %ebx
c01012bb:	5d                   	pop    %ebp
c01012bc:	c3                   	ret    

c01012bd <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012bd:	55                   	push   %ebp
c01012be:	89 e5                	mov    %esp,%ebp
c01012c0:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012ca:	eb 09                	jmp    c01012d5 <serial_putc_sub+0x18>
        delay();
c01012cc:	e8 4f fb ff ff       	call   c0100e20 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012d1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012d5:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012db:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012df:	89 c2                	mov    %eax,%edx
c01012e1:	ec                   	in     (%dx),%al
c01012e2:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012e5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012e9:	0f b6 c0             	movzbl %al,%eax
c01012ec:	83 e0 20             	and    $0x20,%eax
c01012ef:	85 c0                	test   %eax,%eax
c01012f1:	75 09                	jne    c01012fc <serial_putc_sub+0x3f>
c01012f3:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01012fa:	7e d0                	jle    c01012cc <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c01012fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01012ff:	0f b6 c0             	movzbl %al,%eax
c0101302:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101308:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010130b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010130f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101313:	ee                   	out    %al,(%dx)
}
c0101314:	c9                   	leave  
c0101315:	c3                   	ret    

c0101316 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101316:	55                   	push   %ebp
c0101317:	89 e5                	mov    %esp,%ebp
c0101319:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010131c:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101320:	74 0d                	je     c010132f <serial_putc+0x19>
        serial_putc_sub(c);
c0101322:	8b 45 08             	mov    0x8(%ebp),%eax
c0101325:	89 04 24             	mov    %eax,(%esp)
c0101328:	e8 90 ff ff ff       	call   c01012bd <serial_putc_sub>
c010132d:	eb 24                	jmp    c0101353 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c010132f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101336:	e8 82 ff ff ff       	call   c01012bd <serial_putc_sub>
        serial_putc_sub(' ');
c010133b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101342:	e8 76 ff ff ff       	call   c01012bd <serial_putc_sub>
        serial_putc_sub('\b');
c0101347:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010134e:	e8 6a ff ff ff       	call   c01012bd <serial_putc_sub>
    }
}
c0101353:	c9                   	leave  
c0101354:	c3                   	ret    

c0101355 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101355:	55                   	push   %ebp
c0101356:	89 e5                	mov    %esp,%ebp
c0101358:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010135b:	eb 33                	jmp    c0101390 <cons_intr+0x3b>
        if (c != 0) {
c010135d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101361:	74 2d                	je     c0101390 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101363:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101368:	8d 50 01             	lea    0x1(%eax),%edx
c010136b:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c0101371:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101374:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010137a:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010137f:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101384:	75 0a                	jne    c0101390 <cons_intr+0x3b>
                cons.wpos = 0;
c0101386:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c010138d:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101390:	8b 45 08             	mov    0x8(%ebp),%eax
c0101393:	ff d0                	call   *%eax
c0101395:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101398:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c010139c:	75 bf                	jne    c010135d <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c010139e:	c9                   	leave  
c010139f:	c3                   	ret    

c01013a0 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013a0:	55                   	push   %ebp
c01013a1:	89 e5                	mov    %esp,%ebp
c01013a3:	83 ec 10             	sub    $0x10,%esp
c01013a6:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013ac:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013b0:	89 c2                	mov    %eax,%edx
c01013b2:	ec                   	in     (%dx),%al
c01013b3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013b6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013ba:	0f b6 c0             	movzbl %al,%eax
c01013bd:	83 e0 01             	and    $0x1,%eax
c01013c0:	85 c0                	test   %eax,%eax
c01013c2:	75 07                	jne    c01013cb <serial_proc_data+0x2b>
        return -1;
c01013c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013c9:	eb 2a                	jmp    c01013f5 <serial_proc_data+0x55>
c01013cb:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013d1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013d5:	89 c2                	mov    %eax,%edx
c01013d7:	ec                   	in     (%dx),%al
c01013d8:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013db:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013df:	0f b6 c0             	movzbl %al,%eax
c01013e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013e5:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013e9:	75 07                	jne    c01013f2 <serial_proc_data+0x52>
        c = '\b';
c01013eb:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013f5:	c9                   	leave  
c01013f6:	c3                   	ret    

c01013f7 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013f7:	55                   	push   %ebp
c01013f8:	89 e5                	mov    %esp,%ebp
c01013fa:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c01013fd:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101402:	85 c0                	test   %eax,%eax
c0101404:	74 0c                	je     c0101412 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101406:	c7 04 24 a0 13 10 c0 	movl   $0xc01013a0,(%esp)
c010140d:	e8 43 ff ff ff       	call   c0101355 <cons_intr>
    }
}
c0101412:	c9                   	leave  
c0101413:	c3                   	ret    

c0101414 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101414:	55                   	push   %ebp
c0101415:	89 e5                	mov    %esp,%ebp
c0101417:	83 ec 38             	sub    $0x38,%esp
c010141a:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101420:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101424:	89 c2                	mov    %eax,%edx
c0101426:	ec                   	in     (%dx),%al
c0101427:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010142a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010142e:	0f b6 c0             	movzbl %al,%eax
c0101431:	83 e0 01             	and    $0x1,%eax
c0101434:	85 c0                	test   %eax,%eax
c0101436:	75 0a                	jne    c0101442 <kbd_proc_data+0x2e>
        return -1;
c0101438:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010143d:	e9 59 01 00 00       	jmp    c010159b <kbd_proc_data+0x187>
c0101442:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101448:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010144c:	89 c2                	mov    %eax,%edx
c010144e:	ec                   	in     (%dx),%al
c010144f:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101452:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101456:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101459:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010145d:	75 17                	jne    c0101476 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c010145f:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101464:	83 c8 40             	or     $0x40,%eax
c0101467:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c010146c:	b8 00 00 00 00       	mov    $0x0,%eax
c0101471:	e9 25 01 00 00       	jmp    c010159b <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101476:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010147a:	84 c0                	test   %al,%al
c010147c:	79 47                	jns    c01014c5 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010147e:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101483:	83 e0 40             	and    $0x40,%eax
c0101486:	85 c0                	test   %eax,%eax
c0101488:	75 09                	jne    c0101493 <kbd_proc_data+0x7f>
c010148a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010148e:	83 e0 7f             	and    $0x7f,%eax
c0101491:	eb 04                	jmp    c0101497 <kbd_proc_data+0x83>
c0101493:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101497:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c010149a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010149e:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014a5:	83 c8 40             	or     $0x40,%eax
c01014a8:	0f b6 c0             	movzbl %al,%eax
c01014ab:	f7 d0                	not    %eax
c01014ad:	89 c2                	mov    %eax,%edx
c01014af:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014b4:	21 d0                	and    %edx,%eax
c01014b6:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01014bb:	b8 00 00 00 00       	mov    $0x0,%eax
c01014c0:	e9 d6 00 00 00       	jmp    c010159b <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014c5:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014ca:	83 e0 40             	and    $0x40,%eax
c01014cd:	85 c0                	test   %eax,%eax
c01014cf:	74 11                	je     c01014e2 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014d1:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014d5:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014da:	83 e0 bf             	and    $0xffffffbf,%eax
c01014dd:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014e2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014e6:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014ed:	0f b6 d0             	movzbl %al,%edx
c01014f0:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014f5:	09 d0                	or     %edx,%eax
c01014f7:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c01014fc:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101500:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c0101507:	0f b6 d0             	movzbl %al,%edx
c010150a:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010150f:	31 d0                	xor    %edx,%eax
c0101511:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101516:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010151b:	83 e0 03             	and    $0x3,%eax
c010151e:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c0101525:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101529:	01 d0                	add    %edx,%eax
c010152b:	0f b6 00             	movzbl (%eax),%eax
c010152e:	0f b6 c0             	movzbl %al,%eax
c0101531:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101534:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101539:	83 e0 08             	and    $0x8,%eax
c010153c:	85 c0                	test   %eax,%eax
c010153e:	74 22                	je     c0101562 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101540:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101544:	7e 0c                	jle    c0101552 <kbd_proc_data+0x13e>
c0101546:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010154a:	7f 06                	jg     c0101552 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010154c:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101550:	eb 10                	jmp    c0101562 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101552:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101556:	7e 0a                	jle    c0101562 <kbd_proc_data+0x14e>
c0101558:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010155c:	7f 04                	jg     c0101562 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010155e:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101562:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101567:	f7 d0                	not    %eax
c0101569:	83 e0 06             	and    $0x6,%eax
c010156c:	85 c0                	test   %eax,%eax
c010156e:	75 28                	jne    c0101598 <kbd_proc_data+0x184>
c0101570:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101577:	75 1f                	jne    c0101598 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101579:	c7 04 24 bd 62 10 c0 	movl   $0xc01062bd,(%esp)
c0101580:	e8 b7 ed ff ff       	call   c010033c <cprintf>
c0101585:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010158b:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010158f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101593:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101597:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101598:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010159b:	c9                   	leave  
c010159c:	c3                   	ret    

c010159d <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010159d:	55                   	push   %ebp
c010159e:	89 e5                	mov    %esp,%ebp
c01015a0:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015a3:	c7 04 24 14 14 10 c0 	movl   $0xc0101414,(%esp)
c01015aa:	e8 a6 fd ff ff       	call   c0101355 <cons_intr>
}
c01015af:	c9                   	leave  
c01015b0:	c3                   	ret    

c01015b1 <kbd_init>:

static void
kbd_init(void) {
c01015b1:	55                   	push   %ebp
c01015b2:	89 e5                	mov    %esp,%ebp
c01015b4:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015b7:	e8 e1 ff ff ff       	call   c010159d <kbd_intr>
    pic_enable(IRQ_KBD);
c01015bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015c3:	e8 3d 01 00 00       	call   c0101705 <pic_enable>
}
c01015c8:	c9                   	leave  
c01015c9:	c3                   	ret    

c01015ca <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015ca:	55                   	push   %ebp
c01015cb:	89 e5                	mov    %esp,%ebp
c01015cd:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015d0:	e8 93 f8 ff ff       	call   c0100e68 <cga_init>
    serial_init();
c01015d5:	e8 74 f9 ff ff       	call   c0100f4e <serial_init>
    kbd_init();
c01015da:	e8 d2 ff ff ff       	call   c01015b1 <kbd_init>
    if (!serial_exists) {
c01015df:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015e4:	85 c0                	test   %eax,%eax
c01015e6:	75 0c                	jne    c01015f4 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015e8:	c7 04 24 c9 62 10 c0 	movl   $0xc01062c9,(%esp)
c01015ef:	e8 48 ed ff ff       	call   c010033c <cprintf>
    }
}
c01015f4:	c9                   	leave  
c01015f5:	c3                   	ret    

c01015f6 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015f6:	55                   	push   %ebp
c01015f7:	89 e5                	mov    %esp,%ebp
c01015f9:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01015fc:	e8 e2 f7 ff ff       	call   c0100de3 <__intr_save>
c0101601:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101604:	8b 45 08             	mov    0x8(%ebp),%eax
c0101607:	89 04 24             	mov    %eax,(%esp)
c010160a:	e8 9b fa ff ff       	call   c01010aa <lpt_putc>
        cga_putc(c);
c010160f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101612:	89 04 24             	mov    %eax,(%esp)
c0101615:	e8 cf fa ff ff       	call   c01010e9 <cga_putc>
        serial_putc(c);
c010161a:	8b 45 08             	mov    0x8(%ebp),%eax
c010161d:	89 04 24             	mov    %eax,(%esp)
c0101620:	e8 f1 fc ff ff       	call   c0101316 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101625:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101628:	89 04 24             	mov    %eax,(%esp)
c010162b:	e8 dd f7 ff ff       	call   c0100e0d <__intr_restore>
}
c0101630:	c9                   	leave  
c0101631:	c3                   	ret    

c0101632 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101632:	55                   	push   %ebp
c0101633:	89 e5                	mov    %esp,%ebp
c0101635:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101638:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010163f:	e8 9f f7 ff ff       	call   c0100de3 <__intr_save>
c0101644:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101647:	e8 ab fd ff ff       	call   c01013f7 <serial_intr>
        kbd_intr();
c010164c:	e8 4c ff ff ff       	call   c010159d <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101651:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c0101657:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010165c:	39 c2                	cmp    %eax,%edx
c010165e:	74 31                	je     c0101691 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101660:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101665:	8d 50 01             	lea    0x1(%eax),%edx
c0101668:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c010166e:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c0101675:	0f b6 c0             	movzbl %al,%eax
c0101678:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010167b:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101680:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101685:	75 0a                	jne    c0101691 <cons_getc+0x5f>
                cons.rpos = 0;
c0101687:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c010168e:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101691:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101694:	89 04 24             	mov    %eax,(%esp)
c0101697:	e8 71 f7 ff ff       	call   c0100e0d <__intr_restore>
    return c;
c010169c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010169f:	c9                   	leave  
c01016a0:	c3                   	ret    

c01016a1 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016a1:	55                   	push   %ebp
c01016a2:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016a4:	fb                   	sti    
    sti();
}
c01016a5:	5d                   	pop    %ebp
c01016a6:	c3                   	ret    

c01016a7 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016a7:	55                   	push   %ebp
c01016a8:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016aa:	fa                   	cli    
    cli();
}
c01016ab:	5d                   	pop    %ebp
c01016ac:	c3                   	ret    

c01016ad <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016ad:	55                   	push   %ebp
c01016ae:	89 e5                	mov    %esp,%ebp
c01016b0:	83 ec 14             	sub    $0x14,%esp
c01016b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01016b6:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016ba:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016be:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016c4:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016c9:	85 c0                	test   %eax,%eax
c01016cb:	74 36                	je     c0101703 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016cd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016d1:	0f b6 c0             	movzbl %al,%eax
c01016d4:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016da:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016dd:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016e1:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016e5:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016e6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016ea:	66 c1 e8 08          	shr    $0x8,%ax
c01016ee:	0f b6 c0             	movzbl %al,%eax
c01016f1:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01016f7:	88 45 f9             	mov    %al,-0x7(%ebp)
c01016fa:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016fe:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101702:	ee                   	out    %al,(%dx)
    }
}
c0101703:	c9                   	leave  
c0101704:	c3                   	ret    

c0101705 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101705:	55                   	push   %ebp
c0101706:	89 e5                	mov    %esp,%ebp
c0101708:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010170b:	8b 45 08             	mov    0x8(%ebp),%eax
c010170e:	ba 01 00 00 00       	mov    $0x1,%edx
c0101713:	89 c1                	mov    %eax,%ecx
c0101715:	d3 e2                	shl    %cl,%edx
c0101717:	89 d0                	mov    %edx,%eax
c0101719:	f7 d0                	not    %eax
c010171b:	89 c2                	mov    %eax,%edx
c010171d:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101724:	21 d0                	and    %edx,%eax
c0101726:	0f b7 c0             	movzwl %ax,%eax
c0101729:	89 04 24             	mov    %eax,(%esp)
c010172c:	e8 7c ff ff ff       	call   c01016ad <pic_setmask>
}
c0101731:	c9                   	leave  
c0101732:	c3                   	ret    

c0101733 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101733:	55                   	push   %ebp
c0101734:	89 e5                	mov    %esp,%ebp
c0101736:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101739:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c0101740:	00 00 00 
c0101743:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101749:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c010174d:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101751:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101755:	ee                   	out    %al,(%dx)
c0101756:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010175c:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101760:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101764:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101768:	ee                   	out    %al,(%dx)
c0101769:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c010176f:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101773:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101777:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010177b:	ee                   	out    %al,(%dx)
c010177c:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0101782:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0101786:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010178a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010178e:	ee                   	out    %al,(%dx)
c010178f:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0101795:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c0101799:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010179d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017a1:	ee                   	out    %al,(%dx)
c01017a2:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017a8:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017ac:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017b0:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017b4:	ee                   	out    %al,(%dx)
c01017b5:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017bb:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017bf:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017c3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017c7:	ee                   	out    %al,(%dx)
c01017c8:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017ce:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017d2:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017d6:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017da:	ee                   	out    %al,(%dx)
c01017db:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017e1:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017e5:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017e9:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017ed:	ee                   	out    %al,(%dx)
c01017ee:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c01017f4:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c01017f8:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01017fc:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101800:	ee                   	out    %al,(%dx)
c0101801:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101807:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c010180b:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010180f:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101813:	ee                   	out    %al,(%dx)
c0101814:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010181a:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c010181e:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101822:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101826:	ee                   	out    %al,(%dx)
c0101827:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c010182d:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101831:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101835:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101839:	ee                   	out    %al,(%dx)
c010183a:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101840:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c0101844:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101848:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010184c:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010184d:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101854:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101858:	74 12                	je     c010186c <pic_init+0x139>
        pic_setmask(irq_mask);
c010185a:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101861:	0f b7 c0             	movzwl %ax,%eax
c0101864:	89 04 24             	mov    %eax,(%esp)
c0101867:	e8 41 fe ff ff       	call   c01016ad <pic_setmask>
    }
}
c010186c:	c9                   	leave  
c010186d:	c3                   	ret    

c010186e <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c010186e:	55                   	push   %ebp
c010186f:	89 e5                	mov    %esp,%ebp
c0101871:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101874:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010187b:	00 
c010187c:	c7 04 24 00 63 10 c0 	movl   $0xc0106300,(%esp)
c0101883:	e8 b4 ea ff ff       	call   c010033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c0101888:	c7 04 24 0a 63 10 c0 	movl   $0xc010630a,(%esp)
c010188f:	e8 a8 ea ff ff       	call   c010033c <cprintf>
    panic("EOT: kernel seems ok.");
c0101894:	c7 44 24 08 18 63 10 	movl   $0xc0106318,0x8(%esp)
c010189b:	c0 
c010189c:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c01018a3:	00 
c01018a4:	c7 04 24 2e 63 10 c0 	movl   $0xc010632e,(%esp)
c01018ab:	e8 14 f4 ff ff       	call   c0100cc4 <__panic>

c01018b0 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018b0:	55                   	push   %ebp
c01018b1:	89 e5                	mov    %esp,%ebp
c01018b3:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i;
	for(i = 0; i < sizeof(idt) / sizeof(struct gatedesc); ++i){
c01018b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018bd:	e9 c3 00 00 00       	jmp    c0101985 <idt_init+0xd5>
		SETGATE(idt[i],0,GD_KTEXT,__vectors[i],0);
c01018c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018c5:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018cc:	89 c2                	mov    %eax,%edx
c01018ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018d1:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018d8:	c0 
c01018d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018dc:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018e3:	c0 08 00 
c01018e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e9:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018f0:	c0 
c01018f1:	83 e2 e0             	and    $0xffffffe0,%edx
c01018f4:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018fe:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c0101905:	c0 
c0101906:	83 e2 1f             	and    $0x1f,%edx
c0101909:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c0101910:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101913:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010191a:	c0 
c010191b:	83 e2 f0             	and    $0xfffffff0,%edx
c010191e:	83 ca 0e             	or     $0xe,%edx
c0101921:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101928:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010192b:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101932:	c0 
c0101933:	83 e2 ef             	and    $0xffffffef,%edx
c0101936:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010193d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101940:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101947:	c0 
c0101948:	83 e2 9f             	and    $0xffffff9f,%edx
c010194b:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101952:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101955:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010195c:	c0 
c010195d:	83 ca 80             	or     $0xffffff80,%edx
c0101960:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101967:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010196a:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101971:	c1 e8 10             	shr    $0x10,%eax
c0101974:	89 c2                	mov    %eax,%edx
c0101976:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101979:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c0101980:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i;
	for(i = 0; i < sizeof(idt) / sizeof(struct gatedesc); ++i){
c0101981:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101985:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101988:	3d ff 00 00 00       	cmp    $0xff,%eax
c010198d:	0f 86 2f ff ff ff    	jbe    c01018c2 <idt_init+0x12>
		SETGATE(idt[i],0,GD_KTEXT,__vectors[i],0);
	}
	SETGATE(idt[T_SWITCH_TOK],0,GD_KTEXT,__vectors[T_SWITCH_TOK],3);
c0101993:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c0101998:	66 a3 88 84 11 c0    	mov    %ax,0xc0118488
c010199e:	66 c7 05 8a 84 11 c0 	movw   $0x8,0xc011848a
c01019a5:	08 00 
c01019a7:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c01019ae:	83 e0 e0             	and    $0xffffffe0,%eax
c01019b1:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c01019b6:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c01019bd:	83 e0 1f             	and    $0x1f,%eax
c01019c0:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c01019c5:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019cc:	83 e0 f0             	and    $0xfffffff0,%eax
c01019cf:	83 c8 0e             	or     $0xe,%eax
c01019d2:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019d7:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019de:	83 e0 ef             	and    $0xffffffef,%eax
c01019e1:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019e6:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019ed:	83 c8 60             	or     $0x60,%eax
c01019f0:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019f5:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019fc:	83 c8 80             	or     $0xffffff80,%eax
c01019ff:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c0101a04:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c0101a09:	c1 e8 10             	shr    $0x10,%eax
c0101a0c:	66 a3 8e 84 11 c0    	mov    %ax,0xc011848e
c0101a12:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a19:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a1c:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
c0101a1f:	c9                   	leave  
c0101a20:	c3                   	ret    

c0101a21 <trapname>:

static const char *
trapname(int trapno) {
c0101a21:	55                   	push   %ebp
c0101a22:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a24:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a27:	83 f8 13             	cmp    $0x13,%eax
c0101a2a:	77 0c                	ja     c0101a38 <trapname+0x17>
        return excnames[trapno];
c0101a2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a2f:	8b 04 85 80 66 10 c0 	mov    -0x3fef9980(,%eax,4),%eax
c0101a36:	eb 18                	jmp    c0101a50 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a38:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a3c:	7e 0d                	jle    c0101a4b <trapname+0x2a>
c0101a3e:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a42:	7f 07                	jg     c0101a4b <trapname+0x2a>
        return "Hardware Interrupt";
c0101a44:	b8 3f 63 10 c0       	mov    $0xc010633f,%eax
c0101a49:	eb 05                	jmp    c0101a50 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a4b:	b8 52 63 10 c0       	mov    $0xc0106352,%eax
}
c0101a50:	5d                   	pop    %ebp
c0101a51:	c3                   	ret    

c0101a52 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a52:	55                   	push   %ebp
c0101a53:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a55:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a58:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a5c:	66 83 f8 08          	cmp    $0x8,%ax
c0101a60:	0f 94 c0             	sete   %al
c0101a63:	0f b6 c0             	movzbl %al,%eax
}
c0101a66:	5d                   	pop    %ebp
c0101a67:	c3                   	ret    

c0101a68 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a68:	55                   	push   %ebp
c0101a69:	89 e5                	mov    %esp,%ebp
c0101a6b:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101a6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a71:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a75:	c7 04 24 93 63 10 c0 	movl   $0xc0106393,(%esp)
c0101a7c:	e8 bb e8 ff ff       	call   c010033c <cprintf>
    print_regs(&tf->tf_regs);
c0101a81:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a84:	89 04 24             	mov    %eax,(%esp)
c0101a87:	e8 a1 01 00 00       	call   c0101c2d <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a8f:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a93:	0f b7 c0             	movzwl %ax,%eax
c0101a96:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a9a:	c7 04 24 a4 63 10 c0 	movl   $0xc01063a4,(%esp)
c0101aa1:	e8 96 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101aa6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa9:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101aad:	0f b7 c0             	movzwl %ax,%eax
c0101ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ab4:	c7 04 24 b7 63 10 c0 	movl   $0xc01063b7,(%esp)
c0101abb:	e8 7c e8 ff ff       	call   c010033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101ac0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac3:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101ac7:	0f b7 c0             	movzwl %ax,%eax
c0101aca:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ace:	c7 04 24 ca 63 10 c0 	movl   $0xc01063ca,(%esp)
c0101ad5:	e8 62 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101ada:	8b 45 08             	mov    0x8(%ebp),%eax
c0101add:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101ae1:	0f b7 c0             	movzwl %ax,%eax
c0101ae4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ae8:	c7 04 24 dd 63 10 c0 	movl   $0xc01063dd,(%esp)
c0101aef:	e8 48 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101af4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101af7:	8b 40 30             	mov    0x30(%eax),%eax
c0101afa:	89 04 24             	mov    %eax,(%esp)
c0101afd:	e8 1f ff ff ff       	call   c0101a21 <trapname>
c0101b02:	8b 55 08             	mov    0x8(%ebp),%edx
c0101b05:	8b 52 30             	mov    0x30(%edx),%edx
c0101b08:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101b0c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101b10:	c7 04 24 f0 63 10 c0 	movl   $0xc01063f0,(%esp)
c0101b17:	e8 20 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b1f:	8b 40 34             	mov    0x34(%eax),%eax
c0101b22:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b26:	c7 04 24 02 64 10 c0 	movl   $0xc0106402,(%esp)
c0101b2d:	e8 0a e8 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b32:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b35:	8b 40 38             	mov    0x38(%eax),%eax
c0101b38:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b3c:	c7 04 24 11 64 10 c0 	movl   $0xc0106411,(%esp)
c0101b43:	e8 f4 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b48:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b4b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b4f:	0f b7 c0             	movzwl %ax,%eax
c0101b52:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b56:	c7 04 24 20 64 10 c0 	movl   $0xc0106420,(%esp)
c0101b5d:	e8 da e7 ff ff       	call   c010033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b62:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b65:	8b 40 40             	mov    0x40(%eax),%eax
c0101b68:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b6c:	c7 04 24 33 64 10 c0 	movl   $0xc0106433,(%esp)
c0101b73:	e8 c4 e7 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b7f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b86:	eb 3e                	jmp    c0101bc6 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b88:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b8b:	8b 50 40             	mov    0x40(%eax),%edx
c0101b8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b91:	21 d0                	and    %edx,%eax
c0101b93:	85 c0                	test   %eax,%eax
c0101b95:	74 28                	je     c0101bbf <print_trapframe+0x157>
c0101b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b9a:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101ba1:	85 c0                	test   %eax,%eax
c0101ba3:	74 1a                	je     c0101bbf <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ba8:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101baf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bb3:	c7 04 24 42 64 10 c0 	movl   $0xc0106442,(%esp)
c0101bba:	e8 7d e7 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bbf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101bc3:	d1 65 f0             	shll   -0x10(%ebp)
c0101bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bc9:	83 f8 17             	cmp    $0x17,%eax
c0101bcc:	76 ba                	jbe    c0101b88 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101bce:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd1:	8b 40 40             	mov    0x40(%eax),%eax
c0101bd4:	25 00 30 00 00       	and    $0x3000,%eax
c0101bd9:	c1 e8 0c             	shr    $0xc,%eax
c0101bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101be0:	c7 04 24 46 64 10 c0 	movl   $0xc0106446,(%esp)
c0101be7:	e8 50 e7 ff ff       	call   c010033c <cprintf>

    if (!trap_in_kernel(tf)) {
c0101bec:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bef:	89 04 24             	mov    %eax,(%esp)
c0101bf2:	e8 5b fe ff ff       	call   c0101a52 <trap_in_kernel>
c0101bf7:	85 c0                	test   %eax,%eax
c0101bf9:	75 30                	jne    c0101c2b <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101bfb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bfe:	8b 40 44             	mov    0x44(%eax),%eax
c0101c01:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c05:	c7 04 24 4f 64 10 c0 	movl   $0xc010644f,(%esp)
c0101c0c:	e8 2b e7 ff ff       	call   c010033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c11:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c14:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c18:	0f b7 c0             	movzwl %ax,%eax
c0101c1b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c1f:	c7 04 24 5e 64 10 c0 	movl   $0xc010645e,(%esp)
c0101c26:	e8 11 e7 ff ff       	call   c010033c <cprintf>
    }
}
c0101c2b:	c9                   	leave  
c0101c2c:	c3                   	ret    

c0101c2d <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c2d:	55                   	push   %ebp
c0101c2e:	89 e5                	mov    %esp,%ebp
c0101c30:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c33:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c36:	8b 00                	mov    (%eax),%eax
c0101c38:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c3c:	c7 04 24 71 64 10 c0 	movl   $0xc0106471,(%esp)
c0101c43:	e8 f4 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c48:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c4b:	8b 40 04             	mov    0x4(%eax),%eax
c0101c4e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c52:	c7 04 24 80 64 10 c0 	movl   $0xc0106480,(%esp)
c0101c59:	e8 de e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c61:	8b 40 08             	mov    0x8(%eax),%eax
c0101c64:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c68:	c7 04 24 8f 64 10 c0 	movl   $0xc010648f,(%esp)
c0101c6f:	e8 c8 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c74:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c77:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c7a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c7e:	c7 04 24 9e 64 10 c0 	movl   $0xc010649e,(%esp)
c0101c85:	e8 b2 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c8d:	8b 40 10             	mov    0x10(%eax),%eax
c0101c90:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c94:	c7 04 24 ad 64 10 c0 	movl   $0xc01064ad,(%esp)
c0101c9b:	e8 9c e6 ff ff       	call   c010033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101ca0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca3:	8b 40 14             	mov    0x14(%eax),%eax
c0101ca6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101caa:	c7 04 24 bc 64 10 c0 	movl   $0xc01064bc,(%esp)
c0101cb1:	e8 86 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101cb6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cb9:	8b 40 18             	mov    0x18(%eax),%eax
c0101cbc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc0:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0101cc7:	e8 70 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101ccc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ccf:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cd2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cd6:	c7 04 24 da 64 10 c0 	movl   $0xc01064da,(%esp)
c0101cdd:	e8 5a e6 ff ff       	call   c010033c <cprintf>
}
c0101ce2:	c9                   	leave  
c0101ce3:	c3                   	ret    

c0101ce4 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101ce4:	55                   	push   %ebp
c0101ce5:	89 e5                	mov    %esp,%ebp
c0101ce7:	83 ec 28             	sub    $0x28,%esp
    char c;
    static int tick_count = 0;
    switch (tf->tf_trapno) {
c0101cea:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ced:	8b 40 30             	mov    0x30(%eax),%eax
c0101cf0:	83 f8 2f             	cmp    $0x2f,%eax
c0101cf3:	77 21                	ja     c0101d16 <trap_dispatch+0x32>
c0101cf5:	83 f8 2e             	cmp    $0x2e,%eax
c0101cf8:	0f 83 15 01 00 00    	jae    c0101e13 <trap_dispatch+0x12f>
c0101cfe:	83 f8 21             	cmp    $0x21,%eax
c0101d01:	0f 84 92 00 00 00    	je     c0101d99 <trap_dispatch+0xb5>
c0101d07:	83 f8 24             	cmp    $0x24,%eax
c0101d0a:	74 67                	je     c0101d73 <trap_dispatch+0x8f>
c0101d0c:	83 f8 20             	cmp    $0x20,%eax
c0101d0f:	74 16                	je     c0101d27 <trap_dispatch+0x43>
c0101d11:	e9 c5 00 00 00       	jmp    c0101ddb <trap_dispatch+0xf7>
c0101d16:	83 e8 78             	sub    $0x78,%eax
c0101d19:	83 f8 01             	cmp    $0x1,%eax
c0101d1c:	0f 87 b9 00 00 00    	ja     c0101ddb <trap_dispatch+0xf7>
c0101d22:	e9 98 00 00 00       	jmp    c0101dbf <trap_dispatch+0xdb>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    	if((++tick_count) % TICK_NUM == 0){
c0101d27:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0101d2c:	83 c0 01             	add    $0x1,%eax
c0101d2f:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
c0101d34:	8b 0d c0 88 11 c0    	mov    0xc01188c0,%ecx
c0101d3a:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d3f:	89 c8                	mov    %ecx,%eax
c0101d41:	f7 ea                	imul   %edx
c0101d43:	c1 fa 05             	sar    $0x5,%edx
c0101d46:	89 c8                	mov    %ecx,%eax
c0101d48:	c1 f8 1f             	sar    $0x1f,%eax
c0101d4b:	29 c2                	sub    %eax,%edx
c0101d4d:	89 d0                	mov    %edx,%eax
c0101d4f:	6b c0 64             	imul   $0x64,%eax,%eax
c0101d52:	29 c1                	sub    %eax,%ecx
c0101d54:	89 c8                	mov    %ecx,%eax
c0101d56:	85 c0                	test   %eax,%eax
c0101d58:	75 14                	jne    c0101d6e <trap_dispatch+0x8a>
        	print_ticks();
c0101d5a:	e8 0f fb ff ff       	call   c010186e <print_ticks>
        	tick_count = 0;
c0101d5f:	c7 05 c0 88 11 c0 00 	movl   $0x0,0xc01188c0
c0101d66:	00 00 00 
        }
        break;
c0101d69:	e9 a6 00 00 00       	jmp    c0101e14 <trap_dispatch+0x130>
c0101d6e:	e9 a1 00 00 00       	jmp    c0101e14 <trap_dispatch+0x130>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d73:	e8 ba f8 ff ff       	call   c0101632 <cons_getc>
c0101d78:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d7b:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d7f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d83:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d87:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d8b:	c7 04 24 e9 64 10 c0 	movl   $0xc01064e9,(%esp)
c0101d92:	e8 a5 e5 ff ff       	call   c010033c <cprintf>
        break;
c0101d97:	eb 7b                	jmp    c0101e14 <trap_dispatch+0x130>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d99:	e8 94 f8 ff ff       	call   c0101632 <cons_getc>
c0101d9e:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101da1:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101da5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101da9:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101dad:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101db1:	c7 04 24 fb 64 10 c0 	movl   $0xc01064fb,(%esp)
c0101db8:	e8 7f e5 ff ff       	call   c010033c <cprintf>
        break;
c0101dbd:	eb 55                	jmp    c0101e14 <trap_dispatch+0x130>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101dbf:	c7 44 24 08 0a 65 10 	movl   $0xc010650a,0x8(%esp)
c0101dc6:	c0 
c0101dc7:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
c0101dce:	00 
c0101dcf:	c7 04 24 2e 63 10 c0 	movl   $0xc010632e,(%esp)
c0101dd6:	e8 e9 ee ff ff       	call   c0100cc4 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101ddb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dde:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101de2:	0f b7 c0             	movzwl %ax,%eax
c0101de5:	83 e0 03             	and    $0x3,%eax
c0101de8:	85 c0                	test   %eax,%eax
c0101dea:	75 28                	jne    c0101e14 <trap_dispatch+0x130>
            print_trapframe(tf);
c0101dec:	8b 45 08             	mov    0x8(%ebp),%eax
c0101def:	89 04 24             	mov    %eax,(%esp)
c0101df2:	e8 71 fc ff ff       	call   c0101a68 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101df7:	c7 44 24 08 1a 65 10 	movl   $0xc010651a,0x8(%esp)
c0101dfe:	c0 
c0101dff:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c0101e06:	00 
c0101e07:	c7 04 24 2e 63 10 c0 	movl   $0xc010632e,(%esp)
c0101e0e:	e8 b1 ee ff ff       	call   c0100cc4 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101e13:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101e14:	c9                   	leave  
c0101e15:	c3                   	ret    

c0101e16 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101e16:	55                   	push   %ebp
c0101e17:	89 e5                	mov    %esp,%ebp
c0101e19:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101e1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e1f:	89 04 24             	mov    %eax,(%esp)
c0101e22:	e8 bd fe ff ff       	call   c0101ce4 <trap_dispatch>
}
c0101e27:	c9                   	leave  
c0101e28:	c3                   	ret    

c0101e29 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101e29:	1e                   	push   %ds
    pushl %es
c0101e2a:	06                   	push   %es
    pushl %fs
c0101e2b:	0f a0                	push   %fs
    pushl %gs
c0101e2d:	0f a8                	push   %gs
    pushal
c0101e2f:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101e30:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101e35:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101e37:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101e39:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101e3a:	e8 d7 ff ff ff       	call   c0101e16 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101e3f:	5c                   	pop    %esp

c0101e40 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101e40:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101e41:	0f a9                	pop    %gs
    popl %fs
c0101e43:	0f a1                	pop    %fs
    popl %es
c0101e45:	07                   	pop    %es
    popl %ds
c0101e46:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101e47:	83 c4 08             	add    $0x8,%esp
    iret
c0101e4a:	cf                   	iret   

c0101e4b <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101e4b:	6a 00                	push   $0x0
  pushl $0
c0101e4d:	6a 00                	push   $0x0
  jmp __alltraps
c0101e4f:	e9 d5 ff ff ff       	jmp    c0101e29 <__alltraps>

c0101e54 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101e54:	6a 00                	push   $0x0
  pushl $1
c0101e56:	6a 01                	push   $0x1
  jmp __alltraps
c0101e58:	e9 cc ff ff ff       	jmp    c0101e29 <__alltraps>

c0101e5d <vector2>:
.globl vector2
vector2:
  pushl $0
c0101e5d:	6a 00                	push   $0x0
  pushl $2
c0101e5f:	6a 02                	push   $0x2
  jmp __alltraps
c0101e61:	e9 c3 ff ff ff       	jmp    c0101e29 <__alltraps>

c0101e66 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101e66:	6a 00                	push   $0x0
  pushl $3
c0101e68:	6a 03                	push   $0x3
  jmp __alltraps
c0101e6a:	e9 ba ff ff ff       	jmp    c0101e29 <__alltraps>

c0101e6f <vector4>:
.globl vector4
vector4:
  pushl $0
c0101e6f:	6a 00                	push   $0x0
  pushl $4
c0101e71:	6a 04                	push   $0x4
  jmp __alltraps
c0101e73:	e9 b1 ff ff ff       	jmp    c0101e29 <__alltraps>

c0101e78 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101e78:	6a 00                	push   $0x0
  pushl $5
c0101e7a:	6a 05                	push   $0x5
  jmp __alltraps
c0101e7c:	e9 a8 ff ff ff       	jmp    c0101e29 <__alltraps>

c0101e81 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101e81:	6a 00                	push   $0x0
  pushl $6
c0101e83:	6a 06                	push   $0x6
  jmp __alltraps
c0101e85:	e9 9f ff ff ff       	jmp    c0101e29 <__alltraps>

c0101e8a <vector7>:
.globl vector7
vector7:
  pushl $0
c0101e8a:	6a 00                	push   $0x0
  pushl $7
c0101e8c:	6a 07                	push   $0x7
  jmp __alltraps
c0101e8e:	e9 96 ff ff ff       	jmp    c0101e29 <__alltraps>

c0101e93 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101e93:	6a 08                	push   $0x8
  jmp __alltraps
c0101e95:	e9 8f ff ff ff       	jmp    c0101e29 <__alltraps>

c0101e9a <vector9>:
.globl vector9
vector9:
  pushl $9
c0101e9a:	6a 09                	push   $0x9
  jmp __alltraps
c0101e9c:	e9 88 ff ff ff       	jmp    c0101e29 <__alltraps>

c0101ea1 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101ea1:	6a 0a                	push   $0xa
  jmp __alltraps
c0101ea3:	e9 81 ff ff ff       	jmp    c0101e29 <__alltraps>

c0101ea8 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101ea8:	6a 0b                	push   $0xb
  jmp __alltraps
c0101eaa:	e9 7a ff ff ff       	jmp    c0101e29 <__alltraps>

c0101eaf <vector12>:
.globl vector12
vector12:
  pushl $12
c0101eaf:	6a 0c                	push   $0xc
  jmp __alltraps
c0101eb1:	e9 73 ff ff ff       	jmp    c0101e29 <__alltraps>

c0101eb6 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101eb6:	6a 0d                	push   $0xd
  jmp __alltraps
c0101eb8:	e9 6c ff ff ff       	jmp    c0101e29 <__alltraps>

c0101ebd <vector14>:
.globl vector14
vector14:
  pushl $14
c0101ebd:	6a 0e                	push   $0xe
  jmp __alltraps
c0101ebf:	e9 65 ff ff ff       	jmp    c0101e29 <__alltraps>

c0101ec4 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101ec4:	6a 00                	push   $0x0
  pushl $15
c0101ec6:	6a 0f                	push   $0xf
  jmp __alltraps
c0101ec8:	e9 5c ff ff ff       	jmp    c0101e29 <__alltraps>

c0101ecd <vector16>:
.globl vector16
vector16:
  pushl $0
c0101ecd:	6a 00                	push   $0x0
  pushl $16
c0101ecf:	6a 10                	push   $0x10
  jmp __alltraps
c0101ed1:	e9 53 ff ff ff       	jmp    c0101e29 <__alltraps>

c0101ed6 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101ed6:	6a 11                	push   $0x11
  jmp __alltraps
c0101ed8:	e9 4c ff ff ff       	jmp    c0101e29 <__alltraps>

c0101edd <vector18>:
.globl vector18
vector18:
  pushl $0
c0101edd:	6a 00                	push   $0x0
  pushl $18
c0101edf:	6a 12                	push   $0x12
  jmp __alltraps
c0101ee1:	e9 43 ff ff ff       	jmp    c0101e29 <__alltraps>

c0101ee6 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101ee6:	6a 00                	push   $0x0
  pushl $19
c0101ee8:	6a 13                	push   $0x13
  jmp __alltraps
c0101eea:	e9 3a ff ff ff       	jmp    c0101e29 <__alltraps>

c0101eef <vector20>:
.globl vector20
vector20:
  pushl $0
c0101eef:	6a 00                	push   $0x0
  pushl $20
c0101ef1:	6a 14                	push   $0x14
  jmp __alltraps
c0101ef3:	e9 31 ff ff ff       	jmp    c0101e29 <__alltraps>

c0101ef8 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101ef8:	6a 00                	push   $0x0
  pushl $21
c0101efa:	6a 15                	push   $0x15
  jmp __alltraps
c0101efc:	e9 28 ff ff ff       	jmp    c0101e29 <__alltraps>

c0101f01 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101f01:	6a 00                	push   $0x0
  pushl $22
c0101f03:	6a 16                	push   $0x16
  jmp __alltraps
c0101f05:	e9 1f ff ff ff       	jmp    c0101e29 <__alltraps>

c0101f0a <vector23>:
.globl vector23
vector23:
  pushl $0
c0101f0a:	6a 00                	push   $0x0
  pushl $23
c0101f0c:	6a 17                	push   $0x17
  jmp __alltraps
c0101f0e:	e9 16 ff ff ff       	jmp    c0101e29 <__alltraps>

c0101f13 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101f13:	6a 00                	push   $0x0
  pushl $24
c0101f15:	6a 18                	push   $0x18
  jmp __alltraps
c0101f17:	e9 0d ff ff ff       	jmp    c0101e29 <__alltraps>

c0101f1c <vector25>:
.globl vector25
vector25:
  pushl $0
c0101f1c:	6a 00                	push   $0x0
  pushl $25
c0101f1e:	6a 19                	push   $0x19
  jmp __alltraps
c0101f20:	e9 04 ff ff ff       	jmp    c0101e29 <__alltraps>

c0101f25 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101f25:	6a 00                	push   $0x0
  pushl $26
c0101f27:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101f29:	e9 fb fe ff ff       	jmp    c0101e29 <__alltraps>

c0101f2e <vector27>:
.globl vector27
vector27:
  pushl $0
c0101f2e:	6a 00                	push   $0x0
  pushl $27
c0101f30:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101f32:	e9 f2 fe ff ff       	jmp    c0101e29 <__alltraps>

c0101f37 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101f37:	6a 00                	push   $0x0
  pushl $28
c0101f39:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101f3b:	e9 e9 fe ff ff       	jmp    c0101e29 <__alltraps>

c0101f40 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101f40:	6a 00                	push   $0x0
  pushl $29
c0101f42:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101f44:	e9 e0 fe ff ff       	jmp    c0101e29 <__alltraps>

c0101f49 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101f49:	6a 00                	push   $0x0
  pushl $30
c0101f4b:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101f4d:	e9 d7 fe ff ff       	jmp    c0101e29 <__alltraps>

c0101f52 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101f52:	6a 00                	push   $0x0
  pushl $31
c0101f54:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101f56:	e9 ce fe ff ff       	jmp    c0101e29 <__alltraps>

c0101f5b <vector32>:
.globl vector32
vector32:
  pushl $0
c0101f5b:	6a 00                	push   $0x0
  pushl $32
c0101f5d:	6a 20                	push   $0x20
  jmp __alltraps
c0101f5f:	e9 c5 fe ff ff       	jmp    c0101e29 <__alltraps>

c0101f64 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101f64:	6a 00                	push   $0x0
  pushl $33
c0101f66:	6a 21                	push   $0x21
  jmp __alltraps
c0101f68:	e9 bc fe ff ff       	jmp    c0101e29 <__alltraps>

c0101f6d <vector34>:
.globl vector34
vector34:
  pushl $0
c0101f6d:	6a 00                	push   $0x0
  pushl $34
c0101f6f:	6a 22                	push   $0x22
  jmp __alltraps
c0101f71:	e9 b3 fe ff ff       	jmp    c0101e29 <__alltraps>

c0101f76 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101f76:	6a 00                	push   $0x0
  pushl $35
c0101f78:	6a 23                	push   $0x23
  jmp __alltraps
c0101f7a:	e9 aa fe ff ff       	jmp    c0101e29 <__alltraps>

c0101f7f <vector36>:
.globl vector36
vector36:
  pushl $0
c0101f7f:	6a 00                	push   $0x0
  pushl $36
c0101f81:	6a 24                	push   $0x24
  jmp __alltraps
c0101f83:	e9 a1 fe ff ff       	jmp    c0101e29 <__alltraps>

c0101f88 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101f88:	6a 00                	push   $0x0
  pushl $37
c0101f8a:	6a 25                	push   $0x25
  jmp __alltraps
c0101f8c:	e9 98 fe ff ff       	jmp    c0101e29 <__alltraps>

c0101f91 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101f91:	6a 00                	push   $0x0
  pushl $38
c0101f93:	6a 26                	push   $0x26
  jmp __alltraps
c0101f95:	e9 8f fe ff ff       	jmp    c0101e29 <__alltraps>

c0101f9a <vector39>:
.globl vector39
vector39:
  pushl $0
c0101f9a:	6a 00                	push   $0x0
  pushl $39
c0101f9c:	6a 27                	push   $0x27
  jmp __alltraps
c0101f9e:	e9 86 fe ff ff       	jmp    c0101e29 <__alltraps>

c0101fa3 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101fa3:	6a 00                	push   $0x0
  pushl $40
c0101fa5:	6a 28                	push   $0x28
  jmp __alltraps
c0101fa7:	e9 7d fe ff ff       	jmp    c0101e29 <__alltraps>

c0101fac <vector41>:
.globl vector41
vector41:
  pushl $0
c0101fac:	6a 00                	push   $0x0
  pushl $41
c0101fae:	6a 29                	push   $0x29
  jmp __alltraps
c0101fb0:	e9 74 fe ff ff       	jmp    c0101e29 <__alltraps>

c0101fb5 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101fb5:	6a 00                	push   $0x0
  pushl $42
c0101fb7:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101fb9:	e9 6b fe ff ff       	jmp    c0101e29 <__alltraps>

c0101fbe <vector43>:
.globl vector43
vector43:
  pushl $0
c0101fbe:	6a 00                	push   $0x0
  pushl $43
c0101fc0:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101fc2:	e9 62 fe ff ff       	jmp    c0101e29 <__alltraps>

c0101fc7 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101fc7:	6a 00                	push   $0x0
  pushl $44
c0101fc9:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101fcb:	e9 59 fe ff ff       	jmp    c0101e29 <__alltraps>

c0101fd0 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101fd0:	6a 00                	push   $0x0
  pushl $45
c0101fd2:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101fd4:	e9 50 fe ff ff       	jmp    c0101e29 <__alltraps>

c0101fd9 <vector46>:
.globl vector46
vector46:
  pushl $0
c0101fd9:	6a 00                	push   $0x0
  pushl $46
c0101fdb:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101fdd:	e9 47 fe ff ff       	jmp    c0101e29 <__alltraps>

c0101fe2 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101fe2:	6a 00                	push   $0x0
  pushl $47
c0101fe4:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101fe6:	e9 3e fe ff ff       	jmp    c0101e29 <__alltraps>

c0101feb <vector48>:
.globl vector48
vector48:
  pushl $0
c0101feb:	6a 00                	push   $0x0
  pushl $48
c0101fed:	6a 30                	push   $0x30
  jmp __alltraps
c0101fef:	e9 35 fe ff ff       	jmp    c0101e29 <__alltraps>

c0101ff4 <vector49>:
.globl vector49
vector49:
  pushl $0
c0101ff4:	6a 00                	push   $0x0
  pushl $49
c0101ff6:	6a 31                	push   $0x31
  jmp __alltraps
c0101ff8:	e9 2c fe ff ff       	jmp    c0101e29 <__alltraps>

c0101ffd <vector50>:
.globl vector50
vector50:
  pushl $0
c0101ffd:	6a 00                	push   $0x0
  pushl $50
c0101fff:	6a 32                	push   $0x32
  jmp __alltraps
c0102001:	e9 23 fe ff ff       	jmp    c0101e29 <__alltraps>

c0102006 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102006:	6a 00                	push   $0x0
  pushl $51
c0102008:	6a 33                	push   $0x33
  jmp __alltraps
c010200a:	e9 1a fe ff ff       	jmp    c0101e29 <__alltraps>

c010200f <vector52>:
.globl vector52
vector52:
  pushl $0
c010200f:	6a 00                	push   $0x0
  pushl $52
c0102011:	6a 34                	push   $0x34
  jmp __alltraps
c0102013:	e9 11 fe ff ff       	jmp    c0101e29 <__alltraps>

c0102018 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102018:	6a 00                	push   $0x0
  pushl $53
c010201a:	6a 35                	push   $0x35
  jmp __alltraps
c010201c:	e9 08 fe ff ff       	jmp    c0101e29 <__alltraps>

c0102021 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102021:	6a 00                	push   $0x0
  pushl $54
c0102023:	6a 36                	push   $0x36
  jmp __alltraps
c0102025:	e9 ff fd ff ff       	jmp    c0101e29 <__alltraps>

c010202a <vector55>:
.globl vector55
vector55:
  pushl $0
c010202a:	6a 00                	push   $0x0
  pushl $55
c010202c:	6a 37                	push   $0x37
  jmp __alltraps
c010202e:	e9 f6 fd ff ff       	jmp    c0101e29 <__alltraps>

c0102033 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102033:	6a 00                	push   $0x0
  pushl $56
c0102035:	6a 38                	push   $0x38
  jmp __alltraps
c0102037:	e9 ed fd ff ff       	jmp    c0101e29 <__alltraps>

c010203c <vector57>:
.globl vector57
vector57:
  pushl $0
c010203c:	6a 00                	push   $0x0
  pushl $57
c010203e:	6a 39                	push   $0x39
  jmp __alltraps
c0102040:	e9 e4 fd ff ff       	jmp    c0101e29 <__alltraps>

c0102045 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102045:	6a 00                	push   $0x0
  pushl $58
c0102047:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102049:	e9 db fd ff ff       	jmp    c0101e29 <__alltraps>

c010204e <vector59>:
.globl vector59
vector59:
  pushl $0
c010204e:	6a 00                	push   $0x0
  pushl $59
c0102050:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102052:	e9 d2 fd ff ff       	jmp    c0101e29 <__alltraps>

c0102057 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102057:	6a 00                	push   $0x0
  pushl $60
c0102059:	6a 3c                	push   $0x3c
  jmp __alltraps
c010205b:	e9 c9 fd ff ff       	jmp    c0101e29 <__alltraps>

c0102060 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102060:	6a 00                	push   $0x0
  pushl $61
c0102062:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102064:	e9 c0 fd ff ff       	jmp    c0101e29 <__alltraps>

c0102069 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102069:	6a 00                	push   $0x0
  pushl $62
c010206b:	6a 3e                	push   $0x3e
  jmp __alltraps
c010206d:	e9 b7 fd ff ff       	jmp    c0101e29 <__alltraps>

c0102072 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102072:	6a 00                	push   $0x0
  pushl $63
c0102074:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102076:	e9 ae fd ff ff       	jmp    c0101e29 <__alltraps>

c010207b <vector64>:
.globl vector64
vector64:
  pushl $0
c010207b:	6a 00                	push   $0x0
  pushl $64
c010207d:	6a 40                	push   $0x40
  jmp __alltraps
c010207f:	e9 a5 fd ff ff       	jmp    c0101e29 <__alltraps>

c0102084 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102084:	6a 00                	push   $0x0
  pushl $65
c0102086:	6a 41                	push   $0x41
  jmp __alltraps
c0102088:	e9 9c fd ff ff       	jmp    c0101e29 <__alltraps>

c010208d <vector66>:
.globl vector66
vector66:
  pushl $0
c010208d:	6a 00                	push   $0x0
  pushl $66
c010208f:	6a 42                	push   $0x42
  jmp __alltraps
c0102091:	e9 93 fd ff ff       	jmp    c0101e29 <__alltraps>

c0102096 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102096:	6a 00                	push   $0x0
  pushl $67
c0102098:	6a 43                	push   $0x43
  jmp __alltraps
c010209a:	e9 8a fd ff ff       	jmp    c0101e29 <__alltraps>

c010209f <vector68>:
.globl vector68
vector68:
  pushl $0
c010209f:	6a 00                	push   $0x0
  pushl $68
c01020a1:	6a 44                	push   $0x44
  jmp __alltraps
c01020a3:	e9 81 fd ff ff       	jmp    c0101e29 <__alltraps>

c01020a8 <vector69>:
.globl vector69
vector69:
  pushl $0
c01020a8:	6a 00                	push   $0x0
  pushl $69
c01020aa:	6a 45                	push   $0x45
  jmp __alltraps
c01020ac:	e9 78 fd ff ff       	jmp    c0101e29 <__alltraps>

c01020b1 <vector70>:
.globl vector70
vector70:
  pushl $0
c01020b1:	6a 00                	push   $0x0
  pushl $70
c01020b3:	6a 46                	push   $0x46
  jmp __alltraps
c01020b5:	e9 6f fd ff ff       	jmp    c0101e29 <__alltraps>

c01020ba <vector71>:
.globl vector71
vector71:
  pushl $0
c01020ba:	6a 00                	push   $0x0
  pushl $71
c01020bc:	6a 47                	push   $0x47
  jmp __alltraps
c01020be:	e9 66 fd ff ff       	jmp    c0101e29 <__alltraps>

c01020c3 <vector72>:
.globl vector72
vector72:
  pushl $0
c01020c3:	6a 00                	push   $0x0
  pushl $72
c01020c5:	6a 48                	push   $0x48
  jmp __alltraps
c01020c7:	e9 5d fd ff ff       	jmp    c0101e29 <__alltraps>

c01020cc <vector73>:
.globl vector73
vector73:
  pushl $0
c01020cc:	6a 00                	push   $0x0
  pushl $73
c01020ce:	6a 49                	push   $0x49
  jmp __alltraps
c01020d0:	e9 54 fd ff ff       	jmp    c0101e29 <__alltraps>

c01020d5 <vector74>:
.globl vector74
vector74:
  pushl $0
c01020d5:	6a 00                	push   $0x0
  pushl $74
c01020d7:	6a 4a                	push   $0x4a
  jmp __alltraps
c01020d9:	e9 4b fd ff ff       	jmp    c0101e29 <__alltraps>

c01020de <vector75>:
.globl vector75
vector75:
  pushl $0
c01020de:	6a 00                	push   $0x0
  pushl $75
c01020e0:	6a 4b                	push   $0x4b
  jmp __alltraps
c01020e2:	e9 42 fd ff ff       	jmp    c0101e29 <__alltraps>

c01020e7 <vector76>:
.globl vector76
vector76:
  pushl $0
c01020e7:	6a 00                	push   $0x0
  pushl $76
c01020e9:	6a 4c                	push   $0x4c
  jmp __alltraps
c01020eb:	e9 39 fd ff ff       	jmp    c0101e29 <__alltraps>

c01020f0 <vector77>:
.globl vector77
vector77:
  pushl $0
c01020f0:	6a 00                	push   $0x0
  pushl $77
c01020f2:	6a 4d                	push   $0x4d
  jmp __alltraps
c01020f4:	e9 30 fd ff ff       	jmp    c0101e29 <__alltraps>

c01020f9 <vector78>:
.globl vector78
vector78:
  pushl $0
c01020f9:	6a 00                	push   $0x0
  pushl $78
c01020fb:	6a 4e                	push   $0x4e
  jmp __alltraps
c01020fd:	e9 27 fd ff ff       	jmp    c0101e29 <__alltraps>

c0102102 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102102:	6a 00                	push   $0x0
  pushl $79
c0102104:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102106:	e9 1e fd ff ff       	jmp    c0101e29 <__alltraps>

c010210b <vector80>:
.globl vector80
vector80:
  pushl $0
c010210b:	6a 00                	push   $0x0
  pushl $80
c010210d:	6a 50                	push   $0x50
  jmp __alltraps
c010210f:	e9 15 fd ff ff       	jmp    c0101e29 <__alltraps>

c0102114 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102114:	6a 00                	push   $0x0
  pushl $81
c0102116:	6a 51                	push   $0x51
  jmp __alltraps
c0102118:	e9 0c fd ff ff       	jmp    c0101e29 <__alltraps>

c010211d <vector82>:
.globl vector82
vector82:
  pushl $0
c010211d:	6a 00                	push   $0x0
  pushl $82
c010211f:	6a 52                	push   $0x52
  jmp __alltraps
c0102121:	e9 03 fd ff ff       	jmp    c0101e29 <__alltraps>

c0102126 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102126:	6a 00                	push   $0x0
  pushl $83
c0102128:	6a 53                	push   $0x53
  jmp __alltraps
c010212a:	e9 fa fc ff ff       	jmp    c0101e29 <__alltraps>

c010212f <vector84>:
.globl vector84
vector84:
  pushl $0
c010212f:	6a 00                	push   $0x0
  pushl $84
c0102131:	6a 54                	push   $0x54
  jmp __alltraps
c0102133:	e9 f1 fc ff ff       	jmp    c0101e29 <__alltraps>

c0102138 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102138:	6a 00                	push   $0x0
  pushl $85
c010213a:	6a 55                	push   $0x55
  jmp __alltraps
c010213c:	e9 e8 fc ff ff       	jmp    c0101e29 <__alltraps>

c0102141 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102141:	6a 00                	push   $0x0
  pushl $86
c0102143:	6a 56                	push   $0x56
  jmp __alltraps
c0102145:	e9 df fc ff ff       	jmp    c0101e29 <__alltraps>

c010214a <vector87>:
.globl vector87
vector87:
  pushl $0
c010214a:	6a 00                	push   $0x0
  pushl $87
c010214c:	6a 57                	push   $0x57
  jmp __alltraps
c010214e:	e9 d6 fc ff ff       	jmp    c0101e29 <__alltraps>

c0102153 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102153:	6a 00                	push   $0x0
  pushl $88
c0102155:	6a 58                	push   $0x58
  jmp __alltraps
c0102157:	e9 cd fc ff ff       	jmp    c0101e29 <__alltraps>

c010215c <vector89>:
.globl vector89
vector89:
  pushl $0
c010215c:	6a 00                	push   $0x0
  pushl $89
c010215e:	6a 59                	push   $0x59
  jmp __alltraps
c0102160:	e9 c4 fc ff ff       	jmp    c0101e29 <__alltraps>

c0102165 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102165:	6a 00                	push   $0x0
  pushl $90
c0102167:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102169:	e9 bb fc ff ff       	jmp    c0101e29 <__alltraps>

c010216e <vector91>:
.globl vector91
vector91:
  pushl $0
c010216e:	6a 00                	push   $0x0
  pushl $91
c0102170:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102172:	e9 b2 fc ff ff       	jmp    c0101e29 <__alltraps>

c0102177 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102177:	6a 00                	push   $0x0
  pushl $92
c0102179:	6a 5c                	push   $0x5c
  jmp __alltraps
c010217b:	e9 a9 fc ff ff       	jmp    c0101e29 <__alltraps>

c0102180 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102180:	6a 00                	push   $0x0
  pushl $93
c0102182:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102184:	e9 a0 fc ff ff       	jmp    c0101e29 <__alltraps>

c0102189 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102189:	6a 00                	push   $0x0
  pushl $94
c010218b:	6a 5e                	push   $0x5e
  jmp __alltraps
c010218d:	e9 97 fc ff ff       	jmp    c0101e29 <__alltraps>

c0102192 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102192:	6a 00                	push   $0x0
  pushl $95
c0102194:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102196:	e9 8e fc ff ff       	jmp    c0101e29 <__alltraps>

c010219b <vector96>:
.globl vector96
vector96:
  pushl $0
c010219b:	6a 00                	push   $0x0
  pushl $96
c010219d:	6a 60                	push   $0x60
  jmp __alltraps
c010219f:	e9 85 fc ff ff       	jmp    c0101e29 <__alltraps>

c01021a4 <vector97>:
.globl vector97
vector97:
  pushl $0
c01021a4:	6a 00                	push   $0x0
  pushl $97
c01021a6:	6a 61                	push   $0x61
  jmp __alltraps
c01021a8:	e9 7c fc ff ff       	jmp    c0101e29 <__alltraps>

c01021ad <vector98>:
.globl vector98
vector98:
  pushl $0
c01021ad:	6a 00                	push   $0x0
  pushl $98
c01021af:	6a 62                	push   $0x62
  jmp __alltraps
c01021b1:	e9 73 fc ff ff       	jmp    c0101e29 <__alltraps>

c01021b6 <vector99>:
.globl vector99
vector99:
  pushl $0
c01021b6:	6a 00                	push   $0x0
  pushl $99
c01021b8:	6a 63                	push   $0x63
  jmp __alltraps
c01021ba:	e9 6a fc ff ff       	jmp    c0101e29 <__alltraps>

c01021bf <vector100>:
.globl vector100
vector100:
  pushl $0
c01021bf:	6a 00                	push   $0x0
  pushl $100
c01021c1:	6a 64                	push   $0x64
  jmp __alltraps
c01021c3:	e9 61 fc ff ff       	jmp    c0101e29 <__alltraps>

c01021c8 <vector101>:
.globl vector101
vector101:
  pushl $0
c01021c8:	6a 00                	push   $0x0
  pushl $101
c01021ca:	6a 65                	push   $0x65
  jmp __alltraps
c01021cc:	e9 58 fc ff ff       	jmp    c0101e29 <__alltraps>

c01021d1 <vector102>:
.globl vector102
vector102:
  pushl $0
c01021d1:	6a 00                	push   $0x0
  pushl $102
c01021d3:	6a 66                	push   $0x66
  jmp __alltraps
c01021d5:	e9 4f fc ff ff       	jmp    c0101e29 <__alltraps>

c01021da <vector103>:
.globl vector103
vector103:
  pushl $0
c01021da:	6a 00                	push   $0x0
  pushl $103
c01021dc:	6a 67                	push   $0x67
  jmp __alltraps
c01021de:	e9 46 fc ff ff       	jmp    c0101e29 <__alltraps>

c01021e3 <vector104>:
.globl vector104
vector104:
  pushl $0
c01021e3:	6a 00                	push   $0x0
  pushl $104
c01021e5:	6a 68                	push   $0x68
  jmp __alltraps
c01021e7:	e9 3d fc ff ff       	jmp    c0101e29 <__alltraps>

c01021ec <vector105>:
.globl vector105
vector105:
  pushl $0
c01021ec:	6a 00                	push   $0x0
  pushl $105
c01021ee:	6a 69                	push   $0x69
  jmp __alltraps
c01021f0:	e9 34 fc ff ff       	jmp    c0101e29 <__alltraps>

c01021f5 <vector106>:
.globl vector106
vector106:
  pushl $0
c01021f5:	6a 00                	push   $0x0
  pushl $106
c01021f7:	6a 6a                	push   $0x6a
  jmp __alltraps
c01021f9:	e9 2b fc ff ff       	jmp    c0101e29 <__alltraps>

c01021fe <vector107>:
.globl vector107
vector107:
  pushl $0
c01021fe:	6a 00                	push   $0x0
  pushl $107
c0102200:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102202:	e9 22 fc ff ff       	jmp    c0101e29 <__alltraps>

c0102207 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102207:	6a 00                	push   $0x0
  pushl $108
c0102209:	6a 6c                	push   $0x6c
  jmp __alltraps
c010220b:	e9 19 fc ff ff       	jmp    c0101e29 <__alltraps>

c0102210 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102210:	6a 00                	push   $0x0
  pushl $109
c0102212:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102214:	e9 10 fc ff ff       	jmp    c0101e29 <__alltraps>

c0102219 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102219:	6a 00                	push   $0x0
  pushl $110
c010221b:	6a 6e                	push   $0x6e
  jmp __alltraps
c010221d:	e9 07 fc ff ff       	jmp    c0101e29 <__alltraps>

c0102222 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102222:	6a 00                	push   $0x0
  pushl $111
c0102224:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102226:	e9 fe fb ff ff       	jmp    c0101e29 <__alltraps>

c010222b <vector112>:
.globl vector112
vector112:
  pushl $0
c010222b:	6a 00                	push   $0x0
  pushl $112
c010222d:	6a 70                	push   $0x70
  jmp __alltraps
c010222f:	e9 f5 fb ff ff       	jmp    c0101e29 <__alltraps>

c0102234 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102234:	6a 00                	push   $0x0
  pushl $113
c0102236:	6a 71                	push   $0x71
  jmp __alltraps
c0102238:	e9 ec fb ff ff       	jmp    c0101e29 <__alltraps>

c010223d <vector114>:
.globl vector114
vector114:
  pushl $0
c010223d:	6a 00                	push   $0x0
  pushl $114
c010223f:	6a 72                	push   $0x72
  jmp __alltraps
c0102241:	e9 e3 fb ff ff       	jmp    c0101e29 <__alltraps>

c0102246 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102246:	6a 00                	push   $0x0
  pushl $115
c0102248:	6a 73                	push   $0x73
  jmp __alltraps
c010224a:	e9 da fb ff ff       	jmp    c0101e29 <__alltraps>

c010224f <vector116>:
.globl vector116
vector116:
  pushl $0
c010224f:	6a 00                	push   $0x0
  pushl $116
c0102251:	6a 74                	push   $0x74
  jmp __alltraps
c0102253:	e9 d1 fb ff ff       	jmp    c0101e29 <__alltraps>

c0102258 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102258:	6a 00                	push   $0x0
  pushl $117
c010225a:	6a 75                	push   $0x75
  jmp __alltraps
c010225c:	e9 c8 fb ff ff       	jmp    c0101e29 <__alltraps>

c0102261 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102261:	6a 00                	push   $0x0
  pushl $118
c0102263:	6a 76                	push   $0x76
  jmp __alltraps
c0102265:	e9 bf fb ff ff       	jmp    c0101e29 <__alltraps>

c010226a <vector119>:
.globl vector119
vector119:
  pushl $0
c010226a:	6a 00                	push   $0x0
  pushl $119
c010226c:	6a 77                	push   $0x77
  jmp __alltraps
c010226e:	e9 b6 fb ff ff       	jmp    c0101e29 <__alltraps>

c0102273 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102273:	6a 00                	push   $0x0
  pushl $120
c0102275:	6a 78                	push   $0x78
  jmp __alltraps
c0102277:	e9 ad fb ff ff       	jmp    c0101e29 <__alltraps>

c010227c <vector121>:
.globl vector121
vector121:
  pushl $0
c010227c:	6a 00                	push   $0x0
  pushl $121
c010227e:	6a 79                	push   $0x79
  jmp __alltraps
c0102280:	e9 a4 fb ff ff       	jmp    c0101e29 <__alltraps>

c0102285 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102285:	6a 00                	push   $0x0
  pushl $122
c0102287:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102289:	e9 9b fb ff ff       	jmp    c0101e29 <__alltraps>

c010228e <vector123>:
.globl vector123
vector123:
  pushl $0
c010228e:	6a 00                	push   $0x0
  pushl $123
c0102290:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102292:	e9 92 fb ff ff       	jmp    c0101e29 <__alltraps>

c0102297 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102297:	6a 00                	push   $0x0
  pushl $124
c0102299:	6a 7c                	push   $0x7c
  jmp __alltraps
c010229b:	e9 89 fb ff ff       	jmp    c0101e29 <__alltraps>

c01022a0 <vector125>:
.globl vector125
vector125:
  pushl $0
c01022a0:	6a 00                	push   $0x0
  pushl $125
c01022a2:	6a 7d                	push   $0x7d
  jmp __alltraps
c01022a4:	e9 80 fb ff ff       	jmp    c0101e29 <__alltraps>

c01022a9 <vector126>:
.globl vector126
vector126:
  pushl $0
c01022a9:	6a 00                	push   $0x0
  pushl $126
c01022ab:	6a 7e                	push   $0x7e
  jmp __alltraps
c01022ad:	e9 77 fb ff ff       	jmp    c0101e29 <__alltraps>

c01022b2 <vector127>:
.globl vector127
vector127:
  pushl $0
c01022b2:	6a 00                	push   $0x0
  pushl $127
c01022b4:	6a 7f                	push   $0x7f
  jmp __alltraps
c01022b6:	e9 6e fb ff ff       	jmp    c0101e29 <__alltraps>

c01022bb <vector128>:
.globl vector128
vector128:
  pushl $0
c01022bb:	6a 00                	push   $0x0
  pushl $128
c01022bd:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01022c2:	e9 62 fb ff ff       	jmp    c0101e29 <__alltraps>

c01022c7 <vector129>:
.globl vector129
vector129:
  pushl $0
c01022c7:	6a 00                	push   $0x0
  pushl $129
c01022c9:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01022ce:	e9 56 fb ff ff       	jmp    c0101e29 <__alltraps>

c01022d3 <vector130>:
.globl vector130
vector130:
  pushl $0
c01022d3:	6a 00                	push   $0x0
  pushl $130
c01022d5:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01022da:	e9 4a fb ff ff       	jmp    c0101e29 <__alltraps>

c01022df <vector131>:
.globl vector131
vector131:
  pushl $0
c01022df:	6a 00                	push   $0x0
  pushl $131
c01022e1:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01022e6:	e9 3e fb ff ff       	jmp    c0101e29 <__alltraps>

c01022eb <vector132>:
.globl vector132
vector132:
  pushl $0
c01022eb:	6a 00                	push   $0x0
  pushl $132
c01022ed:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01022f2:	e9 32 fb ff ff       	jmp    c0101e29 <__alltraps>

c01022f7 <vector133>:
.globl vector133
vector133:
  pushl $0
c01022f7:	6a 00                	push   $0x0
  pushl $133
c01022f9:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01022fe:	e9 26 fb ff ff       	jmp    c0101e29 <__alltraps>

c0102303 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102303:	6a 00                	push   $0x0
  pushl $134
c0102305:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c010230a:	e9 1a fb ff ff       	jmp    c0101e29 <__alltraps>

c010230f <vector135>:
.globl vector135
vector135:
  pushl $0
c010230f:	6a 00                	push   $0x0
  pushl $135
c0102311:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102316:	e9 0e fb ff ff       	jmp    c0101e29 <__alltraps>

c010231b <vector136>:
.globl vector136
vector136:
  pushl $0
c010231b:	6a 00                	push   $0x0
  pushl $136
c010231d:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102322:	e9 02 fb ff ff       	jmp    c0101e29 <__alltraps>

c0102327 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102327:	6a 00                	push   $0x0
  pushl $137
c0102329:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c010232e:	e9 f6 fa ff ff       	jmp    c0101e29 <__alltraps>

c0102333 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102333:	6a 00                	push   $0x0
  pushl $138
c0102335:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c010233a:	e9 ea fa ff ff       	jmp    c0101e29 <__alltraps>

c010233f <vector139>:
.globl vector139
vector139:
  pushl $0
c010233f:	6a 00                	push   $0x0
  pushl $139
c0102341:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102346:	e9 de fa ff ff       	jmp    c0101e29 <__alltraps>

c010234b <vector140>:
.globl vector140
vector140:
  pushl $0
c010234b:	6a 00                	push   $0x0
  pushl $140
c010234d:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102352:	e9 d2 fa ff ff       	jmp    c0101e29 <__alltraps>

c0102357 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102357:	6a 00                	push   $0x0
  pushl $141
c0102359:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c010235e:	e9 c6 fa ff ff       	jmp    c0101e29 <__alltraps>

c0102363 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102363:	6a 00                	push   $0x0
  pushl $142
c0102365:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c010236a:	e9 ba fa ff ff       	jmp    c0101e29 <__alltraps>

c010236f <vector143>:
.globl vector143
vector143:
  pushl $0
c010236f:	6a 00                	push   $0x0
  pushl $143
c0102371:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102376:	e9 ae fa ff ff       	jmp    c0101e29 <__alltraps>

c010237b <vector144>:
.globl vector144
vector144:
  pushl $0
c010237b:	6a 00                	push   $0x0
  pushl $144
c010237d:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102382:	e9 a2 fa ff ff       	jmp    c0101e29 <__alltraps>

c0102387 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102387:	6a 00                	push   $0x0
  pushl $145
c0102389:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c010238e:	e9 96 fa ff ff       	jmp    c0101e29 <__alltraps>

c0102393 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102393:	6a 00                	push   $0x0
  pushl $146
c0102395:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c010239a:	e9 8a fa ff ff       	jmp    c0101e29 <__alltraps>

c010239f <vector147>:
.globl vector147
vector147:
  pushl $0
c010239f:	6a 00                	push   $0x0
  pushl $147
c01023a1:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01023a6:	e9 7e fa ff ff       	jmp    c0101e29 <__alltraps>

c01023ab <vector148>:
.globl vector148
vector148:
  pushl $0
c01023ab:	6a 00                	push   $0x0
  pushl $148
c01023ad:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01023b2:	e9 72 fa ff ff       	jmp    c0101e29 <__alltraps>

c01023b7 <vector149>:
.globl vector149
vector149:
  pushl $0
c01023b7:	6a 00                	push   $0x0
  pushl $149
c01023b9:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01023be:	e9 66 fa ff ff       	jmp    c0101e29 <__alltraps>

c01023c3 <vector150>:
.globl vector150
vector150:
  pushl $0
c01023c3:	6a 00                	push   $0x0
  pushl $150
c01023c5:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01023ca:	e9 5a fa ff ff       	jmp    c0101e29 <__alltraps>

c01023cf <vector151>:
.globl vector151
vector151:
  pushl $0
c01023cf:	6a 00                	push   $0x0
  pushl $151
c01023d1:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01023d6:	e9 4e fa ff ff       	jmp    c0101e29 <__alltraps>

c01023db <vector152>:
.globl vector152
vector152:
  pushl $0
c01023db:	6a 00                	push   $0x0
  pushl $152
c01023dd:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01023e2:	e9 42 fa ff ff       	jmp    c0101e29 <__alltraps>

c01023e7 <vector153>:
.globl vector153
vector153:
  pushl $0
c01023e7:	6a 00                	push   $0x0
  pushl $153
c01023e9:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01023ee:	e9 36 fa ff ff       	jmp    c0101e29 <__alltraps>

c01023f3 <vector154>:
.globl vector154
vector154:
  pushl $0
c01023f3:	6a 00                	push   $0x0
  pushl $154
c01023f5:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01023fa:	e9 2a fa ff ff       	jmp    c0101e29 <__alltraps>

c01023ff <vector155>:
.globl vector155
vector155:
  pushl $0
c01023ff:	6a 00                	push   $0x0
  pushl $155
c0102401:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102406:	e9 1e fa ff ff       	jmp    c0101e29 <__alltraps>

c010240b <vector156>:
.globl vector156
vector156:
  pushl $0
c010240b:	6a 00                	push   $0x0
  pushl $156
c010240d:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102412:	e9 12 fa ff ff       	jmp    c0101e29 <__alltraps>

c0102417 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102417:	6a 00                	push   $0x0
  pushl $157
c0102419:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c010241e:	e9 06 fa ff ff       	jmp    c0101e29 <__alltraps>

c0102423 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102423:	6a 00                	push   $0x0
  pushl $158
c0102425:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010242a:	e9 fa f9 ff ff       	jmp    c0101e29 <__alltraps>

c010242f <vector159>:
.globl vector159
vector159:
  pushl $0
c010242f:	6a 00                	push   $0x0
  pushl $159
c0102431:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102436:	e9 ee f9 ff ff       	jmp    c0101e29 <__alltraps>

c010243b <vector160>:
.globl vector160
vector160:
  pushl $0
c010243b:	6a 00                	push   $0x0
  pushl $160
c010243d:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102442:	e9 e2 f9 ff ff       	jmp    c0101e29 <__alltraps>

c0102447 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102447:	6a 00                	push   $0x0
  pushl $161
c0102449:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c010244e:	e9 d6 f9 ff ff       	jmp    c0101e29 <__alltraps>

c0102453 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102453:	6a 00                	push   $0x0
  pushl $162
c0102455:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c010245a:	e9 ca f9 ff ff       	jmp    c0101e29 <__alltraps>

c010245f <vector163>:
.globl vector163
vector163:
  pushl $0
c010245f:	6a 00                	push   $0x0
  pushl $163
c0102461:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102466:	e9 be f9 ff ff       	jmp    c0101e29 <__alltraps>

c010246b <vector164>:
.globl vector164
vector164:
  pushl $0
c010246b:	6a 00                	push   $0x0
  pushl $164
c010246d:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102472:	e9 b2 f9 ff ff       	jmp    c0101e29 <__alltraps>

c0102477 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102477:	6a 00                	push   $0x0
  pushl $165
c0102479:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c010247e:	e9 a6 f9 ff ff       	jmp    c0101e29 <__alltraps>

c0102483 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102483:	6a 00                	push   $0x0
  pushl $166
c0102485:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c010248a:	e9 9a f9 ff ff       	jmp    c0101e29 <__alltraps>

c010248f <vector167>:
.globl vector167
vector167:
  pushl $0
c010248f:	6a 00                	push   $0x0
  pushl $167
c0102491:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102496:	e9 8e f9 ff ff       	jmp    c0101e29 <__alltraps>

c010249b <vector168>:
.globl vector168
vector168:
  pushl $0
c010249b:	6a 00                	push   $0x0
  pushl $168
c010249d:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01024a2:	e9 82 f9 ff ff       	jmp    c0101e29 <__alltraps>

c01024a7 <vector169>:
.globl vector169
vector169:
  pushl $0
c01024a7:	6a 00                	push   $0x0
  pushl $169
c01024a9:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01024ae:	e9 76 f9 ff ff       	jmp    c0101e29 <__alltraps>

c01024b3 <vector170>:
.globl vector170
vector170:
  pushl $0
c01024b3:	6a 00                	push   $0x0
  pushl $170
c01024b5:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01024ba:	e9 6a f9 ff ff       	jmp    c0101e29 <__alltraps>

c01024bf <vector171>:
.globl vector171
vector171:
  pushl $0
c01024bf:	6a 00                	push   $0x0
  pushl $171
c01024c1:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01024c6:	e9 5e f9 ff ff       	jmp    c0101e29 <__alltraps>

c01024cb <vector172>:
.globl vector172
vector172:
  pushl $0
c01024cb:	6a 00                	push   $0x0
  pushl $172
c01024cd:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01024d2:	e9 52 f9 ff ff       	jmp    c0101e29 <__alltraps>

c01024d7 <vector173>:
.globl vector173
vector173:
  pushl $0
c01024d7:	6a 00                	push   $0x0
  pushl $173
c01024d9:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01024de:	e9 46 f9 ff ff       	jmp    c0101e29 <__alltraps>

c01024e3 <vector174>:
.globl vector174
vector174:
  pushl $0
c01024e3:	6a 00                	push   $0x0
  pushl $174
c01024e5:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01024ea:	e9 3a f9 ff ff       	jmp    c0101e29 <__alltraps>

c01024ef <vector175>:
.globl vector175
vector175:
  pushl $0
c01024ef:	6a 00                	push   $0x0
  pushl $175
c01024f1:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01024f6:	e9 2e f9 ff ff       	jmp    c0101e29 <__alltraps>

c01024fb <vector176>:
.globl vector176
vector176:
  pushl $0
c01024fb:	6a 00                	push   $0x0
  pushl $176
c01024fd:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102502:	e9 22 f9 ff ff       	jmp    c0101e29 <__alltraps>

c0102507 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102507:	6a 00                	push   $0x0
  pushl $177
c0102509:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c010250e:	e9 16 f9 ff ff       	jmp    c0101e29 <__alltraps>

c0102513 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102513:	6a 00                	push   $0x0
  pushl $178
c0102515:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c010251a:	e9 0a f9 ff ff       	jmp    c0101e29 <__alltraps>

c010251f <vector179>:
.globl vector179
vector179:
  pushl $0
c010251f:	6a 00                	push   $0x0
  pushl $179
c0102521:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102526:	e9 fe f8 ff ff       	jmp    c0101e29 <__alltraps>

c010252b <vector180>:
.globl vector180
vector180:
  pushl $0
c010252b:	6a 00                	push   $0x0
  pushl $180
c010252d:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102532:	e9 f2 f8 ff ff       	jmp    c0101e29 <__alltraps>

c0102537 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102537:	6a 00                	push   $0x0
  pushl $181
c0102539:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c010253e:	e9 e6 f8 ff ff       	jmp    c0101e29 <__alltraps>

c0102543 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102543:	6a 00                	push   $0x0
  pushl $182
c0102545:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c010254a:	e9 da f8 ff ff       	jmp    c0101e29 <__alltraps>

c010254f <vector183>:
.globl vector183
vector183:
  pushl $0
c010254f:	6a 00                	push   $0x0
  pushl $183
c0102551:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102556:	e9 ce f8 ff ff       	jmp    c0101e29 <__alltraps>

c010255b <vector184>:
.globl vector184
vector184:
  pushl $0
c010255b:	6a 00                	push   $0x0
  pushl $184
c010255d:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102562:	e9 c2 f8 ff ff       	jmp    c0101e29 <__alltraps>

c0102567 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102567:	6a 00                	push   $0x0
  pushl $185
c0102569:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c010256e:	e9 b6 f8 ff ff       	jmp    c0101e29 <__alltraps>

c0102573 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102573:	6a 00                	push   $0x0
  pushl $186
c0102575:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c010257a:	e9 aa f8 ff ff       	jmp    c0101e29 <__alltraps>

c010257f <vector187>:
.globl vector187
vector187:
  pushl $0
c010257f:	6a 00                	push   $0x0
  pushl $187
c0102581:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102586:	e9 9e f8 ff ff       	jmp    c0101e29 <__alltraps>

c010258b <vector188>:
.globl vector188
vector188:
  pushl $0
c010258b:	6a 00                	push   $0x0
  pushl $188
c010258d:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102592:	e9 92 f8 ff ff       	jmp    c0101e29 <__alltraps>

c0102597 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102597:	6a 00                	push   $0x0
  pushl $189
c0102599:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c010259e:	e9 86 f8 ff ff       	jmp    c0101e29 <__alltraps>

c01025a3 <vector190>:
.globl vector190
vector190:
  pushl $0
c01025a3:	6a 00                	push   $0x0
  pushl $190
c01025a5:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01025aa:	e9 7a f8 ff ff       	jmp    c0101e29 <__alltraps>

c01025af <vector191>:
.globl vector191
vector191:
  pushl $0
c01025af:	6a 00                	push   $0x0
  pushl $191
c01025b1:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01025b6:	e9 6e f8 ff ff       	jmp    c0101e29 <__alltraps>

c01025bb <vector192>:
.globl vector192
vector192:
  pushl $0
c01025bb:	6a 00                	push   $0x0
  pushl $192
c01025bd:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01025c2:	e9 62 f8 ff ff       	jmp    c0101e29 <__alltraps>

c01025c7 <vector193>:
.globl vector193
vector193:
  pushl $0
c01025c7:	6a 00                	push   $0x0
  pushl $193
c01025c9:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01025ce:	e9 56 f8 ff ff       	jmp    c0101e29 <__alltraps>

c01025d3 <vector194>:
.globl vector194
vector194:
  pushl $0
c01025d3:	6a 00                	push   $0x0
  pushl $194
c01025d5:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01025da:	e9 4a f8 ff ff       	jmp    c0101e29 <__alltraps>

c01025df <vector195>:
.globl vector195
vector195:
  pushl $0
c01025df:	6a 00                	push   $0x0
  pushl $195
c01025e1:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01025e6:	e9 3e f8 ff ff       	jmp    c0101e29 <__alltraps>

c01025eb <vector196>:
.globl vector196
vector196:
  pushl $0
c01025eb:	6a 00                	push   $0x0
  pushl $196
c01025ed:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01025f2:	e9 32 f8 ff ff       	jmp    c0101e29 <__alltraps>

c01025f7 <vector197>:
.globl vector197
vector197:
  pushl $0
c01025f7:	6a 00                	push   $0x0
  pushl $197
c01025f9:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01025fe:	e9 26 f8 ff ff       	jmp    c0101e29 <__alltraps>

c0102603 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102603:	6a 00                	push   $0x0
  pushl $198
c0102605:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c010260a:	e9 1a f8 ff ff       	jmp    c0101e29 <__alltraps>

c010260f <vector199>:
.globl vector199
vector199:
  pushl $0
c010260f:	6a 00                	push   $0x0
  pushl $199
c0102611:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102616:	e9 0e f8 ff ff       	jmp    c0101e29 <__alltraps>

c010261b <vector200>:
.globl vector200
vector200:
  pushl $0
c010261b:	6a 00                	push   $0x0
  pushl $200
c010261d:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102622:	e9 02 f8 ff ff       	jmp    c0101e29 <__alltraps>

c0102627 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102627:	6a 00                	push   $0x0
  pushl $201
c0102629:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c010262e:	e9 f6 f7 ff ff       	jmp    c0101e29 <__alltraps>

c0102633 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102633:	6a 00                	push   $0x0
  pushl $202
c0102635:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c010263a:	e9 ea f7 ff ff       	jmp    c0101e29 <__alltraps>

c010263f <vector203>:
.globl vector203
vector203:
  pushl $0
c010263f:	6a 00                	push   $0x0
  pushl $203
c0102641:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102646:	e9 de f7 ff ff       	jmp    c0101e29 <__alltraps>

c010264b <vector204>:
.globl vector204
vector204:
  pushl $0
c010264b:	6a 00                	push   $0x0
  pushl $204
c010264d:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102652:	e9 d2 f7 ff ff       	jmp    c0101e29 <__alltraps>

c0102657 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102657:	6a 00                	push   $0x0
  pushl $205
c0102659:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010265e:	e9 c6 f7 ff ff       	jmp    c0101e29 <__alltraps>

c0102663 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102663:	6a 00                	push   $0x0
  pushl $206
c0102665:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010266a:	e9 ba f7 ff ff       	jmp    c0101e29 <__alltraps>

c010266f <vector207>:
.globl vector207
vector207:
  pushl $0
c010266f:	6a 00                	push   $0x0
  pushl $207
c0102671:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102676:	e9 ae f7 ff ff       	jmp    c0101e29 <__alltraps>

c010267b <vector208>:
.globl vector208
vector208:
  pushl $0
c010267b:	6a 00                	push   $0x0
  pushl $208
c010267d:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102682:	e9 a2 f7 ff ff       	jmp    c0101e29 <__alltraps>

c0102687 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102687:	6a 00                	push   $0x0
  pushl $209
c0102689:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c010268e:	e9 96 f7 ff ff       	jmp    c0101e29 <__alltraps>

c0102693 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102693:	6a 00                	push   $0x0
  pushl $210
c0102695:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010269a:	e9 8a f7 ff ff       	jmp    c0101e29 <__alltraps>

c010269f <vector211>:
.globl vector211
vector211:
  pushl $0
c010269f:	6a 00                	push   $0x0
  pushl $211
c01026a1:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01026a6:	e9 7e f7 ff ff       	jmp    c0101e29 <__alltraps>

c01026ab <vector212>:
.globl vector212
vector212:
  pushl $0
c01026ab:	6a 00                	push   $0x0
  pushl $212
c01026ad:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01026b2:	e9 72 f7 ff ff       	jmp    c0101e29 <__alltraps>

c01026b7 <vector213>:
.globl vector213
vector213:
  pushl $0
c01026b7:	6a 00                	push   $0x0
  pushl $213
c01026b9:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01026be:	e9 66 f7 ff ff       	jmp    c0101e29 <__alltraps>

c01026c3 <vector214>:
.globl vector214
vector214:
  pushl $0
c01026c3:	6a 00                	push   $0x0
  pushl $214
c01026c5:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01026ca:	e9 5a f7 ff ff       	jmp    c0101e29 <__alltraps>

c01026cf <vector215>:
.globl vector215
vector215:
  pushl $0
c01026cf:	6a 00                	push   $0x0
  pushl $215
c01026d1:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01026d6:	e9 4e f7 ff ff       	jmp    c0101e29 <__alltraps>

c01026db <vector216>:
.globl vector216
vector216:
  pushl $0
c01026db:	6a 00                	push   $0x0
  pushl $216
c01026dd:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01026e2:	e9 42 f7 ff ff       	jmp    c0101e29 <__alltraps>

c01026e7 <vector217>:
.globl vector217
vector217:
  pushl $0
c01026e7:	6a 00                	push   $0x0
  pushl $217
c01026e9:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01026ee:	e9 36 f7 ff ff       	jmp    c0101e29 <__alltraps>

c01026f3 <vector218>:
.globl vector218
vector218:
  pushl $0
c01026f3:	6a 00                	push   $0x0
  pushl $218
c01026f5:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01026fa:	e9 2a f7 ff ff       	jmp    c0101e29 <__alltraps>

c01026ff <vector219>:
.globl vector219
vector219:
  pushl $0
c01026ff:	6a 00                	push   $0x0
  pushl $219
c0102701:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102706:	e9 1e f7 ff ff       	jmp    c0101e29 <__alltraps>

c010270b <vector220>:
.globl vector220
vector220:
  pushl $0
c010270b:	6a 00                	push   $0x0
  pushl $220
c010270d:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102712:	e9 12 f7 ff ff       	jmp    c0101e29 <__alltraps>

c0102717 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102717:	6a 00                	push   $0x0
  pushl $221
c0102719:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c010271e:	e9 06 f7 ff ff       	jmp    c0101e29 <__alltraps>

c0102723 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102723:	6a 00                	push   $0x0
  pushl $222
c0102725:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010272a:	e9 fa f6 ff ff       	jmp    c0101e29 <__alltraps>

c010272f <vector223>:
.globl vector223
vector223:
  pushl $0
c010272f:	6a 00                	push   $0x0
  pushl $223
c0102731:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102736:	e9 ee f6 ff ff       	jmp    c0101e29 <__alltraps>

c010273b <vector224>:
.globl vector224
vector224:
  pushl $0
c010273b:	6a 00                	push   $0x0
  pushl $224
c010273d:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102742:	e9 e2 f6 ff ff       	jmp    c0101e29 <__alltraps>

c0102747 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102747:	6a 00                	push   $0x0
  pushl $225
c0102749:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010274e:	e9 d6 f6 ff ff       	jmp    c0101e29 <__alltraps>

c0102753 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102753:	6a 00                	push   $0x0
  pushl $226
c0102755:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010275a:	e9 ca f6 ff ff       	jmp    c0101e29 <__alltraps>

c010275f <vector227>:
.globl vector227
vector227:
  pushl $0
c010275f:	6a 00                	push   $0x0
  pushl $227
c0102761:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102766:	e9 be f6 ff ff       	jmp    c0101e29 <__alltraps>

c010276b <vector228>:
.globl vector228
vector228:
  pushl $0
c010276b:	6a 00                	push   $0x0
  pushl $228
c010276d:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102772:	e9 b2 f6 ff ff       	jmp    c0101e29 <__alltraps>

c0102777 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102777:	6a 00                	push   $0x0
  pushl $229
c0102779:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c010277e:	e9 a6 f6 ff ff       	jmp    c0101e29 <__alltraps>

c0102783 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102783:	6a 00                	push   $0x0
  pushl $230
c0102785:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010278a:	e9 9a f6 ff ff       	jmp    c0101e29 <__alltraps>

c010278f <vector231>:
.globl vector231
vector231:
  pushl $0
c010278f:	6a 00                	push   $0x0
  pushl $231
c0102791:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102796:	e9 8e f6 ff ff       	jmp    c0101e29 <__alltraps>

c010279b <vector232>:
.globl vector232
vector232:
  pushl $0
c010279b:	6a 00                	push   $0x0
  pushl $232
c010279d:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01027a2:	e9 82 f6 ff ff       	jmp    c0101e29 <__alltraps>

c01027a7 <vector233>:
.globl vector233
vector233:
  pushl $0
c01027a7:	6a 00                	push   $0x0
  pushl $233
c01027a9:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01027ae:	e9 76 f6 ff ff       	jmp    c0101e29 <__alltraps>

c01027b3 <vector234>:
.globl vector234
vector234:
  pushl $0
c01027b3:	6a 00                	push   $0x0
  pushl $234
c01027b5:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01027ba:	e9 6a f6 ff ff       	jmp    c0101e29 <__alltraps>

c01027bf <vector235>:
.globl vector235
vector235:
  pushl $0
c01027bf:	6a 00                	push   $0x0
  pushl $235
c01027c1:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01027c6:	e9 5e f6 ff ff       	jmp    c0101e29 <__alltraps>

c01027cb <vector236>:
.globl vector236
vector236:
  pushl $0
c01027cb:	6a 00                	push   $0x0
  pushl $236
c01027cd:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01027d2:	e9 52 f6 ff ff       	jmp    c0101e29 <__alltraps>

c01027d7 <vector237>:
.globl vector237
vector237:
  pushl $0
c01027d7:	6a 00                	push   $0x0
  pushl $237
c01027d9:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01027de:	e9 46 f6 ff ff       	jmp    c0101e29 <__alltraps>

c01027e3 <vector238>:
.globl vector238
vector238:
  pushl $0
c01027e3:	6a 00                	push   $0x0
  pushl $238
c01027e5:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01027ea:	e9 3a f6 ff ff       	jmp    c0101e29 <__alltraps>

c01027ef <vector239>:
.globl vector239
vector239:
  pushl $0
c01027ef:	6a 00                	push   $0x0
  pushl $239
c01027f1:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01027f6:	e9 2e f6 ff ff       	jmp    c0101e29 <__alltraps>

c01027fb <vector240>:
.globl vector240
vector240:
  pushl $0
c01027fb:	6a 00                	push   $0x0
  pushl $240
c01027fd:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102802:	e9 22 f6 ff ff       	jmp    c0101e29 <__alltraps>

c0102807 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102807:	6a 00                	push   $0x0
  pushl $241
c0102809:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c010280e:	e9 16 f6 ff ff       	jmp    c0101e29 <__alltraps>

c0102813 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102813:	6a 00                	push   $0x0
  pushl $242
c0102815:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010281a:	e9 0a f6 ff ff       	jmp    c0101e29 <__alltraps>

c010281f <vector243>:
.globl vector243
vector243:
  pushl $0
c010281f:	6a 00                	push   $0x0
  pushl $243
c0102821:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102826:	e9 fe f5 ff ff       	jmp    c0101e29 <__alltraps>

c010282b <vector244>:
.globl vector244
vector244:
  pushl $0
c010282b:	6a 00                	push   $0x0
  pushl $244
c010282d:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102832:	e9 f2 f5 ff ff       	jmp    c0101e29 <__alltraps>

c0102837 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102837:	6a 00                	push   $0x0
  pushl $245
c0102839:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010283e:	e9 e6 f5 ff ff       	jmp    c0101e29 <__alltraps>

c0102843 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102843:	6a 00                	push   $0x0
  pushl $246
c0102845:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c010284a:	e9 da f5 ff ff       	jmp    c0101e29 <__alltraps>

c010284f <vector247>:
.globl vector247
vector247:
  pushl $0
c010284f:	6a 00                	push   $0x0
  pushl $247
c0102851:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102856:	e9 ce f5 ff ff       	jmp    c0101e29 <__alltraps>

c010285b <vector248>:
.globl vector248
vector248:
  pushl $0
c010285b:	6a 00                	push   $0x0
  pushl $248
c010285d:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102862:	e9 c2 f5 ff ff       	jmp    c0101e29 <__alltraps>

c0102867 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102867:	6a 00                	push   $0x0
  pushl $249
c0102869:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c010286e:	e9 b6 f5 ff ff       	jmp    c0101e29 <__alltraps>

c0102873 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102873:	6a 00                	push   $0x0
  pushl $250
c0102875:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010287a:	e9 aa f5 ff ff       	jmp    c0101e29 <__alltraps>

c010287f <vector251>:
.globl vector251
vector251:
  pushl $0
c010287f:	6a 00                	push   $0x0
  pushl $251
c0102881:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102886:	e9 9e f5 ff ff       	jmp    c0101e29 <__alltraps>

c010288b <vector252>:
.globl vector252
vector252:
  pushl $0
c010288b:	6a 00                	push   $0x0
  pushl $252
c010288d:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102892:	e9 92 f5 ff ff       	jmp    c0101e29 <__alltraps>

c0102897 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102897:	6a 00                	push   $0x0
  pushl $253
c0102899:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c010289e:	e9 86 f5 ff ff       	jmp    c0101e29 <__alltraps>

c01028a3 <vector254>:
.globl vector254
vector254:
  pushl $0
c01028a3:	6a 00                	push   $0x0
  pushl $254
c01028a5:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01028aa:	e9 7a f5 ff ff       	jmp    c0101e29 <__alltraps>

c01028af <vector255>:
.globl vector255
vector255:
  pushl $0
c01028af:	6a 00                	push   $0x0
  pushl $255
c01028b1:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01028b6:	e9 6e f5 ff ff       	jmp    c0101e29 <__alltraps>

c01028bb <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01028bb:	55                   	push   %ebp
c01028bc:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01028be:	8b 55 08             	mov    0x8(%ebp),%edx
c01028c1:	a1 84 89 11 c0       	mov    0xc0118984,%eax
c01028c6:	29 c2                	sub    %eax,%edx
c01028c8:	89 d0                	mov    %edx,%eax
c01028ca:	c1 f8 02             	sar    $0x2,%eax
c01028cd:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01028d3:	5d                   	pop    %ebp
c01028d4:	c3                   	ret    

c01028d5 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01028d5:	55                   	push   %ebp
c01028d6:	89 e5                	mov    %esp,%ebp
c01028d8:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01028db:	8b 45 08             	mov    0x8(%ebp),%eax
c01028de:	89 04 24             	mov    %eax,(%esp)
c01028e1:	e8 d5 ff ff ff       	call   c01028bb <page2ppn>
c01028e6:	c1 e0 0c             	shl    $0xc,%eax
}
c01028e9:	c9                   	leave  
c01028ea:	c3                   	ret    

c01028eb <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01028eb:	55                   	push   %ebp
c01028ec:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01028ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01028f1:	8b 00                	mov    (%eax),%eax
}
c01028f3:	5d                   	pop    %ebp
c01028f4:	c3                   	ret    

c01028f5 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01028f5:	55                   	push   %ebp
c01028f6:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01028f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01028fb:	8b 55 0c             	mov    0xc(%ebp),%edx
c01028fe:	89 10                	mov    %edx,(%eax)
}
c0102900:	5d                   	pop    %ebp
c0102901:	c3                   	ret    

c0102902 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0102902:	55                   	push   %ebp
c0102903:	89 e5                	mov    %esp,%ebp
c0102905:	83 ec 10             	sub    $0x10,%esp
c0102908:	c7 45 fc 70 89 11 c0 	movl   $0xc0118970,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010290f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102912:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102915:	89 50 04             	mov    %edx,0x4(%eax)
c0102918:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010291b:	8b 50 04             	mov    0x4(%eax),%edx
c010291e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102921:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0102923:	c7 05 78 89 11 c0 00 	movl   $0x0,0xc0118978
c010292a:	00 00 00 
}
c010292d:	c9                   	leave  
c010292e:	c3                   	ret    

c010292f <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010292f:	55                   	push   %ebp
c0102930:	89 e5                	mov    %esp,%ebp
c0102932:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0102935:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102939:	75 24                	jne    c010295f <default_init_memmap+0x30>
c010293b:	c7 44 24 0c d0 66 10 	movl   $0xc01066d0,0xc(%esp)
c0102942:	c0 
c0102943:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c010294a:	c0 
c010294b:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c0102952:	00 
c0102953:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c010295a:	e8 65 e3 ff ff       	call   c0100cc4 <__panic>
    struct Page *p = base;
c010295f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102962:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102965:	e9 de 00 00 00       	jmp    c0102a48 <default_init_memmap+0x119>
        assert(PageReserved(p));
c010296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010296d:	83 c0 04             	add    $0x4,%eax
c0102970:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102977:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010297a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010297d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102980:	0f a3 10             	bt     %edx,(%eax)
c0102983:	19 c0                	sbb    %eax,%eax
c0102985:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0102988:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010298c:	0f 95 c0             	setne  %al
c010298f:	0f b6 c0             	movzbl %al,%eax
c0102992:	85 c0                	test   %eax,%eax
c0102994:	75 24                	jne    c01029ba <default_init_memmap+0x8b>
c0102996:	c7 44 24 0c 01 67 10 	movl   $0xc0106701,0xc(%esp)
c010299d:	c0 
c010299e:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01029a5:	c0 
c01029a6:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c01029ad:	00 
c01029ae:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01029b5:	e8 0a e3 ff ff       	call   c0100cc4 <__panic>
        p->flags = p->property = 0;
c01029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029bd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029c7:	8b 50 08             	mov    0x8(%eax),%edx
c01029ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029cd:	89 50 04             	mov    %edx,0x4(%eax)
        SetPageProperty(p);
c01029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029d3:	83 c0 04             	add    $0x4,%eax
c01029d6:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01029dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01029e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01029e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01029e6:	0f ab 10             	bts    %edx,(%eax)
        set_page_ref(p, 0);
c01029e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01029f0:	00 
c01029f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029f4:	89 04 24             	mov    %eax,(%esp)
c01029f7:	e8 f9 fe ff ff       	call   c01028f5 <set_page_ref>
        list_add_before(&free_list, &(p->page_link));
c01029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029ff:	83 c0 0c             	add    $0xc,%eax
c0102a02:	c7 45 dc 70 89 11 c0 	movl   $0xc0118970,-0x24(%ebp)
c0102a09:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102a0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a0f:	8b 00                	mov    (%eax),%eax
c0102a11:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102a14:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102a17:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102a1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a1d:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102a20:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a23:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102a26:	89 10                	mov    %edx,(%eax)
c0102a28:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a2b:	8b 10                	mov    (%eax),%edx
c0102a2d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102a30:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102a33:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a36:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102a39:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102a3c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a3f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102a42:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102a44:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102a48:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a4b:	89 d0                	mov    %edx,%eax
c0102a4d:	c1 e0 02             	shl    $0x2,%eax
c0102a50:	01 d0                	add    %edx,%eax
c0102a52:	c1 e0 02             	shl    $0x2,%eax
c0102a55:	89 c2                	mov    %eax,%edx
c0102a57:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a5a:	01 d0                	add    %edx,%eax
c0102a5c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102a5f:	0f 85 05 ff ff ff    	jne    c010296a <default_init_memmap+0x3b>
        p->flags = p->property = 0;
        SetPageProperty(p);
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;
c0102a65:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a68:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a6b:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
c0102a6e:	8b 15 78 89 11 c0    	mov    0xc0118978,%edx
c0102a74:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102a77:	01 d0                	add    %edx,%eax
c0102a79:	a3 78 89 11 c0       	mov    %eax,0xc0118978
}
c0102a7e:	c9                   	leave  
c0102a7f:	c3                   	ret    

c0102a80 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102a80:	55                   	push   %ebp
c0102a81:	89 e5                	mov    %esp,%ebp
c0102a83:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102a86:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102a8a:	75 24                	jne    c0102ab0 <default_alloc_pages+0x30>
c0102a8c:	c7 44 24 0c d0 66 10 	movl   $0xc01066d0,0xc(%esp)
c0102a93:	c0 
c0102a94:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0102a9b:	c0 
c0102a9c:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c0102aa3:	00 
c0102aa4:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0102aab:	e8 14 e2 ff ff       	call   c0100cc4 <__panic>
    if (n > nr_free) {
c0102ab0:	a1 78 89 11 c0       	mov    0xc0118978,%eax
c0102ab5:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102ab8:	73 0a                	jae    c0102ac4 <default_alloc_pages+0x44>
        return NULL;
c0102aba:	b8 00 00 00 00       	mov    $0x0,%eax
c0102abf:	e9 46 01 00 00       	jmp    c0102c0a <default_alloc_pages+0x18a>
    }
    struct Page *page = NULL;
c0102ac4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102acb:	c7 45 f0 70 89 11 c0 	movl   $0xc0118970,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0102ad2:	eb 1c                	jmp    c0102af0 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0102ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ad7:	83 e8 0c             	sub    $0xc,%eax
c0102ada:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
c0102add:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102ae0:	8b 40 08             	mov    0x8(%eax),%eax
c0102ae3:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102ae6:	72 08                	jb     c0102af0 <default_alloc_pages+0x70>
            page = p;
c0102ae8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102aeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102aee:	eb 18                	jmp    c0102b08 <default_alloc_pages+0x88>
c0102af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102af3:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102af6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102af9:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0102afc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102aff:	81 7d f0 70 89 11 c0 	cmpl   $0xc0118970,-0x10(%ebp)
c0102b06:	75 cc                	jne    c0102ad4 <default_alloc_pages+0x54>
            page = p;
            break;
        }
    }
    list_entry_t *list_entry_next;
    if (page != NULL) {
c0102b08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102b0c:	0f 84 f5 00 00 00    	je     c0102c07 <default_alloc_pages+0x187>
    	int i;
    	for(i = 0; i < n; ++i){
c0102b12:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102b19:	eb 7c                	jmp    c0102b97 <default_alloc_pages+0x117>
    		struct Page *current_p = le2page(le,page_link);
c0102b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b1e:	83 e8 0c             	sub    $0xc,%eax
c0102b21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    		SetPageReserved(current_p);
c0102b24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b27:	83 c0 04             	add    $0x4,%eax
c0102b2a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
c0102b31:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102b34:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b37:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102b3a:	0f ab 10             	bts    %edx,(%eax)
    		ClearPageProperty(current_p);
c0102b3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b40:	83 c0 04             	add    $0x4,%eax
c0102b43:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0102b4a:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b4d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102b50:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102b53:	0f b3 10             	btr    %edx,(%eax)
c0102b56:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b59:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0102b5c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102b5f:	8b 40 04             	mov    0x4(%eax),%eax
    		list_entry_next = list_next(le);
c0102b62:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102b65:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b68:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102b6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102b6e:	8b 40 04             	mov    0x4(%eax),%eax
c0102b71:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102b74:	8b 12                	mov    (%edx),%edx
c0102b76:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0102b79:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102b7c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102b7f:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102b82:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102b85:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102b88:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102b8b:	89 10                	mov    %edx,(%eax)
    		list_del(le);
    		le = list_entry_next;
c0102b8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102b90:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
    }
    list_entry_t *list_entry_next;
    if (page != NULL) {
    	int i;
    	for(i = 0; i < n; ++i){
c0102b93:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0102b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b9a:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b9d:	0f 82 78 ff ff ff    	jb     c0102b1b <default_alloc_pages+0x9b>
    		ClearPageProperty(current_p);
    		list_entry_next = list_next(le);
    		list_del(le);
    		le = list_entry_next;
    	}
    	if(page->property > n){
c0102ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ba6:	8b 40 08             	mov    0x8(%eax),%eax
c0102ba9:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102bac:	76 1a                	jbe    c0102bc8 <default_alloc_pages+0x148>
    		struct Page *p = le2page(le,page_link);
c0102bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102bb1:	83 e8 0c             	sub    $0xc,%eax
c0102bb4:	89 45 dc             	mov    %eax,-0x24(%ebp)
    		p->property = page->property - n;
c0102bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bba:	8b 40 08             	mov    0x8(%eax),%eax
c0102bbd:	2b 45 08             	sub    0x8(%ebp),%eax
c0102bc0:	89 c2                	mov    %eax,%edx
c0102bc2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102bc5:	89 50 08             	mov    %edx,0x8(%eax)
    	}
    	ClearPageProperty(page);
c0102bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bcb:	83 c0 04             	add    $0x4,%eax
c0102bce:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0102bd5:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0102bd8:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102bdb:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102bde:	0f b3 10             	btr    %edx,(%eax)
    	SetPageReserved(page);
c0102be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102be4:	83 c0 04             	add    $0x4,%eax
c0102be7:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
c0102bee:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102bf1:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102bf4:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102bf7:	0f ab 10             	bts    %edx,(%eax)
    	nr_free -= n;
c0102bfa:	a1 78 89 11 c0       	mov    0xc0118978,%eax
c0102bff:	2b 45 08             	sub    0x8(%ebp),%eax
c0102c02:	a3 78 89 11 c0       	mov    %eax,0xc0118978
    }
    return page;
c0102c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102c0a:	c9                   	leave  
c0102c0b:	c3                   	ret    

c0102c0c <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102c0c:	55                   	push   %ebp
c0102c0d:	89 e5                	mov    %esp,%ebp
c0102c0f:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102c12:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102c16:	75 24                	jne    c0102c3c <default_free_pages+0x30>
c0102c18:	c7 44 24 0c d0 66 10 	movl   $0xc01066d0,0xc(%esp)
c0102c1f:	c0 
c0102c20:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0102c27:	c0 
c0102c28:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
c0102c2f:	00 
c0102c30:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0102c37:	e8 88 e0 ff ff       	call   c0100cc4 <__panic>
    assert(PageReserved(base));
c0102c3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c3f:	83 c0 04             	add    $0x4,%eax
c0102c42:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102c49:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102c52:	0f a3 10             	bt     %edx,(%eax)
c0102c55:	19 c0                	sbb    %eax,%eax
c0102c57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102c5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102c5e:	0f 95 c0             	setne  %al
c0102c61:	0f b6 c0             	movzbl %al,%eax
c0102c64:	85 c0                	test   %eax,%eax
c0102c66:	75 24                	jne    c0102c8c <default_free_pages+0x80>
c0102c68:	c7 44 24 0c 11 67 10 	movl   $0xc0106711,0xc(%esp)
c0102c6f:	c0 
c0102c70:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0102c77:	c0 
c0102c78:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c0102c7f:	00 
c0102c80:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0102c87:	e8 38 e0 ff ff       	call   c0100cc4 <__panic>

    list_entry_t *le = &free_list;
c0102c8c:	c7 45 f4 70 89 11 c0 	movl   $0xc0118970,-0xc(%ebp)
    struct Page *current_p;
    while((le = list_next(le)) != &free_list){
c0102c93:	eb 13                	jmp    c0102ca8 <default_free_pages+0x9c>
    	current_p = le2page(le,page_link);
c0102c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c98:	83 e8 0c             	sub    $0xc,%eax
c0102c9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	if(current_p > base) {
c0102c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ca1:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102ca4:	76 02                	jbe    c0102ca8 <default_free_pages+0x9c>
    		break;
c0102ca6:	eb 18                	jmp    c0102cc0 <default_free_pages+0xb4>
c0102ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cab:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102cae:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102cb1:	8b 40 04             	mov    0x4(%eax),%eax
    assert(n > 0);
    assert(PageReserved(base));

    list_entry_t *le = &free_list;
    struct Page *current_p;
    while((le = list_next(le)) != &free_list){
c0102cb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102cb7:	81 7d f4 70 89 11 c0 	cmpl   $0xc0118970,-0xc(%ebp)
c0102cbe:	75 d5                	jne    c0102c95 <default_free_pages+0x89>
    	current_p = le2page(le,page_link);
    	if(current_p > base) {
    		break;
    	}
    }
    for(current_p = base; current_p < base + n; ++current_p){
c0102cc0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102cc6:	eb 4b                	jmp    c0102d13 <default_free_pages+0x107>
    	list_add_before(le,&(current_p->page_link));
c0102cc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ccb:	8d 50 0c             	lea    0xc(%eax),%edx
c0102cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cd1:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0102cd4:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102cd7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102cda:	8b 00                	mov    (%eax),%eax
c0102cdc:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102cdf:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102ce2:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102ce5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102ce8:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102ceb:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102cee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102cf1:	89 10                	mov    %edx,(%eax)
c0102cf3:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102cf6:	8b 10                	mov    (%eax),%edx
c0102cf8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102cfb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102cfe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102d01:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102d04:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102d07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102d0a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102d0d:	89 10                	mov    %edx,(%eax)
    	current_p = le2page(le,page_link);
    	if(current_p > base) {
    		break;
    	}
    }
    for(current_p = base; current_p < base + n; ++current_p){
c0102d0f:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
c0102d13:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d16:	89 d0                	mov    %edx,%eax
c0102d18:	c1 e0 02             	shl    $0x2,%eax
c0102d1b:	01 d0                	add    %edx,%eax
c0102d1d:	c1 e0 02             	shl    $0x2,%eax
c0102d20:	89 c2                	mov    %eax,%edx
c0102d22:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d25:	01 d0                	add    %edx,%eax
c0102d27:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102d2a:	77 9c                	ja     c0102cc8 <default_free_pages+0xbc>
    	list_add_before(le,&(current_p->page_link));
    }
    base->flags = 0;
c0102d2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    ClearPageProperty(base);
c0102d36:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d39:	83 c0 04             	add    $0x4,%eax
c0102d3c:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0102d43:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d46:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d49:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102d4c:	0f b3 10             	btr    %edx,(%eax)
    set_page_ref(base,0);
c0102d4f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102d56:	00 
c0102d57:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d5a:	89 04 24             	mov    %eax,(%esp)
c0102d5d:	e8 93 fb ff ff       	call   c01028f5 <set_page_ref>
    SetPageProperty(base);
c0102d62:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d65:	83 c0 04             	add    $0x4,%eax
c0102d68:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0102d6f:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d72:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102d75:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102d78:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
c0102d7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d7e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d81:	89 50 08             	mov    %edx,0x8(%eax)

    current_p = le2page(le, page_link);
c0102d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d87:	83 e8 0c             	sub    $0xc,%eax
c0102d8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(base + n == current_p){
c0102d8d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d90:	89 d0                	mov    %edx,%eax
c0102d92:	c1 e0 02             	shl    $0x2,%eax
c0102d95:	01 d0                	add    %edx,%eax
c0102d97:	c1 e0 02             	shl    $0x2,%eax
c0102d9a:	89 c2                	mov    %eax,%edx
c0102d9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d9f:	01 d0                	add    %edx,%eax
c0102da1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102da4:	75 1e                	jne    c0102dc4 <default_free_pages+0x1b8>
    	base->property += current_p->property;
c0102da6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102da9:	8b 50 08             	mov    0x8(%eax),%edx
c0102dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102daf:	8b 40 08             	mov    0x8(%eax),%eax
c0102db2:	01 c2                	add    %eax,%edx
c0102db4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102db7:	89 50 08             	mov    %edx,0x8(%eax)
    	current_p->property = 0;
c0102dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102dbd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le = list_prev(&(base->page_link));
c0102dc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dc7:	83 c0 0c             	add    $0xc,%eax
c0102dca:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0102dcd:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102dd0:	8b 00                	mov    (%eax),%eax
c0102dd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    current_p = le2page(le, page_link);
c0102dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dd8:	83 e8 0c             	sub    $0xc,%eax
c0102ddb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(current_p + 1 == base && le != &free_list){
c0102dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102de1:	83 c0 14             	add    $0x14,%eax
c0102de4:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102de7:	75 55                	jne    c0102e3e <default_free_pages+0x232>
c0102de9:	81 7d f4 70 89 11 c0 	cmpl   $0xc0118970,-0xc(%ebp)
c0102df0:	74 4c                	je     c0102e3e <default_free_pages+0x232>
    	while(le != &free_list){
c0102df2:	eb 41                	jmp    c0102e35 <default_free_pages+0x229>
    		if(current_p->property > 0){
c0102df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102df7:	8b 40 08             	mov    0x8(%eax),%eax
c0102dfa:	85 c0                	test   %eax,%eax
c0102dfc:	74 20                	je     c0102e1e <default_free_pages+0x212>
    			current_p->property += base->property;
c0102dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e01:	8b 50 08             	mov    0x8(%eax),%edx
c0102e04:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e07:	8b 40 08             	mov    0x8(%eax),%eax
c0102e0a:	01 c2                	add    %eax,%edx
c0102e0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e0f:	89 50 08             	mov    %edx,0x8(%eax)
    			base->property = 0;
c0102e12:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e15:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    			break;
c0102e1c:	eb 20                	jmp    c0102e3e <default_free_pages+0x232>
c0102e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e21:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0102e24:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102e27:	8b 00                	mov    (%eax),%eax
    		}
    		le = list_prev(le);
c0102e29:	89 45 f4             	mov    %eax,-0xc(%ebp)
    		current_p = le2page(le,page_link);
c0102e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e2f:	83 e8 0c             	sub    $0xc,%eax
c0102e32:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	current_p->property = 0;
    }
    le = list_prev(&(base->page_link));
    current_p = le2page(le, page_link);
    if(current_p + 1 == base && le != &free_list){
    	while(le != &free_list){
c0102e35:	81 7d f4 70 89 11 c0 	cmpl   $0xc0118970,-0xc(%ebp)
c0102e3c:	75 b6                	jne    c0102df4 <default_free_pages+0x1e8>
    		}
    		le = list_prev(le);
    		current_p = le2page(le,page_link);
    	}
    }
    nr_free += n;
c0102e3e:	8b 15 78 89 11 c0    	mov    0xc0118978,%edx
c0102e44:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102e47:	01 d0                	add    %edx,%eax
c0102e49:	a3 78 89 11 c0       	mov    %eax,0xc0118978
    return ;
c0102e4e:	90                   	nop
//            list_del(&(p->page_link));
//        }
//    }
//    nr_free += n;
//    list_add(&free_list, &(base->page_link));
}
c0102e4f:	c9                   	leave  
c0102e50:	c3                   	ret    

c0102e51 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102e51:	55                   	push   %ebp
c0102e52:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102e54:	a1 78 89 11 c0       	mov    0xc0118978,%eax
}
c0102e59:	5d                   	pop    %ebp
c0102e5a:	c3                   	ret    

c0102e5b <basic_check>:

static void
basic_check(void) {
c0102e5b:	55                   	push   %ebp
c0102e5c:	89 e5                	mov    %esp,%ebp
c0102e5e:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102e61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e71:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102e74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e7b:	e8 85 0e 00 00       	call   c0103d05 <alloc_pages>
c0102e80:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102e83:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102e87:	75 24                	jne    c0102ead <basic_check+0x52>
c0102e89:	c7 44 24 0c 24 67 10 	movl   $0xc0106724,0xc(%esp)
c0102e90:	c0 
c0102e91:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0102e98:	c0 
c0102e99:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0102ea0:	00 
c0102ea1:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0102ea8:	e8 17 de ff ff       	call   c0100cc4 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102ead:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102eb4:	e8 4c 0e 00 00       	call   c0103d05 <alloc_pages>
c0102eb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102ebc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102ec0:	75 24                	jne    c0102ee6 <basic_check+0x8b>
c0102ec2:	c7 44 24 0c 40 67 10 	movl   $0xc0106740,0xc(%esp)
c0102ec9:	c0 
c0102eca:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0102ed1:	c0 
c0102ed2:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0102ed9:	00 
c0102eda:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0102ee1:	e8 de dd ff ff       	call   c0100cc4 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102ee6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102eed:	e8 13 0e 00 00       	call   c0103d05 <alloc_pages>
c0102ef2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102ef5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102ef9:	75 24                	jne    c0102f1f <basic_check+0xc4>
c0102efb:	c7 44 24 0c 5c 67 10 	movl   $0xc010675c,0xc(%esp)
c0102f02:	c0 
c0102f03:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0102f0a:	c0 
c0102f0b:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0102f12:	00 
c0102f13:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0102f1a:	e8 a5 dd ff ff       	call   c0100cc4 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102f1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f22:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102f25:	74 10                	je     c0102f37 <basic_check+0xdc>
c0102f27:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f2a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f2d:	74 08                	je     c0102f37 <basic_check+0xdc>
c0102f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f32:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f35:	75 24                	jne    c0102f5b <basic_check+0x100>
c0102f37:	c7 44 24 0c 78 67 10 	movl   $0xc0106778,0xc(%esp)
c0102f3e:	c0 
c0102f3f:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0102f46:	c0 
c0102f47:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0102f4e:	00 
c0102f4f:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0102f56:	e8 69 dd ff ff       	call   c0100cc4 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102f5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f5e:	89 04 24             	mov    %eax,(%esp)
c0102f61:	e8 85 f9 ff ff       	call   c01028eb <page_ref>
c0102f66:	85 c0                	test   %eax,%eax
c0102f68:	75 1e                	jne    c0102f88 <basic_check+0x12d>
c0102f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f6d:	89 04 24             	mov    %eax,(%esp)
c0102f70:	e8 76 f9 ff ff       	call   c01028eb <page_ref>
c0102f75:	85 c0                	test   %eax,%eax
c0102f77:	75 0f                	jne    c0102f88 <basic_check+0x12d>
c0102f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f7c:	89 04 24             	mov    %eax,(%esp)
c0102f7f:	e8 67 f9 ff ff       	call   c01028eb <page_ref>
c0102f84:	85 c0                	test   %eax,%eax
c0102f86:	74 24                	je     c0102fac <basic_check+0x151>
c0102f88:	c7 44 24 0c 9c 67 10 	movl   $0xc010679c,0xc(%esp)
c0102f8f:	c0 
c0102f90:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0102f97:	c0 
c0102f98:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0102f9f:	00 
c0102fa0:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0102fa7:	e8 18 dd ff ff       	call   c0100cc4 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102fac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102faf:	89 04 24             	mov    %eax,(%esp)
c0102fb2:	e8 1e f9 ff ff       	call   c01028d5 <page2pa>
c0102fb7:	8b 15 e0 88 11 c0    	mov    0xc01188e0,%edx
c0102fbd:	c1 e2 0c             	shl    $0xc,%edx
c0102fc0:	39 d0                	cmp    %edx,%eax
c0102fc2:	72 24                	jb     c0102fe8 <basic_check+0x18d>
c0102fc4:	c7 44 24 0c d8 67 10 	movl   $0xc01067d8,0xc(%esp)
c0102fcb:	c0 
c0102fcc:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0102fd3:	c0 
c0102fd4:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0102fdb:	00 
c0102fdc:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0102fe3:	e8 dc dc ff ff       	call   c0100cc4 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0102fe8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102feb:	89 04 24             	mov    %eax,(%esp)
c0102fee:	e8 e2 f8 ff ff       	call   c01028d5 <page2pa>
c0102ff3:	8b 15 e0 88 11 c0    	mov    0xc01188e0,%edx
c0102ff9:	c1 e2 0c             	shl    $0xc,%edx
c0102ffc:	39 d0                	cmp    %edx,%eax
c0102ffe:	72 24                	jb     c0103024 <basic_check+0x1c9>
c0103000:	c7 44 24 0c f5 67 10 	movl   $0xc01067f5,0xc(%esp)
c0103007:	c0 
c0103008:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c010300f:	c0 
c0103010:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0103017:	00 
c0103018:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c010301f:	e8 a0 dc ff ff       	call   c0100cc4 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103024:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103027:	89 04 24             	mov    %eax,(%esp)
c010302a:	e8 a6 f8 ff ff       	call   c01028d5 <page2pa>
c010302f:	8b 15 e0 88 11 c0    	mov    0xc01188e0,%edx
c0103035:	c1 e2 0c             	shl    $0xc,%edx
c0103038:	39 d0                	cmp    %edx,%eax
c010303a:	72 24                	jb     c0103060 <basic_check+0x205>
c010303c:	c7 44 24 0c 12 68 10 	movl   $0xc0106812,0xc(%esp)
c0103043:	c0 
c0103044:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c010304b:	c0 
c010304c:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0103053:	00 
c0103054:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c010305b:	e8 64 dc ff ff       	call   c0100cc4 <__panic>

    list_entry_t free_list_store = free_list;
c0103060:	a1 70 89 11 c0       	mov    0xc0118970,%eax
c0103065:	8b 15 74 89 11 c0    	mov    0xc0118974,%edx
c010306b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010306e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103071:	c7 45 e0 70 89 11 c0 	movl   $0xc0118970,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103078:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010307b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010307e:	89 50 04             	mov    %edx,0x4(%eax)
c0103081:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103084:	8b 50 04             	mov    0x4(%eax),%edx
c0103087:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010308a:	89 10                	mov    %edx,(%eax)
c010308c:	c7 45 dc 70 89 11 c0 	movl   $0xc0118970,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103093:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103096:	8b 40 04             	mov    0x4(%eax),%eax
c0103099:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010309c:	0f 94 c0             	sete   %al
c010309f:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01030a2:	85 c0                	test   %eax,%eax
c01030a4:	75 24                	jne    c01030ca <basic_check+0x26f>
c01030a6:	c7 44 24 0c 2f 68 10 	movl   $0xc010682f,0xc(%esp)
c01030ad:	c0 
c01030ae:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01030b5:	c0 
c01030b6:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c01030bd:	00 
c01030be:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01030c5:	e8 fa db ff ff       	call   c0100cc4 <__panic>

    unsigned int nr_free_store = nr_free;
c01030ca:	a1 78 89 11 c0       	mov    0xc0118978,%eax
c01030cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01030d2:	c7 05 78 89 11 c0 00 	movl   $0x0,0xc0118978
c01030d9:	00 00 00 

    assert(alloc_page() == NULL);
c01030dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030e3:	e8 1d 0c 00 00       	call   c0103d05 <alloc_pages>
c01030e8:	85 c0                	test   %eax,%eax
c01030ea:	74 24                	je     c0103110 <basic_check+0x2b5>
c01030ec:	c7 44 24 0c 46 68 10 	movl   $0xc0106846,0xc(%esp)
c01030f3:	c0 
c01030f4:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01030fb:	c0 
c01030fc:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0103103:	00 
c0103104:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c010310b:	e8 b4 db ff ff       	call   c0100cc4 <__panic>

    free_page(p0);
c0103110:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103117:	00 
c0103118:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010311b:	89 04 24             	mov    %eax,(%esp)
c010311e:	e8 1a 0c 00 00       	call   c0103d3d <free_pages>
    free_page(p1);
c0103123:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010312a:	00 
c010312b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010312e:	89 04 24             	mov    %eax,(%esp)
c0103131:	e8 07 0c 00 00       	call   c0103d3d <free_pages>
    free_page(p2);
c0103136:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010313d:	00 
c010313e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103141:	89 04 24             	mov    %eax,(%esp)
c0103144:	e8 f4 0b 00 00       	call   c0103d3d <free_pages>
    assert(nr_free == 3);
c0103149:	a1 78 89 11 c0       	mov    0xc0118978,%eax
c010314e:	83 f8 03             	cmp    $0x3,%eax
c0103151:	74 24                	je     c0103177 <basic_check+0x31c>
c0103153:	c7 44 24 0c 5b 68 10 	movl   $0xc010685b,0xc(%esp)
c010315a:	c0 
c010315b:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103162:	c0 
c0103163:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c010316a:	00 
c010316b:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103172:	e8 4d db ff ff       	call   c0100cc4 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103177:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010317e:	e8 82 0b 00 00       	call   c0103d05 <alloc_pages>
c0103183:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103186:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010318a:	75 24                	jne    c01031b0 <basic_check+0x355>
c010318c:	c7 44 24 0c 24 67 10 	movl   $0xc0106724,0xc(%esp)
c0103193:	c0 
c0103194:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c010319b:	c0 
c010319c:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c01031a3:	00 
c01031a4:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01031ab:	e8 14 db ff ff       	call   c0100cc4 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01031b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031b7:	e8 49 0b 00 00       	call   c0103d05 <alloc_pages>
c01031bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01031bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01031c3:	75 24                	jne    c01031e9 <basic_check+0x38e>
c01031c5:	c7 44 24 0c 40 67 10 	movl   $0xc0106740,0xc(%esp)
c01031cc:	c0 
c01031cd:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01031d4:	c0 
c01031d5:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c01031dc:	00 
c01031dd:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01031e4:	e8 db da ff ff       	call   c0100cc4 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01031e9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031f0:	e8 10 0b 00 00       	call   c0103d05 <alloc_pages>
c01031f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01031f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01031fc:	75 24                	jne    c0103222 <basic_check+0x3c7>
c01031fe:	c7 44 24 0c 5c 67 10 	movl   $0xc010675c,0xc(%esp)
c0103205:	c0 
c0103206:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c010320d:	c0 
c010320e:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0103215:	00 
c0103216:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c010321d:	e8 a2 da ff ff       	call   c0100cc4 <__panic>

    assert(alloc_page() == NULL);
c0103222:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103229:	e8 d7 0a 00 00       	call   c0103d05 <alloc_pages>
c010322e:	85 c0                	test   %eax,%eax
c0103230:	74 24                	je     c0103256 <basic_check+0x3fb>
c0103232:	c7 44 24 0c 46 68 10 	movl   $0xc0106846,0xc(%esp)
c0103239:	c0 
c010323a:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103241:	c0 
c0103242:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0103249:	00 
c010324a:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103251:	e8 6e da ff ff       	call   c0100cc4 <__panic>

    free_page(p0);
c0103256:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010325d:	00 
c010325e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103261:	89 04 24             	mov    %eax,(%esp)
c0103264:	e8 d4 0a 00 00       	call   c0103d3d <free_pages>
c0103269:	c7 45 d8 70 89 11 c0 	movl   $0xc0118970,-0x28(%ebp)
c0103270:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103273:	8b 40 04             	mov    0x4(%eax),%eax
c0103276:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103279:	0f 94 c0             	sete   %al
c010327c:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c010327f:	85 c0                	test   %eax,%eax
c0103281:	74 24                	je     c01032a7 <basic_check+0x44c>
c0103283:	c7 44 24 0c 68 68 10 	movl   $0xc0106868,0xc(%esp)
c010328a:	c0 
c010328b:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103292:	c0 
c0103293:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c010329a:	00 
c010329b:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01032a2:	e8 1d da ff ff       	call   c0100cc4 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01032a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032ae:	e8 52 0a 00 00       	call   c0103d05 <alloc_pages>
c01032b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01032b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01032b9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01032bc:	74 24                	je     c01032e2 <basic_check+0x487>
c01032be:	c7 44 24 0c 80 68 10 	movl   $0xc0106880,0xc(%esp)
c01032c5:	c0 
c01032c6:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01032cd:	c0 
c01032ce:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c01032d5:	00 
c01032d6:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01032dd:	e8 e2 d9 ff ff       	call   c0100cc4 <__panic>
    assert(alloc_page() == NULL);
c01032e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032e9:	e8 17 0a 00 00       	call   c0103d05 <alloc_pages>
c01032ee:	85 c0                	test   %eax,%eax
c01032f0:	74 24                	je     c0103316 <basic_check+0x4bb>
c01032f2:	c7 44 24 0c 46 68 10 	movl   $0xc0106846,0xc(%esp)
c01032f9:	c0 
c01032fa:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103301:	c0 
c0103302:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0103309:	00 
c010330a:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103311:	e8 ae d9 ff ff       	call   c0100cc4 <__panic>

    assert(nr_free == 0);
c0103316:	a1 78 89 11 c0       	mov    0xc0118978,%eax
c010331b:	85 c0                	test   %eax,%eax
c010331d:	74 24                	je     c0103343 <basic_check+0x4e8>
c010331f:	c7 44 24 0c 99 68 10 	movl   $0xc0106899,0xc(%esp)
c0103326:	c0 
c0103327:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c010332e:	c0 
c010332f:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c0103336:	00 
c0103337:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c010333e:	e8 81 d9 ff ff       	call   c0100cc4 <__panic>
    free_list = free_list_store;
c0103343:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103346:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103349:	a3 70 89 11 c0       	mov    %eax,0xc0118970
c010334e:	89 15 74 89 11 c0    	mov    %edx,0xc0118974
    nr_free = nr_free_store;
c0103354:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103357:	a3 78 89 11 c0       	mov    %eax,0xc0118978

    free_page(p);
c010335c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103363:	00 
c0103364:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103367:	89 04 24             	mov    %eax,(%esp)
c010336a:	e8 ce 09 00 00       	call   c0103d3d <free_pages>
    free_page(p1);
c010336f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103376:	00 
c0103377:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010337a:	89 04 24             	mov    %eax,(%esp)
c010337d:	e8 bb 09 00 00       	call   c0103d3d <free_pages>
    free_page(p2);
c0103382:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103389:	00 
c010338a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010338d:	89 04 24             	mov    %eax,(%esp)
c0103390:	e8 a8 09 00 00       	call   c0103d3d <free_pages>
}
c0103395:	c9                   	leave  
c0103396:	c3                   	ret    

c0103397 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103397:	55                   	push   %ebp
c0103398:	89 e5                	mov    %esp,%ebp
c010339a:	53                   	push   %ebx
c010339b:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c01033a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01033a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01033af:	c7 45 ec 70 89 11 c0 	movl   $0xc0118970,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01033b6:	eb 6b                	jmp    c0103423 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c01033b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033bb:	83 e8 0c             	sub    $0xc,%eax
c01033be:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c01033c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033c4:	83 c0 04             	add    $0x4,%eax
c01033c7:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01033ce:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01033d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01033d4:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01033d7:	0f a3 10             	bt     %edx,(%eax)
c01033da:	19 c0                	sbb    %eax,%eax
c01033dc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01033df:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01033e3:	0f 95 c0             	setne  %al
c01033e6:	0f b6 c0             	movzbl %al,%eax
c01033e9:	85 c0                	test   %eax,%eax
c01033eb:	75 24                	jne    c0103411 <default_check+0x7a>
c01033ed:	c7 44 24 0c a6 68 10 	movl   $0xc01068a6,0xc(%esp)
c01033f4:	c0 
c01033f5:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01033fc:	c0 
c01033fd:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0103404:	00 
c0103405:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c010340c:	e8 b3 d8 ff ff       	call   c0100cc4 <__panic>
        count ++, total += p->property;
c0103411:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103415:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103418:	8b 50 08             	mov    0x8(%eax),%edx
c010341b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010341e:	01 d0                	add    %edx,%eax
c0103420:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103423:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103426:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103429:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010342c:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010342f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103432:	81 7d ec 70 89 11 c0 	cmpl   $0xc0118970,-0x14(%ebp)
c0103439:	0f 85 79 ff ff ff    	jne    c01033b8 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c010343f:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103442:	e8 28 09 00 00       	call   c0103d6f <nr_free_pages>
c0103447:	39 c3                	cmp    %eax,%ebx
c0103449:	74 24                	je     c010346f <default_check+0xd8>
c010344b:	c7 44 24 0c b6 68 10 	movl   $0xc01068b6,0xc(%esp)
c0103452:	c0 
c0103453:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c010345a:	c0 
c010345b:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c0103462:	00 
c0103463:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c010346a:	e8 55 d8 ff ff       	call   c0100cc4 <__panic>

    basic_check();
c010346f:	e8 e7 f9 ff ff       	call   c0102e5b <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103474:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010347b:	e8 85 08 00 00       	call   c0103d05 <alloc_pages>
c0103480:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103483:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103487:	75 24                	jne    c01034ad <default_check+0x116>
c0103489:	c7 44 24 0c cf 68 10 	movl   $0xc01068cf,0xc(%esp)
c0103490:	c0 
c0103491:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103498:	c0 
c0103499:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c01034a0:	00 
c01034a1:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01034a8:	e8 17 d8 ff ff       	call   c0100cc4 <__panic>
    assert(!PageProperty(p0));
c01034ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034b0:	83 c0 04             	add    $0x4,%eax
c01034b3:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01034ba:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01034bd:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01034c0:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01034c3:	0f a3 10             	bt     %edx,(%eax)
c01034c6:	19 c0                	sbb    %eax,%eax
c01034c8:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01034cb:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01034cf:	0f 95 c0             	setne  %al
c01034d2:	0f b6 c0             	movzbl %al,%eax
c01034d5:	85 c0                	test   %eax,%eax
c01034d7:	74 24                	je     c01034fd <default_check+0x166>
c01034d9:	c7 44 24 0c da 68 10 	movl   $0xc01068da,0xc(%esp)
c01034e0:	c0 
c01034e1:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01034e8:	c0 
c01034e9:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c01034f0:	00 
c01034f1:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01034f8:	e8 c7 d7 ff ff       	call   c0100cc4 <__panic>

    list_entry_t free_list_store = free_list;
c01034fd:	a1 70 89 11 c0       	mov    0xc0118970,%eax
c0103502:	8b 15 74 89 11 c0    	mov    0xc0118974,%edx
c0103508:	89 45 80             	mov    %eax,-0x80(%ebp)
c010350b:	89 55 84             	mov    %edx,-0x7c(%ebp)
c010350e:	c7 45 b4 70 89 11 c0 	movl   $0xc0118970,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103515:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103518:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010351b:	89 50 04             	mov    %edx,0x4(%eax)
c010351e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103521:	8b 50 04             	mov    0x4(%eax),%edx
c0103524:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103527:	89 10                	mov    %edx,(%eax)
c0103529:	c7 45 b0 70 89 11 c0 	movl   $0xc0118970,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103530:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103533:	8b 40 04             	mov    0x4(%eax),%eax
c0103536:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103539:	0f 94 c0             	sete   %al
c010353c:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010353f:	85 c0                	test   %eax,%eax
c0103541:	75 24                	jne    c0103567 <default_check+0x1d0>
c0103543:	c7 44 24 0c 2f 68 10 	movl   $0xc010682f,0xc(%esp)
c010354a:	c0 
c010354b:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103552:	c0 
c0103553:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c010355a:	00 
c010355b:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103562:	e8 5d d7 ff ff       	call   c0100cc4 <__panic>
    assert(alloc_page() == NULL);
c0103567:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010356e:	e8 92 07 00 00       	call   c0103d05 <alloc_pages>
c0103573:	85 c0                	test   %eax,%eax
c0103575:	74 24                	je     c010359b <default_check+0x204>
c0103577:	c7 44 24 0c 46 68 10 	movl   $0xc0106846,0xc(%esp)
c010357e:	c0 
c010357f:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103586:	c0 
c0103587:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c010358e:	00 
c010358f:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103596:	e8 29 d7 ff ff       	call   c0100cc4 <__panic>

    unsigned int nr_free_store = nr_free;
c010359b:	a1 78 89 11 c0       	mov    0xc0118978,%eax
c01035a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01035a3:	c7 05 78 89 11 c0 00 	movl   $0x0,0xc0118978
c01035aa:	00 00 00 

    free_pages(p0 + 2, 3);
c01035ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035b0:	83 c0 28             	add    $0x28,%eax
c01035b3:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01035ba:	00 
c01035bb:	89 04 24             	mov    %eax,(%esp)
c01035be:	e8 7a 07 00 00       	call   c0103d3d <free_pages>
    assert(alloc_pages(4) == NULL);
c01035c3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01035ca:	e8 36 07 00 00       	call   c0103d05 <alloc_pages>
c01035cf:	85 c0                	test   %eax,%eax
c01035d1:	74 24                	je     c01035f7 <default_check+0x260>
c01035d3:	c7 44 24 0c ec 68 10 	movl   $0xc01068ec,0xc(%esp)
c01035da:	c0 
c01035db:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01035e2:	c0 
c01035e3:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c01035ea:	00 
c01035eb:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01035f2:	e8 cd d6 ff ff       	call   c0100cc4 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01035f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035fa:	83 c0 28             	add    $0x28,%eax
c01035fd:	83 c0 04             	add    $0x4,%eax
c0103600:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103607:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010360a:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010360d:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103610:	0f a3 10             	bt     %edx,(%eax)
c0103613:	19 c0                	sbb    %eax,%eax
c0103615:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103618:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010361c:	0f 95 c0             	setne  %al
c010361f:	0f b6 c0             	movzbl %al,%eax
c0103622:	85 c0                	test   %eax,%eax
c0103624:	74 0e                	je     c0103634 <default_check+0x29d>
c0103626:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103629:	83 c0 28             	add    $0x28,%eax
c010362c:	8b 40 08             	mov    0x8(%eax),%eax
c010362f:	83 f8 03             	cmp    $0x3,%eax
c0103632:	74 24                	je     c0103658 <default_check+0x2c1>
c0103634:	c7 44 24 0c 04 69 10 	movl   $0xc0106904,0xc(%esp)
c010363b:	c0 
c010363c:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103643:	c0 
c0103644:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c010364b:	00 
c010364c:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103653:	e8 6c d6 ff ff       	call   c0100cc4 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103658:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010365f:	e8 a1 06 00 00       	call   c0103d05 <alloc_pages>
c0103664:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103667:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010366b:	75 24                	jne    c0103691 <default_check+0x2fa>
c010366d:	c7 44 24 0c 30 69 10 	movl   $0xc0106930,0xc(%esp)
c0103674:	c0 
c0103675:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c010367c:	c0 
c010367d:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0103684:	00 
c0103685:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c010368c:	e8 33 d6 ff ff       	call   c0100cc4 <__panic>
    assert(alloc_page() == NULL);
c0103691:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103698:	e8 68 06 00 00       	call   c0103d05 <alloc_pages>
c010369d:	85 c0                	test   %eax,%eax
c010369f:	74 24                	je     c01036c5 <default_check+0x32e>
c01036a1:	c7 44 24 0c 46 68 10 	movl   $0xc0106846,0xc(%esp)
c01036a8:	c0 
c01036a9:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01036b0:	c0 
c01036b1:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c01036b8:	00 
c01036b9:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01036c0:	e8 ff d5 ff ff       	call   c0100cc4 <__panic>
    assert(p0 + 2 == p1);
c01036c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036c8:	83 c0 28             	add    $0x28,%eax
c01036cb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01036ce:	74 24                	je     c01036f4 <default_check+0x35d>
c01036d0:	c7 44 24 0c 4e 69 10 	movl   $0xc010694e,0xc(%esp)
c01036d7:	c0 
c01036d8:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01036df:	c0 
c01036e0:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01036e7:	00 
c01036e8:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01036ef:	e8 d0 d5 ff ff       	call   c0100cc4 <__panic>

    p2 = p0 + 1;
c01036f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036f7:	83 c0 14             	add    $0x14,%eax
c01036fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01036fd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103704:	00 
c0103705:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103708:	89 04 24             	mov    %eax,(%esp)
c010370b:	e8 2d 06 00 00       	call   c0103d3d <free_pages>
    free_pages(p1, 3);
c0103710:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103717:	00 
c0103718:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010371b:	89 04 24             	mov    %eax,(%esp)
c010371e:	e8 1a 06 00 00       	call   c0103d3d <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0103723:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103726:	83 c0 04             	add    $0x4,%eax
c0103729:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103730:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103733:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103736:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103739:	0f a3 10             	bt     %edx,(%eax)
c010373c:	19 c0                	sbb    %eax,%eax
c010373e:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0103741:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103745:	0f 95 c0             	setne  %al
c0103748:	0f b6 c0             	movzbl %al,%eax
c010374b:	85 c0                	test   %eax,%eax
c010374d:	74 0b                	je     c010375a <default_check+0x3c3>
c010374f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103752:	8b 40 08             	mov    0x8(%eax),%eax
c0103755:	83 f8 01             	cmp    $0x1,%eax
c0103758:	74 24                	je     c010377e <default_check+0x3e7>
c010375a:	c7 44 24 0c 5c 69 10 	movl   $0xc010695c,0xc(%esp)
c0103761:	c0 
c0103762:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103769:	c0 
c010376a:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
c0103771:	00 
c0103772:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103779:	e8 46 d5 ff ff       	call   c0100cc4 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010377e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103781:	83 c0 04             	add    $0x4,%eax
c0103784:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c010378b:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010378e:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103791:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103794:	0f a3 10             	bt     %edx,(%eax)
c0103797:	19 c0                	sbb    %eax,%eax
c0103799:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c010379c:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01037a0:	0f 95 c0             	setne  %al
c01037a3:	0f b6 c0             	movzbl %al,%eax
c01037a6:	85 c0                	test   %eax,%eax
c01037a8:	74 0b                	je     c01037b5 <default_check+0x41e>
c01037aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01037ad:	8b 40 08             	mov    0x8(%eax),%eax
c01037b0:	83 f8 03             	cmp    $0x3,%eax
c01037b3:	74 24                	je     c01037d9 <default_check+0x442>
c01037b5:	c7 44 24 0c 84 69 10 	movl   $0xc0106984,0xc(%esp)
c01037bc:	c0 
c01037bd:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01037c4:	c0 
c01037c5:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c01037cc:	00 
c01037cd:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01037d4:	e8 eb d4 ff ff       	call   c0100cc4 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01037d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01037e0:	e8 20 05 00 00       	call   c0103d05 <alloc_pages>
c01037e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01037e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01037eb:	83 e8 14             	sub    $0x14,%eax
c01037ee:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01037f1:	74 24                	je     c0103817 <default_check+0x480>
c01037f3:	c7 44 24 0c aa 69 10 	movl   $0xc01069aa,0xc(%esp)
c01037fa:	c0 
c01037fb:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103802:	c0 
c0103803:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c010380a:	00 
c010380b:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103812:	e8 ad d4 ff ff       	call   c0100cc4 <__panic>
    free_page(p0);
c0103817:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010381e:	00 
c010381f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103822:	89 04 24             	mov    %eax,(%esp)
c0103825:	e8 13 05 00 00       	call   c0103d3d <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c010382a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0103831:	e8 cf 04 00 00       	call   c0103d05 <alloc_pages>
c0103836:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103839:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010383c:	83 c0 14             	add    $0x14,%eax
c010383f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103842:	74 24                	je     c0103868 <default_check+0x4d1>
c0103844:	c7 44 24 0c c8 69 10 	movl   $0xc01069c8,0xc(%esp)
c010384b:	c0 
c010384c:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103853:	c0 
c0103854:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
c010385b:	00 
c010385c:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103863:	e8 5c d4 ff ff       	call   c0100cc4 <__panic>

    free_pages(p0, 2);
c0103868:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010386f:	00 
c0103870:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103873:	89 04 24             	mov    %eax,(%esp)
c0103876:	e8 c2 04 00 00       	call   c0103d3d <free_pages>
    free_page(p2);
c010387b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103882:	00 
c0103883:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103886:	89 04 24             	mov    %eax,(%esp)
c0103889:	e8 af 04 00 00       	call   c0103d3d <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c010388e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103895:	e8 6b 04 00 00       	call   c0103d05 <alloc_pages>
c010389a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010389d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01038a1:	75 24                	jne    c01038c7 <default_check+0x530>
c01038a3:	c7 44 24 0c e8 69 10 	movl   $0xc01069e8,0xc(%esp)
c01038aa:	c0 
c01038ab:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01038b2:	c0 
c01038b3:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
c01038ba:	00 
c01038bb:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01038c2:	e8 fd d3 ff ff       	call   c0100cc4 <__panic>
    assert(alloc_page() == NULL);
c01038c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038ce:	e8 32 04 00 00       	call   c0103d05 <alloc_pages>
c01038d3:	85 c0                	test   %eax,%eax
c01038d5:	74 24                	je     c01038fb <default_check+0x564>
c01038d7:	c7 44 24 0c 46 68 10 	movl   $0xc0106846,0xc(%esp)
c01038de:	c0 
c01038df:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01038e6:	c0 
c01038e7:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
c01038ee:	00 
c01038ef:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01038f6:	e8 c9 d3 ff ff       	call   c0100cc4 <__panic>

    assert(nr_free == 0);
c01038fb:	a1 78 89 11 c0       	mov    0xc0118978,%eax
c0103900:	85 c0                	test   %eax,%eax
c0103902:	74 24                	je     c0103928 <default_check+0x591>
c0103904:	c7 44 24 0c 99 68 10 	movl   $0xc0106899,0xc(%esp)
c010390b:	c0 
c010390c:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103913:	c0 
c0103914:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c010391b:	00 
c010391c:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103923:	e8 9c d3 ff ff       	call   c0100cc4 <__panic>
    nr_free = nr_free_store;
c0103928:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010392b:	a3 78 89 11 c0       	mov    %eax,0xc0118978

    free_list = free_list_store;
c0103930:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103933:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103936:	a3 70 89 11 c0       	mov    %eax,0xc0118970
c010393b:	89 15 74 89 11 c0    	mov    %edx,0xc0118974
    free_pages(p0, 5);
c0103941:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103948:	00 
c0103949:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010394c:	89 04 24             	mov    %eax,(%esp)
c010394f:	e8 e9 03 00 00       	call   c0103d3d <free_pages>

    le = &free_list;
c0103954:	c7 45 ec 70 89 11 c0 	movl   $0xc0118970,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010395b:	eb 1d                	jmp    c010397a <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c010395d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103960:	83 e8 0c             	sub    $0xc,%eax
c0103963:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0103966:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010396a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010396d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103970:	8b 40 08             	mov    0x8(%eax),%eax
c0103973:	29 c2                	sub    %eax,%edx
c0103975:	89 d0                	mov    %edx,%eax
c0103977:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010397a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010397d:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103980:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103983:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103986:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103989:	81 7d ec 70 89 11 c0 	cmpl   $0xc0118970,-0x14(%ebp)
c0103990:	75 cb                	jne    c010395d <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0103992:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103996:	74 24                	je     c01039bc <default_check+0x625>
c0103998:	c7 44 24 0c 06 6a 10 	movl   $0xc0106a06,0xc(%esp)
c010399f:	c0 
c01039a0:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01039a7:	c0 
c01039a8:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
c01039af:	00 
c01039b0:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01039b7:	e8 08 d3 ff ff       	call   c0100cc4 <__panic>
    assert(total == 0);
c01039bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01039c0:	74 24                	je     c01039e6 <default_check+0x64f>
c01039c2:	c7 44 24 0c 11 6a 10 	movl   $0xc0106a11,0xc(%esp)
c01039c9:	c0 
c01039ca:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01039d1:	c0 
c01039d2:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
c01039d9:	00 
c01039da:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01039e1:	e8 de d2 ff ff       	call   c0100cc4 <__panic>
}
c01039e6:	81 c4 94 00 00 00    	add    $0x94,%esp
c01039ec:	5b                   	pop    %ebx
c01039ed:	5d                   	pop    %ebp
c01039ee:	c3                   	ret    

c01039ef <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01039ef:	55                   	push   %ebp
c01039f0:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01039f2:	8b 55 08             	mov    0x8(%ebp),%edx
c01039f5:	a1 84 89 11 c0       	mov    0xc0118984,%eax
c01039fa:	29 c2                	sub    %eax,%edx
c01039fc:	89 d0                	mov    %edx,%eax
c01039fe:	c1 f8 02             	sar    $0x2,%eax
c0103a01:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103a07:	5d                   	pop    %ebp
c0103a08:	c3                   	ret    

c0103a09 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103a09:	55                   	push   %ebp
c0103a0a:	89 e5                	mov    %esp,%ebp
c0103a0c:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103a0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a12:	89 04 24             	mov    %eax,(%esp)
c0103a15:	e8 d5 ff ff ff       	call   c01039ef <page2ppn>
c0103a1a:	c1 e0 0c             	shl    $0xc,%eax
}
c0103a1d:	c9                   	leave  
c0103a1e:	c3                   	ret    

c0103a1f <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103a1f:	55                   	push   %ebp
c0103a20:	89 e5                	mov    %esp,%ebp
c0103a22:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103a25:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a28:	c1 e8 0c             	shr    $0xc,%eax
c0103a2b:	89 c2                	mov    %eax,%edx
c0103a2d:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c0103a32:	39 c2                	cmp    %eax,%edx
c0103a34:	72 1c                	jb     c0103a52 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103a36:	c7 44 24 08 4c 6a 10 	movl   $0xc0106a4c,0x8(%esp)
c0103a3d:	c0 
c0103a3e:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103a45:	00 
c0103a46:	c7 04 24 6b 6a 10 c0 	movl   $0xc0106a6b,(%esp)
c0103a4d:	e8 72 d2 ff ff       	call   c0100cc4 <__panic>
    }
    return &pages[PPN(pa)];
c0103a52:	8b 0d 84 89 11 c0    	mov    0xc0118984,%ecx
c0103a58:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a5b:	c1 e8 0c             	shr    $0xc,%eax
c0103a5e:	89 c2                	mov    %eax,%edx
c0103a60:	89 d0                	mov    %edx,%eax
c0103a62:	c1 e0 02             	shl    $0x2,%eax
c0103a65:	01 d0                	add    %edx,%eax
c0103a67:	c1 e0 02             	shl    $0x2,%eax
c0103a6a:	01 c8                	add    %ecx,%eax
}
c0103a6c:	c9                   	leave  
c0103a6d:	c3                   	ret    

c0103a6e <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103a6e:	55                   	push   %ebp
c0103a6f:	89 e5                	mov    %esp,%ebp
c0103a71:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103a74:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a77:	89 04 24             	mov    %eax,(%esp)
c0103a7a:	e8 8a ff ff ff       	call   c0103a09 <page2pa>
c0103a7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a85:	c1 e8 0c             	shr    $0xc,%eax
c0103a88:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a8b:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c0103a90:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103a93:	72 23                	jb     c0103ab8 <page2kva+0x4a>
c0103a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a98:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103a9c:	c7 44 24 08 7c 6a 10 	movl   $0xc0106a7c,0x8(%esp)
c0103aa3:	c0 
c0103aa4:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103aab:	00 
c0103aac:	c7 04 24 6b 6a 10 c0 	movl   $0xc0106a6b,(%esp)
c0103ab3:	e8 0c d2 ff ff       	call   c0100cc4 <__panic>
c0103ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103abb:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103ac0:	c9                   	leave  
c0103ac1:	c3                   	ret    

c0103ac2 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103ac2:	55                   	push   %ebp
c0103ac3:	89 e5                	mov    %esp,%ebp
c0103ac5:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103ac8:	8b 45 08             	mov    0x8(%ebp),%eax
c0103acb:	83 e0 01             	and    $0x1,%eax
c0103ace:	85 c0                	test   %eax,%eax
c0103ad0:	75 1c                	jne    c0103aee <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103ad2:	c7 44 24 08 a0 6a 10 	movl   $0xc0106aa0,0x8(%esp)
c0103ad9:	c0 
c0103ada:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103ae1:	00 
c0103ae2:	c7 04 24 6b 6a 10 c0 	movl   $0xc0106a6b,(%esp)
c0103ae9:	e8 d6 d1 ff ff       	call   c0100cc4 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103aee:	8b 45 08             	mov    0x8(%ebp),%eax
c0103af1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103af6:	89 04 24             	mov    %eax,(%esp)
c0103af9:	e8 21 ff ff ff       	call   c0103a1f <pa2page>
}
c0103afe:	c9                   	leave  
c0103aff:	c3                   	ret    

c0103b00 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103b00:	55                   	push   %ebp
c0103b01:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103b03:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b06:	8b 00                	mov    (%eax),%eax
}
c0103b08:	5d                   	pop    %ebp
c0103b09:	c3                   	ret    

c0103b0a <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103b0a:	55                   	push   %ebp
c0103b0b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103b0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b10:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103b13:	89 10                	mov    %edx,(%eax)
}
c0103b15:	5d                   	pop    %ebp
c0103b16:	c3                   	ret    

c0103b17 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103b17:	55                   	push   %ebp
c0103b18:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103b1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b1d:	8b 00                	mov    (%eax),%eax
c0103b1f:	8d 50 01             	lea    0x1(%eax),%edx
c0103b22:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b25:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103b27:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b2a:	8b 00                	mov    (%eax),%eax
}
c0103b2c:	5d                   	pop    %ebp
c0103b2d:	c3                   	ret    

c0103b2e <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103b2e:	55                   	push   %ebp
c0103b2f:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103b31:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b34:	8b 00                	mov    (%eax),%eax
c0103b36:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103b39:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b3c:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103b3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b41:	8b 00                	mov    (%eax),%eax
}
c0103b43:	5d                   	pop    %ebp
c0103b44:	c3                   	ret    

c0103b45 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103b45:	55                   	push   %ebp
c0103b46:	89 e5                	mov    %esp,%ebp
c0103b48:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103b4b:	9c                   	pushf  
c0103b4c:	58                   	pop    %eax
c0103b4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103b53:	25 00 02 00 00       	and    $0x200,%eax
c0103b58:	85 c0                	test   %eax,%eax
c0103b5a:	74 0c                	je     c0103b68 <__intr_save+0x23>
        intr_disable();
c0103b5c:	e8 46 db ff ff       	call   c01016a7 <intr_disable>
        return 1;
c0103b61:	b8 01 00 00 00       	mov    $0x1,%eax
c0103b66:	eb 05                	jmp    c0103b6d <__intr_save+0x28>
    }
    return 0;
c0103b68:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103b6d:	c9                   	leave  
c0103b6e:	c3                   	ret    

c0103b6f <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103b6f:	55                   	push   %ebp
c0103b70:	89 e5                	mov    %esp,%ebp
c0103b72:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103b75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103b79:	74 05                	je     c0103b80 <__intr_restore+0x11>
        intr_enable();
c0103b7b:	e8 21 db ff ff       	call   c01016a1 <intr_enable>
    }
}
c0103b80:	c9                   	leave  
c0103b81:	c3                   	ret    

c0103b82 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103b82:	55                   	push   %ebp
c0103b83:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103b85:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b88:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103b8b:	b8 23 00 00 00       	mov    $0x23,%eax
c0103b90:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103b92:	b8 23 00 00 00       	mov    $0x23,%eax
c0103b97:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103b99:	b8 10 00 00 00       	mov    $0x10,%eax
c0103b9e:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103ba0:	b8 10 00 00 00       	mov    $0x10,%eax
c0103ba5:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103ba7:	b8 10 00 00 00       	mov    $0x10,%eax
c0103bac:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103bae:	ea b5 3b 10 c0 08 00 	ljmp   $0x8,$0xc0103bb5
}
c0103bb5:	5d                   	pop    %ebp
c0103bb6:	c3                   	ret    

c0103bb7 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103bb7:	55                   	push   %ebp
c0103bb8:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103bba:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bbd:	a3 04 89 11 c0       	mov    %eax,0xc0118904
}
c0103bc2:	5d                   	pop    %ebp
c0103bc3:	c3                   	ret    

c0103bc4 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103bc4:	55                   	push   %ebp
c0103bc5:	89 e5                	mov    %esp,%ebp
c0103bc7:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103bca:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103bcf:	89 04 24             	mov    %eax,(%esp)
c0103bd2:	e8 e0 ff ff ff       	call   c0103bb7 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103bd7:	66 c7 05 08 89 11 c0 	movw   $0x10,0xc0118908
c0103bde:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103be0:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103be7:	68 00 
c0103be9:	b8 00 89 11 c0       	mov    $0xc0118900,%eax
c0103bee:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103bf4:	b8 00 89 11 c0       	mov    $0xc0118900,%eax
c0103bf9:	c1 e8 10             	shr    $0x10,%eax
c0103bfc:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103c01:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c08:	83 e0 f0             	and    $0xfffffff0,%eax
c0103c0b:	83 c8 09             	or     $0x9,%eax
c0103c0e:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c13:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c1a:	83 e0 ef             	and    $0xffffffef,%eax
c0103c1d:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c22:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c29:	83 e0 9f             	and    $0xffffff9f,%eax
c0103c2c:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c31:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c38:	83 c8 80             	or     $0xffffff80,%eax
c0103c3b:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c40:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c47:	83 e0 f0             	and    $0xfffffff0,%eax
c0103c4a:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c4f:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c56:	83 e0 ef             	and    $0xffffffef,%eax
c0103c59:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c5e:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c65:	83 e0 df             	and    $0xffffffdf,%eax
c0103c68:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c6d:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c74:	83 c8 40             	or     $0x40,%eax
c0103c77:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c7c:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c83:	83 e0 7f             	and    $0x7f,%eax
c0103c86:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c8b:	b8 00 89 11 c0       	mov    $0xc0118900,%eax
c0103c90:	c1 e8 18             	shr    $0x18,%eax
c0103c93:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103c98:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103c9f:	e8 de fe ff ff       	call   c0103b82 <lgdt>
c0103ca4:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103caa:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103cae:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103cb1:	c9                   	leave  
c0103cb2:	c3                   	ret    

c0103cb3 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103cb3:	55                   	push   %ebp
c0103cb4:	89 e5                	mov    %esp,%ebp
c0103cb6:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103cb9:	c7 05 7c 89 11 c0 30 	movl   $0xc0106a30,0xc011897c
c0103cc0:	6a 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103cc3:	a1 7c 89 11 c0       	mov    0xc011897c,%eax
c0103cc8:	8b 00                	mov    (%eax),%eax
c0103cca:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103cce:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0103cd5:	e8 62 c6 ff ff       	call   c010033c <cprintf>
    pmm_manager->init();
c0103cda:	a1 7c 89 11 c0       	mov    0xc011897c,%eax
c0103cdf:	8b 40 04             	mov    0x4(%eax),%eax
c0103ce2:	ff d0                	call   *%eax
}
c0103ce4:	c9                   	leave  
c0103ce5:	c3                   	ret    

c0103ce6 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103ce6:	55                   	push   %ebp
c0103ce7:	89 e5                	mov    %esp,%ebp
c0103ce9:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103cec:	a1 7c 89 11 c0       	mov    0xc011897c,%eax
c0103cf1:	8b 40 08             	mov    0x8(%eax),%eax
c0103cf4:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103cf7:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103cfb:	8b 55 08             	mov    0x8(%ebp),%edx
c0103cfe:	89 14 24             	mov    %edx,(%esp)
c0103d01:	ff d0                	call   *%eax
}
c0103d03:	c9                   	leave  
c0103d04:	c3                   	ret    

c0103d05 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103d05:	55                   	push   %ebp
c0103d06:	89 e5                	mov    %esp,%ebp
c0103d08:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103d0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d12:	e8 2e fe ff ff       	call   c0103b45 <__intr_save>
c0103d17:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103d1a:	a1 7c 89 11 c0       	mov    0xc011897c,%eax
c0103d1f:	8b 40 0c             	mov    0xc(%eax),%eax
c0103d22:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d25:	89 14 24             	mov    %edx,(%esp)
c0103d28:	ff d0                	call   *%eax
c0103d2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d30:	89 04 24             	mov    %eax,(%esp)
c0103d33:	e8 37 fe ff ff       	call   c0103b6f <__intr_restore>
    return page;
c0103d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103d3b:	c9                   	leave  
c0103d3c:	c3                   	ret    

c0103d3d <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103d3d:	55                   	push   %ebp
c0103d3e:	89 e5                	mov    %esp,%ebp
c0103d40:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d43:	e8 fd fd ff ff       	call   c0103b45 <__intr_save>
c0103d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103d4b:	a1 7c 89 11 c0       	mov    0xc011897c,%eax
c0103d50:	8b 40 10             	mov    0x10(%eax),%eax
c0103d53:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d56:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d5a:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d5d:	89 14 24             	mov    %edx,(%esp)
c0103d60:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d65:	89 04 24             	mov    %eax,(%esp)
c0103d68:	e8 02 fe ff ff       	call   c0103b6f <__intr_restore>
}
c0103d6d:	c9                   	leave  
c0103d6e:	c3                   	ret    

c0103d6f <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103d6f:	55                   	push   %ebp
c0103d70:	89 e5                	mov    %esp,%ebp
c0103d72:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d75:	e8 cb fd ff ff       	call   c0103b45 <__intr_save>
c0103d7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103d7d:	a1 7c 89 11 c0       	mov    0xc011897c,%eax
c0103d82:	8b 40 14             	mov    0x14(%eax),%eax
c0103d85:	ff d0                	call   *%eax
c0103d87:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d8d:	89 04 24             	mov    %eax,(%esp)
c0103d90:	e8 da fd ff ff       	call   c0103b6f <__intr_restore>
    return ret;
c0103d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103d98:	c9                   	leave  
c0103d99:	c3                   	ret    

c0103d9a <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103d9a:	55                   	push   %ebp
c0103d9b:	89 e5                	mov    %esp,%ebp
c0103d9d:	57                   	push   %edi
c0103d9e:	56                   	push   %esi
c0103d9f:	53                   	push   %ebx
c0103da0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103da6:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103dad:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103db4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103dbb:	c7 04 24 e3 6a 10 c0 	movl   $0xc0106ae3,(%esp)
c0103dc2:	e8 75 c5 ff ff       	call   c010033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103dc7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103dce:	e9 15 01 00 00       	jmp    c0103ee8 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103dd3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103dd6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103dd9:	89 d0                	mov    %edx,%eax
c0103ddb:	c1 e0 02             	shl    $0x2,%eax
c0103dde:	01 d0                	add    %edx,%eax
c0103de0:	c1 e0 02             	shl    $0x2,%eax
c0103de3:	01 c8                	add    %ecx,%eax
c0103de5:	8b 50 08             	mov    0x8(%eax),%edx
c0103de8:	8b 40 04             	mov    0x4(%eax),%eax
c0103deb:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103dee:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103df1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103df4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103df7:	89 d0                	mov    %edx,%eax
c0103df9:	c1 e0 02             	shl    $0x2,%eax
c0103dfc:	01 d0                	add    %edx,%eax
c0103dfe:	c1 e0 02             	shl    $0x2,%eax
c0103e01:	01 c8                	add    %ecx,%eax
c0103e03:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e06:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e09:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e0c:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103e0f:	01 c8                	add    %ecx,%eax
c0103e11:	11 da                	adc    %ebx,%edx
c0103e13:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103e16:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103e19:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e1f:	89 d0                	mov    %edx,%eax
c0103e21:	c1 e0 02             	shl    $0x2,%eax
c0103e24:	01 d0                	add    %edx,%eax
c0103e26:	c1 e0 02             	shl    $0x2,%eax
c0103e29:	01 c8                	add    %ecx,%eax
c0103e2b:	83 c0 14             	add    $0x14,%eax
c0103e2e:	8b 00                	mov    (%eax),%eax
c0103e30:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103e36:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e39:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103e3c:	83 c0 ff             	add    $0xffffffff,%eax
c0103e3f:	83 d2 ff             	adc    $0xffffffff,%edx
c0103e42:	89 c6                	mov    %eax,%esi
c0103e44:	89 d7                	mov    %edx,%edi
c0103e46:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e49:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e4c:	89 d0                	mov    %edx,%eax
c0103e4e:	c1 e0 02             	shl    $0x2,%eax
c0103e51:	01 d0                	add    %edx,%eax
c0103e53:	c1 e0 02             	shl    $0x2,%eax
c0103e56:	01 c8                	add    %ecx,%eax
c0103e58:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e5b:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e5e:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103e64:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103e68:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103e6c:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103e70:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e73:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103e76:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103e7a:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103e7e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103e82:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103e86:	c7 04 24 f0 6a 10 c0 	movl   $0xc0106af0,(%esp)
c0103e8d:	e8 aa c4 ff ff       	call   c010033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103e92:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e95:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e98:	89 d0                	mov    %edx,%eax
c0103e9a:	c1 e0 02             	shl    $0x2,%eax
c0103e9d:	01 d0                	add    %edx,%eax
c0103e9f:	c1 e0 02             	shl    $0x2,%eax
c0103ea2:	01 c8                	add    %ecx,%eax
c0103ea4:	83 c0 14             	add    $0x14,%eax
c0103ea7:	8b 00                	mov    (%eax),%eax
c0103ea9:	83 f8 01             	cmp    $0x1,%eax
c0103eac:	75 36                	jne    c0103ee4 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103eae:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103eb1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103eb4:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103eb7:	77 2b                	ja     c0103ee4 <page_init+0x14a>
c0103eb9:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103ebc:	72 05                	jb     c0103ec3 <page_init+0x129>
c0103ebe:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103ec1:	73 21                	jae    c0103ee4 <page_init+0x14a>
c0103ec3:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103ec7:	77 1b                	ja     c0103ee4 <page_init+0x14a>
c0103ec9:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103ecd:	72 09                	jb     c0103ed8 <page_init+0x13e>
c0103ecf:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103ed6:	77 0c                	ja     c0103ee4 <page_init+0x14a>
                maxpa = end;
c0103ed8:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103edb:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103ede:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103ee1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103ee4:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103ee8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103eeb:	8b 00                	mov    (%eax),%eax
c0103eed:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103ef0:	0f 8f dd fe ff ff    	jg     c0103dd3 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103ef6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103efa:	72 1d                	jb     c0103f19 <page_init+0x17f>
c0103efc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f00:	77 09                	ja     c0103f0b <page_init+0x171>
c0103f02:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103f09:	76 0e                	jbe    c0103f19 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103f0b:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103f12:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103f19:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103f1f:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103f23:	c1 ea 0c             	shr    $0xc,%edx
c0103f26:	a3 e0 88 11 c0       	mov    %eax,0xc01188e0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103f2b:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103f32:	b8 88 89 11 c0       	mov    $0xc0118988,%eax
c0103f37:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103f3a:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103f3d:	01 d0                	add    %edx,%eax
c0103f3f:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103f42:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103f45:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f4a:	f7 75 ac             	divl   -0x54(%ebp)
c0103f4d:	89 d0                	mov    %edx,%eax
c0103f4f:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103f52:	29 c2                	sub    %eax,%edx
c0103f54:	89 d0                	mov    %edx,%eax
c0103f56:	a3 84 89 11 c0       	mov    %eax,0xc0118984

    for (i = 0; i < npage; i ++) {
c0103f5b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103f62:	eb 2f                	jmp    c0103f93 <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103f64:	8b 0d 84 89 11 c0    	mov    0xc0118984,%ecx
c0103f6a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f6d:	89 d0                	mov    %edx,%eax
c0103f6f:	c1 e0 02             	shl    $0x2,%eax
c0103f72:	01 d0                	add    %edx,%eax
c0103f74:	c1 e0 02             	shl    $0x2,%eax
c0103f77:	01 c8                	add    %ecx,%eax
c0103f79:	83 c0 04             	add    $0x4,%eax
c0103f7c:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103f83:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103f86:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103f89:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103f8c:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0103f8f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103f93:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f96:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c0103f9b:	39 c2                	cmp    %eax,%edx
c0103f9d:	72 c5                	jb     c0103f64 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103f9f:	8b 15 e0 88 11 c0    	mov    0xc01188e0,%edx
c0103fa5:	89 d0                	mov    %edx,%eax
c0103fa7:	c1 e0 02             	shl    $0x2,%eax
c0103faa:	01 d0                	add    %edx,%eax
c0103fac:	c1 e0 02             	shl    $0x2,%eax
c0103faf:	89 c2                	mov    %eax,%edx
c0103fb1:	a1 84 89 11 c0       	mov    0xc0118984,%eax
c0103fb6:	01 d0                	add    %edx,%eax
c0103fb8:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0103fbb:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0103fc2:	77 23                	ja     c0103fe7 <page_init+0x24d>
c0103fc4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103fc7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103fcb:	c7 44 24 08 20 6b 10 	movl   $0xc0106b20,0x8(%esp)
c0103fd2:	c0 
c0103fd3:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103fda:	00 
c0103fdb:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0103fe2:	e8 dd cc ff ff       	call   c0100cc4 <__panic>
c0103fe7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103fea:	05 00 00 00 40       	add    $0x40000000,%eax
c0103fef:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103ff2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103ff9:	e9 74 01 00 00       	jmp    c0104172 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103ffe:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104001:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104004:	89 d0                	mov    %edx,%eax
c0104006:	c1 e0 02             	shl    $0x2,%eax
c0104009:	01 d0                	add    %edx,%eax
c010400b:	c1 e0 02             	shl    $0x2,%eax
c010400e:	01 c8                	add    %ecx,%eax
c0104010:	8b 50 08             	mov    0x8(%eax),%edx
c0104013:	8b 40 04             	mov    0x4(%eax),%eax
c0104016:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104019:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010401c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010401f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104022:	89 d0                	mov    %edx,%eax
c0104024:	c1 e0 02             	shl    $0x2,%eax
c0104027:	01 d0                	add    %edx,%eax
c0104029:	c1 e0 02             	shl    $0x2,%eax
c010402c:	01 c8                	add    %ecx,%eax
c010402e:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104031:	8b 58 10             	mov    0x10(%eax),%ebx
c0104034:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104037:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010403a:	01 c8                	add    %ecx,%eax
c010403c:	11 da                	adc    %ebx,%edx
c010403e:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104041:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0104044:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104047:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010404a:	89 d0                	mov    %edx,%eax
c010404c:	c1 e0 02             	shl    $0x2,%eax
c010404f:	01 d0                	add    %edx,%eax
c0104051:	c1 e0 02             	shl    $0x2,%eax
c0104054:	01 c8                	add    %ecx,%eax
c0104056:	83 c0 14             	add    $0x14,%eax
c0104059:	8b 00                	mov    (%eax),%eax
c010405b:	83 f8 01             	cmp    $0x1,%eax
c010405e:	0f 85 0a 01 00 00    	jne    c010416e <page_init+0x3d4>
            if (begin < freemem) {
c0104064:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104067:	ba 00 00 00 00       	mov    $0x0,%edx
c010406c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010406f:	72 17                	jb     c0104088 <page_init+0x2ee>
c0104071:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104074:	77 05                	ja     c010407b <page_init+0x2e1>
c0104076:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0104079:	76 0d                	jbe    c0104088 <page_init+0x2ee>
                begin = freemem;
c010407b:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010407e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104081:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104088:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010408c:	72 1d                	jb     c01040ab <page_init+0x311>
c010408e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104092:	77 09                	ja     c010409d <page_init+0x303>
c0104094:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c010409b:	76 0e                	jbe    c01040ab <page_init+0x311>
                end = KMEMSIZE;
c010409d:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01040a4:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01040ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01040b1:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040b4:	0f 87 b4 00 00 00    	ja     c010416e <page_init+0x3d4>
c01040ba:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040bd:	72 09                	jb     c01040c8 <page_init+0x32e>
c01040bf:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01040c2:	0f 83 a6 00 00 00    	jae    c010416e <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c01040c8:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c01040cf:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01040d2:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01040d5:	01 d0                	add    %edx,%eax
c01040d7:	83 e8 01             	sub    $0x1,%eax
c01040da:	89 45 98             	mov    %eax,-0x68(%ebp)
c01040dd:	8b 45 98             	mov    -0x68(%ebp),%eax
c01040e0:	ba 00 00 00 00       	mov    $0x0,%edx
c01040e5:	f7 75 9c             	divl   -0x64(%ebp)
c01040e8:	89 d0                	mov    %edx,%eax
c01040ea:	8b 55 98             	mov    -0x68(%ebp),%edx
c01040ed:	29 c2                	sub    %eax,%edx
c01040ef:	89 d0                	mov    %edx,%eax
c01040f1:	ba 00 00 00 00       	mov    $0x0,%edx
c01040f6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01040f9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01040fc:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01040ff:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104102:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104105:	ba 00 00 00 00       	mov    $0x0,%edx
c010410a:	89 c7                	mov    %eax,%edi
c010410c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104112:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104115:	89 d0                	mov    %edx,%eax
c0104117:	83 e0 00             	and    $0x0,%eax
c010411a:	89 45 84             	mov    %eax,-0x7c(%ebp)
c010411d:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104120:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104123:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104126:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104129:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010412c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010412f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104132:	77 3a                	ja     c010416e <page_init+0x3d4>
c0104134:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104137:	72 05                	jb     c010413e <page_init+0x3a4>
c0104139:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010413c:	73 30                	jae    c010416e <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c010413e:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0104141:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0104144:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104147:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010414a:	29 c8                	sub    %ecx,%eax
c010414c:	19 da                	sbb    %ebx,%edx
c010414e:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104152:	c1 ea 0c             	shr    $0xc,%edx
c0104155:	89 c3                	mov    %eax,%ebx
c0104157:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010415a:	89 04 24             	mov    %eax,(%esp)
c010415d:	e8 bd f8 ff ff       	call   c0103a1f <pa2page>
c0104162:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104166:	89 04 24             	mov    %eax,(%esp)
c0104169:	e8 78 fb ff ff       	call   c0103ce6 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c010416e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104172:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104175:	8b 00                	mov    (%eax),%eax
c0104177:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010417a:	0f 8f 7e fe ff ff    	jg     c0103ffe <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0104180:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104186:	5b                   	pop    %ebx
c0104187:	5e                   	pop    %esi
c0104188:	5f                   	pop    %edi
c0104189:	5d                   	pop    %ebp
c010418a:	c3                   	ret    

c010418b <enable_paging>:

static void
enable_paging(void) {
c010418b:	55                   	push   %ebp
c010418c:	89 e5                	mov    %esp,%ebp
c010418e:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0104191:	a1 80 89 11 c0       	mov    0xc0118980,%eax
c0104196:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0104199:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010419c:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c010419f:	0f 20 c0             	mov    %cr0,%eax
c01041a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c01041a5:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c01041a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c01041ab:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c01041b2:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c01041b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01041b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c01041bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041bf:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c01041c2:	c9                   	leave  
c01041c3:	c3                   	ret    

c01041c4 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01041c4:	55                   	push   %ebp
c01041c5:	89 e5                	mov    %esp,%ebp
c01041c7:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01041ca:	8b 45 14             	mov    0x14(%ebp),%eax
c01041cd:	8b 55 0c             	mov    0xc(%ebp),%edx
c01041d0:	31 d0                	xor    %edx,%eax
c01041d2:	25 ff 0f 00 00       	and    $0xfff,%eax
c01041d7:	85 c0                	test   %eax,%eax
c01041d9:	74 24                	je     c01041ff <boot_map_segment+0x3b>
c01041db:	c7 44 24 0c 52 6b 10 	movl   $0xc0106b52,0xc(%esp)
c01041e2:	c0 
c01041e3:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c01041ea:	c0 
c01041eb:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c01041f2:	00 
c01041f3:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c01041fa:	e8 c5 ca ff ff       	call   c0100cc4 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01041ff:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104206:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104209:	25 ff 0f 00 00       	and    $0xfff,%eax
c010420e:	89 c2                	mov    %eax,%edx
c0104210:	8b 45 10             	mov    0x10(%ebp),%eax
c0104213:	01 c2                	add    %eax,%edx
c0104215:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104218:	01 d0                	add    %edx,%eax
c010421a:	83 e8 01             	sub    $0x1,%eax
c010421d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104220:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104223:	ba 00 00 00 00       	mov    $0x0,%edx
c0104228:	f7 75 f0             	divl   -0x10(%ebp)
c010422b:	89 d0                	mov    %edx,%eax
c010422d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104230:	29 c2                	sub    %eax,%edx
c0104232:	89 d0                	mov    %edx,%eax
c0104234:	c1 e8 0c             	shr    $0xc,%eax
c0104237:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c010423a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010423d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104240:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104243:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104248:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c010424b:	8b 45 14             	mov    0x14(%ebp),%eax
c010424e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104251:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104254:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104259:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010425c:	eb 6b                	jmp    c01042c9 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010425e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104265:	00 
c0104266:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104269:	89 44 24 04          	mov    %eax,0x4(%esp)
c010426d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104270:	89 04 24             	mov    %eax,(%esp)
c0104273:	e8 cc 01 00 00       	call   c0104444 <get_pte>
c0104278:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c010427b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010427f:	75 24                	jne    c01042a5 <boot_map_segment+0xe1>
c0104281:	c7 44 24 0c 7e 6b 10 	movl   $0xc0106b7e,0xc(%esp)
c0104288:	c0 
c0104289:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104290:	c0 
c0104291:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0104298:	00 
c0104299:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c01042a0:	e8 1f ca ff ff       	call   c0100cc4 <__panic>
        *ptep = pa | PTE_P | perm;
c01042a5:	8b 45 18             	mov    0x18(%ebp),%eax
c01042a8:	8b 55 14             	mov    0x14(%ebp),%edx
c01042ab:	09 d0                	or     %edx,%eax
c01042ad:	83 c8 01             	or     $0x1,%eax
c01042b0:	89 c2                	mov    %eax,%edx
c01042b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042b5:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01042b7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01042bb:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01042c2:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01042c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01042cd:	75 8f                	jne    c010425e <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c01042cf:	c9                   	leave  
c01042d0:	c3                   	ret    

c01042d1 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01042d1:	55                   	push   %ebp
c01042d2:	89 e5                	mov    %esp,%ebp
c01042d4:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01042d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01042de:	e8 22 fa ff ff       	call   c0103d05 <alloc_pages>
c01042e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01042e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01042ea:	75 1c                	jne    c0104308 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01042ec:	c7 44 24 08 8b 6b 10 	movl   $0xc0106b8b,0x8(%esp)
c01042f3:	c0 
c01042f4:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01042fb:	00 
c01042fc:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104303:	e8 bc c9 ff ff       	call   c0100cc4 <__panic>
    }
    return page2kva(p);
c0104308:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010430b:	89 04 24             	mov    %eax,(%esp)
c010430e:	e8 5b f7 ff ff       	call   c0103a6e <page2kva>
}
c0104313:	c9                   	leave  
c0104314:	c3                   	ret    

c0104315 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104315:	55                   	push   %ebp
c0104316:	89 e5                	mov    %esp,%ebp
c0104318:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c010431b:	e8 93 f9 ff ff       	call   c0103cb3 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104320:	e8 75 fa ff ff       	call   c0103d9a <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104325:	e8 70 04 00 00       	call   c010479a <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c010432a:	e8 a2 ff ff ff       	call   c01042d1 <boot_alloc_page>
c010432f:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
    memset(boot_pgdir, 0, PGSIZE);
c0104334:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104339:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104340:	00 
c0104341:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104348:	00 
c0104349:	89 04 24             	mov    %eax,(%esp)
c010434c:	e8 b2 1a 00 00       	call   c0105e03 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c0104351:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104356:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104359:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104360:	77 23                	ja     c0104385 <pmm_init+0x70>
c0104362:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104365:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104369:	c7 44 24 08 20 6b 10 	movl   $0xc0106b20,0x8(%esp)
c0104370:	c0 
c0104371:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0104378:	00 
c0104379:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104380:	e8 3f c9 ff ff       	call   c0100cc4 <__panic>
c0104385:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104388:	05 00 00 00 40       	add    $0x40000000,%eax
c010438d:	a3 80 89 11 c0       	mov    %eax,0xc0118980

    check_pgdir();
c0104392:	e8 21 04 00 00       	call   c01047b8 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104397:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c010439c:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01043a2:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01043a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01043aa:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01043b1:	77 23                	ja     c01043d6 <pmm_init+0xc1>
c01043b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043ba:	c7 44 24 08 20 6b 10 	movl   $0xc0106b20,0x8(%esp)
c01043c1:	c0 
c01043c2:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c01043c9:	00 
c01043ca:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c01043d1:	e8 ee c8 ff ff       	call   c0100cc4 <__panic>
c01043d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043d9:	05 00 00 00 40       	add    $0x40000000,%eax
c01043de:	83 c8 03             	or     $0x3,%eax
c01043e1:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01043e3:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01043e8:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01043ef:	00 
c01043f0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01043f7:	00 
c01043f8:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01043ff:	38 
c0104400:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104407:	c0 
c0104408:	89 04 24             	mov    %eax,(%esp)
c010440b:	e8 b4 fd ff ff       	call   c01041c4 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0104410:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104415:	8b 15 e4 88 11 c0    	mov    0xc01188e4,%edx
c010441b:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0104421:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0104423:	e8 63 fd ff ff       	call   c010418b <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104428:	e8 97 f7 ff ff       	call   c0103bc4 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c010442d:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104432:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104438:	e8 16 0a 00 00       	call   c0104e53 <check_boot_pgdir>

    print_pgdir();
c010443d:	e8 a3 0e 00 00       	call   c01052e5 <print_pgdir>

}
c0104442:	c9                   	leave  
c0104443:	c3                   	ret    

c0104444 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104444:	55                   	push   %ebp
c0104445:	89 e5                	mov    %esp,%ebp
c0104447:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c010444a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010444d:	c1 e8 16             	shr    $0x16,%eax
c0104450:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104457:	8b 45 08             	mov    0x8(%ebp),%eax
c010445a:	01 d0                	add    %edx,%eax
c010445c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c010445f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104462:	8b 00                	mov    (%eax),%eax
c0104464:	83 e0 01             	and    $0x1,%eax
c0104467:	85 c0                	test   %eax,%eax
c0104469:	0f 85 b9 00 00 00    	jne    c0104528 <get_pte+0xe4>
    	if(!create) return NULL;
c010446f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104473:	75 0a                	jne    c010447f <get_pte+0x3b>
c0104475:	b8 00 00 00 00       	mov    $0x0,%eax
c010447a:	e9 05 01 00 00       	jmp    c0104584 <get_pte+0x140>
    	struct Page *new_page = alloc_page();
c010447f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104486:	e8 7a f8 ff ff       	call   c0103d05 <alloc_pages>
c010448b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	if(new_page == NULL) return NULL;
c010448e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104492:	75 0a                	jne    c010449e <get_pte+0x5a>
c0104494:	b8 00 00 00 00       	mov    $0x0,%eax
c0104499:	e9 e6 00 00 00       	jmp    c0104584 <get_pte+0x140>
    	set_page_ref(new_page,1);
c010449e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01044a5:	00 
c01044a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044a9:	89 04 24             	mov    %eax,(%esp)
c01044ac:	e8 59 f6 ff ff       	call   c0103b0a <set_page_ref>
    	uintptr_t pa = page2pa(new_page);
c01044b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044b4:	89 04 24             	mov    %eax,(%esp)
c01044b7:	e8 4d f5 ff ff       	call   c0103a09 <page2pa>
c01044bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	memset(KADDR(pa), 0, PGSIZE);
c01044bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01044c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044c8:	c1 e8 0c             	shr    $0xc,%eax
c01044cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01044ce:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c01044d3:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01044d6:	72 23                	jb     c01044fb <get_pte+0xb7>
c01044d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044db:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01044df:	c7 44 24 08 7c 6a 10 	movl   $0xc0106a7c,0x8(%esp)
c01044e6:	c0 
c01044e7:	c7 44 24 04 86 01 00 	movl   $0x186,0x4(%esp)
c01044ee:	00 
c01044ef:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c01044f6:	e8 c9 c7 ff ff       	call   c0100cc4 <__panic>
c01044fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044fe:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104503:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010450a:	00 
c010450b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104512:	00 
c0104513:	89 04 24             	mov    %eax,(%esp)
c0104516:	e8 e8 18 00 00       	call   c0105e03 <memset>
    	*pdep = pa | PTE_P | PTE_W | PTE_U;
c010451b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010451e:	83 c8 07             	or     $0x7,%eax
c0104521:	89 c2                	mov    %eax,%edx
c0104523:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104526:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0104528:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010452b:	8b 00                	mov    (%eax),%eax
c010452d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104532:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104535:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104538:	c1 e8 0c             	shr    $0xc,%eax
c010453b:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010453e:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c0104543:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104546:	72 23                	jb     c010456b <get_pte+0x127>
c0104548:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010454b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010454f:	c7 44 24 08 7c 6a 10 	movl   $0xc0106a7c,0x8(%esp)
c0104556:	c0 
c0104557:	c7 44 24 04 89 01 00 	movl   $0x189,0x4(%esp)
c010455e:	00 
c010455f:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104566:	e8 59 c7 ff ff       	call   c0100cc4 <__panic>
c010456b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010456e:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104573:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104576:	c1 ea 0c             	shr    $0xc,%edx
c0104579:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c010457f:	c1 e2 02             	shl    $0x2,%edx
c0104582:	01 d0                	add    %edx,%eax
}
c0104584:	c9                   	leave  
c0104585:	c3                   	ret    

c0104586 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104586:	55                   	push   %ebp
c0104587:	89 e5                	mov    %esp,%ebp
c0104589:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010458c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104593:	00 
c0104594:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104597:	89 44 24 04          	mov    %eax,0x4(%esp)
c010459b:	8b 45 08             	mov    0x8(%ebp),%eax
c010459e:	89 04 24             	mov    %eax,(%esp)
c01045a1:	e8 9e fe ff ff       	call   c0104444 <get_pte>
c01045a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01045a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01045ad:	74 08                	je     c01045b7 <get_page+0x31>
        *ptep_store = ptep;
c01045af:	8b 45 10             	mov    0x10(%ebp),%eax
c01045b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01045b5:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01045b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01045bb:	74 1b                	je     c01045d8 <get_page+0x52>
c01045bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045c0:	8b 00                	mov    (%eax),%eax
c01045c2:	83 e0 01             	and    $0x1,%eax
c01045c5:	85 c0                	test   %eax,%eax
c01045c7:	74 0f                	je     c01045d8 <get_page+0x52>
        return pa2page(*ptep);
c01045c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045cc:	8b 00                	mov    (%eax),%eax
c01045ce:	89 04 24             	mov    %eax,(%esp)
c01045d1:	e8 49 f4 ff ff       	call   c0103a1f <pa2page>
c01045d6:	eb 05                	jmp    c01045dd <get_page+0x57>
    }
    return NULL;
c01045d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01045dd:	c9                   	leave  
c01045de:	c3                   	ret    

c01045df <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01045df:	55                   	push   %ebp
c01045e0:	89 e5                	mov    %esp,%ebp
c01045e2:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c01045e5:	8b 45 10             	mov    0x10(%ebp),%eax
c01045e8:	8b 00                	mov    (%eax),%eax
c01045ea:	83 e0 01             	and    $0x1,%eax
c01045ed:	85 c0                	test   %eax,%eax
c01045ef:	74 4d                	je     c010463e <page_remove_pte+0x5f>
    	struct Page *page = pte2page(*ptep);
c01045f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01045f4:	8b 00                	mov    (%eax),%eax
c01045f6:	89 04 24             	mov    %eax,(%esp)
c01045f9:	e8 c4 f4 ff ff       	call   c0103ac2 <pte2page>
c01045fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	if (page_ref_dec(page) == 0) {
c0104601:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104604:	89 04 24             	mov    %eax,(%esp)
c0104607:	e8 22 f5 ff ff       	call   c0103b2e <page_ref_dec>
c010460c:	85 c0                	test   %eax,%eax
c010460e:	75 13                	jne    c0104623 <page_remove_pte+0x44>
    		free_page(page);
c0104610:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104617:	00 
c0104618:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010461b:	89 04 24             	mov    %eax,(%esp)
c010461e:	e8 1a f7 ff ff       	call   c0103d3d <free_pages>
    	}
    	*ptep = 0;
c0104623:	8b 45 10             	mov    0x10(%ebp),%eax
c0104626:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    	tlb_invalidate(pgdir,la);
c010462c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010462f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104633:	8b 45 08             	mov    0x8(%ebp),%eax
c0104636:	89 04 24             	mov    %eax,(%esp)
c0104639:	e8 ff 00 00 00       	call   c010473d <tlb_invalidate>
    }
}
c010463e:	c9                   	leave  
c010463f:	c3                   	ret    

c0104640 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104640:	55                   	push   %ebp
c0104641:	89 e5                	mov    %esp,%ebp
c0104643:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104646:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010464d:	00 
c010464e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104651:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104655:	8b 45 08             	mov    0x8(%ebp),%eax
c0104658:	89 04 24             	mov    %eax,(%esp)
c010465b:	e8 e4 fd ff ff       	call   c0104444 <get_pte>
c0104660:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0104663:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104667:	74 19                	je     c0104682 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0104669:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010466c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104670:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104673:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104677:	8b 45 08             	mov    0x8(%ebp),%eax
c010467a:	89 04 24             	mov    %eax,(%esp)
c010467d:	e8 5d ff ff ff       	call   c01045df <page_remove_pte>
    }
}
c0104682:	c9                   	leave  
c0104683:	c3                   	ret    

c0104684 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0104684:	55                   	push   %ebp
c0104685:	89 e5                	mov    %esp,%ebp
c0104687:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010468a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104691:	00 
c0104692:	8b 45 10             	mov    0x10(%ebp),%eax
c0104695:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104699:	8b 45 08             	mov    0x8(%ebp),%eax
c010469c:	89 04 24             	mov    %eax,(%esp)
c010469f:	e8 a0 fd ff ff       	call   c0104444 <get_pte>
c01046a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01046a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01046ab:	75 0a                	jne    c01046b7 <page_insert+0x33>
        return -E_NO_MEM;
c01046ad:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01046b2:	e9 84 00 00 00       	jmp    c010473b <page_insert+0xb7>
    }
    page_ref_inc(page);
c01046b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046ba:	89 04 24             	mov    %eax,(%esp)
c01046bd:	e8 55 f4 ff ff       	call   c0103b17 <page_ref_inc>
    if (*ptep & PTE_P) {
c01046c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046c5:	8b 00                	mov    (%eax),%eax
c01046c7:	83 e0 01             	and    $0x1,%eax
c01046ca:	85 c0                	test   %eax,%eax
c01046cc:	74 3e                	je     c010470c <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01046ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046d1:	8b 00                	mov    (%eax),%eax
c01046d3:	89 04 24             	mov    %eax,(%esp)
c01046d6:	e8 e7 f3 ff ff       	call   c0103ac2 <pte2page>
c01046db:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01046de:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046e1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01046e4:	75 0d                	jne    c01046f3 <page_insert+0x6f>
            page_ref_dec(page);
c01046e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046e9:	89 04 24             	mov    %eax,(%esp)
c01046ec:	e8 3d f4 ff ff       	call   c0103b2e <page_ref_dec>
c01046f1:	eb 19                	jmp    c010470c <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01046f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046f6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01046fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01046fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104701:	8b 45 08             	mov    0x8(%ebp),%eax
c0104704:	89 04 24             	mov    %eax,(%esp)
c0104707:	e8 d3 fe ff ff       	call   c01045df <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010470c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010470f:	89 04 24             	mov    %eax,(%esp)
c0104712:	e8 f2 f2 ff ff       	call   c0103a09 <page2pa>
c0104717:	0b 45 14             	or     0x14(%ebp),%eax
c010471a:	83 c8 01             	or     $0x1,%eax
c010471d:	89 c2                	mov    %eax,%edx
c010471f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104722:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0104724:	8b 45 10             	mov    0x10(%ebp),%eax
c0104727:	89 44 24 04          	mov    %eax,0x4(%esp)
c010472b:	8b 45 08             	mov    0x8(%ebp),%eax
c010472e:	89 04 24             	mov    %eax,(%esp)
c0104731:	e8 07 00 00 00       	call   c010473d <tlb_invalidate>
    return 0;
c0104736:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010473b:	c9                   	leave  
c010473c:	c3                   	ret    

c010473d <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010473d:	55                   	push   %ebp
c010473e:	89 e5                	mov    %esp,%ebp
c0104740:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0104743:	0f 20 d8             	mov    %cr3,%eax
c0104746:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0104749:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c010474c:	89 c2                	mov    %eax,%edx
c010474e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104751:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104754:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010475b:	77 23                	ja     c0104780 <tlb_invalidate+0x43>
c010475d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104760:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104764:	c7 44 24 08 20 6b 10 	movl   $0xc0106b20,0x8(%esp)
c010476b:	c0 
c010476c:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c0104773:	00 
c0104774:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c010477b:	e8 44 c5 ff ff       	call   c0100cc4 <__panic>
c0104780:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104783:	05 00 00 00 40       	add    $0x40000000,%eax
c0104788:	39 c2                	cmp    %eax,%edx
c010478a:	75 0c                	jne    c0104798 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c010478c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010478f:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104792:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104795:	0f 01 38             	invlpg (%eax)
    }
}
c0104798:	c9                   	leave  
c0104799:	c3                   	ret    

c010479a <check_alloc_page>:

static void
check_alloc_page(void) {
c010479a:	55                   	push   %ebp
c010479b:	89 e5                	mov    %esp,%ebp
c010479d:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01047a0:	a1 7c 89 11 c0       	mov    0xc011897c,%eax
c01047a5:	8b 40 18             	mov    0x18(%eax),%eax
c01047a8:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01047aa:	c7 04 24 a4 6b 10 c0 	movl   $0xc0106ba4,(%esp)
c01047b1:	e8 86 bb ff ff       	call   c010033c <cprintf>
}
c01047b6:	c9                   	leave  
c01047b7:	c3                   	ret    

c01047b8 <check_pgdir>:

static void
check_pgdir(void) {
c01047b8:	55                   	push   %ebp
c01047b9:	89 e5                	mov    %esp,%ebp
c01047bb:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01047be:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c01047c3:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01047c8:	76 24                	jbe    c01047ee <check_pgdir+0x36>
c01047ca:	c7 44 24 0c c3 6b 10 	movl   $0xc0106bc3,0xc(%esp)
c01047d1:	c0 
c01047d2:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c01047d9:	c0 
c01047da:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c01047e1:	00 
c01047e2:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c01047e9:	e8 d6 c4 ff ff       	call   c0100cc4 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01047ee:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01047f3:	85 c0                	test   %eax,%eax
c01047f5:	74 0e                	je     c0104805 <check_pgdir+0x4d>
c01047f7:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01047fc:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104801:	85 c0                	test   %eax,%eax
c0104803:	74 24                	je     c0104829 <check_pgdir+0x71>
c0104805:	c7 44 24 0c e0 6b 10 	movl   $0xc0106be0,0xc(%esp)
c010480c:	c0 
c010480d:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104814:	c0 
c0104815:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c010481c:	00 
c010481d:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104824:	e8 9b c4 ff ff       	call   c0100cc4 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104829:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c010482e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104835:	00 
c0104836:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010483d:	00 
c010483e:	89 04 24             	mov    %eax,(%esp)
c0104841:	e8 40 fd ff ff       	call   c0104586 <get_page>
c0104846:	85 c0                	test   %eax,%eax
c0104848:	74 24                	je     c010486e <check_pgdir+0xb6>
c010484a:	c7 44 24 0c 18 6c 10 	movl   $0xc0106c18,0xc(%esp)
c0104851:	c0 
c0104852:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104859:	c0 
c010485a:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c0104861:	00 
c0104862:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104869:	e8 56 c4 ff ff       	call   c0100cc4 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010486e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104875:	e8 8b f4 ff ff       	call   c0103d05 <alloc_pages>
c010487a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c010487d:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104882:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104889:	00 
c010488a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104891:	00 
c0104892:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104895:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104899:	89 04 24             	mov    %eax,(%esp)
c010489c:	e8 e3 fd ff ff       	call   c0104684 <page_insert>
c01048a1:	85 c0                	test   %eax,%eax
c01048a3:	74 24                	je     c01048c9 <check_pgdir+0x111>
c01048a5:	c7 44 24 0c 40 6c 10 	movl   $0xc0106c40,0xc(%esp)
c01048ac:	c0 
c01048ad:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c01048b4:	c0 
c01048b5:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c01048bc:	00 
c01048bd:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c01048c4:	e8 fb c3 ff ff       	call   c0100cc4 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01048c9:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01048ce:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048d5:	00 
c01048d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01048dd:	00 
c01048de:	89 04 24             	mov    %eax,(%esp)
c01048e1:	e8 5e fb ff ff       	call   c0104444 <get_pte>
c01048e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01048e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01048ed:	75 24                	jne    c0104913 <check_pgdir+0x15b>
c01048ef:	c7 44 24 0c 6c 6c 10 	movl   $0xc0106c6c,0xc(%esp)
c01048f6:	c0 
c01048f7:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c01048fe:	c0 
c01048ff:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0104906:	00 
c0104907:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c010490e:	e8 b1 c3 ff ff       	call   c0100cc4 <__panic>
    assert(pa2page(*ptep) == p1);
c0104913:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104916:	8b 00                	mov    (%eax),%eax
c0104918:	89 04 24             	mov    %eax,(%esp)
c010491b:	e8 ff f0 ff ff       	call   c0103a1f <pa2page>
c0104920:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104923:	74 24                	je     c0104949 <check_pgdir+0x191>
c0104925:	c7 44 24 0c 99 6c 10 	movl   $0xc0106c99,0xc(%esp)
c010492c:	c0 
c010492d:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104934:	c0 
c0104935:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c010493c:	00 
c010493d:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104944:	e8 7b c3 ff ff       	call   c0100cc4 <__panic>
    assert(page_ref(p1) == 1);
c0104949:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010494c:	89 04 24             	mov    %eax,(%esp)
c010494f:	e8 ac f1 ff ff       	call   c0103b00 <page_ref>
c0104954:	83 f8 01             	cmp    $0x1,%eax
c0104957:	74 24                	je     c010497d <check_pgdir+0x1c5>
c0104959:	c7 44 24 0c ae 6c 10 	movl   $0xc0106cae,0xc(%esp)
c0104960:	c0 
c0104961:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104968:	c0 
c0104969:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104970:	00 
c0104971:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104978:	e8 47 c3 ff ff       	call   c0100cc4 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c010497d:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104982:	8b 00                	mov    (%eax),%eax
c0104984:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104989:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010498c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010498f:	c1 e8 0c             	shr    $0xc,%eax
c0104992:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104995:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c010499a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010499d:	72 23                	jb     c01049c2 <check_pgdir+0x20a>
c010499f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01049a6:	c7 44 24 08 7c 6a 10 	movl   $0xc0106a7c,0x8(%esp)
c01049ad:	c0 
c01049ae:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c01049b5:	00 
c01049b6:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c01049bd:	e8 02 c3 ff ff       	call   c0100cc4 <__panic>
c01049c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049c5:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01049ca:	83 c0 04             	add    $0x4,%eax
c01049cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01049d0:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01049d5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01049dc:	00 
c01049dd:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01049e4:	00 
c01049e5:	89 04 24             	mov    %eax,(%esp)
c01049e8:	e8 57 fa ff ff       	call   c0104444 <get_pte>
c01049ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01049f0:	74 24                	je     c0104a16 <check_pgdir+0x25e>
c01049f2:	c7 44 24 0c c0 6c 10 	movl   $0xc0106cc0,0xc(%esp)
c01049f9:	c0 
c01049fa:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104a01:	c0 
c0104a02:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c0104a09:	00 
c0104a0a:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104a11:	e8 ae c2 ff ff       	call   c0100cc4 <__panic>

    p2 = alloc_page();
c0104a16:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104a1d:	e8 e3 f2 ff ff       	call   c0103d05 <alloc_pages>
c0104a22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104a25:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104a2a:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104a31:	00 
c0104a32:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104a39:	00 
c0104a3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104a3d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a41:	89 04 24             	mov    %eax,(%esp)
c0104a44:	e8 3b fc ff ff       	call   c0104684 <page_insert>
c0104a49:	85 c0                	test   %eax,%eax
c0104a4b:	74 24                	je     c0104a71 <check_pgdir+0x2b9>
c0104a4d:	c7 44 24 0c e8 6c 10 	movl   $0xc0106ce8,0xc(%esp)
c0104a54:	c0 
c0104a55:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104a5c:	c0 
c0104a5d:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104a64:	00 
c0104a65:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104a6c:	e8 53 c2 ff ff       	call   c0100cc4 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104a71:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104a76:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a7d:	00 
c0104a7e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104a85:	00 
c0104a86:	89 04 24             	mov    %eax,(%esp)
c0104a89:	e8 b6 f9 ff ff       	call   c0104444 <get_pte>
c0104a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a95:	75 24                	jne    c0104abb <check_pgdir+0x303>
c0104a97:	c7 44 24 0c 20 6d 10 	movl   $0xc0106d20,0xc(%esp)
c0104a9e:	c0 
c0104a9f:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104aa6:	c0 
c0104aa7:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0104aae:	00 
c0104aaf:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104ab6:	e8 09 c2 ff ff       	call   c0100cc4 <__panic>
    assert(*ptep & PTE_U);
c0104abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104abe:	8b 00                	mov    (%eax),%eax
c0104ac0:	83 e0 04             	and    $0x4,%eax
c0104ac3:	85 c0                	test   %eax,%eax
c0104ac5:	75 24                	jne    c0104aeb <check_pgdir+0x333>
c0104ac7:	c7 44 24 0c 50 6d 10 	movl   $0xc0106d50,0xc(%esp)
c0104ace:	c0 
c0104acf:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104ad6:	c0 
c0104ad7:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0104ade:	00 
c0104adf:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104ae6:	e8 d9 c1 ff ff       	call   c0100cc4 <__panic>
    assert(*ptep & PTE_W);
c0104aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104aee:	8b 00                	mov    (%eax),%eax
c0104af0:	83 e0 02             	and    $0x2,%eax
c0104af3:	85 c0                	test   %eax,%eax
c0104af5:	75 24                	jne    c0104b1b <check_pgdir+0x363>
c0104af7:	c7 44 24 0c 5e 6d 10 	movl   $0xc0106d5e,0xc(%esp)
c0104afe:	c0 
c0104aff:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104b06:	c0 
c0104b07:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0104b0e:	00 
c0104b0f:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104b16:	e8 a9 c1 ff ff       	call   c0100cc4 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104b1b:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104b20:	8b 00                	mov    (%eax),%eax
c0104b22:	83 e0 04             	and    $0x4,%eax
c0104b25:	85 c0                	test   %eax,%eax
c0104b27:	75 24                	jne    c0104b4d <check_pgdir+0x395>
c0104b29:	c7 44 24 0c 6c 6d 10 	movl   $0xc0106d6c,0xc(%esp)
c0104b30:	c0 
c0104b31:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104b38:	c0 
c0104b39:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104b40:	00 
c0104b41:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104b48:	e8 77 c1 ff ff       	call   c0100cc4 <__panic>
    assert(page_ref(p2) == 1);
c0104b4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b50:	89 04 24             	mov    %eax,(%esp)
c0104b53:	e8 a8 ef ff ff       	call   c0103b00 <page_ref>
c0104b58:	83 f8 01             	cmp    $0x1,%eax
c0104b5b:	74 24                	je     c0104b81 <check_pgdir+0x3c9>
c0104b5d:	c7 44 24 0c 82 6d 10 	movl   $0xc0106d82,0xc(%esp)
c0104b64:	c0 
c0104b65:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104b6c:	c0 
c0104b6d:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0104b74:	00 
c0104b75:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104b7c:	e8 43 c1 ff ff       	call   c0100cc4 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104b81:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104b86:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104b8d:	00 
c0104b8e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104b95:	00 
c0104b96:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104b99:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104b9d:	89 04 24             	mov    %eax,(%esp)
c0104ba0:	e8 df fa ff ff       	call   c0104684 <page_insert>
c0104ba5:	85 c0                	test   %eax,%eax
c0104ba7:	74 24                	je     c0104bcd <check_pgdir+0x415>
c0104ba9:	c7 44 24 0c 94 6d 10 	movl   $0xc0106d94,0xc(%esp)
c0104bb0:	c0 
c0104bb1:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104bb8:	c0 
c0104bb9:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104bc0:	00 
c0104bc1:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104bc8:	e8 f7 c0 ff ff       	call   c0100cc4 <__panic>
    assert(page_ref(p1) == 2);
c0104bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bd0:	89 04 24             	mov    %eax,(%esp)
c0104bd3:	e8 28 ef ff ff       	call   c0103b00 <page_ref>
c0104bd8:	83 f8 02             	cmp    $0x2,%eax
c0104bdb:	74 24                	je     c0104c01 <check_pgdir+0x449>
c0104bdd:	c7 44 24 0c c0 6d 10 	movl   $0xc0106dc0,0xc(%esp)
c0104be4:	c0 
c0104be5:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104bec:	c0 
c0104bed:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0104bf4:	00 
c0104bf5:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104bfc:	e8 c3 c0 ff ff       	call   c0100cc4 <__panic>
    assert(page_ref(p2) == 0);
c0104c01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c04:	89 04 24             	mov    %eax,(%esp)
c0104c07:	e8 f4 ee ff ff       	call   c0103b00 <page_ref>
c0104c0c:	85 c0                	test   %eax,%eax
c0104c0e:	74 24                	je     c0104c34 <check_pgdir+0x47c>
c0104c10:	c7 44 24 0c d2 6d 10 	movl   $0xc0106dd2,0xc(%esp)
c0104c17:	c0 
c0104c18:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104c1f:	c0 
c0104c20:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104c27:	00 
c0104c28:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104c2f:	e8 90 c0 ff ff       	call   c0100cc4 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104c34:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104c39:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104c40:	00 
c0104c41:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c48:	00 
c0104c49:	89 04 24             	mov    %eax,(%esp)
c0104c4c:	e8 f3 f7 ff ff       	call   c0104444 <get_pte>
c0104c51:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104c58:	75 24                	jne    c0104c7e <check_pgdir+0x4c6>
c0104c5a:	c7 44 24 0c 20 6d 10 	movl   $0xc0106d20,0xc(%esp)
c0104c61:	c0 
c0104c62:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104c69:	c0 
c0104c6a:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0104c71:	00 
c0104c72:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104c79:	e8 46 c0 ff ff       	call   c0100cc4 <__panic>
    assert(pa2page(*ptep) == p1);
c0104c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c81:	8b 00                	mov    (%eax),%eax
c0104c83:	89 04 24             	mov    %eax,(%esp)
c0104c86:	e8 94 ed ff ff       	call   c0103a1f <pa2page>
c0104c8b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104c8e:	74 24                	je     c0104cb4 <check_pgdir+0x4fc>
c0104c90:	c7 44 24 0c 99 6c 10 	movl   $0xc0106c99,0xc(%esp)
c0104c97:	c0 
c0104c98:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104c9f:	c0 
c0104ca0:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104ca7:	00 
c0104ca8:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104caf:	e8 10 c0 ff ff       	call   c0100cc4 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cb7:	8b 00                	mov    (%eax),%eax
c0104cb9:	83 e0 04             	and    $0x4,%eax
c0104cbc:	85 c0                	test   %eax,%eax
c0104cbe:	74 24                	je     c0104ce4 <check_pgdir+0x52c>
c0104cc0:	c7 44 24 0c e4 6d 10 	movl   $0xc0106de4,0xc(%esp)
c0104cc7:	c0 
c0104cc8:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104ccf:	c0 
c0104cd0:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0104cd7:	00 
c0104cd8:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104cdf:	e8 e0 bf ff ff       	call   c0100cc4 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104ce4:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104ce9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104cf0:	00 
c0104cf1:	89 04 24             	mov    %eax,(%esp)
c0104cf4:	e8 47 f9 ff ff       	call   c0104640 <page_remove>
    assert(page_ref(p1) == 1);
c0104cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cfc:	89 04 24             	mov    %eax,(%esp)
c0104cff:	e8 fc ed ff ff       	call   c0103b00 <page_ref>
c0104d04:	83 f8 01             	cmp    $0x1,%eax
c0104d07:	74 24                	je     c0104d2d <check_pgdir+0x575>
c0104d09:	c7 44 24 0c ae 6c 10 	movl   $0xc0106cae,0xc(%esp)
c0104d10:	c0 
c0104d11:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104d18:	c0 
c0104d19:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104d20:	00 
c0104d21:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104d28:	e8 97 bf ff ff       	call   c0100cc4 <__panic>
    assert(page_ref(p2) == 0);
c0104d2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d30:	89 04 24             	mov    %eax,(%esp)
c0104d33:	e8 c8 ed ff ff       	call   c0103b00 <page_ref>
c0104d38:	85 c0                	test   %eax,%eax
c0104d3a:	74 24                	je     c0104d60 <check_pgdir+0x5a8>
c0104d3c:	c7 44 24 0c d2 6d 10 	movl   $0xc0106dd2,0xc(%esp)
c0104d43:	c0 
c0104d44:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104d4b:	c0 
c0104d4c:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104d53:	00 
c0104d54:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104d5b:	e8 64 bf ff ff       	call   c0100cc4 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104d60:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104d65:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104d6c:	00 
c0104d6d:	89 04 24             	mov    %eax,(%esp)
c0104d70:	e8 cb f8 ff ff       	call   c0104640 <page_remove>
    assert(page_ref(p1) == 0);
c0104d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d78:	89 04 24             	mov    %eax,(%esp)
c0104d7b:	e8 80 ed ff ff       	call   c0103b00 <page_ref>
c0104d80:	85 c0                	test   %eax,%eax
c0104d82:	74 24                	je     c0104da8 <check_pgdir+0x5f0>
c0104d84:	c7 44 24 0c f9 6d 10 	movl   $0xc0106df9,0xc(%esp)
c0104d8b:	c0 
c0104d8c:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104d93:	c0 
c0104d94:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0104d9b:	00 
c0104d9c:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104da3:	e8 1c bf ff ff       	call   c0100cc4 <__panic>
    assert(page_ref(p2) == 0);
c0104da8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104dab:	89 04 24             	mov    %eax,(%esp)
c0104dae:	e8 4d ed ff ff       	call   c0103b00 <page_ref>
c0104db3:	85 c0                	test   %eax,%eax
c0104db5:	74 24                	je     c0104ddb <check_pgdir+0x623>
c0104db7:	c7 44 24 0c d2 6d 10 	movl   $0xc0106dd2,0xc(%esp)
c0104dbe:	c0 
c0104dbf:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104dc6:	c0 
c0104dc7:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0104dce:	00 
c0104dcf:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104dd6:	e8 e9 be ff ff       	call   c0100cc4 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0104ddb:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104de0:	8b 00                	mov    (%eax),%eax
c0104de2:	89 04 24             	mov    %eax,(%esp)
c0104de5:	e8 35 ec ff ff       	call   c0103a1f <pa2page>
c0104dea:	89 04 24             	mov    %eax,(%esp)
c0104ded:	e8 0e ed ff ff       	call   c0103b00 <page_ref>
c0104df2:	83 f8 01             	cmp    $0x1,%eax
c0104df5:	74 24                	je     c0104e1b <check_pgdir+0x663>
c0104df7:	c7 44 24 0c 0c 6e 10 	movl   $0xc0106e0c,0xc(%esp)
c0104dfe:	c0 
c0104dff:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104e06:	c0 
c0104e07:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0104e0e:	00 
c0104e0f:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104e16:	e8 a9 be ff ff       	call   c0100cc4 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0104e1b:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104e20:	8b 00                	mov    (%eax),%eax
c0104e22:	89 04 24             	mov    %eax,(%esp)
c0104e25:	e8 f5 eb ff ff       	call   c0103a1f <pa2page>
c0104e2a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104e31:	00 
c0104e32:	89 04 24             	mov    %eax,(%esp)
c0104e35:	e8 03 ef ff ff       	call   c0103d3d <free_pages>
    boot_pgdir[0] = 0;
c0104e3a:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104e3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104e45:	c7 04 24 32 6e 10 c0 	movl   $0xc0106e32,(%esp)
c0104e4c:	e8 eb b4 ff ff       	call   c010033c <cprintf>
}
c0104e51:	c9                   	leave  
c0104e52:	c3                   	ret    

c0104e53 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104e53:	55                   	push   %ebp
c0104e54:	89 e5                	mov    %esp,%ebp
c0104e56:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104e59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104e60:	e9 ca 00 00 00       	jmp    c0104f2f <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e68:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e6e:	c1 e8 0c             	shr    $0xc,%eax
c0104e71:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104e74:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c0104e79:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104e7c:	72 23                	jb     c0104ea1 <check_boot_pgdir+0x4e>
c0104e7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e81:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e85:	c7 44 24 08 7c 6a 10 	movl   $0xc0106a7c,0x8(%esp)
c0104e8c:	c0 
c0104e8d:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c0104e94:	00 
c0104e95:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104e9c:	e8 23 be ff ff       	call   c0100cc4 <__panic>
c0104ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ea4:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104ea9:	89 c2                	mov    %eax,%edx
c0104eab:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104eb0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104eb7:	00 
c0104eb8:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104ebc:	89 04 24             	mov    %eax,(%esp)
c0104ebf:	e8 80 f5 ff ff       	call   c0104444 <get_pte>
c0104ec4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104ec7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104ecb:	75 24                	jne    c0104ef1 <check_boot_pgdir+0x9e>
c0104ecd:	c7 44 24 0c 4c 6e 10 	movl   $0xc0106e4c,0xc(%esp)
c0104ed4:	c0 
c0104ed5:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104edc:	c0 
c0104edd:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c0104ee4:	00 
c0104ee5:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104eec:	e8 d3 bd ff ff       	call   c0100cc4 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104ef1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ef4:	8b 00                	mov    (%eax),%eax
c0104ef6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104efb:	89 c2                	mov    %eax,%edx
c0104efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f00:	39 c2                	cmp    %eax,%edx
c0104f02:	74 24                	je     c0104f28 <check_boot_pgdir+0xd5>
c0104f04:	c7 44 24 0c 89 6e 10 	movl   $0xc0106e89,0xc(%esp)
c0104f0b:	c0 
c0104f0c:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104f13:	c0 
c0104f14:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0104f1b:	00 
c0104f1c:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104f23:	e8 9c bd ff ff       	call   c0100cc4 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104f28:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104f2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104f32:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c0104f37:	39 c2                	cmp    %eax,%edx
c0104f39:	0f 82 26 ff ff ff    	jb     c0104e65 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104f3f:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104f44:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104f49:	8b 00                	mov    (%eax),%eax
c0104f4b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f50:	89 c2                	mov    %eax,%edx
c0104f52:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104f57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104f5a:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104f61:	77 23                	ja     c0104f86 <check_boot_pgdir+0x133>
c0104f63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f66:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f6a:	c7 44 24 08 20 6b 10 	movl   $0xc0106b20,0x8(%esp)
c0104f71:	c0 
c0104f72:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c0104f79:	00 
c0104f7a:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104f81:	e8 3e bd ff ff       	call   c0100cc4 <__panic>
c0104f86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f89:	05 00 00 00 40       	add    $0x40000000,%eax
c0104f8e:	39 c2                	cmp    %eax,%edx
c0104f90:	74 24                	je     c0104fb6 <check_boot_pgdir+0x163>
c0104f92:	c7 44 24 0c a0 6e 10 	movl   $0xc0106ea0,0xc(%esp)
c0104f99:	c0 
c0104f9a:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104fa1:	c0 
c0104fa2:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c0104fa9:	00 
c0104faa:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104fb1:	e8 0e bd ff ff       	call   c0100cc4 <__panic>

    assert(boot_pgdir[0] == 0);
c0104fb6:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104fbb:	8b 00                	mov    (%eax),%eax
c0104fbd:	85 c0                	test   %eax,%eax
c0104fbf:	74 24                	je     c0104fe5 <check_boot_pgdir+0x192>
c0104fc1:	c7 44 24 0c d4 6e 10 	movl   $0xc0106ed4,0xc(%esp)
c0104fc8:	c0 
c0104fc9:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104fd0:	c0 
c0104fd1:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c0104fd8:	00 
c0104fd9:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104fe0:	e8 df bc ff ff       	call   c0100cc4 <__panic>

    struct Page *p;
    p = alloc_page();
c0104fe5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104fec:	e8 14 ed ff ff       	call   c0103d05 <alloc_pages>
c0104ff1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104ff4:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104ff9:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105000:	00 
c0105001:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105008:	00 
c0105009:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010500c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105010:	89 04 24             	mov    %eax,(%esp)
c0105013:	e8 6c f6 ff ff       	call   c0104684 <page_insert>
c0105018:	85 c0                	test   %eax,%eax
c010501a:	74 24                	je     c0105040 <check_boot_pgdir+0x1ed>
c010501c:	c7 44 24 0c e8 6e 10 	movl   $0xc0106ee8,0xc(%esp)
c0105023:	c0 
c0105024:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c010502b:	c0 
c010502c:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c0105033:	00 
c0105034:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c010503b:	e8 84 bc ff ff       	call   c0100cc4 <__panic>
    assert(page_ref(p) == 1);
c0105040:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105043:	89 04 24             	mov    %eax,(%esp)
c0105046:	e8 b5 ea ff ff       	call   c0103b00 <page_ref>
c010504b:	83 f8 01             	cmp    $0x1,%eax
c010504e:	74 24                	je     c0105074 <check_boot_pgdir+0x221>
c0105050:	c7 44 24 0c 16 6f 10 	movl   $0xc0106f16,0xc(%esp)
c0105057:	c0 
c0105058:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c010505f:	c0 
c0105060:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0105067:	00 
c0105068:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c010506f:	e8 50 bc ff ff       	call   c0100cc4 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105074:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0105079:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105080:	00 
c0105081:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105088:	00 
c0105089:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010508c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105090:	89 04 24             	mov    %eax,(%esp)
c0105093:	e8 ec f5 ff ff       	call   c0104684 <page_insert>
c0105098:	85 c0                	test   %eax,%eax
c010509a:	74 24                	je     c01050c0 <check_boot_pgdir+0x26d>
c010509c:	c7 44 24 0c 28 6f 10 	movl   $0xc0106f28,0xc(%esp)
c01050a3:	c0 
c01050a4:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c01050ab:	c0 
c01050ac:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c01050b3:	00 
c01050b4:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c01050bb:	e8 04 bc ff ff       	call   c0100cc4 <__panic>
    assert(page_ref(p) == 2);
c01050c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050c3:	89 04 24             	mov    %eax,(%esp)
c01050c6:	e8 35 ea ff ff       	call   c0103b00 <page_ref>
c01050cb:	83 f8 02             	cmp    $0x2,%eax
c01050ce:	74 24                	je     c01050f4 <check_boot_pgdir+0x2a1>
c01050d0:	c7 44 24 0c 5f 6f 10 	movl   $0xc0106f5f,0xc(%esp)
c01050d7:	c0 
c01050d8:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c01050df:	c0 
c01050e0:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c01050e7:	00 
c01050e8:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c01050ef:	e8 d0 bb ff ff       	call   c0100cc4 <__panic>

    const char *str = "ucore: Hello world!!";
c01050f4:	c7 45 dc 70 6f 10 c0 	movl   $0xc0106f70,-0x24(%ebp)
    strcpy((void *)0x100, str);
c01050fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01050fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105102:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105109:	e8 1e 0a 00 00       	call   c0105b2c <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c010510e:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105115:	00 
c0105116:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010511d:	e8 83 0a 00 00       	call   c0105ba5 <strcmp>
c0105122:	85 c0                	test   %eax,%eax
c0105124:	74 24                	je     c010514a <check_boot_pgdir+0x2f7>
c0105126:	c7 44 24 0c 88 6f 10 	movl   $0xc0106f88,0xc(%esp)
c010512d:	c0 
c010512e:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0105135:	c0 
c0105136:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c010513d:	00 
c010513e:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0105145:	e8 7a bb ff ff       	call   c0100cc4 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c010514a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010514d:	89 04 24             	mov    %eax,(%esp)
c0105150:	e8 19 e9 ff ff       	call   c0103a6e <page2kva>
c0105155:	05 00 01 00 00       	add    $0x100,%eax
c010515a:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c010515d:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105164:	e8 6b 09 00 00       	call   c0105ad4 <strlen>
c0105169:	85 c0                	test   %eax,%eax
c010516b:	74 24                	je     c0105191 <check_boot_pgdir+0x33e>
c010516d:	c7 44 24 0c c0 6f 10 	movl   $0xc0106fc0,0xc(%esp)
c0105174:	c0 
c0105175:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c010517c:	c0 
c010517d:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c0105184:	00 
c0105185:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c010518c:	e8 33 bb ff ff       	call   c0100cc4 <__panic>

    free_page(p);
c0105191:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105198:	00 
c0105199:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010519c:	89 04 24             	mov    %eax,(%esp)
c010519f:	e8 99 eb ff ff       	call   c0103d3d <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c01051a4:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01051a9:	8b 00                	mov    (%eax),%eax
c01051ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01051b0:	89 04 24             	mov    %eax,(%esp)
c01051b3:	e8 67 e8 ff ff       	call   c0103a1f <pa2page>
c01051b8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01051bf:	00 
c01051c0:	89 04 24             	mov    %eax,(%esp)
c01051c3:	e8 75 eb ff ff       	call   c0103d3d <free_pages>
    boot_pgdir[0] = 0;
c01051c8:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01051cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01051d3:	c7 04 24 e4 6f 10 c0 	movl   $0xc0106fe4,(%esp)
c01051da:	e8 5d b1 ff ff       	call   c010033c <cprintf>
}
c01051df:	c9                   	leave  
c01051e0:	c3                   	ret    

c01051e1 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01051e1:	55                   	push   %ebp
c01051e2:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01051e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01051e7:	83 e0 04             	and    $0x4,%eax
c01051ea:	85 c0                	test   %eax,%eax
c01051ec:	74 07                	je     c01051f5 <perm2str+0x14>
c01051ee:	b8 75 00 00 00       	mov    $0x75,%eax
c01051f3:	eb 05                	jmp    c01051fa <perm2str+0x19>
c01051f5:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01051fa:	a2 68 89 11 c0       	mov    %al,0xc0118968
    str[1] = 'r';
c01051ff:	c6 05 69 89 11 c0 72 	movb   $0x72,0xc0118969
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105206:	8b 45 08             	mov    0x8(%ebp),%eax
c0105209:	83 e0 02             	and    $0x2,%eax
c010520c:	85 c0                	test   %eax,%eax
c010520e:	74 07                	je     c0105217 <perm2str+0x36>
c0105210:	b8 77 00 00 00       	mov    $0x77,%eax
c0105215:	eb 05                	jmp    c010521c <perm2str+0x3b>
c0105217:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010521c:	a2 6a 89 11 c0       	mov    %al,0xc011896a
    str[3] = '\0';
c0105221:	c6 05 6b 89 11 c0 00 	movb   $0x0,0xc011896b
    return str;
c0105228:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
}
c010522d:	5d                   	pop    %ebp
c010522e:	c3                   	ret    

c010522f <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c010522f:	55                   	push   %ebp
c0105230:	89 e5                	mov    %esp,%ebp
c0105232:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105235:	8b 45 10             	mov    0x10(%ebp),%eax
c0105238:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010523b:	72 0a                	jb     c0105247 <get_pgtable_items+0x18>
        return 0;
c010523d:	b8 00 00 00 00       	mov    $0x0,%eax
c0105242:	e9 9c 00 00 00       	jmp    c01052e3 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105247:	eb 04                	jmp    c010524d <get_pgtable_items+0x1e>
        start ++;
c0105249:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c010524d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105250:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105253:	73 18                	jae    c010526d <get_pgtable_items+0x3e>
c0105255:	8b 45 10             	mov    0x10(%ebp),%eax
c0105258:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010525f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105262:	01 d0                	add    %edx,%eax
c0105264:	8b 00                	mov    (%eax),%eax
c0105266:	83 e0 01             	and    $0x1,%eax
c0105269:	85 c0                	test   %eax,%eax
c010526b:	74 dc                	je     c0105249 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c010526d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105270:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105273:	73 69                	jae    c01052de <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0105275:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105279:	74 08                	je     c0105283 <get_pgtable_items+0x54>
            *left_store = start;
c010527b:	8b 45 18             	mov    0x18(%ebp),%eax
c010527e:	8b 55 10             	mov    0x10(%ebp),%edx
c0105281:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105283:	8b 45 10             	mov    0x10(%ebp),%eax
c0105286:	8d 50 01             	lea    0x1(%eax),%edx
c0105289:	89 55 10             	mov    %edx,0x10(%ebp)
c010528c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105293:	8b 45 14             	mov    0x14(%ebp),%eax
c0105296:	01 d0                	add    %edx,%eax
c0105298:	8b 00                	mov    (%eax),%eax
c010529a:	83 e0 07             	and    $0x7,%eax
c010529d:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01052a0:	eb 04                	jmp    c01052a6 <get_pgtable_items+0x77>
            start ++;
c01052a2:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c01052a6:	8b 45 10             	mov    0x10(%ebp),%eax
c01052a9:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01052ac:	73 1d                	jae    c01052cb <get_pgtable_items+0x9c>
c01052ae:	8b 45 10             	mov    0x10(%ebp),%eax
c01052b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01052b8:	8b 45 14             	mov    0x14(%ebp),%eax
c01052bb:	01 d0                	add    %edx,%eax
c01052bd:	8b 00                	mov    (%eax),%eax
c01052bf:	83 e0 07             	and    $0x7,%eax
c01052c2:	89 c2                	mov    %eax,%edx
c01052c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01052c7:	39 c2                	cmp    %eax,%edx
c01052c9:	74 d7                	je     c01052a2 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c01052cb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01052cf:	74 08                	je     c01052d9 <get_pgtable_items+0xaa>
            *right_store = start;
c01052d1:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01052d4:	8b 55 10             	mov    0x10(%ebp),%edx
c01052d7:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01052d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01052dc:	eb 05                	jmp    c01052e3 <get_pgtable_items+0xb4>
    }
    return 0;
c01052de:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01052e3:	c9                   	leave  
c01052e4:	c3                   	ret    

c01052e5 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01052e5:	55                   	push   %ebp
c01052e6:	89 e5                	mov    %esp,%ebp
c01052e8:	57                   	push   %edi
c01052e9:	56                   	push   %esi
c01052ea:	53                   	push   %ebx
c01052eb:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01052ee:	c7 04 24 04 70 10 c0 	movl   $0xc0107004,(%esp)
c01052f5:	e8 42 b0 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
c01052fa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105301:	e9 fa 00 00 00       	jmp    c0105400 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105306:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105309:	89 04 24             	mov    %eax,(%esp)
c010530c:	e8 d0 fe ff ff       	call   c01051e1 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105311:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105314:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105317:	29 d1                	sub    %edx,%ecx
c0105319:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010531b:	89 d6                	mov    %edx,%esi
c010531d:	c1 e6 16             	shl    $0x16,%esi
c0105320:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105323:	89 d3                	mov    %edx,%ebx
c0105325:	c1 e3 16             	shl    $0x16,%ebx
c0105328:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010532b:	89 d1                	mov    %edx,%ecx
c010532d:	c1 e1 16             	shl    $0x16,%ecx
c0105330:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105333:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105336:	29 d7                	sub    %edx,%edi
c0105338:	89 fa                	mov    %edi,%edx
c010533a:	89 44 24 14          	mov    %eax,0x14(%esp)
c010533e:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105342:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105346:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010534a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010534e:	c7 04 24 35 70 10 c0 	movl   $0xc0107035,(%esp)
c0105355:	e8 e2 af ff ff       	call   c010033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c010535a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010535d:	c1 e0 0a             	shl    $0xa,%eax
c0105360:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105363:	eb 54                	jmp    c01053b9 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105365:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105368:	89 04 24             	mov    %eax,(%esp)
c010536b:	e8 71 fe ff ff       	call   c01051e1 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105370:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105373:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105376:	29 d1                	sub    %edx,%ecx
c0105378:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010537a:	89 d6                	mov    %edx,%esi
c010537c:	c1 e6 0c             	shl    $0xc,%esi
c010537f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105382:	89 d3                	mov    %edx,%ebx
c0105384:	c1 e3 0c             	shl    $0xc,%ebx
c0105387:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010538a:	c1 e2 0c             	shl    $0xc,%edx
c010538d:	89 d1                	mov    %edx,%ecx
c010538f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105392:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105395:	29 d7                	sub    %edx,%edi
c0105397:	89 fa                	mov    %edi,%edx
c0105399:	89 44 24 14          	mov    %eax,0x14(%esp)
c010539d:	89 74 24 10          	mov    %esi,0x10(%esp)
c01053a1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01053a5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01053a9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01053ad:	c7 04 24 54 70 10 c0 	movl   $0xc0107054,(%esp)
c01053b4:	e8 83 af ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01053b9:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c01053be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01053c1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01053c4:	89 ce                	mov    %ecx,%esi
c01053c6:	c1 e6 0a             	shl    $0xa,%esi
c01053c9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01053cc:	89 cb                	mov    %ecx,%ebx
c01053ce:	c1 e3 0a             	shl    $0xa,%ebx
c01053d1:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c01053d4:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01053d8:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c01053db:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01053df:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01053e3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01053e7:	89 74 24 04          	mov    %esi,0x4(%esp)
c01053eb:	89 1c 24             	mov    %ebx,(%esp)
c01053ee:	e8 3c fe ff ff       	call   c010522f <get_pgtable_items>
c01053f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01053f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01053fa:	0f 85 65 ff ff ff    	jne    c0105365 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105400:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0105405:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105408:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c010540b:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c010540f:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105412:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105416:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010541a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010541e:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105425:	00 
c0105426:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010542d:	e8 fd fd ff ff       	call   c010522f <get_pgtable_items>
c0105432:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105435:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105439:	0f 85 c7 fe ff ff    	jne    c0105306 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c010543f:	c7 04 24 78 70 10 c0 	movl   $0xc0107078,(%esp)
c0105446:	e8 f1 ae ff ff       	call   c010033c <cprintf>
}
c010544b:	83 c4 4c             	add    $0x4c,%esp
c010544e:	5b                   	pop    %ebx
c010544f:	5e                   	pop    %esi
c0105450:	5f                   	pop    %edi
c0105451:	5d                   	pop    %ebp
c0105452:	c3                   	ret    

c0105453 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105453:	55                   	push   %ebp
c0105454:	89 e5                	mov    %esp,%ebp
c0105456:	83 ec 58             	sub    $0x58,%esp
c0105459:	8b 45 10             	mov    0x10(%ebp),%eax
c010545c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010545f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105462:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105465:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105468:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010546b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010546e:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105471:	8b 45 18             	mov    0x18(%ebp),%eax
c0105474:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105477:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010547a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010547d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105480:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105483:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105486:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105489:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010548d:	74 1c                	je     c01054ab <printnum+0x58>
c010548f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105492:	ba 00 00 00 00       	mov    $0x0,%edx
c0105497:	f7 75 e4             	divl   -0x1c(%ebp)
c010549a:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010549d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054a0:	ba 00 00 00 00       	mov    $0x0,%edx
c01054a5:	f7 75 e4             	divl   -0x1c(%ebp)
c01054a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01054b1:	f7 75 e4             	divl   -0x1c(%ebp)
c01054b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01054b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01054ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01054c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01054c3:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01054c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01054c9:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01054cc:	8b 45 18             	mov    0x18(%ebp),%eax
c01054cf:	ba 00 00 00 00       	mov    $0x0,%edx
c01054d4:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01054d7:	77 56                	ja     c010552f <printnum+0xdc>
c01054d9:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01054dc:	72 05                	jb     c01054e3 <printnum+0x90>
c01054de:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01054e1:	77 4c                	ja     c010552f <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c01054e3:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01054e6:	8d 50 ff             	lea    -0x1(%eax),%edx
c01054e9:	8b 45 20             	mov    0x20(%ebp),%eax
c01054ec:	89 44 24 18          	mov    %eax,0x18(%esp)
c01054f0:	89 54 24 14          	mov    %edx,0x14(%esp)
c01054f4:	8b 45 18             	mov    0x18(%ebp),%eax
c01054f7:	89 44 24 10          	mov    %eax,0x10(%esp)
c01054fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105501:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105505:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105509:	8b 45 0c             	mov    0xc(%ebp),%eax
c010550c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105510:	8b 45 08             	mov    0x8(%ebp),%eax
c0105513:	89 04 24             	mov    %eax,(%esp)
c0105516:	e8 38 ff ff ff       	call   c0105453 <printnum>
c010551b:	eb 1c                	jmp    c0105539 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010551d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105520:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105524:	8b 45 20             	mov    0x20(%ebp),%eax
c0105527:	89 04 24             	mov    %eax,(%esp)
c010552a:	8b 45 08             	mov    0x8(%ebp),%eax
c010552d:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c010552f:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0105533:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105537:	7f e4                	jg     c010551d <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105539:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010553c:	05 2c 71 10 c0       	add    $0xc010712c,%eax
c0105541:	0f b6 00             	movzbl (%eax),%eax
c0105544:	0f be c0             	movsbl %al,%eax
c0105547:	8b 55 0c             	mov    0xc(%ebp),%edx
c010554a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010554e:	89 04 24             	mov    %eax,(%esp)
c0105551:	8b 45 08             	mov    0x8(%ebp),%eax
c0105554:	ff d0                	call   *%eax
}
c0105556:	c9                   	leave  
c0105557:	c3                   	ret    

c0105558 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105558:	55                   	push   %ebp
c0105559:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010555b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010555f:	7e 14                	jle    c0105575 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105561:	8b 45 08             	mov    0x8(%ebp),%eax
c0105564:	8b 00                	mov    (%eax),%eax
c0105566:	8d 48 08             	lea    0x8(%eax),%ecx
c0105569:	8b 55 08             	mov    0x8(%ebp),%edx
c010556c:	89 0a                	mov    %ecx,(%edx)
c010556e:	8b 50 04             	mov    0x4(%eax),%edx
c0105571:	8b 00                	mov    (%eax),%eax
c0105573:	eb 30                	jmp    c01055a5 <getuint+0x4d>
    }
    else if (lflag) {
c0105575:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105579:	74 16                	je     c0105591 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010557b:	8b 45 08             	mov    0x8(%ebp),%eax
c010557e:	8b 00                	mov    (%eax),%eax
c0105580:	8d 48 04             	lea    0x4(%eax),%ecx
c0105583:	8b 55 08             	mov    0x8(%ebp),%edx
c0105586:	89 0a                	mov    %ecx,(%edx)
c0105588:	8b 00                	mov    (%eax),%eax
c010558a:	ba 00 00 00 00       	mov    $0x0,%edx
c010558f:	eb 14                	jmp    c01055a5 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105591:	8b 45 08             	mov    0x8(%ebp),%eax
c0105594:	8b 00                	mov    (%eax),%eax
c0105596:	8d 48 04             	lea    0x4(%eax),%ecx
c0105599:	8b 55 08             	mov    0x8(%ebp),%edx
c010559c:	89 0a                	mov    %ecx,(%edx)
c010559e:	8b 00                	mov    (%eax),%eax
c01055a0:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01055a5:	5d                   	pop    %ebp
c01055a6:	c3                   	ret    

c01055a7 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01055a7:	55                   	push   %ebp
c01055a8:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01055aa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01055ae:	7e 14                	jle    c01055c4 <getint+0x1d>
        return va_arg(*ap, long long);
c01055b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01055b3:	8b 00                	mov    (%eax),%eax
c01055b5:	8d 48 08             	lea    0x8(%eax),%ecx
c01055b8:	8b 55 08             	mov    0x8(%ebp),%edx
c01055bb:	89 0a                	mov    %ecx,(%edx)
c01055bd:	8b 50 04             	mov    0x4(%eax),%edx
c01055c0:	8b 00                	mov    (%eax),%eax
c01055c2:	eb 28                	jmp    c01055ec <getint+0x45>
    }
    else if (lflag) {
c01055c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01055c8:	74 12                	je     c01055dc <getint+0x35>
        return va_arg(*ap, long);
c01055ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01055cd:	8b 00                	mov    (%eax),%eax
c01055cf:	8d 48 04             	lea    0x4(%eax),%ecx
c01055d2:	8b 55 08             	mov    0x8(%ebp),%edx
c01055d5:	89 0a                	mov    %ecx,(%edx)
c01055d7:	8b 00                	mov    (%eax),%eax
c01055d9:	99                   	cltd   
c01055da:	eb 10                	jmp    c01055ec <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01055dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01055df:	8b 00                	mov    (%eax),%eax
c01055e1:	8d 48 04             	lea    0x4(%eax),%ecx
c01055e4:	8b 55 08             	mov    0x8(%ebp),%edx
c01055e7:	89 0a                	mov    %ecx,(%edx)
c01055e9:	8b 00                	mov    (%eax),%eax
c01055eb:	99                   	cltd   
    }
}
c01055ec:	5d                   	pop    %ebp
c01055ed:	c3                   	ret    

c01055ee <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01055ee:	55                   	push   %ebp
c01055ef:	89 e5                	mov    %esp,%ebp
c01055f1:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01055f4:	8d 45 14             	lea    0x14(%ebp),%eax
c01055f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01055fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105601:	8b 45 10             	mov    0x10(%ebp),%eax
c0105604:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105608:	8b 45 0c             	mov    0xc(%ebp),%eax
c010560b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010560f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105612:	89 04 24             	mov    %eax,(%esp)
c0105615:	e8 02 00 00 00       	call   c010561c <vprintfmt>
    va_end(ap);
}
c010561a:	c9                   	leave  
c010561b:	c3                   	ret    

c010561c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010561c:	55                   	push   %ebp
c010561d:	89 e5                	mov    %esp,%ebp
c010561f:	56                   	push   %esi
c0105620:	53                   	push   %ebx
c0105621:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105624:	eb 18                	jmp    c010563e <vprintfmt+0x22>
            if (ch == '\0') {
c0105626:	85 db                	test   %ebx,%ebx
c0105628:	75 05                	jne    c010562f <vprintfmt+0x13>
                return;
c010562a:	e9 d1 03 00 00       	jmp    c0105a00 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c010562f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105632:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105636:	89 1c 24             	mov    %ebx,(%esp)
c0105639:	8b 45 08             	mov    0x8(%ebp),%eax
c010563c:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010563e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105641:	8d 50 01             	lea    0x1(%eax),%edx
c0105644:	89 55 10             	mov    %edx,0x10(%ebp)
c0105647:	0f b6 00             	movzbl (%eax),%eax
c010564a:	0f b6 d8             	movzbl %al,%ebx
c010564d:	83 fb 25             	cmp    $0x25,%ebx
c0105650:	75 d4                	jne    c0105626 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105652:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105656:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010565d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105660:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105663:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010566a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010566d:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105670:	8b 45 10             	mov    0x10(%ebp),%eax
c0105673:	8d 50 01             	lea    0x1(%eax),%edx
c0105676:	89 55 10             	mov    %edx,0x10(%ebp)
c0105679:	0f b6 00             	movzbl (%eax),%eax
c010567c:	0f b6 d8             	movzbl %al,%ebx
c010567f:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105682:	83 f8 55             	cmp    $0x55,%eax
c0105685:	0f 87 44 03 00 00    	ja     c01059cf <vprintfmt+0x3b3>
c010568b:	8b 04 85 50 71 10 c0 	mov    -0x3fef8eb0(,%eax,4),%eax
c0105692:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105694:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105698:	eb d6                	jmp    c0105670 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010569a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010569e:	eb d0                	jmp    c0105670 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01056a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01056a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01056aa:	89 d0                	mov    %edx,%eax
c01056ac:	c1 e0 02             	shl    $0x2,%eax
c01056af:	01 d0                	add    %edx,%eax
c01056b1:	01 c0                	add    %eax,%eax
c01056b3:	01 d8                	add    %ebx,%eax
c01056b5:	83 e8 30             	sub    $0x30,%eax
c01056b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01056bb:	8b 45 10             	mov    0x10(%ebp),%eax
c01056be:	0f b6 00             	movzbl (%eax),%eax
c01056c1:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01056c4:	83 fb 2f             	cmp    $0x2f,%ebx
c01056c7:	7e 0b                	jle    c01056d4 <vprintfmt+0xb8>
c01056c9:	83 fb 39             	cmp    $0x39,%ebx
c01056cc:	7f 06                	jg     c01056d4 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01056ce:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01056d2:	eb d3                	jmp    c01056a7 <vprintfmt+0x8b>
            goto process_precision;
c01056d4:	eb 33                	jmp    c0105709 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c01056d6:	8b 45 14             	mov    0x14(%ebp),%eax
c01056d9:	8d 50 04             	lea    0x4(%eax),%edx
c01056dc:	89 55 14             	mov    %edx,0x14(%ebp)
c01056df:	8b 00                	mov    (%eax),%eax
c01056e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01056e4:	eb 23                	jmp    c0105709 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c01056e6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056ea:	79 0c                	jns    c01056f8 <vprintfmt+0xdc>
                width = 0;
c01056ec:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01056f3:	e9 78 ff ff ff       	jmp    c0105670 <vprintfmt+0x54>
c01056f8:	e9 73 ff ff ff       	jmp    c0105670 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c01056fd:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105704:	e9 67 ff ff ff       	jmp    c0105670 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0105709:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010570d:	79 12                	jns    c0105721 <vprintfmt+0x105>
                width = precision, precision = -1;
c010570f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105712:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105715:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010571c:	e9 4f ff ff ff       	jmp    c0105670 <vprintfmt+0x54>
c0105721:	e9 4a ff ff ff       	jmp    c0105670 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105726:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010572a:	e9 41 ff ff ff       	jmp    c0105670 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010572f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105732:	8d 50 04             	lea    0x4(%eax),%edx
c0105735:	89 55 14             	mov    %edx,0x14(%ebp)
c0105738:	8b 00                	mov    (%eax),%eax
c010573a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010573d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105741:	89 04 24             	mov    %eax,(%esp)
c0105744:	8b 45 08             	mov    0x8(%ebp),%eax
c0105747:	ff d0                	call   *%eax
            break;
c0105749:	e9 ac 02 00 00       	jmp    c01059fa <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010574e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105751:	8d 50 04             	lea    0x4(%eax),%edx
c0105754:	89 55 14             	mov    %edx,0x14(%ebp)
c0105757:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105759:	85 db                	test   %ebx,%ebx
c010575b:	79 02                	jns    c010575f <vprintfmt+0x143>
                err = -err;
c010575d:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010575f:	83 fb 06             	cmp    $0x6,%ebx
c0105762:	7f 0b                	jg     c010576f <vprintfmt+0x153>
c0105764:	8b 34 9d 10 71 10 c0 	mov    -0x3fef8ef0(,%ebx,4),%esi
c010576b:	85 f6                	test   %esi,%esi
c010576d:	75 23                	jne    c0105792 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c010576f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105773:	c7 44 24 08 3d 71 10 	movl   $0xc010713d,0x8(%esp)
c010577a:	c0 
c010577b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010577e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105782:	8b 45 08             	mov    0x8(%ebp),%eax
c0105785:	89 04 24             	mov    %eax,(%esp)
c0105788:	e8 61 fe ff ff       	call   c01055ee <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010578d:	e9 68 02 00 00       	jmp    c01059fa <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0105792:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105796:	c7 44 24 08 46 71 10 	movl   $0xc0107146,0x8(%esp)
c010579d:	c0 
c010579e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01057a8:	89 04 24             	mov    %eax,(%esp)
c01057ab:	e8 3e fe ff ff       	call   c01055ee <printfmt>
            }
            break;
c01057b0:	e9 45 02 00 00       	jmp    c01059fa <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01057b5:	8b 45 14             	mov    0x14(%ebp),%eax
c01057b8:	8d 50 04             	lea    0x4(%eax),%edx
c01057bb:	89 55 14             	mov    %edx,0x14(%ebp)
c01057be:	8b 30                	mov    (%eax),%esi
c01057c0:	85 f6                	test   %esi,%esi
c01057c2:	75 05                	jne    c01057c9 <vprintfmt+0x1ad>
                p = "(null)";
c01057c4:	be 49 71 10 c0       	mov    $0xc0107149,%esi
            }
            if (width > 0 && padc != '-') {
c01057c9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057cd:	7e 3e                	jle    c010580d <vprintfmt+0x1f1>
c01057cf:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01057d3:	74 38                	je     c010580d <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01057d5:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c01057d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057db:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057df:	89 34 24             	mov    %esi,(%esp)
c01057e2:	e8 15 03 00 00       	call   c0105afc <strnlen>
c01057e7:	29 c3                	sub    %eax,%ebx
c01057e9:	89 d8                	mov    %ebx,%eax
c01057eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057ee:	eb 17                	jmp    c0105807 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c01057f0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01057f4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01057f7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01057fb:	89 04 24             	mov    %eax,(%esp)
c01057fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105801:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105803:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105807:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010580b:	7f e3                	jg     c01057f0 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010580d:	eb 38                	jmp    c0105847 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c010580f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105813:	74 1f                	je     c0105834 <vprintfmt+0x218>
c0105815:	83 fb 1f             	cmp    $0x1f,%ebx
c0105818:	7e 05                	jle    c010581f <vprintfmt+0x203>
c010581a:	83 fb 7e             	cmp    $0x7e,%ebx
c010581d:	7e 15                	jle    c0105834 <vprintfmt+0x218>
                    putch('?', putdat);
c010581f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105822:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105826:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010582d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105830:	ff d0                	call   *%eax
c0105832:	eb 0f                	jmp    c0105843 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0105834:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105837:	89 44 24 04          	mov    %eax,0x4(%esp)
c010583b:	89 1c 24             	mov    %ebx,(%esp)
c010583e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105841:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105843:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105847:	89 f0                	mov    %esi,%eax
c0105849:	8d 70 01             	lea    0x1(%eax),%esi
c010584c:	0f b6 00             	movzbl (%eax),%eax
c010584f:	0f be d8             	movsbl %al,%ebx
c0105852:	85 db                	test   %ebx,%ebx
c0105854:	74 10                	je     c0105866 <vprintfmt+0x24a>
c0105856:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010585a:	78 b3                	js     c010580f <vprintfmt+0x1f3>
c010585c:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105860:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105864:	79 a9                	jns    c010580f <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105866:	eb 17                	jmp    c010587f <vprintfmt+0x263>
                putch(' ', putdat);
c0105868:	8b 45 0c             	mov    0xc(%ebp),%eax
c010586b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010586f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105876:	8b 45 08             	mov    0x8(%ebp),%eax
c0105879:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010587b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010587f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105883:	7f e3                	jg     c0105868 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0105885:	e9 70 01 00 00       	jmp    c01059fa <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010588a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010588d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105891:	8d 45 14             	lea    0x14(%ebp),%eax
c0105894:	89 04 24             	mov    %eax,(%esp)
c0105897:	e8 0b fd ff ff       	call   c01055a7 <getint>
c010589c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010589f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01058a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01058a8:	85 d2                	test   %edx,%edx
c01058aa:	79 26                	jns    c01058d2 <vprintfmt+0x2b6>
                putch('-', putdat);
c01058ac:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058b3:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01058ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01058bd:	ff d0                	call   *%eax
                num = -(long long)num;
c01058bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01058c5:	f7 d8                	neg    %eax
c01058c7:	83 d2 00             	adc    $0x0,%edx
c01058ca:	f7 da                	neg    %edx
c01058cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01058d2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058d9:	e9 a8 00 00 00       	jmp    c0105986 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01058de:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058e1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058e5:	8d 45 14             	lea    0x14(%ebp),%eax
c01058e8:	89 04 24             	mov    %eax,(%esp)
c01058eb:	e8 68 fc ff ff       	call   c0105558 <getuint>
c01058f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01058f6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058fd:	e9 84 00 00 00       	jmp    c0105986 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105902:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105905:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105909:	8d 45 14             	lea    0x14(%ebp),%eax
c010590c:	89 04 24             	mov    %eax,(%esp)
c010590f:	e8 44 fc ff ff       	call   c0105558 <getuint>
c0105914:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105917:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010591a:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105921:	eb 63                	jmp    c0105986 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0105923:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105926:	89 44 24 04          	mov    %eax,0x4(%esp)
c010592a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105931:	8b 45 08             	mov    0x8(%ebp),%eax
c0105934:	ff d0                	call   *%eax
            putch('x', putdat);
c0105936:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105939:	89 44 24 04          	mov    %eax,0x4(%esp)
c010593d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105944:	8b 45 08             	mov    0x8(%ebp),%eax
c0105947:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105949:	8b 45 14             	mov    0x14(%ebp),%eax
c010594c:	8d 50 04             	lea    0x4(%eax),%edx
c010594f:	89 55 14             	mov    %edx,0x14(%ebp)
c0105952:	8b 00                	mov    (%eax),%eax
c0105954:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105957:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010595e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105965:	eb 1f                	jmp    c0105986 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105967:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010596a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010596e:	8d 45 14             	lea    0x14(%ebp),%eax
c0105971:	89 04 24             	mov    %eax,(%esp)
c0105974:	e8 df fb ff ff       	call   c0105558 <getuint>
c0105979:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010597c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010597f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105986:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010598a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010598d:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105991:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105994:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105998:	89 44 24 10          	mov    %eax,0x10(%esp)
c010599c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010599f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059a2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01059a6:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01059aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059ad:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b4:	89 04 24             	mov    %eax,(%esp)
c01059b7:	e8 97 fa ff ff       	call   c0105453 <printnum>
            break;
c01059bc:	eb 3c                	jmp    c01059fa <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01059be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059c5:	89 1c 24             	mov    %ebx,(%esp)
c01059c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01059cb:	ff d0                	call   *%eax
            break;
c01059cd:	eb 2b                	jmp    c01059fa <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01059cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059d2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059d6:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01059dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01059e0:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01059e2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01059e6:	eb 04                	jmp    c01059ec <vprintfmt+0x3d0>
c01059e8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01059ec:	8b 45 10             	mov    0x10(%ebp),%eax
c01059ef:	83 e8 01             	sub    $0x1,%eax
c01059f2:	0f b6 00             	movzbl (%eax),%eax
c01059f5:	3c 25                	cmp    $0x25,%al
c01059f7:	75 ef                	jne    c01059e8 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c01059f9:	90                   	nop
        }
    }
c01059fa:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01059fb:	e9 3e fc ff ff       	jmp    c010563e <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105a00:	83 c4 40             	add    $0x40,%esp
c0105a03:	5b                   	pop    %ebx
c0105a04:	5e                   	pop    %esi
c0105a05:	5d                   	pop    %ebp
c0105a06:	c3                   	ret    

c0105a07 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105a07:	55                   	push   %ebp
c0105a08:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105a0a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a0d:	8b 40 08             	mov    0x8(%eax),%eax
c0105a10:	8d 50 01             	lea    0x1(%eax),%edx
c0105a13:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a16:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105a19:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a1c:	8b 10                	mov    (%eax),%edx
c0105a1e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a21:	8b 40 04             	mov    0x4(%eax),%eax
c0105a24:	39 c2                	cmp    %eax,%edx
c0105a26:	73 12                	jae    c0105a3a <sprintputch+0x33>
        *b->buf ++ = ch;
c0105a28:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a2b:	8b 00                	mov    (%eax),%eax
c0105a2d:	8d 48 01             	lea    0x1(%eax),%ecx
c0105a30:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105a33:	89 0a                	mov    %ecx,(%edx)
c0105a35:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a38:	88 10                	mov    %dl,(%eax)
    }
}
c0105a3a:	5d                   	pop    %ebp
c0105a3b:	c3                   	ret    

c0105a3c <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105a3c:	55                   	push   %ebp
c0105a3d:	89 e5                	mov    %esp,%ebp
c0105a3f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105a42:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a4b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a4f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a52:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a56:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a59:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a60:	89 04 24             	mov    %eax,(%esp)
c0105a63:	e8 08 00 00 00       	call   c0105a70 <vsnprintf>
c0105a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a6e:	c9                   	leave  
c0105a6f:	c3                   	ret    

c0105a70 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105a70:	55                   	push   %ebp
c0105a71:	89 e5                	mov    %esp,%ebp
c0105a73:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105a76:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a79:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a7c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a7f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a82:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a85:	01 d0                	add    %edx,%eax
c0105a87:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105a91:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105a95:	74 0a                	je     c0105aa1 <vsnprintf+0x31>
c0105a97:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a9d:	39 c2                	cmp    %eax,%edx
c0105a9f:	76 07                	jbe    c0105aa8 <vsnprintf+0x38>
        return -E_INVAL;
c0105aa1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105aa6:	eb 2a                	jmp    c0105ad2 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105aa8:	8b 45 14             	mov    0x14(%ebp),%eax
c0105aab:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105aaf:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ab2:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105ab6:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105ab9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105abd:	c7 04 24 07 5a 10 c0 	movl   $0xc0105a07,(%esp)
c0105ac4:	e8 53 fb ff ff       	call   c010561c <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105ac9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105acc:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105ad2:	c9                   	leave  
c0105ad3:	c3                   	ret    

c0105ad4 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105ad4:	55                   	push   %ebp
c0105ad5:	89 e5                	mov    %esp,%ebp
c0105ad7:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105ada:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105ae1:	eb 04                	jmp    c0105ae7 <strlen+0x13>
        cnt ++;
c0105ae3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105ae7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aea:	8d 50 01             	lea    0x1(%eax),%edx
c0105aed:	89 55 08             	mov    %edx,0x8(%ebp)
c0105af0:	0f b6 00             	movzbl (%eax),%eax
c0105af3:	84 c0                	test   %al,%al
c0105af5:	75 ec                	jne    c0105ae3 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105af7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105afa:	c9                   	leave  
c0105afb:	c3                   	ret    

c0105afc <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105afc:	55                   	push   %ebp
c0105afd:	89 e5                	mov    %esp,%ebp
c0105aff:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105b02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105b09:	eb 04                	jmp    c0105b0f <strnlen+0x13>
        cnt ++;
c0105b0b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105b0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b12:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105b15:	73 10                	jae    c0105b27 <strnlen+0x2b>
c0105b17:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b1a:	8d 50 01             	lea    0x1(%eax),%edx
c0105b1d:	89 55 08             	mov    %edx,0x8(%ebp)
c0105b20:	0f b6 00             	movzbl (%eax),%eax
c0105b23:	84 c0                	test   %al,%al
c0105b25:	75 e4                	jne    c0105b0b <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105b27:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105b2a:	c9                   	leave  
c0105b2b:	c3                   	ret    

c0105b2c <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105b2c:	55                   	push   %ebp
c0105b2d:	89 e5                	mov    %esp,%ebp
c0105b2f:	57                   	push   %edi
c0105b30:	56                   	push   %esi
c0105b31:	83 ec 20             	sub    $0x20,%esp
c0105b34:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b37:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105b40:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b46:	89 d1                	mov    %edx,%ecx
c0105b48:	89 c2                	mov    %eax,%edx
c0105b4a:	89 ce                	mov    %ecx,%esi
c0105b4c:	89 d7                	mov    %edx,%edi
c0105b4e:	ac                   	lods   %ds:(%esi),%al
c0105b4f:	aa                   	stos   %al,%es:(%edi)
c0105b50:	84 c0                	test   %al,%al
c0105b52:	75 fa                	jne    c0105b4e <strcpy+0x22>
c0105b54:	89 fa                	mov    %edi,%edx
c0105b56:	89 f1                	mov    %esi,%ecx
c0105b58:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105b5b:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105b5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105b64:	83 c4 20             	add    $0x20,%esp
c0105b67:	5e                   	pop    %esi
c0105b68:	5f                   	pop    %edi
c0105b69:	5d                   	pop    %ebp
c0105b6a:	c3                   	ret    

c0105b6b <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105b6b:	55                   	push   %ebp
c0105b6c:	89 e5                	mov    %esp,%ebp
c0105b6e:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105b71:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b74:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105b77:	eb 21                	jmp    c0105b9a <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105b79:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b7c:	0f b6 10             	movzbl (%eax),%edx
c0105b7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b82:	88 10                	mov    %dl,(%eax)
c0105b84:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b87:	0f b6 00             	movzbl (%eax),%eax
c0105b8a:	84 c0                	test   %al,%al
c0105b8c:	74 04                	je     c0105b92 <strncpy+0x27>
            src ++;
c0105b8e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105b92:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105b96:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105b9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b9e:	75 d9                	jne    c0105b79 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105ba0:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105ba3:	c9                   	leave  
c0105ba4:	c3                   	ret    

c0105ba5 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105ba5:	55                   	push   %ebp
c0105ba6:	89 e5                	mov    %esp,%ebp
c0105ba8:	57                   	push   %edi
c0105ba9:	56                   	push   %esi
c0105baa:	83 ec 20             	sub    $0x20,%esp
c0105bad:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105bb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bbf:	89 d1                	mov    %edx,%ecx
c0105bc1:	89 c2                	mov    %eax,%edx
c0105bc3:	89 ce                	mov    %ecx,%esi
c0105bc5:	89 d7                	mov    %edx,%edi
c0105bc7:	ac                   	lods   %ds:(%esi),%al
c0105bc8:	ae                   	scas   %es:(%edi),%al
c0105bc9:	75 08                	jne    c0105bd3 <strcmp+0x2e>
c0105bcb:	84 c0                	test   %al,%al
c0105bcd:	75 f8                	jne    c0105bc7 <strcmp+0x22>
c0105bcf:	31 c0                	xor    %eax,%eax
c0105bd1:	eb 04                	jmp    c0105bd7 <strcmp+0x32>
c0105bd3:	19 c0                	sbb    %eax,%eax
c0105bd5:	0c 01                	or     $0x1,%al
c0105bd7:	89 fa                	mov    %edi,%edx
c0105bd9:	89 f1                	mov    %esi,%ecx
c0105bdb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105bde:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105be1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105be4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105be7:	83 c4 20             	add    $0x20,%esp
c0105bea:	5e                   	pop    %esi
c0105beb:	5f                   	pop    %edi
c0105bec:	5d                   	pop    %ebp
c0105bed:	c3                   	ret    

c0105bee <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105bee:	55                   	push   %ebp
c0105bef:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105bf1:	eb 0c                	jmp    c0105bff <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105bf3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105bf7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105bfb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105bff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c03:	74 1a                	je     c0105c1f <strncmp+0x31>
c0105c05:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c08:	0f b6 00             	movzbl (%eax),%eax
c0105c0b:	84 c0                	test   %al,%al
c0105c0d:	74 10                	je     c0105c1f <strncmp+0x31>
c0105c0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c12:	0f b6 10             	movzbl (%eax),%edx
c0105c15:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c18:	0f b6 00             	movzbl (%eax),%eax
c0105c1b:	38 c2                	cmp    %al,%dl
c0105c1d:	74 d4                	je     c0105bf3 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105c1f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c23:	74 18                	je     c0105c3d <strncmp+0x4f>
c0105c25:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c28:	0f b6 00             	movzbl (%eax),%eax
c0105c2b:	0f b6 d0             	movzbl %al,%edx
c0105c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c31:	0f b6 00             	movzbl (%eax),%eax
c0105c34:	0f b6 c0             	movzbl %al,%eax
c0105c37:	29 c2                	sub    %eax,%edx
c0105c39:	89 d0                	mov    %edx,%eax
c0105c3b:	eb 05                	jmp    c0105c42 <strncmp+0x54>
c0105c3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c42:	5d                   	pop    %ebp
c0105c43:	c3                   	ret    

c0105c44 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105c44:	55                   	push   %ebp
c0105c45:	89 e5                	mov    %esp,%ebp
c0105c47:	83 ec 04             	sub    $0x4,%esp
c0105c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c4d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c50:	eb 14                	jmp    c0105c66 <strchr+0x22>
        if (*s == c) {
c0105c52:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c55:	0f b6 00             	movzbl (%eax),%eax
c0105c58:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105c5b:	75 05                	jne    c0105c62 <strchr+0x1e>
            return (char *)s;
c0105c5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c60:	eb 13                	jmp    c0105c75 <strchr+0x31>
        }
        s ++;
c0105c62:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105c66:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c69:	0f b6 00             	movzbl (%eax),%eax
c0105c6c:	84 c0                	test   %al,%al
c0105c6e:	75 e2                	jne    c0105c52 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105c70:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c75:	c9                   	leave  
c0105c76:	c3                   	ret    

c0105c77 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105c77:	55                   	push   %ebp
c0105c78:	89 e5                	mov    %esp,%ebp
c0105c7a:	83 ec 04             	sub    $0x4,%esp
c0105c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c80:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c83:	eb 11                	jmp    c0105c96 <strfind+0x1f>
        if (*s == c) {
c0105c85:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c88:	0f b6 00             	movzbl (%eax),%eax
c0105c8b:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105c8e:	75 02                	jne    c0105c92 <strfind+0x1b>
            break;
c0105c90:	eb 0e                	jmp    c0105ca0 <strfind+0x29>
        }
        s ++;
c0105c92:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105c96:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c99:	0f b6 00             	movzbl (%eax),%eax
c0105c9c:	84 c0                	test   %al,%al
c0105c9e:	75 e5                	jne    c0105c85 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105ca0:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105ca3:	c9                   	leave  
c0105ca4:	c3                   	ret    

c0105ca5 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105ca5:	55                   	push   %ebp
c0105ca6:	89 e5                	mov    %esp,%ebp
c0105ca8:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105cab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105cb2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105cb9:	eb 04                	jmp    c0105cbf <strtol+0x1a>
        s ++;
c0105cbb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105cbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cc2:	0f b6 00             	movzbl (%eax),%eax
c0105cc5:	3c 20                	cmp    $0x20,%al
c0105cc7:	74 f2                	je     c0105cbb <strtol+0x16>
c0105cc9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ccc:	0f b6 00             	movzbl (%eax),%eax
c0105ccf:	3c 09                	cmp    $0x9,%al
c0105cd1:	74 e8                	je     c0105cbb <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105cd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cd6:	0f b6 00             	movzbl (%eax),%eax
c0105cd9:	3c 2b                	cmp    $0x2b,%al
c0105cdb:	75 06                	jne    c0105ce3 <strtol+0x3e>
        s ++;
c0105cdd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105ce1:	eb 15                	jmp    c0105cf8 <strtol+0x53>
    }
    else if (*s == '-') {
c0105ce3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ce6:	0f b6 00             	movzbl (%eax),%eax
c0105ce9:	3c 2d                	cmp    $0x2d,%al
c0105ceb:	75 0b                	jne    c0105cf8 <strtol+0x53>
        s ++, neg = 1;
c0105ced:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105cf1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105cf8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105cfc:	74 06                	je     c0105d04 <strtol+0x5f>
c0105cfe:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105d02:	75 24                	jne    c0105d28 <strtol+0x83>
c0105d04:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d07:	0f b6 00             	movzbl (%eax),%eax
c0105d0a:	3c 30                	cmp    $0x30,%al
c0105d0c:	75 1a                	jne    c0105d28 <strtol+0x83>
c0105d0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d11:	83 c0 01             	add    $0x1,%eax
c0105d14:	0f b6 00             	movzbl (%eax),%eax
c0105d17:	3c 78                	cmp    $0x78,%al
c0105d19:	75 0d                	jne    c0105d28 <strtol+0x83>
        s += 2, base = 16;
c0105d1b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105d1f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105d26:	eb 2a                	jmp    c0105d52 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105d28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d2c:	75 17                	jne    c0105d45 <strtol+0xa0>
c0105d2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d31:	0f b6 00             	movzbl (%eax),%eax
c0105d34:	3c 30                	cmp    $0x30,%al
c0105d36:	75 0d                	jne    c0105d45 <strtol+0xa0>
        s ++, base = 8;
c0105d38:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105d3c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105d43:	eb 0d                	jmp    c0105d52 <strtol+0xad>
    }
    else if (base == 0) {
c0105d45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d49:	75 07                	jne    c0105d52 <strtol+0xad>
        base = 10;
c0105d4b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105d52:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d55:	0f b6 00             	movzbl (%eax),%eax
c0105d58:	3c 2f                	cmp    $0x2f,%al
c0105d5a:	7e 1b                	jle    c0105d77 <strtol+0xd2>
c0105d5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d5f:	0f b6 00             	movzbl (%eax),%eax
c0105d62:	3c 39                	cmp    $0x39,%al
c0105d64:	7f 11                	jg     c0105d77 <strtol+0xd2>
            dig = *s - '0';
c0105d66:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d69:	0f b6 00             	movzbl (%eax),%eax
c0105d6c:	0f be c0             	movsbl %al,%eax
c0105d6f:	83 e8 30             	sub    $0x30,%eax
c0105d72:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d75:	eb 48                	jmp    c0105dbf <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105d77:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d7a:	0f b6 00             	movzbl (%eax),%eax
c0105d7d:	3c 60                	cmp    $0x60,%al
c0105d7f:	7e 1b                	jle    c0105d9c <strtol+0xf7>
c0105d81:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d84:	0f b6 00             	movzbl (%eax),%eax
c0105d87:	3c 7a                	cmp    $0x7a,%al
c0105d89:	7f 11                	jg     c0105d9c <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105d8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d8e:	0f b6 00             	movzbl (%eax),%eax
c0105d91:	0f be c0             	movsbl %al,%eax
c0105d94:	83 e8 57             	sub    $0x57,%eax
c0105d97:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d9a:	eb 23                	jmp    c0105dbf <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105d9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d9f:	0f b6 00             	movzbl (%eax),%eax
c0105da2:	3c 40                	cmp    $0x40,%al
c0105da4:	7e 3d                	jle    c0105de3 <strtol+0x13e>
c0105da6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105da9:	0f b6 00             	movzbl (%eax),%eax
c0105dac:	3c 5a                	cmp    $0x5a,%al
c0105dae:	7f 33                	jg     c0105de3 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105db0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105db3:	0f b6 00             	movzbl (%eax),%eax
c0105db6:	0f be c0             	movsbl %al,%eax
c0105db9:	83 e8 37             	sub    $0x37,%eax
c0105dbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105dc2:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105dc5:	7c 02                	jl     c0105dc9 <strtol+0x124>
            break;
c0105dc7:	eb 1a                	jmp    c0105de3 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105dc9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105dcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105dd0:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105dd4:	89 c2                	mov    %eax,%edx
c0105dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105dd9:	01 d0                	add    %edx,%eax
c0105ddb:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105dde:	e9 6f ff ff ff       	jmp    c0105d52 <strtol+0xad>

    if (endptr) {
c0105de3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105de7:	74 08                	je     c0105df1 <strtol+0x14c>
        *endptr = (char *) s;
c0105de9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dec:	8b 55 08             	mov    0x8(%ebp),%edx
c0105def:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105df1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105df5:	74 07                	je     c0105dfe <strtol+0x159>
c0105df7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105dfa:	f7 d8                	neg    %eax
c0105dfc:	eb 03                	jmp    c0105e01 <strtol+0x15c>
c0105dfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105e01:	c9                   	leave  
c0105e02:	c3                   	ret    

c0105e03 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105e03:	55                   	push   %ebp
c0105e04:	89 e5                	mov    %esp,%ebp
c0105e06:	57                   	push   %edi
c0105e07:	83 ec 24             	sub    $0x24,%esp
c0105e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e0d:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105e10:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105e14:	8b 55 08             	mov    0x8(%ebp),%edx
c0105e17:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105e1a:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105e1d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e20:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105e23:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105e26:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105e2a:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105e2d:	89 d7                	mov    %edx,%edi
c0105e2f:	f3 aa                	rep stos %al,%es:(%edi)
c0105e31:	89 fa                	mov    %edi,%edx
c0105e33:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105e36:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105e39:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105e3c:	83 c4 24             	add    $0x24,%esp
c0105e3f:	5f                   	pop    %edi
c0105e40:	5d                   	pop    %ebp
c0105e41:	c3                   	ret    

c0105e42 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105e42:	55                   	push   %ebp
c0105e43:	89 e5                	mov    %esp,%ebp
c0105e45:	57                   	push   %edi
c0105e46:	56                   	push   %esi
c0105e47:	53                   	push   %ebx
c0105e48:	83 ec 30             	sub    $0x30,%esp
c0105e4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e51:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e54:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105e57:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e5a:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105e5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e60:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105e63:	73 42                	jae    c0105ea7 <memmove+0x65>
c0105e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e68:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105e6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105e71:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e74:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105e77:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105e7a:	c1 e8 02             	shr    $0x2,%eax
c0105e7d:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105e7f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105e82:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105e85:	89 d7                	mov    %edx,%edi
c0105e87:	89 c6                	mov    %eax,%esi
c0105e89:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105e8b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105e8e:	83 e1 03             	and    $0x3,%ecx
c0105e91:	74 02                	je     c0105e95 <memmove+0x53>
c0105e93:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e95:	89 f0                	mov    %esi,%eax
c0105e97:	89 fa                	mov    %edi,%edx
c0105e99:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105e9c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105e9f:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105ea2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ea5:	eb 36                	jmp    c0105edd <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105ea7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105eaa:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105ead:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105eb0:	01 c2                	add    %eax,%edx
c0105eb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105eb5:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ebb:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105ebe:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ec1:	89 c1                	mov    %eax,%ecx
c0105ec3:	89 d8                	mov    %ebx,%eax
c0105ec5:	89 d6                	mov    %edx,%esi
c0105ec7:	89 c7                	mov    %eax,%edi
c0105ec9:	fd                   	std    
c0105eca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105ecc:	fc                   	cld    
c0105ecd:	89 f8                	mov    %edi,%eax
c0105ecf:	89 f2                	mov    %esi,%edx
c0105ed1:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105ed4:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105ed7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105edd:	83 c4 30             	add    $0x30,%esp
c0105ee0:	5b                   	pop    %ebx
c0105ee1:	5e                   	pop    %esi
c0105ee2:	5f                   	pop    %edi
c0105ee3:	5d                   	pop    %ebp
c0105ee4:	c3                   	ret    

c0105ee5 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105ee5:	55                   	push   %ebp
c0105ee6:	89 e5                	mov    %esp,%ebp
c0105ee8:	57                   	push   %edi
c0105ee9:	56                   	push   %esi
c0105eea:	83 ec 20             	sub    $0x20,%esp
c0105eed:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ef0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ef6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ef9:	8b 45 10             	mov    0x10(%ebp),%eax
c0105efc:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105eff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f02:	c1 e8 02             	shr    $0x2,%eax
c0105f05:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105f07:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105f0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f0d:	89 d7                	mov    %edx,%edi
c0105f0f:	89 c6                	mov    %eax,%esi
c0105f11:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105f13:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105f16:	83 e1 03             	and    $0x3,%ecx
c0105f19:	74 02                	je     c0105f1d <memcpy+0x38>
c0105f1b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105f1d:	89 f0                	mov    %esi,%eax
c0105f1f:	89 fa                	mov    %edi,%edx
c0105f21:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105f24:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105f27:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105f2d:	83 c4 20             	add    $0x20,%esp
c0105f30:	5e                   	pop    %esi
c0105f31:	5f                   	pop    %edi
c0105f32:	5d                   	pop    %ebp
c0105f33:	c3                   	ret    

c0105f34 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105f34:	55                   	push   %ebp
c0105f35:	89 e5                	mov    %esp,%ebp
c0105f37:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105f3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105f40:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f43:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105f46:	eb 30                	jmp    c0105f78 <memcmp+0x44>
        if (*s1 != *s2) {
c0105f48:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f4b:	0f b6 10             	movzbl (%eax),%edx
c0105f4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f51:	0f b6 00             	movzbl (%eax),%eax
c0105f54:	38 c2                	cmp    %al,%dl
c0105f56:	74 18                	je     c0105f70 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105f58:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f5b:	0f b6 00             	movzbl (%eax),%eax
c0105f5e:	0f b6 d0             	movzbl %al,%edx
c0105f61:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f64:	0f b6 00             	movzbl (%eax),%eax
c0105f67:	0f b6 c0             	movzbl %al,%eax
c0105f6a:	29 c2                	sub    %eax,%edx
c0105f6c:	89 d0                	mov    %edx,%eax
c0105f6e:	eb 1a                	jmp    c0105f8a <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105f70:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105f74:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105f78:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f7b:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105f7e:	89 55 10             	mov    %edx,0x10(%ebp)
c0105f81:	85 c0                	test   %eax,%eax
c0105f83:	75 c3                	jne    c0105f48 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105f85:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105f8a:	c9                   	leave  
c0105f8b:	c3                   	ret    
