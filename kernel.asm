
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 f0 2d 10 80       	mov    $0x80102df0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
80100049:	83 ec 14             	sub    $0x14,%esp
8010004c:	c7 44 24 04 80 6d 10 	movl   $0x80106d80,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 30 41 00 00       	call   80104190 <initlock>
80100060:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100065:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006c:	fc 10 80 
8010006f:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 87 6d 10 	movl   $0x80106d87,0x4(%esp)
8010009b:	80 
8010009c:	e8 bf 3f 00 00       	call   80104060 <initsleeplock>
801000a1:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000b4:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
801000ba:	75 c4                	jne    80100080 <binit+0x40>
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
801000e6:	e8 15 42 00 00       	call   80104300 <acquire>
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 0a 42 00 00       	call   80104370 <release>
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 2f 3f 00 00       	call   801040a0 <acquiresleep>
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 a2 1f 00 00       	call   80102120 <iderw>
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
80100188:	c7 04 24 8e 6d 10 80 	movl   $0x80106d8e,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 8b 3f 00 00       	call   80104140 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
801001c4:	e9 57 1f 00 00       	jmp    80102120 <iderw>
801001c9:	c7 04 24 9f 6d 10 80 	movl   $0x80106d9f,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 4a 3f 00 00       	call   80104140 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 fe 3e 00 00       	call   80104100 <releasesleep>
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 f2 40 00 00       	call   80104300 <acquire>
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
80100226:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010022b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
80100235:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
8010023d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
80100243:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
80100250:	e9 1b 41 00 00       	jmp    80104370 <release>
80100255:	c7 04 24 a6 6d 10 80 	movl   $0x80106da6,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 09 15 00 00       	call   80101790 <iunlock>
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 6d 40 00 00       	call   80104300 <acquire>
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801002a8:	e8 f3 33 00 00       	call   801036a0 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 58 3a 00 00       	call   80103d20 <sleep>
801002c8:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cd:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
801002f2:	83 c6 01             	add    $0x1,%esi
801002f5:	83 eb 01             	sub    $0x1,%ebx
801002f8:	83 fa 0a             	cmp    $0xa,%edx
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
80100307:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 5a 40 00 00       	call   80104370 <release>
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 92 13 00 00       	call   801016b0 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 3c 40 00 00       	call   80104370 <release>
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 74 13 00 00       	call   801016b0 <ilock>
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
8010034e:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
80100368:	fa                   	cli    
80100369:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100370:	00 00 00 
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100376:	e8 e5 23 00 00       	call   80102760 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 ad 6d 10 80 	movl   $0x80106dad,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
80100399:	c7 04 24 fb 76 10 80 	movl   $0x801076fb,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 fc 3d 00 00       	call   801041b0 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 c1 6d 10 80 	movl   $0x80106dc1,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 d2 54 00 00       	call   801058e0 <uartputc>
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
80100423:	0f b6 c8             	movzbl %al,%ecx
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 22 54 00 00       	call   801058e0 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 16 54 00 00       	call   801058e0 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 0a 54 00 00       	call   801058e0 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 5f 3f 00 00       	call   80104460 <memmove>
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 a2 3e 00 00       	call   801043c0 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
8010052a:	c7 04 24 c5 6d 10 80 	movl   $0x80106dc5,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 f0 6d 10 80 	movzbl -0x7fef9210(%edx),%edx
801005a0:	85 c0                	test   %eax,%eax
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
801005a6:	75 e8                	jne    80100590 <printint+0x20>
801005a8:	85 ff                	test   %edi,%edi
801005aa:	89 d8                	mov    %ebx,%eax
801005ac:	74 08                	je     801005b6 <printint+0x46>
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
801005c5:	83 eb 01             	sub    $0x1,%ebx
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 89 11 00 00       	call   80101790 <iunlock>
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 ed 3c 00 00       	call   80104300 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 35 3d 00 00       	call   80104370 <release>
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 6a 10 00 00       	call   801016b0 <ilock>
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
8010065e:	85 c0                	test   %eax,%eax
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 78 3c 00 00       	call   80104370 <release>
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100760:	b8 d8 6d 10 80       	mov    $0x80106dd8,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 64 3b 00 00       	call   80104300 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>
801007a1:	c7 04 24 df 6d 10 80 	movl   $0x80106ddf,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
801007b5:	31 f6                	xor    %esi,%esi
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 36 3b 00 00       	call   80104300 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
801007f2:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007f7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 44 3b 00 00       	call   80104370 <release>
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
80100865:	83 ff 0d             	cmp    $0xd,%edi
80100868:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
801008a6:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801008ad:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
801008b2:	e8 f9 35 00 00       	call   80103eb0 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801008c0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801008d8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
801008e7:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ec:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
80100900:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
80100927:	e9 64 36 00 00       	jmp    80103f90 <procdump>
8010092c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
80100956:	c7 44 24 04 e8 6d 10 	movl   $0x80106de8,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 26 38 00 00       	call   80104190 <initlock>
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100979:	c7 05 6c 09 11 80 f0 	movl   $0x801005f0,0x8011096c
80100980:	05 10 80 
80100983:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010098a:	02 10 80 
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 
80100997:	e8 14 19 00 00       	call   801022b0 <ioapicenable>
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
8010099e:	66 90                	xchg   %ax,%ax

801009a0 <exec>:
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
801009ac:	e8 ef 2c 00 00       	call   801036a0 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
801009b7:	e8 54 21 00 00       	call   80102b10 <begin_op>
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 39 15 00 00       	call   80101f00 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 c2 01 00 00    	je     80100b93 <exec+0x1f3>
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 d7 0c 00 00       	call   801016b0 <ilock>
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 65 0f 00 00       	call   80101960 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 08 0f 00 00       	call   80101910 <iunlockput>
80100a08:	e8 73 21 00 00       	call   80102b80 <end_op>
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
80100a2c:	e8 9f 60 00 00       	call   80106ad0 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 cd 0e 00 00       	call   80101960 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 69 5e 00 00       	call   80106940 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 68 5d 00 00       	call   80106880 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 22 5f 00 00       	call   80106a50 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 d5 0d 00 00       	call   80101910 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b40:	e8 3b 20 00 00       	call   80102b80 <end_op>
80100b45:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100b4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100b55:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b65:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b69:	89 04 24             	mov    %eax,(%esp)
80100b6c:	e8 cf 5d 00 00       	call   80106940 <allocuvm>
80100b71:	85 c0                	test   %eax,%eax
80100b73:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100b79:	75 33                	jne    80100bae <exec+0x20e>
80100b7b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b81:	89 04 24             	mov    %eax,(%esp)
80100b84:	e8 c7 5e 00 00       	call   80106a50 <freevm>
80100b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8e:	e9 7f fe ff ff       	jmp    80100a12 <exec+0x72>
80100b93:	e8 e8 1f 00 00       	call   80102b80 <end_op>
80100b98:	c7 04 24 01 6e 10 80 	movl   $0x80106e01,(%esp)
80100b9f:	e8 ac fa ff ff       	call   80100650 <cprintf>
80100ba4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba9:	e9 64 fe ff ff       	jmp    80100a12 <exec+0x72>
80100bae:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100bb4:	89 d8                	mov    %ebx,%eax
80100bb6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bbf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bc5:	89 04 24             	mov    %eax,(%esp)
80100bc8:	e8 b3 5f 00 00       	call   80106b80 <clearpteu>
80100bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bd0:	8b 00                	mov    (%eax),%eax
80100bd2:	85 c0                	test   %eax,%eax
80100bd4:	0f 84 59 01 00 00    	je     80100d33 <exec+0x393>
80100bda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100bdd:	31 d2                	xor    %edx,%edx
80100bdf:	8d 71 04             	lea    0x4(%ecx),%esi
80100be2:	89 cf                	mov    %ecx,%edi
80100be4:	89 d1                	mov    %edx,%ecx
80100be6:	89 f2                	mov    %esi,%edx
80100be8:	89 fe                	mov    %edi,%esi
80100bea:	89 cf                	mov    %ecx,%edi
80100bec:	eb 0a                	jmp    80100bf8 <exec+0x258>
80100bee:	66 90                	xchg   %ax,%ax
80100bf0:	83 c2 04             	add    $0x4,%edx
80100bf3:	83 ff 20             	cmp    $0x20,%edi
80100bf6:	74 83                	je     80100b7b <exec+0x1db>
80100bf8:	89 04 24             	mov    %eax,(%esp)
80100bfb:	89 95 ec fe ff ff    	mov    %edx,-0x114(%ebp)
80100c01:	e8 da 39 00 00       	call   801045e0 <strlen>
80100c06:	f7 d0                	not    %eax
80100c08:	01 c3                	add    %eax,%ebx
80100c0a:	8b 06                	mov    (%esi),%eax
80100c0c:	83 e3 fc             	and    $0xfffffffc,%ebx
80100c0f:	89 04 24             	mov    %eax,(%esp)
80100c12:	e8 c9 39 00 00       	call   801045e0 <strlen>
80100c17:	83 c0 01             	add    $0x1,%eax
80100c1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c1e:	8b 06                	mov    (%esi),%eax
80100c20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c24:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c28:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c2e:	89 04 24             	mov    %eax,(%esp)
80100c31:	e8 aa 60 00 00       	call   80106ce0 <copyout>
80100c36:	85 c0                	test   %eax,%eax
80100c38:	0f 88 3d ff ff ff    	js     80100b7b <exec+0x1db>
80100c3e:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100c44:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100c4a:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
80100c51:	83 c7 01             	add    $0x1,%edi
80100c54:	8b 02                	mov    (%edx),%eax
80100c56:	89 d6                	mov    %edx,%esi
80100c58:	85 c0                	test   %eax,%eax
80100c5a:	75 94                	jne    80100bf0 <exec+0x250>
80100c5c:	89 fa                	mov    %edi,%edx
80100c5e:	c7 84 95 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edx,4)
80100c65:	00 00 00 00 
80100c69:	8d 04 95 04 00 00 00 	lea    0x4(,%edx,4),%eax
80100c70:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
80100c76:	89 da                	mov    %ebx,%edx
80100c78:	29 c2                	sub    %eax,%edx
80100c7a:	83 c0 0c             	add    $0xc,%eax
80100c7d:	29 c3                	sub    %eax,%ebx
80100c7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c83:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c89:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c8d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c91:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c98:	ff ff ff 
80100c9b:	89 04 24             	mov    %eax,(%esp)
80100c9e:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
80100ca4:	e8 37 60 00 00       	call   80106ce0 <copyout>
80100ca9:	85 c0                	test   %eax,%eax
80100cab:	0f 88 ca fe ff ff    	js     80100b7b <exec+0x1db>
80100cb1:	8b 45 08             	mov    0x8(%ebp),%eax
80100cb4:	0f b6 10             	movzbl (%eax),%edx
80100cb7:	84 d2                	test   %dl,%dl
80100cb9:	74 19                	je     80100cd4 <exec+0x334>
80100cbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cbe:	83 c0 01             	add    $0x1,%eax
80100cc1:	80 fa 2f             	cmp    $0x2f,%dl
80100cc4:	0f b6 10             	movzbl (%eax),%edx
80100cc7:	0f 44 c8             	cmove  %eax,%ecx
80100cca:	83 c0 01             	add    $0x1,%eax
80100ccd:	84 d2                	test   %dl,%dl
80100ccf:	75 f0                	jne    80100cc1 <exec+0x321>
80100cd1:	89 4d 08             	mov    %ecx,0x8(%ebp)
80100cd4:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cda:	8b 45 08             	mov    0x8(%ebp),%eax
80100cdd:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100ce4:	00 
80100ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ce9:	89 f8                	mov    %edi,%eax
80100ceb:	83 c0 6c             	add    $0x6c,%eax
80100cee:	89 04 24             	mov    %eax,(%esp)
80100cf1:	e8 aa 38 00 00       	call   801045a0 <safestrcpy>
80100cf6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100cfc:	8b 77 04             	mov    0x4(%edi),%esi
80100cff:	8b 47 18             	mov    0x18(%edi),%eax
80100d02:	89 4f 04             	mov    %ecx,0x4(%edi)
80100d05:	8b 8d e8 fe ff ff    	mov    -0x118(%ebp),%ecx
80100d0b:	89 0f                	mov    %ecx,(%edi)
80100d0d:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d13:	89 50 38             	mov    %edx,0x38(%eax)
80100d16:	8b 47 18             	mov    0x18(%edi),%eax
80100d19:	89 58 44             	mov    %ebx,0x44(%eax)
80100d1c:	89 3c 24             	mov    %edi,(%esp)
80100d1f:	e8 cc 59 00 00       	call   801066f0 <switchuvm>
80100d24:	89 34 24             	mov    %esi,(%esp)
80100d27:	e8 24 5d 00 00       	call   80106a50 <freevm>
80100d2c:	31 c0                	xor    %eax,%eax
80100d2e:	e9 df fc ff ff       	jmp    80100a12 <exec+0x72>
80100d33:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100d39:	31 d2                	xor    %edx,%edx
80100d3b:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d41:	e9 18 ff ff ff       	jmp    80100c5e <exec+0x2be>
80100d46:	66 90                	xchg   %ax,%ax
80100d48:	66 90                	xchg   %ax,%ax
80100d4a:	66 90                	xchg   %ax,%ax
80100d4c:	66 90                	xchg   %ax,%ax
80100d4e:	66 90                	xchg   %ax,%ax

80100d50 <fileinit>:
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 18             	sub    $0x18,%esp
80100d56:	c7 44 24 04 0d 6e 10 	movl   $0x80106e0d,0x4(%esp)
80100d5d:	80 
80100d5e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d65:	e8 26 34 00 00       	call   80104190 <initlock>
80100d6a:	c9                   	leave  
80100d6b:	c3                   	ret    
80100d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d70 <filealloc>:
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
80100d74:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
80100d79:	83 ec 14             	sub    $0x14,%esp
80100d7c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d83:	e8 78 35 00 00       	call   80104300 <acquire>
80100d88:	eb 11                	jmp    80100d9b <filealloc+0x2b>
80100d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
80100da2:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100da9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
80100db0:	e8 bb 35 00 00       	call   80104370 <release>
80100db5:	83 c4 14             	add    $0x14,%esp
80100db8:	89 d8                	mov    %ebx,%eax
80100dba:	5b                   	pop    %ebx
80100dbb:	5d                   	pop    %ebp
80100dbc:	c3                   	ret    
80100dbd:	8d 76 00             	lea    0x0(%esi),%esi
80100dc0:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dc7:	e8 a4 35 00 00       	call   80104370 <release>
80100dcc:	83 c4 14             	add    $0x14,%esp
80100dcf:	31 c0                	xor    %eax,%eax
80100dd1:	5b                   	pop    %ebx
80100dd2:	5d                   	pop    %ebp
80100dd3:	c3                   	ret    
80100dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100de0 <filedup>:
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 14             	sub    $0x14,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100dea:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100df1:	e8 0a 35 00 00       	call   80104300 <acquire>
80100df6:	8b 43 04             	mov    0x4(%ebx),%eax
80100df9:	85 c0                	test   %eax,%eax
80100dfb:	7e 1a                	jle    80100e17 <filedup+0x37>
80100dfd:	83 c0 01             	add    $0x1,%eax
80100e00:	89 43 04             	mov    %eax,0x4(%ebx)
80100e03:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e0a:	e8 61 35 00 00       	call   80104370 <release>
80100e0f:	83 c4 14             	add    $0x14,%esp
80100e12:	89 d8                	mov    %ebx,%eax
80100e14:	5b                   	pop    %ebx
80100e15:	5d                   	pop    %ebp
80100e16:	c3                   	ret    
80100e17:	c7 04 24 14 6e 10 80 	movl   $0x80106e14,(%esp)
80100e1e:	e8 3d f5 ff ff       	call   80100360 <panic>
80100e23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 1c             	sub    $0x1c,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
80100e3c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e43:	e8 b8 34 00 00       	call   80104300 <acquire>
80100e48:	8b 57 04             	mov    0x4(%edi),%edx
80100e4b:	85 d2                	test   %edx,%edx
80100e4d:	0f 8e 89 00 00 00    	jle    80100edc <fileclose+0xac>
80100e53:	83 ea 01             	sub    $0x1,%edx
80100e56:	85 d2                	test   %edx,%edx
80100e58:	89 57 04             	mov    %edx,0x4(%edi)
80100e5b:	74 13                	je     80100e70 <fileclose+0x40>
80100e5d:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
80100e64:	83 c4 1c             	add    $0x1c,%esp
80100e67:	5b                   	pop    %ebx
80100e68:	5e                   	pop    %esi
80100e69:	5f                   	pop    %edi
80100e6a:	5d                   	pop    %ebp
80100e6b:	e9 00 35 00 00       	jmp    80104370 <release>
80100e70:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e74:	8b 37                	mov    (%edi),%esi
80100e76:	8b 5f 0c             	mov    0xc(%edi),%ebx
80100e79:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80100e7f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e82:	8b 47 10             	mov    0x10(%edi),%eax
80100e85:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e8f:	e8 dc 34 00 00       	call   80104370 <release>
80100e94:	83 fe 01             	cmp    $0x1,%esi
80100e97:	74 0f                	je     80100ea8 <fileclose+0x78>
80100e99:	83 fe 02             	cmp    $0x2,%esi
80100e9c:	74 22                	je     80100ec0 <fileclose+0x90>
80100e9e:	83 c4 1c             	add    $0x1c,%esp
80100ea1:	5b                   	pop    %ebx
80100ea2:	5e                   	pop    %esi
80100ea3:	5f                   	pop    %edi
80100ea4:	5d                   	pop    %ebp
80100ea5:	c3                   	ret    
80100ea6:	66 90                	xchg   %ax,%ax
80100ea8:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100eac:	89 1c 24             	mov    %ebx,(%esp)
80100eaf:	89 74 24 04          	mov    %esi,0x4(%esp)
80100eb3:	e8 a8 23 00 00       	call   80103260 <pipeclose>
80100eb8:	eb e4                	jmp    80100e9e <fileclose+0x6e>
80100eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100ec0:	e8 4b 1c 00 00       	call   80102b10 <begin_op>
80100ec5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ec8:	89 04 24             	mov    %eax,(%esp)
80100ecb:	e8 00 09 00 00       	call   801017d0 <iput>
80100ed0:	83 c4 1c             	add    $0x1c,%esp
80100ed3:	5b                   	pop    %ebx
80100ed4:	5e                   	pop    %esi
80100ed5:	5f                   	pop    %edi
80100ed6:	5d                   	pop    %ebp
80100ed7:	e9 a4 1c 00 00       	jmp    80102b80 <end_op>
80100edc:	c7 04 24 1c 6e 10 80 	movl   $0x80106e1c,(%esp)
80100ee3:	e8 78 f4 ff ff       	call   80100360 <panic>
80100ee8:	90                   	nop
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filestat>:
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 14             	sub    $0x14,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100efa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100efd:	75 31                	jne    80100f30 <filestat+0x40>
80100eff:	8b 43 10             	mov    0x10(%ebx),%eax
80100f02:	89 04 24             	mov    %eax,(%esp)
80100f05:	e8 a6 07 00 00       	call   801016b0 <ilock>
80100f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f11:	8b 43 10             	mov    0x10(%ebx),%eax
80100f14:	89 04 24             	mov    %eax,(%esp)
80100f17:	e8 14 0a 00 00       	call   80101930 <stati>
80100f1c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f1f:	89 04 24             	mov    %eax,(%esp)
80100f22:	e8 69 08 00 00       	call   80101790 <iunlock>
80100f27:	83 c4 14             	add    $0x14,%esp
80100f2a:	31 c0                	xor    %eax,%eax
80100f2c:	5b                   	pop    %ebx
80100f2d:	5d                   	pop    %ebp
80100f2e:	c3                   	ret    
80100f2f:	90                   	nop
80100f30:	83 c4 14             	add    $0x14,%esp
80100f33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f38:	5b                   	pop    %ebx
80100f39:	5d                   	pop    %ebp
80100f3a:	c3                   	ret    
80100f3b:	90                   	nop
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <fileread>:
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 1c             	sub    $0x1c,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f4f:	8b 7d 10             	mov    0x10(%ebp),%edi
80100f52:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f56:	74 68                	je     80100fc0 <fileread+0x80>
80100f58:	8b 03                	mov    (%ebx),%eax
80100f5a:	83 f8 01             	cmp    $0x1,%eax
80100f5d:	74 49                	je     80100fa8 <fileread+0x68>
80100f5f:	83 f8 02             	cmp    $0x2,%eax
80100f62:	75 63                	jne    80100fc7 <fileread+0x87>
80100f64:	8b 43 10             	mov    0x10(%ebx),%eax
80100f67:	89 04 24             	mov    %eax,(%esp)
80100f6a:	e8 41 07 00 00       	call   801016b0 <ilock>
80100f6f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f73:	8b 43 14             	mov    0x14(%ebx),%eax
80100f76:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f7a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f7e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f81:	89 04 24             	mov    %eax,(%esp)
80100f84:	e8 d7 09 00 00       	call   80101960 <readi>
80100f89:	85 c0                	test   %eax,%eax
80100f8b:	89 c6                	mov    %eax,%esi
80100f8d:	7e 03                	jle    80100f92 <fileread+0x52>
80100f8f:	01 43 14             	add    %eax,0x14(%ebx)
80100f92:	8b 43 10             	mov    0x10(%ebx),%eax
80100f95:	89 04 24             	mov    %eax,(%esp)
80100f98:	e8 f3 07 00 00       	call   80101790 <iunlock>
80100f9d:	89 f0                	mov    %esi,%eax
80100f9f:	83 c4 1c             	add    $0x1c,%esp
80100fa2:	5b                   	pop    %ebx
80100fa3:	5e                   	pop    %esi
80100fa4:	5f                   	pop    %edi
80100fa5:	5d                   	pop    %ebp
80100fa6:	c3                   	ret    
80100fa7:	90                   	nop
80100fa8:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fab:	89 45 08             	mov    %eax,0x8(%ebp)
80100fae:	83 c4 1c             	add    $0x1c,%esp
80100fb1:	5b                   	pop    %ebx
80100fb2:	5e                   	pop    %esi
80100fb3:	5f                   	pop    %edi
80100fb4:	5d                   	pop    %ebp
80100fb5:	e9 26 24 00 00       	jmp    801033e0 <piperead>
80100fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fc5:	eb d8                	jmp    80100f9f <fileread+0x5f>
80100fc7:	c7 04 24 26 6e 10 80 	movl   $0x80106e26,(%esp)
80100fce:	e8 8d f3 ff ff       	call   80100360 <panic>
80100fd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fe0 <filewrite>:
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 2c             	sub    $0x2c,%esp
80100fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fec:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fef:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff2:	8b 45 10             	mov    0x10(%ebp),%eax
80100ff5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100ffc:	0f 84 ae 00 00 00    	je     801010b0 <filewrite+0xd0>
80101002:	8b 07                	mov    (%edi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d7 00 00 00    	jne    801010ed <filewrite+0x10d>
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 db                	xor    %ebx,%ebx
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 31                	jg     80101050 <filewrite+0x70>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101028:	8b 4f 10             	mov    0x10(%edi),%ecx
8010102b:	01 47 14             	add    %eax,0x14(%edi)
8010102e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101031:	89 0c 24             	mov    %ecx,(%esp)
80101034:	e8 57 07 00 00       	call   80101790 <iunlock>
80101039:	e8 42 1b 00 00       	call   80102b80 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101041:	39 f0                	cmp    %esi,%eax
80101043:	0f 85 98 00 00 00    	jne    801010e1 <filewrite+0x101>
80101049:	01 c3                	add    %eax,%ebx
8010104b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010104e:	7e 70                	jle    801010c0 <filewrite+0xe0>
80101050:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101053:	b8 00 06 00 00       	mov    $0x600,%eax
80101058:	29 de                	sub    %ebx,%esi
8010105a:	81 fe 00 06 00 00    	cmp    $0x600,%esi
80101060:	0f 4f f0             	cmovg  %eax,%esi
80101063:	e8 a8 1a 00 00       	call   80102b10 <begin_op>
80101068:	8b 47 10             	mov    0x10(%edi),%eax
8010106b:	89 04 24             	mov    %eax,(%esp)
8010106e:	e8 3d 06 00 00       	call   801016b0 <ilock>
80101073:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101077:	8b 47 14             	mov    0x14(%edi),%eax
8010107a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010107e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101081:	01 d8                	add    %ebx,%eax
80101083:	89 44 24 04          	mov    %eax,0x4(%esp)
80101087:	8b 47 10             	mov    0x10(%edi),%eax
8010108a:	89 04 24             	mov    %eax,(%esp)
8010108d:	e8 ce 09 00 00       	call   80101a60 <writei>
80101092:	85 c0                	test   %eax,%eax
80101094:	7f 92                	jg     80101028 <filewrite+0x48>
80101096:	8b 4f 10             	mov    0x10(%edi),%ecx
80101099:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010109c:	89 0c 24             	mov    %ecx,(%esp)
8010109f:	e8 ec 06 00 00       	call   80101790 <iunlock>
801010a4:	e8 d7 1a 00 00       	call   80102b80 <end_op>
801010a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010ac:	85 c0                	test   %eax,%eax
801010ae:	74 91                	je     80101041 <filewrite+0x61>
801010b0:	83 c4 2c             	add    $0x2c,%esp
801010b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010b8:	5b                   	pop    %ebx
801010b9:	5e                   	pop    %esi
801010ba:	5f                   	pop    %edi
801010bb:	5d                   	pop    %ebp
801010bc:	c3                   	ret    
801010bd:	8d 76 00             	lea    0x0(%esi),%esi
801010c0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010c3:	89 d8                	mov    %ebx,%eax
801010c5:	75 e9                	jne    801010b0 <filewrite+0xd0>
801010c7:	83 c4 2c             	add    $0x2c,%esp
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
801010cf:	8b 47 0c             	mov    0xc(%edi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
801010d5:	83 c4 2c             	add    $0x2c,%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
801010dc:	e9 0f 22 00 00       	jmp    801032f0 <pipewrite>
801010e1:	c7 04 24 2f 6e 10 80 	movl   $0x80106e2f,(%esp)
801010e8:	e8 73 f2 ff ff       	call   80100360 <panic>
801010ed:	c7 04 24 35 6e 10 80 	movl   $0x80106e35,(%esp)
801010f4:	e8 67 f2 ff ff       	call   80100360 <panic>
801010f9:	66 90                	xchg   %ax,%ax
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <bfree>:
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	89 d7                	mov    %edx,%edi
80101106:	56                   	push   %esi
80101107:	53                   	push   %ebx
80101108:	bb 01 00 00 00       	mov    $0x1,%ebx
8010110d:	83 ec 1c             	sub    $0x1c,%esp
80101110:	c1 ea 0c             	shr    $0xc,%edx
80101113:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101119:	89 04 24             	mov    %eax,(%esp)
8010111c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101120:	e8 ab ef ff ff       	call   801000d0 <bread>
80101125:	89 f9                	mov    %edi,%ecx
80101127:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
8010112d:	89 fa                	mov    %edi,%edx
8010112f:	83 e1 07             	and    $0x7,%ecx
80101132:	c1 fa 03             	sar    $0x3,%edx
80101135:	d3 e3                	shl    %cl,%ebx
80101137:	89 c6                	mov    %eax,%esi
80101139:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
8010113e:	0f b6 c8             	movzbl %al,%ecx
80101141:	85 d9                	test   %ebx,%ecx
80101143:	74 20                	je     80101165 <bfree+0x65>
80101145:	f7 d3                	not    %ebx
80101147:	21 c3                	and    %eax,%ebx
80101149:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
8010114d:	89 34 24             	mov    %esi,(%esp)
80101150:	e8 5b 1b 00 00       	call   80102cb0 <log_write>
80101155:	89 34 24             	mov    %esi,(%esp)
80101158:	e8 83 f0 ff ff       	call   801001e0 <brelse>
8010115d:	83 c4 1c             	add    $0x1c,%esp
80101160:	5b                   	pop    %ebx
80101161:	5e                   	pop    %esi
80101162:	5f                   	pop    %edi
80101163:	5d                   	pop    %ebp
80101164:	c3                   	ret    
80101165:	c7 04 24 3f 6e 10 80 	movl   $0x80106e3f,(%esp)
8010116c:	e8 ef f1 ff ff       	call   80100360 <panic>
80101171:	eb 0d                	jmp    80101180 <balloc>
80101173:	90                   	nop
80101174:	90                   	nop
80101175:	90                   	nop
80101176:	90                   	nop
80101177:	90                   	nop
80101178:	90                   	nop
80101179:	90                   	nop
8010117a:	90                   	nop
8010117b:	90                   	nop
8010117c:	90                   	nop
8010117d:	90                   	nop
8010117e:	90                   	nop
8010117f:	90                   	nop

80101180 <balloc>:
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 2c             	sub    $0x2c,%esp
80101189:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010118c:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101191:	85 c0                	test   %eax,%eax
80101193:	0f 84 8c 00 00 00    	je     80101225 <balloc+0xa5>
80101199:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
801011a0:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a3:	89 f0                	mov    %esi,%eax
801011a5:	c1 f8 0c             	sar    $0xc,%eax
801011a8:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011ae:	89 44 24 04          	mov    %eax,0x4(%esp)
801011b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011b5:	89 04 24             	mov    %eax,(%esp)
801011b8:	e8 13 ef ff ff       	call   801000d0 <bread>
801011bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011c0:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011c8:	31 c0                	xor    %eax,%eax
801011ca:	eb 33                	jmp    801011ff <balloc+0x7f>
801011cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011d0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011d3:	89 c2                	mov    %eax,%edx
801011d5:	89 c1                	mov    %eax,%ecx
801011d7:	c1 fa 03             	sar    $0x3,%edx
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	bf 01 00 00 00       	mov    $0x1,%edi
801011e2:	d3 e7                	shl    %cl,%edi
801011e4:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx
801011e9:	89 f9                	mov    %edi,%ecx
801011eb:	0f b6 fb             	movzbl %bl,%edi
801011ee:	85 cf                	test   %ecx,%edi
801011f0:	74 46                	je     80101238 <balloc+0xb8>
801011f2:	83 c0 01             	add    $0x1,%eax
801011f5:	83 c6 01             	add    $0x1,%esi
801011f8:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011fd:	74 05                	je     80101204 <balloc+0x84>
801011ff:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101202:	72 cc                	jb     801011d0 <balloc+0x50>
80101204:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101207:	89 04 24             	mov    %eax,(%esp)
8010120a:	e8 d1 ef ff ff       	call   801001e0 <brelse>
8010120f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	3b 05 c0 09 11 80    	cmp    0x801109c0,%eax
8010121f:	0f 82 7b ff ff ff    	jb     801011a0 <balloc+0x20>
80101225:	c7 04 24 52 6e 10 80 	movl   $0x80106e52,(%esp)
8010122c:	e8 2f f1 ff ff       	call   80100360 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	09 d9                	or     %ebx,%ecx
8010123a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010123d:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
80101241:	89 1c 24             	mov    %ebx,(%esp)
80101244:	e8 67 1a 00 00       	call   80102cb0 <log_write>
80101249:	89 1c 24             	mov    %ebx,(%esp)
8010124c:	e8 8f ef ff ff       	call   801001e0 <brelse>
80101251:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101254:	89 74 24 04          	mov    %esi,0x4(%esp)
80101258:	89 04 24             	mov    %eax,(%esp)
8010125b:	e8 70 ee ff ff       	call   801000d0 <bread>
80101260:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101267:	00 
80101268:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010126f:	00 
80101270:	89 c3                	mov    %eax,%ebx
80101272:	8d 40 5c             	lea    0x5c(%eax),%eax
80101275:	89 04 24             	mov    %eax,(%esp)
80101278:	e8 43 31 00 00       	call   801043c0 <memset>
8010127d:	89 1c 24             	mov    %ebx,(%esp)
80101280:	e8 2b 1a 00 00       	call   80102cb0 <log_write>
80101285:	89 1c 24             	mov    %ebx,(%esp)
80101288:	e8 53 ef ff ff       	call   801001e0 <brelse>
8010128d:	83 c4 2c             	add    $0x2c,%esp
80101290:	89 f0                	mov    %esi,%eax
80101292:	5b                   	pop    %ebx
80101293:	5e                   	pop    %esi
80101294:	5f                   	pop    %edi
80101295:	5d                   	pop    %ebp
80101296:	c3                   	ret    
80101297:	89 f6                	mov    %esi,%esi
80101299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801012a0 <iget>:
801012a0:	55                   	push   %ebp
801012a1:	89 e5                	mov    %esp,%ebp
801012a3:	57                   	push   %edi
801012a4:	89 c7                	mov    %eax,%edi
801012a6:	56                   	push   %esi
801012a7:	31 f6                	xor    %esi,%esi
801012a9:	53                   	push   %ebx
801012aa:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
801012af:	83 ec 1c             	sub    $0x1c,%esp
801012b2:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801012b9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801012bc:	e8 3f 30 00 00       	call   80104300 <acquire>
801012c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012c4:	eb 14                	jmp    801012da <iget+0x3a>
801012c6:	66 90                	xchg   %ax,%ax
801012c8:	85 f6                	test   %esi,%esi
801012ca:	74 3c                	je     80101308 <iget+0x68>
801012cc:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012d2:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012d8:	74 46                	je     80101320 <iget+0x80>
801012da:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012dd:	85 c9                	test   %ecx,%ecx
801012df:	7e e7                	jle    801012c8 <iget+0x28>
801012e1:	39 3b                	cmp    %edi,(%ebx)
801012e3:	75 e3                	jne    801012c8 <iget+0x28>
801012e5:	39 53 04             	cmp    %edx,0x4(%ebx)
801012e8:	75 de                	jne    801012c8 <iget+0x28>
801012ea:	83 c1 01             	add    $0x1,%ecx
801012ed:	89 de                	mov    %ebx,%esi
801012ef:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801012f6:	89 4b 08             	mov    %ecx,0x8(%ebx)
801012f9:	e8 72 30 00 00       	call   80104370 <release>
801012fe:	83 c4 1c             	add    $0x1c,%esp
80101301:	89 f0                	mov    %esi,%eax
80101303:	5b                   	pop    %ebx
80101304:	5e                   	pop    %esi
80101305:	5f                   	pop    %edi
80101306:	5d                   	pop    %ebp
80101307:	c3                   	ret    
80101308:	85 c9                	test   %ecx,%ecx
8010130a:	0f 44 f3             	cmove  %ebx,%esi
8010130d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101313:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101319:	75 bf                	jne    801012da <iget+0x3a>
8010131b:	90                   	nop
8010131c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101320:	85 f6                	test   %esi,%esi
80101322:	74 29                	je     8010134d <iget+0xad>
80101324:	89 3e                	mov    %edi,(%esi)
80101326:	89 56 04             	mov    %edx,0x4(%esi)
80101329:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
80101330:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101337:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010133e:	e8 2d 30 00 00       	call   80104370 <release>
80101343:	83 c4 1c             	add    $0x1c,%esp
80101346:	89 f0                	mov    %esi,%eax
80101348:	5b                   	pop    %ebx
80101349:	5e                   	pop    %esi
8010134a:	5f                   	pop    %edi
8010134b:	5d                   	pop    %ebp
8010134c:	c3                   	ret    
8010134d:	c7 04 24 68 6e 10 80 	movl   $0x80106e68,(%esp)
80101354:	e8 07 f0 ff ff       	call   80100360 <panic>
80101359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101360 <bmap>:
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c3                	mov    %eax,%ebx
80101368:	83 ec 1c             	sub    $0x1c,%esp
8010136b:	83 fa 0b             	cmp    $0xb,%edx
8010136e:	77 18                	ja     80101388 <bmap+0x28>
80101370:	8d 34 90             	lea    (%eax,%edx,4),%esi
80101373:	8b 46 5c             	mov    0x5c(%esi),%eax
80101376:	85 c0                	test   %eax,%eax
80101378:	74 66                	je     801013e0 <bmap+0x80>
8010137a:	83 c4 1c             	add    $0x1c,%esp
8010137d:	5b                   	pop    %ebx
8010137e:	5e                   	pop    %esi
8010137f:	5f                   	pop    %edi
80101380:	5d                   	pop    %ebp
80101381:	c3                   	ret    
80101382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101388:	8d 72 f4             	lea    -0xc(%edx),%esi
8010138b:	83 fe 7f             	cmp    $0x7f,%esi
8010138e:	77 77                	ja     80101407 <bmap+0xa7>
80101390:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101396:	85 c0                	test   %eax,%eax
80101398:	74 5e                	je     801013f8 <bmap+0x98>
8010139a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010139e:	8b 03                	mov    (%ebx),%eax
801013a0:	89 04 24             	mov    %eax,(%esp)
801013a3:	e8 28 ed ff ff       	call   801000d0 <bread>
801013a8:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx
801013ac:	89 c7                	mov    %eax,%edi
801013ae:	8b 32                	mov    (%edx),%esi
801013b0:	85 f6                	test   %esi,%esi
801013b2:	75 19                	jne    801013cd <bmap+0x6d>
801013b4:	8b 03                	mov    (%ebx),%eax
801013b6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013b9:	e8 c2 fd ff ff       	call   80101180 <balloc>
801013be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013c1:	89 02                	mov    %eax,(%edx)
801013c3:	89 c6                	mov    %eax,%esi
801013c5:	89 3c 24             	mov    %edi,(%esp)
801013c8:	e8 e3 18 00 00       	call   80102cb0 <log_write>
801013cd:	89 3c 24             	mov    %edi,(%esp)
801013d0:	e8 0b ee ff ff       	call   801001e0 <brelse>
801013d5:	83 c4 1c             	add    $0x1c,%esp
801013d8:	89 f0                	mov    %esi,%eax
801013da:	5b                   	pop    %ebx
801013db:	5e                   	pop    %esi
801013dc:	5f                   	pop    %edi
801013dd:	5d                   	pop    %ebp
801013de:	c3                   	ret    
801013df:	90                   	nop
801013e0:	8b 03                	mov    (%ebx),%eax
801013e2:	e8 99 fd ff ff       	call   80101180 <balloc>
801013e7:	89 46 5c             	mov    %eax,0x5c(%esi)
801013ea:	83 c4 1c             	add    $0x1c,%esp
801013ed:	5b                   	pop    %ebx
801013ee:	5e                   	pop    %esi
801013ef:	5f                   	pop    %edi
801013f0:	5d                   	pop    %ebp
801013f1:	c3                   	ret    
801013f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013f8:	8b 03                	mov    (%ebx),%eax
801013fa:	e8 81 fd ff ff       	call   80101180 <balloc>
801013ff:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101405:	eb 93                	jmp    8010139a <bmap+0x3a>
80101407:	c7 04 24 78 6e 10 80 	movl   $0x80106e78,(%esp)
8010140e:	e8 4d ef ff ff       	call   80100360 <panic>
80101413:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101420 <readsb>:
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	56                   	push   %esi
80101424:	53                   	push   %ebx
80101425:	83 ec 10             	sub    $0x10,%esp
80101428:	8b 45 08             	mov    0x8(%ebp),%eax
8010142b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101432:	00 
80101433:	8b 75 0c             	mov    0xc(%ebp),%esi
80101436:	89 04 24             	mov    %eax,(%esp)
80101439:	e8 92 ec ff ff       	call   801000d0 <bread>
8010143e:	89 34 24             	mov    %esi,(%esp)
80101441:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101448:	00 
80101449:	89 c3                	mov    %eax,%ebx
8010144b:	8d 40 5c             	lea    0x5c(%eax),%eax
8010144e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101452:	e8 09 30 00 00       	call   80104460 <memmove>
80101457:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010145a:	83 c4 10             	add    $0x10,%esp
8010145d:	5b                   	pop    %ebx
8010145e:	5e                   	pop    %esi
8010145f:	5d                   	pop    %ebp
80101460:	e9 7b ed ff ff       	jmp    801001e0 <brelse>
80101465:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101470 <iinit>:
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	53                   	push   %ebx
80101474:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101479:	83 ec 24             	sub    $0x24,%esp
8010147c:	c7 44 24 04 8b 6e 10 	movl   $0x80106e8b,0x4(%esp)
80101483:	80 
80101484:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010148b:	e8 00 2d 00 00       	call   80104190 <initlock>
80101490:	89 1c 24             	mov    %ebx,(%esp)
80101493:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101499:	c7 44 24 04 92 6e 10 	movl   $0x80106e92,0x4(%esp)
801014a0:	80 
801014a1:	e8 ba 2b 00 00       	call   80104060 <initsleeplock>
801014a6:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014ac:	75 e2                	jne    80101490 <iinit+0x20>
801014ae:	8b 45 08             	mov    0x8(%ebp),%eax
801014b1:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801014b8:	80 
801014b9:	89 04 24             	mov    %eax,(%esp)
801014bc:	e8 5f ff ff ff       	call   80101420 <readsb>
801014c1:	a1 d8 09 11 80       	mov    0x801109d8,%eax
801014c6:	c7 04 24 f8 6e 10 80 	movl   $0x80106ef8,(%esp)
801014cd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014d1:	a1 d4 09 11 80       	mov    0x801109d4,%eax
801014d6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014da:	a1 d0 09 11 80       	mov    0x801109d0,%eax
801014df:	89 44 24 14          	mov    %eax,0x14(%esp)
801014e3:	a1 cc 09 11 80       	mov    0x801109cc,%eax
801014e8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014ec:	a1 c8 09 11 80       	mov    0x801109c8,%eax
801014f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
801014f5:	a1 c4 09 11 80       	mov    0x801109c4,%eax
801014fa:	89 44 24 08          	mov    %eax,0x8(%esp)
801014fe:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101503:	89 44 24 04          	mov    %eax,0x4(%esp)
80101507:	e8 44 f1 ff ff       	call   80100650 <cprintf>
8010150c:	83 c4 24             	add    $0x24,%esp
8010150f:	5b                   	pop    %ebx
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
80101512:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101520 <ialloc>:
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 2c             	sub    $0x2c,%esp
80101529:	8b 45 0c             	mov    0xc(%ebp),%eax
8010152c:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
80101533:	8b 7d 08             	mov    0x8(%ebp),%edi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101539:	0f 86 a2 00 00 00    	jbe    801015e1 <ialloc+0xc1>
8010153f:	be 01 00 00 00       	mov    $0x1,%esi
80101544:	bb 01 00 00 00       	mov    $0x1,%ebx
80101549:	eb 1a                	jmp    80101565 <ialloc+0x45>
8010154b:	90                   	nop
8010154c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101550:	89 14 24             	mov    %edx,(%esp)
80101553:	83 c3 01             	add    $0x1,%ebx
80101556:	e8 85 ec ff ff       	call   801001e0 <brelse>
8010155b:	89 de                	mov    %ebx,%esi
8010155d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101563:	73 7c                	jae    801015e1 <ialloc+0xc1>
80101565:	89 f0                	mov    %esi,%eax
80101567:	c1 e8 03             	shr    $0x3,%eax
8010156a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101570:	89 3c 24             	mov    %edi,(%esp)
80101573:	89 44 24 04          	mov    %eax,0x4(%esp)
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c2                	mov    %eax,%edx
8010157e:	89 f0                	mov    %esi,%eax
80101580:	83 e0 07             	and    $0x7,%eax
80101583:	c1 e0 06             	shl    $0x6,%eax
80101586:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
8010158a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010158e:	75 c0                	jne    80101550 <ialloc+0x30>
80101590:	89 0c 24             	mov    %ecx,(%esp)
80101593:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010159a:	00 
8010159b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015a2:	00 
801015a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015a9:	e8 12 2e 00 00       	call   801043c0 <memset>
801015ae:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015b2:	8b 55 dc             	mov    -0x24(%ebp),%edx
801015b5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015b8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801015bb:	66 89 01             	mov    %ax,(%ecx)
801015be:	89 14 24             	mov    %edx,(%esp)
801015c1:	e8 ea 16 00 00       	call   80102cb0 <log_write>
801015c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015c9:	89 14 24             	mov    %edx,(%esp)
801015cc:	e8 0f ec ff ff       	call   801001e0 <brelse>
801015d1:	83 c4 2c             	add    $0x2c,%esp
801015d4:	89 f2                	mov    %esi,%edx
801015d6:	5b                   	pop    %ebx
801015d7:	89 f8                	mov    %edi,%eax
801015d9:	5e                   	pop    %esi
801015da:	5f                   	pop    %edi
801015db:	5d                   	pop    %ebp
801015dc:	e9 bf fc ff ff       	jmp    801012a0 <iget>
801015e1:	c7 04 24 98 6e 10 80 	movl   $0x80106e98,(%esp)
801015e8:	e8 73 ed ff ff       	call   80100360 <panic>
801015ed:	8d 76 00             	lea    0x0(%esi),%esi

801015f0 <iupdate>:
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	56                   	push   %esi
801015f4:	53                   	push   %ebx
801015f5:	83 ec 10             	sub    $0x10,%esp
801015f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801015fb:	8b 43 04             	mov    0x4(%ebx),%eax
801015fe:	83 c3 5c             	add    $0x5c,%ebx
80101601:	c1 e8 03             	shr    $0x3,%eax
80101604:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010160a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010160e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101611:	89 04 24             	mov    %eax,(%esp)
80101614:	e8 b7 ea ff ff       	call   801000d0 <bread>
80101619:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010161c:	83 e2 07             	and    $0x7,%edx
8010161f:	c1 e2 06             	shl    $0x6,%edx
80101622:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
80101626:	89 c6                	mov    %eax,%esi
80101628:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
8010162c:	83 c2 0c             	add    $0xc,%edx
8010162f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
80101633:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101637:	66 89 42 f6          	mov    %ax,-0xa(%edx)
8010163b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010163f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
80101643:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101647:	66 89 42 fa          	mov    %ax,-0x6(%edx)
8010164b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010164e:	89 42 fc             	mov    %eax,-0x4(%edx)
80101651:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101655:	89 14 24             	mov    %edx,(%esp)
80101658:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010165f:	00 
80101660:	e8 fb 2d 00 00       	call   80104460 <memmove>
80101665:	89 34 24             	mov    %esi,(%esp)
80101668:	e8 43 16 00 00       	call   80102cb0 <log_write>
8010166d:	89 75 08             	mov    %esi,0x8(%ebp)
80101670:	83 c4 10             	add    $0x10,%esp
80101673:	5b                   	pop    %ebx
80101674:	5e                   	pop    %esi
80101675:	5d                   	pop    %ebp
80101676:	e9 65 eb ff ff       	jmp    801001e0 <brelse>
8010167b:	90                   	nop
8010167c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101680 <idup>:
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	53                   	push   %ebx
80101684:	83 ec 14             	sub    $0x14,%esp
80101687:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010168a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101691:	e8 6a 2c 00 00       	call   80104300 <acquire>
80101696:	83 43 08 01          	addl   $0x1,0x8(%ebx)
8010169a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016a1:	e8 ca 2c 00 00       	call   80104370 <release>
801016a6:	83 c4 14             	add    $0x14,%esp
801016a9:	89 d8                	mov    %ebx,%eax
801016ab:	5b                   	pop    %ebx
801016ac:	5d                   	pop    %ebp
801016ad:	c3                   	ret    
801016ae:	66 90                	xchg   %ax,%ax

801016b0 <ilock>:
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	56                   	push   %esi
801016b4:	53                   	push   %ebx
801016b5:	83 ec 10             	sub    $0x10,%esp
801016b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801016bb:	85 db                	test   %ebx,%ebx
801016bd:	0f 84 b3 00 00 00    	je     80101776 <ilock+0xc6>
801016c3:	8b 53 08             	mov    0x8(%ebx),%edx
801016c6:	85 d2                	test   %edx,%edx
801016c8:	0f 8e a8 00 00 00    	jle    80101776 <ilock+0xc6>
801016ce:	8d 43 0c             	lea    0xc(%ebx),%eax
801016d1:	89 04 24             	mov    %eax,(%esp)
801016d4:	e8 c7 29 00 00       	call   801040a0 <acquiresleep>
801016d9:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016dc:	85 c0                	test   %eax,%eax
801016de:	74 08                	je     801016e8 <ilock+0x38>
801016e0:	83 c4 10             	add    $0x10,%esp
801016e3:	5b                   	pop    %ebx
801016e4:	5e                   	pop    %esi
801016e5:	5d                   	pop    %ebp
801016e6:	c3                   	ret    
801016e7:	90                   	nop
801016e8:	8b 43 04             	mov    0x4(%ebx),%eax
801016eb:	c1 e8 03             	shr    $0x3,%eax
801016ee:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801016f8:	8b 03                	mov    (%ebx),%eax
801016fa:	89 04 24             	mov    %eax,(%esp)
801016fd:	e8 ce e9 ff ff       	call   801000d0 <bread>
80101702:	8b 53 04             	mov    0x4(%ebx),%edx
80101705:	83 e2 07             	and    $0x7,%edx
80101708:	c1 e2 06             	shl    $0x6,%edx
8010170b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
8010170f:	89 c6                	mov    %eax,%esi
80101711:	0f b7 02             	movzwl (%edx),%eax
80101714:	83 c2 0c             	add    $0xc,%edx
80101717:	66 89 43 50          	mov    %ax,0x50(%ebx)
8010171b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010171f:	66 89 43 52          	mov    %ax,0x52(%ebx)
80101723:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101727:	66 89 43 54          	mov    %ax,0x54(%ebx)
8010172b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010172f:	66 89 43 56          	mov    %ax,0x56(%ebx)
80101733:	8b 42 fc             	mov    -0x4(%edx),%eax
80101736:	89 43 58             	mov    %eax,0x58(%ebx)
80101739:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010173c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101740:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101747:	00 
80101748:	89 04 24             	mov    %eax,(%esp)
8010174b:	e8 10 2d 00 00       	call   80104460 <memmove>
80101750:	89 34 24             	mov    %esi,(%esp)
80101753:	e8 88 ea ff ff       	call   801001e0 <brelse>
80101758:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
8010175d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
80101764:	0f 85 76 ff ff ff    	jne    801016e0 <ilock+0x30>
8010176a:	c7 04 24 b0 6e 10 80 	movl   $0x80106eb0,(%esp)
80101771:	e8 ea eb ff ff       	call   80100360 <panic>
80101776:	c7 04 24 aa 6e 10 80 	movl   $0x80106eaa,(%esp)
8010177d:	e8 de eb ff ff       	call   80100360 <panic>
80101782:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101790 <iunlock>:
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	56                   	push   %esi
80101794:	53                   	push   %ebx
80101795:	83 ec 10             	sub    $0x10,%esp
80101798:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010179b:	85 db                	test   %ebx,%ebx
8010179d:	74 24                	je     801017c3 <iunlock+0x33>
8010179f:	8d 73 0c             	lea    0xc(%ebx),%esi
801017a2:	89 34 24             	mov    %esi,(%esp)
801017a5:	e8 96 29 00 00       	call   80104140 <holdingsleep>
801017aa:	85 c0                	test   %eax,%eax
801017ac:	74 15                	je     801017c3 <iunlock+0x33>
801017ae:	8b 43 08             	mov    0x8(%ebx),%eax
801017b1:	85 c0                	test   %eax,%eax
801017b3:	7e 0e                	jle    801017c3 <iunlock+0x33>
801017b5:	89 75 08             	mov    %esi,0x8(%ebp)
801017b8:	83 c4 10             	add    $0x10,%esp
801017bb:	5b                   	pop    %ebx
801017bc:	5e                   	pop    %esi
801017bd:	5d                   	pop    %ebp
801017be:	e9 3d 29 00 00       	jmp    80104100 <releasesleep>
801017c3:	c7 04 24 bf 6e 10 80 	movl   $0x80106ebf,(%esp)
801017ca:	e8 91 eb ff ff       	call   80100360 <panic>
801017cf:	90                   	nop

801017d0 <iput>:
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	57                   	push   %edi
801017d4:	56                   	push   %esi
801017d5:	53                   	push   %ebx
801017d6:	83 ec 1c             	sub    $0x1c,%esp
801017d9:	8b 75 08             	mov    0x8(%ebp),%esi
801017dc:	8d 7e 0c             	lea    0xc(%esi),%edi
801017df:	89 3c 24             	mov    %edi,(%esp)
801017e2:	e8 b9 28 00 00       	call   801040a0 <acquiresleep>
801017e7:	8b 56 4c             	mov    0x4c(%esi),%edx
801017ea:	85 d2                	test   %edx,%edx
801017ec:	74 07                	je     801017f5 <iput+0x25>
801017ee:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017f3:	74 2b                	je     80101820 <iput+0x50>
801017f5:	89 3c 24             	mov    %edi,(%esp)
801017f8:	e8 03 29 00 00       	call   80104100 <releasesleep>
801017fd:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101804:	e8 f7 2a 00 00       	call   80104300 <acquire>
80101809:	83 6e 08 01          	subl   $0x1,0x8(%esi)
8010180d:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
80101814:	83 c4 1c             	add    $0x1c,%esp
80101817:	5b                   	pop    %ebx
80101818:	5e                   	pop    %esi
80101819:	5f                   	pop    %edi
8010181a:	5d                   	pop    %ebp
8010181b:	e9 50 2b 00 00       	jmp    80104370 <release>
80101820:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101827:	e8 d4 2a 00 00       	call   80104300 <acquire>
8010182c:	8b 5e 08             	mov    0x8(%esi),%ebx
8010182f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101836:	e8 35 2b 00 00       	call   80104370 <release>
8010183b:	83 fb 01             	cmp    $0x1,%ebx
8010183e:	75 b5                	jne    801017f5 <iput+0x25>
80101840:	8d 4e 30             	lea    0x30(%esi),%ecx
80101843:	89 f3                	mov    %esi,%ebx
80101845:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101848:	89 cf                	mov    %ecx,%edi
8010184a:	eb 0b                	jmp    80101857 <iput+0x87>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101850:	83 c3 04             	add    $0x4,%ebx
80101853:	39 fb                	cmp    %edi,%ebx
80101855:	74 19                	je     80101870 <iput+0xa0>
80101857:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010185a:	85 d2                	test   %edx,%edx
8010185c:	74 f2                	je     80101850 <iput+0x80>
8010185e:	8b 06                	mov    (%esi),%eax
80101860:	e8 9b f8 ff ff       	call   80101100 <bfree>
80101865:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010186c:	eb e2                	jmp    80101850 <iput+0x80>
8010186e:	66 90                	xchg   %ax,%ax
80101870:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101879:	85 c0                	test   %eax,%eax
8010187b:	75 2b                	jne    801018a8 <iput+0xd8>
8010187d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
80101884:	89 34 24             	mov    %esi,(%esp)
80101887:	e8 64 fd ff ff       	call   801015f0 <iupdate>
8010188c:	31 c0                	xor    %eax,%eax
8010188e:	66 89 46 50          	mov    %ax,0x50(%esi)
80101892:	89 34 24             	mov    %esi,(%esp)
80101895:	e8 56 fd ff ff       	call   801015f0 <iupdate>
8010189a:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018a1:	e9 4f ff ff ff       	jmp    801017f5 <iput+0x25>
801018a6:	66 90                	xchg   %ax,%ax
801018a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801018ac:	8b 06                	mov    (%esi),%eax
801018ae:	31 db                	xor    %ebx,%ebx
801018b0:	89 04 24             	mov    %eax,(%esp)
801018b3:	e8 18 e8 ff ff       	call   801000d0 <bread>
801018b8:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018bb:	8d 48 5c             	lea    0x5c(%eax),%ecx
801018be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801018c1:	89 cf                	mov    %ecx,%edi
801018c3:	31 c0                	xor    %eax,%eax
801018c5:	eb 0e                	jmp    801018d5 <iput+0x105>
801018c7:	90                   	nop
801018c8:	83 c3 01             	add    $0x1,%ebx
801018cb:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018d1:	89 d8                	mov    %ebx,%eax
801018d3:	74 10                	je     801018e5 <iput+0x115>
801018d5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018d8:	85 d2                	test   %edx,%edx
801018da:	74 ec                	je     801018c8 <iput+0xf8>
801018dc:	8b 06                	mov    (%esi),%eax
801018de:	e8 1d f8 ff ff       	call   80101100 <bfree>
801018e3:	eb e3                	jmp    801018c8 <iput+0xf8>
801018e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018e8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018eb:	89 04 24             	mov    %eax,(%esp)
801018ee:	e8 ed e8 ff ff       	call   801001e0 <brelse>
801018f3:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018f9:	8b 06                	mov    (%esi),%eax
801018fb:	e8 00 f8 ff ff       	call   80101100 <bfree>
80101900:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101907:	00 00 00 
8010190a:	e9 6e ff ff ff       	jmp    8010187d <iput+0xad>
8010190f:	90                   	nop

80101910 <iunlockput>:
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	53                   	push   %ebx
80101914:	83 ec 14             	sub    $0x14,%esp
80101917:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010191a:	89 1c 24             	mov    %ebx,(%esp)
8010191d:	e8 6e fe ff ff       	call   80101790 <iunlock>
80101922:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101925:	83 c4 14             	add    $0x14,%esp
80101928:	5b                   	pop    %ebx
80101929:	5d                   	pop    %ebp
8010192a:	e9 a1 fe ff ff       	jmp    801017d0 <iput>
8010192f:	90                   	nop

80101930 <stati>:
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	8b 55 08             	mov    0x8(%ebp),%edx
80101936:	8b 45 0c             	mov    0xc(%ebp),%eax
80101939:	8b 0a                	mov    (%edx),%ecx
8010193b:	89 48 04             	mov    %ecx,0x4(%eax)
8010193e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101941:	89 48 08             	mov    %ecx,0x8(%eax)
80101944:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101948:	66 89 08             	mov    %cx,(%eax)
8010194b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010194f:	66 89 48 0c          	mov    %cx,0xc(%eax)
80101953:	8b 52 58             	mov    0x58(%edx),%edx
80101956:	89 50 10             	mov    %edx,0x10(%eax)
80101959:	5d                   	pop    %ebp
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <readi>:
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 2c             	sub    $0x2c,%esp
80101969:	8b 45 0c             	mov    0xc(%ebp),%eax
8010196c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010196f:	8b 75 10             	mov    0x10(%ebp),%esi
80101972:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101975:	8b 45 14             	mov    0x14(%ebp),%eax
80101978:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
8010197d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101980:	0f 84 aa 00 00 00    	je     80101a30 <readi+0xd0>
80101986:	8b 47 58             	mov    0x58(%edi),%eax
80101989:	39 f0                	cmp    %esi,%eax
8010198b:	0f 82 c7 00 00 00    	jb     80101a58 <readi+0xf8>
80101991:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101994:	89 da                	mov    %ebx,%edx
80101996:	01 f2                	add    %esi,%edx
80101998:	0f 82 ba 00 00 00    	jb     80101a58 <readi+0xf8>
8010199e:	89 c1                	mov    %eax,%ecx
801019a0:	29 f1                	sub    %esi,%ecx
801019a2:	39 d0                	cmp    %edx,%eax
801019a4:	0f 43 cb             	cmovae %ebx,%ecx
801019a7:	31 c0                	xor    %eax,%eax
801019a9:	85 c9                	test   %ecx,%ecx
801019ab:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801019ae:	74 70                	je     80101a20 <readi+0xc0>
801019b0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019b3:	89 c7                	mov    %eax,%edi
801019b5:	8d 76 00             	lea    0x0(%esi),%esi
801019b8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019bb:	89 f2                	mov    %esi,%edx
801019bd:	c1 ea 09             	shr    $0x9,%edx
801019c0:	89 d8                	mov    %ebx,%eax
801019c2:	e8 99 f9 ff ff       	call   80101360 <bmap>
801019c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019cb:	8b 03                	mov    (%ebx),%eax
801019cd:	bb 00 02 00 00       	mov    $0x200,%ebx
801019d2:	89 04 24             	mov    %eax,(%esp)
801019d5:	e8 f6 e6 ff ff       	call   801000d0 <bread>
801019da:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019dd:	29 f9                	sub    %edi,%ecx
801019df:	89 c2                	mov    %eax,%edx
801019e1:	89 f0                	mov    %esi,%eax
801019e3:	25 ff 01 00 00       	and    $0x1ff,%eax
801019e8:	29 c3                	sub    %eax,%ebx
801019ea:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
801019ee:	39 cb                	cmp    %ecx,%ebx
801019f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801019f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801019f7:	0f 47 d9             	cmova  %ecx,%ebx
801019fa:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801019fe:	01 df                	add    %ebx,%edi
80101a00:	01 de                	add    %ebx,%esi
80101a02:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a05:	89 04 24             	mov    %eax,(%esp)
80101a08:	e8 53 2a 00 00       	call   80104460 <memmove>
80101a0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a10:	89 14 24             	mov    %edx,(%esp)
80101a13:	e8 c8 e7 ff ff       	call   801001e0 <brelse>
80101a18:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a1b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a1e:	77 98                	ja     801019b8 <readi+0x58>
80101a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101a23:	83 c4 2c             	add    $0x2c,%esp
80101a26:	5b                   	pop    %ebx
80101a27:	5e                   	pop    %esi
80101a28:	5f                   	pop    %edi
80101a29:	5d                   	pop    %ebp
80101a2a:	c3                   	ret    
80101a2b:	90                   	nop
80101a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a30:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a34:	66 83 f8 09          	cmp    $0x9,%ax
80101a38:	77 1e                	ja     80101a58 <readi+0xf8>
80101a3a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a41:	85 c0                	test   %eax,%eax
80101a43:	74 13                	je     80101a58 <readi+0xf8>
80101a45:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a48:	89 75 10             	mov    %esi,0x10(%ebp)
80101a4b:	83 c4 2c             	add    $0x2c,%esp
80101a4e:	5b                   	pop    %ebx
80101a4f:	5e                   	pop    %esi
80101a50:	5f                   	pop    %edi
80101a51:	5d                   	pop    %ebp
80101a52:	ff e0                	jmp    *%eax
80101a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a5d:	eb c4                	jmp    80101a23 <readi+0xc3>
80101a5f:	90                   	nop

80101a60 <writei>:
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	57                   	push   %edi
80101a64:	56                   	push   %esi
80101a65:	53                   	push   %ebx
80101a66:	83 ec 2c             	sub    $0x2c,%esp
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a6f:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101a72:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101a77:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a7a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a7d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a80:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101a83:	0f 84 b7 00 00 00    	je     80101b40 <writei+0xe0>
80101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a8c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a8f:	0f 82 e3 00 00 00    	jb     80101b78 <writei+0x118>
80101a95:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a98:	89 c8                	mov    %ecx,%eax
80101a9a:	01 f0                	add    %esi,%eax
80101a9c:	0f 82 d6 00 00 00    	jb     80101b78 <writei+0x118>
80101aa2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101aa7:	0f 87 cb 00 00 00    	ja     80101b78 <writei+0x118>
80101aad:	85 c9                	test   %ecx,%ecx
80101aaf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ab6:	74 77                	je     80101b2f <writei+0xcf>
80101ab8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101abb:	89 f2                	mov    %esi,%edx
80101abd:	bb 00 02 00 00       	mov    $0x200,%ebx
80101ac2:	c1 ea 09             	shr    $0x9,%edx
80101ac5:	89 f8                	mov    %edi,%eax
80101ac7:	e8 94 f8 ff ff       	call   80101360 <bmap>
80101acc:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ad0:	8b 07                	mov    (%edi),%eax
80101ad2:	89 04 24             	mov    %eax,(%esp)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
80101ada:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101add:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
80101ae0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101ae3:	89 c7                	mov    %eax,%edi
80101ae5:	89 f0                	mov    %esi,%eax
80101ae7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aec:	29 c3                	sub    %eax,%ebx
80101aee:	39 cb                	cmp    %ecx,%ebx
80101af0:	0f 47 d9             	cmova  %ecx,%ebx
80101af3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
80101af7:	01 de                	add    %ebx,%esi
80101af9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101afd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b01:	89 04 24             	mov    %eax,(%esp)
80101b04:	e8 57 29 00 00       	call   80104460 <memmove>
80101b09:	89 3c 24             	mov    %edi,(%esp)
80101b0c:	e8 9f 11 00 00       	call   80102cb0 <log_write>
80101b11:	89 3c 24             	mov    %edi,(%esp)
80101b14:	e8 c7 e6 ff ff       	call   801001e0 <brelse>
80101b19:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b1f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b22:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b25:	77 91                	ja     80101ab8 <writei+0x58>
80101b27:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b2a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b2d:	72 39                	jb     80101b68 <writei+0x108>
80101b2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101b32:	83 c4 2c             	add    $0x2c,%esp
80101b35:	5b                   	pop    %ebx
80101b36:	5e                   	pop    %esi
80101b37:	5f                   	pop    %edi
80101b38:	5d                   	pop    %ebp
80101b39:	c3                   	ret    
80101b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 2e                	ja     80101b78 <writei+0x118>
80101b4a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 23                	je     80101b78 <writei+0x118>
80101b55:	89 4d 10             	mov    %ecx,0x10(%ebp)
80101b58:	83 c4 2c             	add    $0x2c,%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
80101b5f:	ff e0                	jmp    *%eax
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b68:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b6b:	89 70 58             	mov    %esi,0x58(%eax)
80101b6e:	89 04 24             	mov    %eax,(%esp)
80101b71:	e8 7a fa ff ff       	call   801015f0 <iupdate>
80101b76:	eb b7                	jmp    80101b2f <writei+0xcf>
80101b78:	83 c4 2c             	add    $0x2c,%esp
80101b7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b80:	5b                   	pop    %ebx
80101b81:	5e                   	pop    %esi
80101b82:	5f                   	pop    %edi
80101b83:	5d                   	pop    %ebp
80101b84:	c3                   	ret    
80101b85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b90 <namecmp>:
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	83 ec 18             	sub    $0x18,%esp
80101b96:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b99:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ba0:	00 
80101ba1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ba5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba8:	89 04 24             	mov    %eax,(%esp)
80101bab:	e8 30 29 00 00       	call   801044e0 <strncmp>
80101bb0:	c9                   	leave  
80101bb1:	c3                   	ret    
80101bb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <dirlookup>:
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 2c             	sub    $0x2c,%esp
80101bc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101bcc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bd1:	0f 85 97 00 00 00    	jne    80101c6e <dirlookup+0xae>
80101bd7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bda:	31 ff                	xor    %edi,%edi
80101bdc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bdf:	85 d2                	test   %edx,%edx
80101be1:	75 0d                	jne    80101bf0 <dirlookup+0x30>
80101be3:	eb 73                	jmp    80101c58 <dirlookup+0x98>
80101be5:	8d 76 00             	lea    0x0(%esi),%esi
80101be8:	83 c7 10             	add    $0x10,%edi
80101beb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bee:	76 68                	jbe    80101c58 <dirlookup+0x98>
80101bf0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101bf7:	00 
80101bf8:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101bfc:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c00:	89 1c 24             	mov    %ebx,(%esp)
80101c03:	e8 58 fd ff ff       	call   80101960 <readi>
80101c08:	83 f8 10             	cmp    $0x10,%eax
80101c0b:	75 55                	jne    80101c62 <dirlookup+0xa2>
80101c0d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c12:	74 d4                	je     80101be8 <dirlookup+0x28>
80101c14:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c17:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c1e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c25:	00 
80101c26:	89 04 24             	mov    %eax,(%esp)
80101c29:	e8 b2 28 00 00       	call   801044e0 <strncmp>
80101c2e:	85 c0                	test   %eax,%eax
80101c30:	75 b6                	jne    80101be8 <dirlookup+0x28>
80101c32:	8b 45 10             	mov    0x10(%ebp),%eax
80101c35:	85 c0                	test   %eax,%eax
80101c37:	74 05                	je     80101c3e <dirlookup+0x7e>
80101c39:	8b 45 10             	mov    0x10(%ebp),%eax
80101c3c:	89 38                	mov    %edi,(%eax)
80101c3e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101c42:	8b 03                	mov    (%ebx),%eax
80101c44:	e8 57 f6 ff ff       	call   801012a0 <iget>
80101c49:	83 c4 2c             	add    $0x2c,%esp
80101c4c:	5b                   	pop    %ebx
80101c4d:	5e                   	pop    %esi
80101c4e:	5f                   	pop    %edi
80101c4f:	5d                   	pop    %ebp
80101c50:	c3                   	ret    
80101c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c58:	83 c4 2c             	add    $0x2c,%esp
80101c5b:	31 c0                	xor    %eax,%eax
80101c5d:	5b                   	pop    %ebx
80101c5e:	5e                   	pop    %esi
80101c5f:	5f                   	pop    %edi
80101c60:	5d                   	pop    %ebp
80101c61:	c3                   	ret    
80101c62:	c7 04 24 d9 6e 10 80 	movl   $0x80106ed9,(%esp)
80101c69:	e8 f2 e6 ff ff       	call   80100360 <panic>
80101c6e:	c7 04 24 c7 6e 10 80 	movl   $0x80106ec7,(%esp)
80101c75:	e8 e6 e6 ff ff       	call   80100360 <panic>
80101c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c80 <namex>:
80101c80:	55                   	push   %ebp
80101c81:	89 e5                	mov    %esp,%ebp
80101c83:	57                   	push   %edi
80101c84:	89 cf                	mov    %ecx,%edi
80101c86:	56                   	push   %esi
80101c87:	53                   	push   %ebx
80101c88:	89 c3                	mov    %eax,%ebx
80101c8a:	83 ec 2c             	sub    $0x2c,%esp
80101c8d:	80 38 2f             	cmpb   $0x2f,(%eax)
80101c90:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101c93:	0f 84 51 01 00 00    	je     80101dea <namex+0x16a>
80101c99:	e8 02 1a 00 00       	call   801036a0 <myproc>
80101c9e:	8b 70 68             	mov    0x68(%eax),%esi
80101ca1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101ca8:	e8 53 26 00 00       	call   80104300 <acquire>
80101cad:	83 46 08 01          	addl   $0x1,0x8(%esi)
80101cb1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cb8:	e8 b3 26 00 00       	call   80104370 <release>
80101cbd:	eb 04                	jmp    80101cc3 <namex+0x43>
80101cbf:	90                   	nop
80101cc0:	83 c3 01             	add    $0x1,%ebx
80101cc3:	0f b6 03             	movzbl (%ebx),%eax
80101cc6:	3c 2f                	cmp    $0x2f,%al
80101cc8:	74 f6                	je     80101cc0 <namex+0x40>
80101cca:	84 c0                	test   %al,%al
80101ccc:	0f 84 ed 00 00 00    	je     80101dbf <namex+0x13f>
80101cd2:	0f b6 03             	movzbl (%ebx),%eax
80101cd5:	89 da                	mov    %ebx,%edx
80101cd7:	84 c0                	test   %al,%al
80101cd9:	0f 84 b1 00 00 00    	je     80101d90 <namex+0x110>
80101cdf:	3c 2f                	cmp    $0x2f,%al
80101ce1:	75 0f                	jne    80101cf2 <namex+0x72>
80101ce3:	e9 a8 00 00 00       	jmp    80101d90 <namex+0x110>
80101ce8:	3c 2f                	cmp    $0x2f,%al
80101cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101cf0:	74 0a                	je     80101cfc <namex+0x7c>
80101cf2:	83 c2 01             	add    $0x1,%edx
80101cf5:	0f b6 02             	movzbl (%edx),%eax
80101cf8:	84 c0                	test   %al,%al
80101cfa:	75 ec                	jne    80101ce8 <namex+0x68>
80101cfc:	89 d1                	mov    %edx,%ecx
80101cfe:	29 d9                	sub    %ebx,%ecx
80101d00:	83 f9 0d             	cmp    $0xd,%ecx
80101d03:	0f 8e 8f 00 00 00    	jle    80101d98 <namex+0x118>
80101d09:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d0d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d14:	00 
80101d15:	89 3c 24             	mov    %edi,(%esp)
80101d18:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d1b:	e8 40 27 00 00       	call   80104460 <memmove>
80101d20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d23:	89 d3                	mov    %edx,%ebx
80101d25:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d28:	75 0e                	jne    80101d38 <namex+0xb8>
80101d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d30:	83 c3 01             	add    $0x1,%ebx
80101d33:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d36:	74 f8                	je     80101d30 <namex+0xb0>
80101d38:	89 34 24             	mov    %esi,(%esp)
80101d3b:	e8 70 f9 ff ff       	call   801016b0 <ilock>
80101d40:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d45:	0f 85 85 00 00 00    	jne    80101dd0 <namex+0x150>
80101d4b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d4e:	85 d2                	test   %edx,%edx
80101d50:	74 09                	je     80101d5b <namex+0xdb>
80101d52:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d55:	0f 84 a5 00 00 00    	je     80101e00 <namex+0x180>
80101d5b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d62:	00 
80101d63:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d67:	89 34 24             	mov    %esi,(%esp)
80101d6a:	e8 51 fe ff ff       	call   80101bc0 <dirlookup>
80101d6f:	85 c0                	test   %eax,%eax
80101d71:	74 5d                	je     80101dd0 <namex+0x150>
80101d73:	89 34 24             	mov    %esi,(%esp)
80101d76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d79:	e8 12 fa ff ff       	call   80101790 <iunlock>
80101d7e:	89 34 24             	mov    %esi,(%esp)
80101d81:	e8 4a fa ff ff       	call   801017d0 <iput>
80101d86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d89:	89 c6                	mov    %eax,%esi
80101d8b:	e9 33 ff ff ff       	jmp    80101cc3 <namex+0x43>
80101d90:	31 c9                	xor    %ecx,%ecx
80101d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d98:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101d9c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101da0:	89 3c 24             	mov    %edi,(%esp)
80101da3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101da9:	e8 b2 26 00 00       	call   80104460 <memmove>
80101dae:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101db1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101db4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101db8:	89 d3                	mov    %edx,%ebx
80101dba:	e9 66 ff ff ff       	jmp    80101d25 <namex+0xa5>
80101dbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dc2:	85 c0                	test   %eax,%eax
80101dc4:	75 4c                	jne    80101e12 <namex+0x192>
80101dc6:	89 f0                	mov    %esi,%eax
80101dc8:	83 c4 2c             	add    $0x2c,%esp
80101dcb:	5b                   	pop    %ebx
80101dcc:	5e                   	pop    %esi
80101dcd:	5f                   	pop    %edi
80101dce:	5d                   	pop    %ebp
80101dcf:	c3                   	ret    
80101dd0:	89 34 24             	mov    %esi,(%esp)
80101dd3:	e8 b8 f9 ff ff       	call   80101790 <iunlock>
80101dd8:	89 34 24             	mov    %esi,(%esp)
80101ddb:	e8 f0 f9 ff ff       	call   801017d0 <iput>
80101de0:	83 c4 2c             	add    $0x2c,%esp
80101de3:	31 c0                	xor    %eax,%eax
80101de5:	5b                   	pop    %ebx
80101de6:	5e                   	pop    %esi
80101de7:	5f                   	pop    %edi
80101de8:	5d                   	pop    %ebp
80101de9:	c3                   	ret    
80101dea:	ba 01 00 00 00       	mov    $0x1,%edx
80101def:	b8 01 00 00 00       	mov    $0x1,%eax
80101df4:	e8 a7 f4 ff ff       	call   801012a0 <iget>
80101df9:	89 c6                	mov    %eax,%esi
80101dfb:	e9 c3 fe ff ff       	jmp    80101cc3 <namex+0x43>
80101e00:	89 34 24             	mov    %esi,(%esp)
80101e03:	e8 88 f9 ff ff       	call   80101790 <iunlock>
80101e08:	83 c4 2c             	add    $0x2c,%esp
80101e0b:	89 f0                	mov    %esi,%eax
80101e0d:	5b                   	pop    %ebx
80101e0e:	5e                   	pop    %esi
80101e0f:	5f                   	pop    %edi
80101e10:	5d                   	pop    %ebp
80101e11:	c3                   	ret    
80101e12:	89 34 24             	mov    %esi,(%esp)
80101e15:	e8 b6 f9 ff ff       	call   801017d0 <iput>
80101e1a:	31 c0                	xor    %eax,%eax
80101e1c:	eb aa                	jmp    80101dc8 <namex+0x148>
80101e1e:	66 90                	xchg   %ax,%ax

80101e20 <dirlink>:
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	83 ec 2c             	sub    $0x2c,%esp
80101e29:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e2f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e36:	00 
80101e37:	89 1c 24             	mov    %ebx,(%esp)
80101e3a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e3e:	e8 7d fd ff ff       	call   80101bc0 <dirlookup>
80101e43:	85 c0                	test   %eax,%eax
80101e45:	0f 85 8b 00 00 00    	jne    80101ed6 <dirlink+0xb6>
80101e4b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e4e:	31 ff                	xor    %edi,%edi
80101e50:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e53:	85 c0                	test   %eax,%eax
80101e55:	75 13                	jne    80101e6a <dirlink+0x4a>
80101e57:	eb 35                	jmp    80101e8e <dirlink+0x6e>
80101e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e60:	8d 57 10             	lea    0x10(%edi),%edx
80101e63:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e66:	89 d7                	mov    %edx,%edi
80101e68:	76 24                	jbe    80101e8e <dirlink+0x6e>
80101e6a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e71:	00 
80101e72:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e76:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e7a:	89 1c 24             	mov    %ebx,(%esp)
80101e7d:	e8 de fa ff ff       	call   80101960 <readi>
80101e82:	83 f8 10             	cmp    $0x10,%eax
80101e85:	75 5e                	jne    80101ee5 <dirlink+0xc5>
80101e87:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e8c:	75 d2                	jne    80101e60 <dirlink+0x40>
80101e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e91:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101e98:	00 
80101e99:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e9d:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ea0:	89 04 24             	mov    %eax,(%esp)
80101ea3:	e8 a8 26 00 00       	call   80104550 <strncpy>
80101ea8:	8b 45 10             	mov    0x10(%ebp),%eax
80101eab:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101eb2:	00 
80101eb3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101eb7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101ebb:	89 1c 24             	mov    %ebx,(%esp)
80101ebe:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
80101ec2:	e8 99 fb ff ff       	call   80101a60 <writei>
80101ec7:	83 f8 10             	cmp    $0x10,%eax
80101eca:	75 25                	jne    80101ef1 <dirlink+0xd1>
80101ecc:	31 c0                	xor    %eax,%eax
80101ece:	83 c4 2c             	add    $0x2c,%esp
80101ed1:	5b                   	pop    %ebx
80101ed2:	5e                   	pop    %esi
80101ed3:	5f                   	pop    %edi
80101ed4:	5d                   	pop    %ebp
80101ed5:	c3                   	ret    
80101ed6:	89 04 24             	mov    %eax,(%esp)
80101ed9:	e8 f2 f8 ff ff       	call   801017d0 <iput>
80101ede:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ee3:	eb e9                	jmp    80101ece <dirlink+0xae>
80101ee5:	c7 04 24 e8 6e 10 80 	movl   $0x80106ee8,(%esp)
80101eec:	e8 6f e4 ff ff       	call   80100360 <panic>
80101ef1:	c7 04 24 e2 74 10 80 	movl   $0x801074e2,(%esp)
80101ef8:	e8 63 e4 ff ff       	call   80100360 <panic>
80101efd:	8d 76 00             	lea    0x0(%esi),%esi

80101f00 <namei>:
80101f00:	55                   	push   %ebp
80101f01:	31 d2                	xor    %edx,%edx
80101f03:	89 e5                	mov    %esp,%ebp
80101f05:	83 ec 18             	sub    $0x18,%esp
80101f08:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f0e:	e8 6d fd ff ff       	call   80101c80 <namex>
80101f13:	c9                   	leave  
80101f14:	c3                   	ret    
80101f15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f20 <nameiparent>:
80101f20:	55                   	push   %ebp
80101f21:	ba 01 00 00 00       	mov    $0x1,%edx
80101f26:	89 e5                	mov    %esp,%ebp
80101f28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2e:	5d                   	pop    %ebp
80101f2f:	e9 4c fd ff ff       	jmp    80101c80 <namex>
80101f34:	66 90                	xchg   %ax,%ax
80101f36:	66 90                	xchg   %ax,%ax
80101f38:	66 90                	xchg   %ax,%ax
80101f3a:	66 90                	xchg   %ax,%ax
80101f3c:	66 90                	xchg   %ax,%ax
80101f3e:	66 90                	xchg   %ax,%ax

80101f40 <idestart>:
80101f40:	55                   	push   %ebp
80101f41:	89 e5                	mov    %esp,%ebp
80101f43:	56                   	push   %esi
80101f44:	89 c6                	mov    %eax,%esi
80101f46:	53                   	push   %ebx
80101f47:	83 ec 10             	sub    $0x10,%esp
80101f4a:	85 c0                	test   %eax,%eax
80101f4c:	0f 84 99 00 00 00    	je     80101feb <idestart+0xab>
80101f52:	8b 48 08             	mov    0x8(%eax),%ecx
80101f55:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f5b:	0f 87 7e 00 00 00    	ja     80101fdf <idestart+0x9f>
80101f61:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f66:	66 90                	xchg   %ax,%ax
80101f68:	ec                   	in     (%dx),%al
80101f69:	83 e0 c0             	and    $0xffffffc0,%eax
80101f6c:	3c 40                	cmp    $0x40,%al
80101f6e:	75 f8                	jne    80101f68 <idestart+0x28>
80101f70:	31 db                	xor    %ebx,%ebx
80101f72:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f77:	89 d8                	mov    %ebx,%eax
80101f79:	ee                   	out    %al,(%dx)
80101f7a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f7f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f84:	ee                   	out    %al,(%dx)
80101f85:	0f b6 c1             	movzbl %cl,%eax
80101f88:	b2 f3                	mov    $0xf3,%dl
80101f8a:	ee                   	out    %al,(%dx)
80101f8b:	89 c8                	mov    %ecx,%eax
80101f8d:	b2 f4                	mov    $0xf4,%dl
80101f8f:	c1 f8 08             	sar    $0x8,%eax
80101f92:	ee                   	out    %al,(%dx)
80101f93:	b2 f5                	mov    $0xf5,%dl
80101f95:	89 d8                	mov    %ebx,%eax
80101f97:	ee                   	out    %al,(%dx)
80101f98:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f9c:	b2 f6                	mov    $0xf6,%dl
80101f9e:	83 e0 01             	and    $0x1,%eax
80101fa1:	c1 e0 04             	shl    $0x4,%eax
80101fa4:	83 c8 e0             	or     $0xffffffe0,%eax
80101fa7:	ee                   	out    %al,(%dx)
80101fa8:	f6 06 04             	testb  $0x4,(%esi)
80101fab:	75 13                	jne    80101fc0 <idestart+0x80>
80101fad:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fb2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fb7:	ee                   	out    %al,(%dx)
80101fb8:	83 c4 10             	add    $0x10,%esp
80101fbb:	5b                   	pop    %ebx
80101fbc:	5e                   	pop    %esi
80101fbd:	5d                   	pop    %ebp
80101fbe:	c3                   	ret    
80101fbf:	90                   	nop
80101fc0:	b2 f7                	mov    $0xf7,%dl
80101fc2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fc7:	ee                   	out    %al,(%dx)
80101fc8:	b9 80 00 00 00       	mov    $0x80,%ecx
80101fcd:	83 c6 5c             	add    $0x5c,%esi
80101fd0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fd5:	fc                   	cld    
80101fd6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80101fd8:	83 c4 10             	add    $0x10,%esp
80101fdb:	5b                   	pop    %ebx
80101fdc:	5e                   	pop    %esi
80101fdd:	5d                   	pop    %ebp
80101fde:	c3                   	ret    
80101fdf:	c7 04 24 54 6f 10 80 	movl   $0x80106f54,(%esp)
80101fe6:	e8 75 e3 ff ff       	call   80100360 <panic>
80101feb:	c7 04 24 4b 6f 10 80 	movl   $0x80106f4b,(%esp)
80101ff2:	e8 69 e3 ff ff       	call   80100360 <panic>
80101ff7:	89 f6                	mov    %esi,%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102000 <ideinit>:
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	83 ec 18             	sub    $0x18,%esp
80102006:	c7 44 24 04 66 6f 10 	movl   $0x80106f66,0x4(%esp)
8010200d:	80 
8010200e:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102015:	e8 76 21 00 00       	call   80104190 <initlock>
8010201a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010201f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102026:	83 e8 01             	sub    $0x1,%eax
80102029:	89 44 24 04          	mov    %eax,0x4(%esp)
8010202d:	e8 7e 02 00 00       	call   801022b0 <ioapicenable>
80102032:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102037:	90                   	nop
80102038:	ec                   	in     (%dx),%al
80102039:	83 e0 c0             	and    $0xffffffc0,%eax
8010203c:	3c 40                	cmp    $0x40,%al
8010203e:	75 f8                	jne    80102038 <ideinit+0x38>
80102040:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102045:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010204a:	ee                   	out    %al,(%dx)
8010204b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102050:	b2 f7                	mov    $0xf7,%dl
80102052:	eb 09                	jmp    8010205d <ideinit+0x5d>
80102054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102058:	83 e9 01             	sub    $0x1,%ecx
8010205b:	74 0f                	je     8010206c <ideinit+0x6c>
8010205d:	ec                   	in     (%dx),%al
8010205e:	84 c0                	test   %al,%al
80102060:	74 f6                	je     80102058 <ideinit+0x58>
80102062:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102069:	00 00 00 
8010206c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102071:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102076:	ee                   	out    %al,(%dx)
80102077:	c9                   	leave  
80102078:	c3                   	ret    
80102079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102080 <ideintr>:
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 1c             	sub    $0x1c,%esp
80102089:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102090:	e8 6b 22 00 00       	call   80104300 <acquire>
80102095:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
8010209b:	85 db                	test   %ebx,%ebx
8010209d:	74 30                	je     801020cf <ideintr+0x4f>
8010209f:	8b 43 58             	mov    0x58(%ebx),%eax
801020a2:	a3 64 a5 10 80       	mov    %eax,0x8010a564
801020a7:	8b 33                	mov    (%ebx),%esi
801020a9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020af:	74 37                	je     801020e8 <ideintr+0x68>
801020b1:	83 e6 fb             	and    $0xfffffffb,%esi
801020b4:	83 ce 02             	or     $0x2,%esi
801020b7:	89 33                	mov    %esi,(%ebx)
801020b9:	89 1c 24             	mov    %ebx,(%esp)
801020bc:	e8 ef 1d 00 00       	call   80103eb0 <wakeup>
801020c1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020c6:	85 c0                	test   %eax,%eax
801020c8:	74 05                	je     801020cf <ideintr+0x4f>
801020ca:	e8 71 fe ff ff       	call   80101f40 <idestart>
801020cf:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020d6:	e8 95 22 00 00       	call   80104370 <release>
801020db:	83 c4 1c             	add    $0x1c,%esp
801020de:	5b                   	pop    %ebx
801020df:	5e                   	pop    %esi
801020e0:	5f                   	pop    %edi
801020e1:	5d                   	pop    %ebp
801020e2:	c3                   	ret    
801020e3:	90                   	nop
801020e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020e8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020ed:	8d 76 00             	lea    0x0(%esi),%esi
801020f0:	ec                   	in     (%dx),%al
801020f1:	89 c1                	mov    %eax,%ecx
801020f3:	83 e1 c0             	and    $0xffffffc0,%ecx
801020f6:	80 f9 40             	cmp    $0x40,%cl
801020f9:	75 f5                	jne    801020f0 <ideintr+0x70>
801020fb:	a8 21                	test   $0x21,%al
801020fd:	75 b2                	jne    801020b1 <ideintr+0x31>
801020ff:	8d 7b 5c             	lea    0x5c(%ebx),%edi
80102102:	b9 80 00 00 00       	mov    $0x80,%ecx
80102107:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010210c:	fc                   	cld    
8010210d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010210f:	8b 33                	mov    (%ebx),%esi
80102111:	eb 9e                	jmp    801020b1 <ideintr+0x31>
80102113:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102120 <iderw>:
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	53                   	push   %ebx
80102124:	83 ec 14             	sub    $0x14,%esp
80102127:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010212a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010212d:	89 04 24             	mov    %eax,(%esp)
80102130:	e8 0b 20 00 00       	call   80104140 <holdingsleep>
80102135:	85 c0                	test   %eax,%eax
80102137:	0f 84 9e 00 00 00    	je     801021db <iderw+0xbb>
8010213d:	8b 03                	mov    (%ebx),%eax
8010213f:	83 e0 06             	and    $0x6,%eax
80102142:	83 f8 02             	cmp    $0x2,%eax
80102145:	0f 84 a8 00 00 00    	je     801021f3 <iderw+0xd3>
8010214b:	8b 53 04             	mov    0x4(%ebx),%edx
8010214e:	85 d2                	test   %edx,%edx
80102150:	74 0d                	je     8010215f <iderw+0x3f>
80102152:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102157:	85 c0                	test   %eax,%eax
80102159:	0f 84 88 00 00 00    	je     801021e7 <iderw+0xc7>
8010215f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102166:	e8 95 21 00 00       	call   80104300 <acquire>
8010216b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102170:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
80102177:	85 c0                	test   %eax,%eax
80102179:	75 07                	jne    80102182 <iderw+0x62>
8010217b:	eb 4e                	jmp    801021cb <iderw+0xab>
8010217d:	8d 76 00             	lea    0x0(%esi),%esi
80102180:	89 d0                	mov    %edx,%eax
80102182:	8b 50 58             	mov    0x58(%eax),%edx
80102185:	85 d2                	test   %edx,%edx
80102187:	75 f7                	jne    80102180 <iderw+0x60>
80102189:	83 c0 58             	add    $0x58,%eax
8010218c:	89 18                	mov    %ebx,(%eax)
8010218e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80102194:	74 3c                	je     801021d2 <iderw+0xb2>
80102196:	8b 03                	mov    (%ebx),%eax
80102198:	83 e0 06             	and    $0x6,%eax
8010219b:	83 f8 02             	cmp    $0x2,%eax
8010219e:	74 1a                	je     801021ba <iderw+0x9a>
801021a0:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
801021a7:	80 
801021a8:	89 1c 24             	mov    %ebx,(%esp)
801021ab:	e8 70 1b 00 00       	call   80103d20 <sleep>
801021b0:	8b 13                	mov    (%ebx),%edx
801021b2:	83 e2 06             	and    $0x6,%edx
801021b5:	83 fa 02             	cmp    $0x2,%edx
801021b8:	75 e6                	jne    801021a0 <iderw+0x80>
801021ba:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
801021c1:	83 c4 14             	add    $0x14,%esp
801021c4:	5b                   	pop    %ebx
801021c5:	5d                   	pop    %ebp
801021c6:	e9 a5 21 00 00       	jmp    80104370 <release>
801021cb:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021d0:	eb ba                	jmp    8010218c <iderw+0x6c>
801021d2:	89 d8                	mov    %ebx,%eax
801021d4:	e8 67 fd ff ff       	call   80101f40 <idestart>
801021d9:	eb bb                	jmp    80102196 <iderw+0x76>
801021db:	c7 04 24 6a 6f 10 80 	movl   $0x80106f6a,(%esp)
801021e2:	e8 79 e1 ff ff       	call   80100360 <panic>
801021e7:	c7 04 24 95 6f 10 80 	movl   $0x80106f95,(%esp)
801021ee:	e8 6d e1 ff ff       	call   80100360 <panic>
801021f3:	c7 04 24 80 6f 10 80 	movl   $0x80106f80,(%esp)
801021fa:	e8 61 e1 ff ff       	call   80100360 <panic>
801021ff:	90                   	nop

80102200 <ioapicinit>:
80102200:	55                   	push   %ebp
80102201:	89 e5                	mov    %esp,%ebp
80102203:	56                   	push   %esi
80102204:	53                   	push   %ebx
80102205:	83 ec 10             	sub    $0x10,%esp
80102208:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010220f:	00 c0 fe 
80102212:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102219:	00 00 00 
8010221c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102222:	8b 42 10             	mov    0x10(%edx),%eax
80102225:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
8010222b:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102231:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
80102238:	c1 e8 10             	shr    $0x10,%eax
8010223b:	0f b6 f0             	movzbl %al,%esi
8010223e:	8b 43 10             	mov    0x10(%ebx),%eax
80102241:	c1 e8 18             	shr    $0x18,%eax
80102244:	39 c2                	cmp    %eax,%edx
80102246:	74 12                	je     8010225a <ioapicinit+0x5a>
80102248:	c7 04 24 b4 6f 10 80 	movl   $0x80106fb4,(%esp)
8010224f:	e8 fc e3 ff ff       	call   80100650 <cprintf>
80102254:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010225a:	ba 10 00 00 00       	mov    $0x10,%edx
8010225f:	31 c0                	xor    %eax,%eax
80102261:	eb 07                	jmp    8010226a <ioapicinit+0x6a>
80102263:	90                   	nop
80102264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102268:	89 cb                	mov    %ecx,%ebx
8010226a:	89 13                	mov    %edx,(%ebx)
8010226c:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102272:	8d 48 20             	lea    0x20(%eax),%ecx
80102275:	81 c9 00 00 01 00    	or     $0x10000,%ecx
8010227b:	83 c0 01             	add    $0x1,%eax
8010227e:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102281:	8d 4a 01             	lea    0x1(%edx),%ecx
80102284:	83 c2 02             	add    $0x2,%edx
80102287:	89 0b                	mov    %ecx,(%ebx)
80102289:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010228f:	39 c6                	cmp    %eax,%esi
80102291:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
80102298:	7d ce                	jge    80102268 <ioapicinit+0x68>
8010229a:	83 c4 10             	add    $0x10,%esp
8010229d:	5b                   	pop    %ebx
8010229e:	5e                   	pop    %esi
8010229f:	5d                   	pop    %ebp
801022a0:	c3                   	ret    
801022a1:	eb 0d                	jmp    801022b0 <ioapicenable>
801022a3:	90                   	nop
801022a4:	90                   	nop
801022a5:	90                   	nop
801022a6:	90                   	nop
801022a7:	90                   	nop
801022a8:	90                   	nop
801022a9:	90                   	nop
801022aa:	90                   	nop
801022ab:	90                   	nop
801022ac:	90                   	nop
801022ad:	90                   	nop
801022ae:	90                   	nop
801022af:	90                   	nop

801022b0 <ioapicenable>:
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	8b 55 08             	mov    0x8(%ebp),%edx
801022b6:	53                   	push   %ebx
801022b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801022ba:	8d 5a 20             	lea    0x20(%edx),%ebx
801022bd:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
801022c1:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801022c7:	c1 e0 18             	shl    $0x18,%eax
801022ca:	89 0a                	mov    %ecx,(%edx)
801022cc:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801022d2:	83 c1 01             	add    $0x1,%ecx
801022d5:	89 5a 10             	mov    %ebx,0x10(%edx)
801022d8:	89 0a                	mov    %ecx,(%edx)
801022da:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801022e0:	89 42 10             	mov    %eax,0x10(%edx)
801022e3:	5b                   	pop    %ebx
801022e4:	5d                   	pop    %ebp
801022e5:	c3                   	ret    
801022e6:	66 90                	xchg   %ax,%ax
801022e8:	66 90                	xchg   %ax,%ax
801022ea:	66 90                	xchg   %ax,%ax
801022ec:	66 90                	xchg   %ax,%ax
801022ee:	66 90                	xchg   %ax,%ax

801022f0 <kfree>:
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	53                   	push   %ebx
801022f4:	83 ec 14             	sub    $0x14,%esp
801022f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801022fa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102300:	75 7c                	jne    8010237e <kfree+0x8e>
80102302:	81 fb a8 55 11 80    	cmp    $0x801155a8,%ebx
80102308:	72 74                	jb     8010237e <kfree+0x8e>
8010230a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102310:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102315:	77 67                	ja     8010237e <kfree+0x8e>
80102317:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010231e:	00 
8010231f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102326:	00 
80102327:	89 1c 24             	mov    %ebx,(%esp)
8010232a:	e8 91 20 00 00       	call   801043c0 <memset>
8010232f:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102335:	85 d2                	test   %edx,%edx
80102337:	75 37                	jne    80102370 <kfree+0x80>
80102339:	a1 78 26 11 80       	mov    0x80112678,%eax
8010233e:	89 03                	mov    %eax,(%ebx)
80102340:	a1 74 26 11 80       	mov    0x80112674,%eax
80102345:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
8010234b:	85 c0                	test   %eax,%eax
8010234d:	75 09                	jne    80102358 <kfree+0x68>
8010234f:	83 c4 14             	add    $0x14,%esp
80102352:	5b                   	pop    %ebx
80102353:	5d                   	pop    %ebp
80102354:	c3                   	ret    
80102355:	8d 76 00             	lea    0x0(%esi),%esi
80102358:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
8010235f:	83 c4 14             	add    $0x14,%esp
80102362:	5b                   	pop    %ebx
80102363:	5d                   	pop    %ebp
80102364:	e9 07 20 00 00       	jmp    80104370 <release>
80102369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102370:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102377:	e8 84 1f 00 00       	call   80104300 <acquire>
8010237c:	eb bb                	jmp    80102339 <kfree+0x49>
8010237e:	c7 04 24 e6 6f 10 80 	movl   $0x80106fe6,(%esp)
80102385:	e8 d6 df ff ff       	call   80100360 <panic>
8010238a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102390 <freerange>:
80102390:	55                   	push   %ebp
80102391:	89 e5                	mov    %esp,%ebp
80102393:	56                   	push   %esi
80102394:	53                   	push   %ebx
80102395:	83 ec 10             	sub    $0x10,%esp
80102398:	8b 45 08             	mov    0x8(%ebp),%eax
8010239b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010239e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023a4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801023aa:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023b0:	39 de                	cmp    %ebx,%esi
801023b2:	73 08                	jae    801023bc <freerange+0x2c>
801023b4:	eb 18                	jmp    801023ce <freerange+0x3e>
801023b6:	66 90                	xchg   %ax,%ax
801023b8:	89 da                	mov    %ebx,%edx
801023ba:	89 c3                	mov    %eax,%ebx
801023bc:	89 14 24             	mov    %edx,(%esp)
801023bf:	e8 2c ff ff ff       	call   801022f0 <kfree>
801023c4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023ca:	39 f0                	cmp    %esi,%eax
801023cc:	76 ea                	jbe    801023b8 <freerange+0x28>
801023ce:	83 c4 10             	add    $0x10,%esp
801023d1:	5b                   	pop    %ebx
801023d2:	5e                   	pop    %esi
801023d3:	5d                   	pop    %ebp
801023d4:	c3                   	ret    
801023d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023e0 <kinit1>:
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	56                   	push   %esi
801023e4:	53                   	push   %ebx
801023e5:	83 ec 10             	sub    $0x10,%esp
801023e8:	8b 75 0c             	mov    0xc(%ebp),%esi
801023eb:	c7 44 24 04 ec 6f 10 	movl   $0x80106fec,0x4(%esp)
801023f2:	80 
801023f3:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801023fa:	e8 91 1d 00 00       	call   80104190 <initlock>
801023ff:	8b 45 08             	mov    0x8(%ebp),%eax
80102402:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102409:	00 00 00 
8010240c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102412:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80102418:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010241e:	39 de                	cmp    %ebx,%esi
80102420:	73 0a                	jae    8010242c <kinit1+0x4c>
80102422:	eb 1a                	jmp    8010243e <kinit1+0x5e>
80102424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102428:	89 da                	mov    %ebx,%edx
8010242a:	89 c3                	mov    %eax,%ebx
8010242c:	89 14 24             	mov    %edx,(%esp)
8010242f:	e8 bc fe ff ff       	call   801022f0 <kfree>
80102434:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010243a:	39 c6                	cmp    %eax,%esi
8010243c:	73 ea                	jae    80102428 <kinit1+0x48>
8010243e:	83 c4 10             	add    $0x10,%esp
80102441:	5b                   	pop    %ebx
80102442:	5e                   	pop    %esi
80102443:	5d                   	pop    %ebp
80102444:	c3                   	ret    
80102445:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102450 <kinit2>:
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	56                   	push   %esi
80102454:	53                   	push   %ebx
80102455:	83 ec 10             	sub    $0x10,%esp
80102458:	8b 45 08             	mov    0x8(%ebp),%eax
8010245b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010245e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102464:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
8010246a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102470:	39 de                	cmp    %ebx,%esi
80102472:	73 08                	jae    8010247c <kinit2+0x2c>
80102474:	eb 18                	jmp    8010248e <kinit2+0x3e>
80102476:	66 90                	xchg   %ax,%ax
80102478:	89 da                	mov    %ebx,%edx
8010247a:	89 c3                	mov    %eax,%ebx
8010247c:	89 14 24             	mov    %edx,(%esp)
8010247f:	e8 6c fe ff ff       	call   801022f0 <kfree>
80102484:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010248a:	39 c6                	cmp    %eax,%esi
8010248c:	73 ea                	jae    80102478 <kinit2+0x28>
8010248e:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102495:	00 00 00 
80102498:	83 c4 10             	add    $0x10,%esp
8010249b:	5b                   	pop    %ebx
8010249c:	5e                   	pop    %esi
8010249d:	5d                   	pop    %ebp
8010249e:	c3                   	ret    
8010249f:	90                   	nop

801024a0 <kalloc>:
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	53                   	push   %ebx
801024a4:	83 ec 14             	sub    $0x14,%esp
801024a7:	a1 74 26 11 80       	mov    0x80112674,%eax
801024ac:	85 c0                	test   %eax,%eax
801024ae:	75 30                	jne    801024e0 <kalloc+0x40>
801024b0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
801024b6:	85 db                	test   %ebx,%ebx
801024b8:	74 08                	je     801024c2 <kalloc+0x22>
801024ba:	8b 13                	mov    (%ebx),%edx
801024bc:	89 15 78 26 11 80    	mov    %edx,0x80112678
801024c2:	85 c0                	test   %eax,%eax
801024c4:	74 0c                	je     801024d2 <kalloc+0x32>
801024c6:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024cd:	e8 9e 1e 00 00       	call   80104370 <release>
801024d2:	83 c4 14             	add    $0x14,%esp
801024d5:	89 d8                	mov    %ebx,%eax
801024d7:	5b                   	pop    %ebx
801024d8:	5d                   	pop    %ebp
801024d9:	c3                   	ret    
801024da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801024e0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024e7:	e8 14 1e 00 00       	call   80104300 <acquire>
801024ec:	a1 74 26 11 80       	mov    0x80112674,%eax
801024f1:	eb bd                	jmp    801024b0 <kalloc+0x10>
801024f3:	66 90                	xchg   %ax,%ax
801024f5:	66 90                	xchg   %ax,%ax
801024f7:	66 90                	xchg   %ax,%ax
801024f9:	66 90                	xchg   %ax,%ax
801024fb:	66 90                	xchg   %ax,%ax
801024fd:	66 90                	xchg   %ax,%ax
801024ff:	90                   	nop

80102500 <kbdgetc>:
80102500:	ba 64 00 00 00       	mov    $0x64,%edx
80102505:	ec                   	in     (%dx),%al
80102506:	a8 01                	test   $0x1,%al
80102508:	0f 84 ba 00 00 00    	je     801025c8 <kbdgetc+0xc8>
8010250e:	b2 60                	mov    $0x60,%dl
80102510:	ec                   	in     (%dx),%al
80102511:	0f b6 c8             	movzbl %al,%ecx
80102514:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010251a:	0f 84 88 00 00 00    	je     801025a8 <kbdgetc+0xa8>
80102520:	84 c0                	test   %al,%al
80102522:	79 2c                	jns    80102550 <kbdgetc+0x50>
80102524:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010252a:	f6 c2 40             	test   $0x40,%dl
8010252d:	75 05                	jne    80102534 <kbdgetc+0x34>
8010252f:	89 c1                	mov    %eax,%ecx
80102531:	83 e1 7f             	and    $0x7f,%ecx
80102534:	0f b6 81 20 71 10 80 	movzbl -0x7fef8ee0(%ecx),%eax
8010253b:	83 c8 40             	or     $0x40,%eax
8010253e:	0f b6 c0             	movzbl %al,%eax
80102541:	f7 d0                	not    %eax
80102543:	21 d0                	and    %edx,%eax
80102545:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
8010254a:	31 c0                	xor    %eax,%eax
8010254c:	c3                   	ret    
8010254d:	8d 76 00             	lea    0x0(%esi),%esi
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	53                   	push   %ebx
80102554:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
8010255a:	f6 c3 40             	test   $0x40,%bl
8010255d:	74 09                	je     80102568 <kbdgetc+0x68>
8010255f:	83 c8 80             	or     $0xffffff80,%eax
80102562:	83 e3 bf             	and    $0xffffffbf,%ebx
80102565:	0f b6 c8             	movzbl %al,%ecx
80102568:	0f b6 91 20 71 10 80 	movzbl -0x7fef8ee0(%ecx),%edx
8010256f:	0f b6 81 20 70 10 80 	movzbl -0x7fef8fe0(%ecx),%eax
80102576:	09 da                	or     %ebx,%edx
80102578:	31 c2                	xor    %eax,%edx
8010257a:	89 d0                	mov    %edx,%eax
8010257c:	83 e0 03             	and    $0x3,%eax
8010257f:	8b 04 85 00 70 10 80 	mov    -0x7fef9000(,%eax,4),%eax
80102586:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
8010258c:	83 e2 08             	and    $0x8,%edx
8010258f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
80102593:	74 0b                	je     801025a0 <kbdgetc+0xa0>
80102595:	8d 50 9f             	lea    -0x61(%eax),%edx
80102598:	83 fa 19             	cmp    $0x19,%edx
8010259b:	77 1b                	ja     801025b8 <kbdgetc+0xb8>
8010259d:	83 e8 20             	sub    $0x20,%eax
801025a0:	5b                   	pop    %ebx
801025a1:	5d                   	pop    %ebp
801025a2:	c3                   	ret    
801025a3:	90                   	nop
801025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025a8:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
801025af:	31 c0                	xor    %eax,%eax
801025b1:	c3                   	ret    
801025b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801025b8:	8d 48 bf             	lea    -0x41(%eax),%ecx
801025bb:	8d 50 20             	lea    0x20(%eax),%edx
801025be:	83 f9 19             	cmp    $0x19,%ecx
801025c1:	0f 46 c2             	cmovbe %edx,%eax
801025c4:	eb da                	jmp    801025a0 <kbdgetc+0xa0>
801025c6:	66 90                	xchg   %ax,%ax
801025c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025cd:	c3                   	ret    
801025ce:	66 90                	xchg   %ax,%ax

801025d0 <kbdintr>:
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	83 ec 18             	sub    $0x18,%esp
801025d6:	c7 04 24 00 25 10 80 	movl   $0x80102500,(%esp)
801025dd:	e8 ce e1 ff ff       	call   801007b0 <consoleintr>
801025e2:	c9                   	leave  
801025e3:	c3                   	ret    
801025e4:	66 90                	xchg   %ax,%ax
801025e6:	66 90                	xchg   %ax,%ax
801025e8:	66 90                	xchg   %ax,%ax
801025ea:	66 90                	xchg   %ax,%ax
801025ec:	66 90                	xchg   %ax,%ax
801025ee:	66 90                	xchg   %ax,%ax

801025f0 <fill_rtcdate>:
801025f0:	55                   	push   %ebp
801025f1:	89 c1                	mov    %eax,%ecx
801025f3:	89 e5                	mov    %esp,%ebp
801025f5:	ba 70 00 00 00       	mov    $0x70,%edx
801025fa:	53                   	push   %ebx
801025fb:	31 c0                	xor    %eax,%eax
801025fd:	ee                   	out    %al,(%dx)
801025fe:	bb 71 00 00 00       	mov    $0x71,%ebx
80102603:	89 da                	mov    %ebx,%edx
80102605:	ec                   	in     (%dx),%al
80102606:	0f b6 c0             	movzbl %al,%eax
80102609:	b2 70                	mov    $0x70,%dl
8010260b:	89 01                	mov    %eax,(%ecx)
8010260d:	b8 02 00 00 00       	mov    $0x2,%eax
80102612:	ee                   	out    %al,(%dx)
80102613:	89 da                	mov    %ebx,%edx
80102615:	ec                   	in     (%dx),%al
80102616:	0f b6 c0             	movzbl %al,%eax
80102619:	b2 70                	mov    $0x70,%dl
8010261b:	89 41 04             	mov    %eax,0x4(%ecx)
8010261e:	b8 04 00 00 00       	mov    $0x4,%eax
80102623:	ee                   	out    %al,(%dx)
80102624:	89 da                	mov    %ebx,%edx
80102626:	ec                   	in     (%dx),%al
80102627:	0f b6 c0             	movzbl %al,%eax
8010262a:	b2 70                	mov    $0x70,%dl
8010262c:	89 41 08             	mov    %eax,0x8(%ecx)
8010262f:	b8 07 00 00 00       	mov    $0x7,%eax
80102634:	ee                   	out    %al,(%dx)
80102635:	89 da                	mov    %ebx,%edx
80102637:	ec                   	in     (%dx),%al
80102638:	0f b6 c0             	movzbl %al,%eax
8010263b:	b2 70                	mov    $0x70,%dl
8010263d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102640:	b8 08 00 00 00       	mov    $0x8,%eax
80102645:	ee                   	out    %al,(%dx)
80102646:	89 da                	mov    %ebx,%edx
80102648:	ec                   	in     (%dx),%al
80102649:	0f b6 c0             	movzbl %al,%eax
8010264c:	b2 70                	mov    $0x70,%dl
8010264e:	89 41 10             	mov    %eax,0x10(%ecx)
80102651:	b8 09 00 00 00       	mov    $0x9,%eax
80102656:	ee                   	out    %al,(%dx)
80102657:	89 da                	mov    %ebx,%edx
80102659:	ec                   	in     (%dx),%al
8010265a:	0f b6 d8             	movzbl %al,%ebx
8010265d:	89 59 14             	mov    %ebx,0x14(%ecx)
80102660:	5b                   	pop    %ebx
80102661:	5d                   	pop    %ebp
80102662:	c3                   	ret    
80102663:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102670 <lapicinit>:
80102670:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102675:	55                   	push   %ebp
80102676:	89 e5                	mov    %esp,%ebp
80102678:	85 c0                	test   %eax,%eax
8010267a:	0f 84 c0 00 00 00    	je     80102740 <lapicinit+0xd0>
80102680:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102687:	01 00 00 
8010268a:	8b 50 20             	mov    0x20(%eax),%edx
8010268d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102694:	00 00 00 
80102697:	8b 50 20             	mov    0x20(%eax),%edx
8010269a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026a1:	00 02 00 
801026a4:	8b 50 20             	mov    0x20(%eax),%edx
801026a7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026ae:	96 98 00 
801026b1:	8b 50 20             	mov    0x20(%eax),%edx
801026b4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026bb:	00 01 00 
801026be:	8b 50 20             	mov    0x20(%eax),%edx
801026c1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026c8:	00 01 00 
801026cb:	8b 50 20             	mov    0x20(%eax),%edx
801026ce:	8b 50 30             	mov    0x30(%eax),%edx
801026d1:	c1 ea 10             	shr    $0x10,%edx
801026d4:	80 fa 03             	cmp    $0x3,%dl
801026d7:	77 6f                	ja     80102748 <lapicinit+0xd8>
801026d9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026e0:	00 00 00 
801026e3:	8b 50 20             	mov    0x20(%eax),%edx
801026e6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ed:	00 00 00 
801026f0:	8b 50 20             	mov    0x20(%eax),%edx
801026f3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026fa:	00 00 00 
801026fd:	8b 50 20             	mov    0x20(%eax),%edx
80102700:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102707:	00 00 00 
8010270a:	8b 50 20             	mov    0x20(%eax),%edx
8010270d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102714:	00 00 00 
80102717:	8b 50 20             	mov    0x20(%eax),%edx
8010271a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102721:	85 08 00 
80102724:	8b 50 20             	mov    0x20(%eax),%edx
80102727:	90                   	nop
80102728:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010272e:	80 e6 10             	and    $0x10,%dh
80102731:	75 f5                	jne    80102728 <lapicinit+0xb8>
80102733:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010273a:	00 00 00 
8010273d:	8b 40 20             	mov    0x20(%eax),%eax
80102740:	5d                   	pop    %ebp
80102741:	c3                   	ret    
80102742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102748:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010274f:	00 01 00 
80102752:	8b 50 20             	mov    0x20(%eax),%edx
80102755:	eb 82                	jmp    801026d9 <lapicinit+0x69>
80102757:	89 f6                	mov    %esi,%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102760 <lapicid>:
80102760:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102765:	55                   	push   %ebp
80102766:	89 e5                	mov    %esp,%ebp
80102768:	85 c0                	test   %eax,%eax
8010276a:	74 0c                	je     80102778 <lapicid+0x18>
8010276c:	8b 40 20             	mov    0x20(%eax),%eax
8010276f:	5d                   	pop    %ebp
80102770:	c1 e8 18             	shr    $0x18,%eax
80102773:	c3                   	ret    
80102774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102778:	31 c0                	xor    %eax,%eax
8010277a:	5d                   	pop    %ebp
8010277b:	c3                   	ret    
8010277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102780 <lapiceoi>:
80102780:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102785:	55                   	push   %ebp
80102786:	89 e5                	mov    %esp,%ebp
80102788:	85 c0                	test   %eax,%eax
8010278a:	74 0d                	je     80102799 <lapiceoi+0x19>
8010278c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102793:	00 00 00 
80102796:	8b 40 20             	mov    0x20(%eax),%eax
80102799:	5d                   	pop    %ebp
8010279a:	c3                   	ret    
8010279b:	90                   	nop
8010279c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027a0 <microdelay>:
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
801027a3:	5d                   	pop    %ebp
801027a4:	c3                   	ret    
801027a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027b0 <lapicstartap>:
801027b0:	55                   	push   %ebp
801027b1:	ba 70 00 00 00       	mov    $0x70,%edx
801027b6:	89 e5                	mov    %esp,%ebp
801027b8:	b8 0f 00 00 00       	mov    $0xf,%eax
801027bd:	53                   	push   %ebx
801027be:	8b 4d 08             	mov    0x8(%ebp),%ecx
801027c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801027c4:	ee                   	out    %al,(%dx)
801027c5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027ca:	b2 71                	mov    $0x71,%dl
801027cc:	ee                   	out    %al,(%dx)
801027cd:	31 c0                	xor    %eax,%eax
801027cf:	66 a3 67 04 00 80    	mov    %ax,0x80000467
801027d5:	89 d8                	mov    %ebx,%eax
801027d7:	c1 e8 04             	shr    $0x4,%eax
801027da:	66 a3 69 04 00 80    	mov    %ax,0x80000469
801027e0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801027e5:	c1 e1 18             	shl    $0x18,%ecx
801027e8:	c1 eb 0c             	shr    $0xc,%ebx
801027eb:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
801027f1:	8b 50 20             	mov    0x20(%eax),%edx
801027f4:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027fb:	c5 00 00 
801027fe:	8b 50 20             	mov    0x20(%eax),%edx
80102801:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102808:	85 00 00 
8010280b:	8b 50 20             	mov    0x20(%eax),%edx
8010280e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
80102814:	8b 50 20             	mov    0x20(%eax),%edx
80102817:	89 da                	mov    %ebx,%edx
80102819:	80 ce 06             	or     $0x6,%dh
8010281c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
80102822:	8b 58 20             	mov    0x20(%eax),%ebx
80102825:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
8010282b:	8b 48 20             	mov    0x20(%eax),%ecx
8010282e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
80102834:	8b 40 20             	mov    0x20(%eax),%eax
80102837:	5b                   	pop    %ebx
80102838:	5d                   	pop    %ebp
80102839:	c3                   	ret    
8010283a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102840 <cmostime>:
80102840:	55                   	push   %ebp
80102841:	ba 70 00 00 00       	mov    $0x70,%edx
80102846:	89 e5                	mov    %esp,%ebp
80102848:	b8 0b 00 00 00       	mov    $0xb,%eax
8010284d:	57                   	push   %edi
8010284e:	56                   	push   %esi
8010284f:	53                   	push   %ebx
80102850:	83 ec 4c             	sub    $0x4c,%esp
80102853:	ee                   	out    %al,(%dx)
80102854:	b2 71                	mov    $0x71,%dl
80102856:	ec                   	in     (%dx),%al
80102857:	88 45 b7             	mov    %al,-0x49(%ebp)
8010285a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
8010285d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102861:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102868:	be 70 00 00 00       	mov    $0x70,%esi
8010286d:	89 d8                	mov    %ebx,%eax
8010286f:	e8 7c fd ff ff       	call   801025f0 <fill_rtcdate>
80102874:	b8 0a 00 00 00       	mov    $0xa,%eax
80102879:	89 f2                	mov    %esi,%edx
8010287b:	ee                   	out    %al,(%dx)
8010287c:	ba 71 00 00 00       	mov    $0x71,%edx
80102881:	ec                   	in     (%dx),%al
80102882:	84 c0                	test   %al,%al
80102884:	78 e7                	js     8010286d <cmostime+0x2d>
80102886:	89 f8                	mov    %edi,%eax
80102888:	e8 63 fd ff ff       	call   801025f0 <fill_rtcdate>
8010288d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102894:	00 
80102895:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102899:	89 1c 24             	mov    %ebx,(%esp)
8010289c:	e8 6f 1b 00 00       	call   80104410 <memcmp>
801028a1:	85 c0                	test   %eax,%eax
801028a3:	75 c3                	jne    80102868 <cmostime+0x28>
801028a5:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028a9:	75 78                	jne    80102923 <cmostime+0xe3>
801028ab:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028ae:	89 c2                	mov    %eax,%edx
801028b0:	83 e0 0f             	and    $0xf,%eax
801028b3:	c1 ea 04             	shr    $0x4,%edx
801028b6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028b9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028bc:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028bf:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028c2:	89 c2                	mov    %eax,%edx
801028c4:	83 e0 0f             	and    $0xf,%eax
801028c7:	c1 ea 04             	shr    $0x4,%edx
801028ca:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028cd:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028d0:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801028d6:	89 c2                	mov    %eax,%edx
801028d8:	83 e0 0f             	and    $0xf,%eax
801028db:	c1 ea 04             	shr    $0x4,%edx
801028de:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028e1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028e4:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028e7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801028ea:	89 c2                	mov    %eax,%edx
801028ec:	83 e0 0f             	and    $0xf,%eax
801028ef:	c1 ea 04             	shr    $0x4,%edx
801028f2:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028f5:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028f8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028fb:	8b 45 c8             	mov    -0x38(%ebp),%eax
801028fe:	89 c2                	mov    %eax,%edx
80102900:	83 e0 0f             	and    $0xf,%eax
80102903:	c1 ea 04             	shr    $0x4,%edx
80102906:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102909:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010290c:	89 45 c8             	mov    %eax,-0x38(%ebp)
8010290f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102912:	89 c2                	mov    %eax,%edx
80102914:	83 e0 0f             	and    $0xf,%eax
80102917:	c1 ea 04             	shr    $0x4,%edx
8010291a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010291d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102920:	89 45 cc             	mov    %eax,-0x34(%ebp)
80102923:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102926:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102929:	89 01                	mov    %eax,(%ecx)
8010292b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010292e:	89 41 04             	mov    %eax,0x4(%ecx)
80102931:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102934:	89 41 08             	mov    %eax,0x8(%ecx)
80102937:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010293a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010293d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102940:	89 41 10             	mov    %eax,0x10(%ecx)
80102943:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102946:	89 41 14             	mov    %eax,0x14(%ecx)
80102949:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
80102950:	83 c4 4c             	add    $0x4c,%esp
80102953:	5b                   	pop    %ebx
80102954:	5e                   	pop    %esi
80102955:	5f                   	pop    %edi
80102956:	5d                   	pop    %ebp
80102957:	c3                   	ret    
80102958:	66 90                	xchg   %ax,%ax
8010295a:	66 90                	xchg   %ax,%ax
8010295c:	66 90                	xchg   %ax,%ax
8010295e:	66 90                	xchg   %ax,%ax

80102960 <install_trans>:
80102960:	55                   	push   %ebp
80102961:	89 e5                	mov    %esp,%ebp
80102963:	57                   	push   %edi
80102964:	56                   	push   %esi
80102965:	53                   	push   %ebx
80102966:	31 db                	xor    %ebx,%ebx
80102968:	83 ec 1c             	sub    $0x1c,%esp
8010296b:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102970:	85 c0                	test   %eax,%eax
80102972:	7e 78                	jle    801029ec <install_trans+0x8c>
80102974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102978:	a1 b4 26 11 80       	mov    0x801126b4,%eax
8010297d:	01 d8                	add    %ebx,%eax
8010297f:	83 c0 01             	add    $0x1,%eax
80102982:	89 44 24 04          	mov    %eax,0x4(%esp)
80102986:	a1 c4 26 11 80       	mov    0x801126c4,%eax
8010298b:	89 04 24             	mov    %eax,(%esp)
8010298e:	e8 3d d7 ff ff       	call   801000d0 <bread>
80102993:	89 c7                	mov    %eax,%edi
80102995:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
8010299c:	83 c3 01             	add    $0x1,%ebx
8010299f:	89 44 24 04          	mov    %eax,0x4(%esp)
801029a3:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029a8:	89 04 24             	mov    %eax,(%esp)
801029ab:	e8 20 d7 ff ff       	call   801000d0 <bread>
801029b0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801029b7:	00 
801029b8:	89 c6                	mov    %eax,%esi
801029ba:	8d 47 5c             	lea    0x5c(%edi),%eax
801029bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801029c1:	8d 46 5c             	lea    0x5c(%esi),%eax
801029c4:	89 04 24             	mov    %eax,(%esp)
801029c7:	e8 94 1a 00 00       	call   80104460 <memmove>
801029cc:	89 34 24             	mov    %esi,(%esp)
801029cf:	e8 cc d7 ff ff       	call   801001a0 <bwrite>
801029d4:	89 3c 24             	mov    %edi,(%esp)
801029d7:	e8 04 d8 ff ff       	call   801001e0 <brelse>
801029dc:	89 34 24             	mov    %esi,(%esp)
801029df:	e8 fc d7 ff ff       	call   801001e0 <brelse>
801029e4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
801029ea:	7f 8c                	jg     80102978 <install_trans+0x18>
801029ec:	83 c4 1c             	add    $0x1c,%esp
801029ef:	5b                   	pop    %ebx
801029f0:	5e                   	pop    %esi
801029f1:	5f                   	pop    %edi
801029f2:	5d                   	pop    %ebp
801029f3:	c3                   	ret    
801029f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801029fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a00 <write_head>:
80102a00:	55                   	push   %ebp
80102a01:	89 e5                	mov    %esp,%ebp
80102a03:	57                   	push   %edi
80102a04:	56                   	push   %esi
80102a05:	53                   	push   %ebx
80102a06:	83 ec 1c             	sub    $0x1c,%esp
80102a09:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a0e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a12:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a17:	89 04 24             	mov    %eax,(%esp)
80102a1a:	e8 b1 d6 ff ff       	call   801000d0 <bread>
80102a1f:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
80102a25:	31 d2                	xor    %edx,%edx
80102a27:	85 db                	test   %ebx,%ebx
80102a29:	89 c7                	mov    %eax,%edi
80102a2b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a2e:	8d 70 5c             	lea    0x5c(%eax),%esi
80102a31:	7e 17                	jle    80102a4a <write_head+0x4a>
80102a33:	90                   	nop
80102a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a38:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102a3f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
80102a43:	83 c2 01             	add    $0x1,%edx
80102a46:	39 da                	cmp    %ebx,%edx
80102a48:	75 ee                	jne    80102a38 <write_head+0x38>
80102a4a:	89 3c 24             	mov    %edi,(%esp)
80102a4d:	e8 4e d7 ff ff       	call   801001a0 <bwrite>
80102a52:	89 3c 24             	mov    %edi,(%esp)
80102a55:	e8 86 d7 ff ff       	call   801001e0 <brelse>
80102a5a:	83 c4 1c             	add    $0x1c,%esp
80102a5d:	5b                   	pop    %ebx
80102a5e:	5e                   	pop    %esi
80102a5f:	5f                   	pop    %edi
80102a60:	5d                   	pop    %ebp
80102a61:	c3                   	ret    
80102a62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a70 <initlog>:
80102a70:	55                   	push   %ebp
80102a71:	89 e5                	mov    %esp,%ebp
80102a73:	56                   	push   %esi
80102a74:	53                   	push   %ebx
80102a75:	83 ec 30             	sub    $0x30,%esp
80102a78:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a7b:	c7 44 24 04 20 72 10 	movl   $0x80107220,0x4(%esp)
80102a82:	80 
80102a83:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102a8a:	e8 01 17 00 00       	call   80104190 <initlock>
80102a8f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102a92:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a96:	89 1c 24             	mov    %ebx,(%esp)
80102a99:	e8 82 e9 ff ff       	call   80101420 <readsb>
80102a9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102aa1:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102aa4:	89 1c 24             	mov    %ebx,(%esp)
80102aa7:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
80102aad:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ab1:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
80102ab7:	a3 b4 26 11 80       	mov    %eax,0x801126b4
80102abc:	e8 0f d6 ff ff       	call   801000d0 <bread>
80102ac1:	31 d2                	xor    %edx,%edx
80102ac3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ac6:	8d 70 5c             	lea    0x5c(%eax),%esi
80102ac9:	85 db                	test   %ebx,%ebx
80102acb:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
80102ad1:	7e 17                	jle    80102aea <initlog+0x7a>
80102ad3:	90                   	nop
80102ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ad8:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102adc:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
80102ae3:	83 c2 01             	add    $0x1,%edx
80102ae6:	39 da                	cmp    %ebx,%edx
80102ae8:	75 ee                	jne    80102ad8 <initlog+0x68>
80102aea:	89 04 24             	mov    %eax,(%esp)
80102aed:	e8 ee d6 ff ff       	call   801001e0 <brelse>
80102af2:	e8 69 fe ff ff       	call   80102960 <install_trans>
80102af7:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102afe:	00 00 00 
80102b01:	e8 fa fe ff ff       	call   80102a00 <write_head>
80102b06:	83 c4 30             	add    $0x30,%esp
80102b09:	5b                   	pop    %ebx
80102b0a:	5e                   	pop    %esi
80102b0b:	5d                   	pop    %ebp
80102b0c:	c3                   	ret    
80102b0d:	8d 76 00             	lea    0x0(%esi),%esi

80102b10 <begin_op>:
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
80102b13:	83 ec 18             	sub    $0x18,%esp
80102b16:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b1d:	e8 de 17 00 00       	call   80104300 <acquire>
80102b22:	eb 18                	jmp    80102b3c <begin_op+0x2c>
80102b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b28:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102b2f:	80 
80102b30:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b37:	e8 e4 11 00 00       	call   80103d20 <sleep>
80102b3c:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b41:	85 c0                	test   %eax,%eax
80102b43:	75 e3                	jne    80102b28 <begin_op+0x18>
80102b45:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b4a:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b50:	83 c0 01             	add    $0x1,%eax
80102b53:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b56:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b59:	83 fa 1e             	cmp    $0x1e,%edx
80102b5c:	7f ca                	jg     80102b28 <begin_op+0x18>
80102b5e:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b65:	a3 bc 26 11 80       	mov    %eax,0x801126bc
80102b6a:	e8 01 18 00 00       	call   80104370 <release>
80102b6f:	c9                   	leave  
80102b70:	c3                   	ret    
80102b71:	eb 0d                	jmp    80102b80 <end_op>
80102b73:	90                   	nop
80102b74:	90                   	nop
80102b75:	90                   	nop
80102b76:	90                   	nop
80102b77:	90                   	nop
80102b78:	90                   	nop
80102b79:	90                   	nop
80102b7a:	90                   	nop
80102b7b:	90                   	nop
80102b7c:	90                   	nop
80102b7d:	90                   	nop
80102b7e:	90                   	nop
80102b7f:	90                   	nop

80102b80 <end_op>:
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	57                   	push   %edi
80102b84:	56                   	push   %esi
80102b85:	53                   	push   %ebx
80102b86:	83 ec 1c             	sub    $0x1c,%esp
80102b89:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b90:	e8 6b 17 00 00       	call   80104300 <acquire>
80102b95:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b9a:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
80102ba0:	83 e8 01             	sub    $0x1,%eax
80102ba3:	85 d2                	test   %edx,%edx
80102ba5:	a3 bc 26 11 80       	mov    %eax,0x801126bc
80102baa:	0f 85 f3 00 00 00    	jne    80102ca3 <end_op+0x123>
80102bb0:	85 c0                	test   %eax,%eax
80102bb2:	0f 85 cb 00 00 00    	jne    80102c83 <end_op+0x103>
80102bb8:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102bbf:	31 db                	xor    %ebx,%ebx
80102bc1:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102bc8:	00 00 00 
80102bcb:	e8 a0 17 00 00       	call   80104370 <release>
80102bd0:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102bd5:	85 c0                	test   %eax,%eax
80102bd7:	0f 8e 90 00 00 00    	jle    80102c6d <end_op+0xed>
80102bdd:	8d 76 00             	lea    0x0(%esi),%esi
80102be0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102be5:	01 d8                	add    %ebx,%eax
80102be7:	83 c0 01             	add    $0x1,%eax
80102bea:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bee:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102bf3:	89 04 24             	mov    %eax,(%esp)
80102bf6:	e8 d5 d4 ff ff       	call   801000d0 <bread>
80102bfb:	89 c6                	mov    %eax,%esi
80102bfd:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
80102c04:	83 c3 01             	add    $0x1,%ebx
80102c07:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c0b:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c10:	89 04 24             	mov    %eax,(%esp)
80102c13:	e8 b8 d4 ff ff       	call   801000d0 <bread>
80102c18:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c1f:	00 
80102c20:	89 c7                	mov    %eax,%edi
80102c22:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c25:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c29:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c2c:	89 04 24             	mov    %eax,(%esp)
80102c2f:	e8 2c 18 00 00       	call   80104460 <memmove>
80102c34:	89 34 24             	mov    %esi,(%esp)
80102c37:	e8 64 d5 ff ff       	call   801001a0 <bwrite>
80102c3c:	89 3c 24             	mov    %edi,(%esp)
80102c3f:	e8 9c d5 ff ff       	call   801001e0 <brelse>
80102c44:	89 34 24             	mov    %esi,(%esp)
80102c47:	e8 94 d5 ff ff       	call   801001e0 <brelse>
80102c4c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c52:	7c 8c                	jl     80102be0 <end_op+0x60>
80102c54:	e8 a7 fd ff ff       	call   80102a00 <write_head>
80102c59:	e8 02 fd ff ff       	call   80102960 <install_trans>
80102c5e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c65:	00 00 00 
80102c68:	e8 93 fd ff ff       	call   80102a00 <write_head>
80102c6d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c74:	e8 87 16 00 00       	call   80104300 <acquire>
80102c79:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102c80:	00 00 00 
80102c83:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c8a:	e8 21 12 00 00       	call   80103eb0 <wakeup>
80102c8f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c96:	e8 d5 16 00 00       	call   80104370 <release>
80102c9b:	83 c4 1c             	add    $0x1c,%esp
80102c9e:	5b                   	pop    %ebx
80102c9f:	5e                   	pop    %esi
80102ca0:	5f                   	pop    %edi
80102ca1:	5d                   	pop    %ebp
80102ca2:	c3                   	ret    
80102ca3:	c7 04 24 24 72 10 80 	movl   $0x80107224,(%esp)
80102caa:	e8 b1 d6 ff ff       	call   80100360 <panic>
80102caf:	90                   	nop

80102cb0 <log_write>:
80102cb0:	55                   	push   %ebp
80102cb1:	89 e5                	mov    %esp,%ebp
80102cb3:	53                   	push   %ebx
80102cb4:	83 ec 14             	sub    $0x14,%esp
80102cb7:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102cbc:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102cbf:	83 f8 1d             	cmp    $0x1d,%eax
80102cc2:	0f 8f 98 00 00 00    	jg     80102d60 <log_write+0xb0>
80102cc8:	8b 0d b8 26 11 80    	mov    0x801126b8,%ecx
80102cce:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102cd1:	39 d0                	cmp    %edx,%eax
80102cd3:	0f 8d 87 00 00 00    	jge    80102d60 <log_write+0xb0>
80102cd9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102cde:	85 c0                	test   %eax,%eax
80102ce0:	0f 8e 86 00 00 00    	jle    80102d6c <log_write+0xbc>
80102ce6:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ced:	e8 0e 16 00 00       	call   80104300 <acquire>
80102cf2:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102cf8:	83 fa 00             	cmp    $0x0,%edx
80102cfb:	7e 54                	jle    80102d51 <log_write+0xa1>
80102cfd:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102d00:	31 c0                	xor    %eax,%eax
80102d02:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102d08:	75 0f                	jne    80102d19 <log_write+0x69>
80102d0a:	eb 3c                	jmp    80102d48 <log_write+0x98>
80102d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d10:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d17:	74 2f                	je     80102d48 <log_write+0x98>
80102d19:	83 c0 01             	add    $0x1,%eax
80102d1c:	39 d0                	cmp    %edx,%eax
80102d1e:	75 f0                	jne    80102d10 <log_write+0x60>
80102d20:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
80102d27:	83 c2 01             	add    $0x1,%edx
80102d2a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
80102d30:	83 0b 04             	orl    $0x4,(%ebx)
80102d33:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
80102d3a:	83 c4 14             	add    $0x14,%esp
80102d3d:	5b                   	pop    %ebx
80102d3e:	5d                   	pop    %ebp
80102d3f:	e9 2c 16 00 00       	jmp    80104370 <release>
80102d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d48:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102d4f:	eb df                	jmp    80102d30 <log_write+0x80>
80102d51:	8b 43 08             	mov    0x8(%ebx),%eax
80102d54:	a3 cc 26 11 80       	mov    %eax,0x801126cc
80102d59:	75 d5                	jne    80102d30 <log_write+0x80>
80102d5b:	eb ca                	jmp    80102d27 <log_write+0x77>
80102d5d:	8d 76 00             	lea    0x0(%esi),%esi
80102d60:	c7 04 24 33 72 10 80 	movl   $0x80107233,(%esp)
80102d67:	e8 f4 d5 ff ff       	call   80100360 <panic>
80102d6c:	c7 04 24 49 72 10 80 	movl   $0x80107249,(%esp)
80102d73:	e8 e8 d5 ff ff       	call   80100360 <panic>
80102d78:	66 90                	xchg   %ax,%ax
80102d7a:	66 90                	xchg   %ax,%ax
80102d7c:	66 90                	xchg   %ax,%ax
80102d7e:	66 90                	xchg   %ax,%ax

80102d80 <mpmain>:
80102d80:	55                   	push   %ebp
80102d81:	89 e5                	mov    %esp,%ebp
80102d83:	53                   	push   %ebx
80102d84:	83 ec 14             	sub    $0x14,%esp
80102d87:	e8 f4 08 00 00       	call   80103680 <cpuid>
80102d8c:	89 c3                	mov    %eax,%ebx
80102d8e:	e8 ed 08 00 00       	call   80103680 <cpuid>
80102d93:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102d97:	c7 04 24 64 72 10 80 	movl   $0x80107264,(%esp)
80102d9e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102da2:	e8 a9 d8 ff ff       	call   80100650 <cprintf>
80102da7:	e8 64 28 00 00       	call   80105610 <idtinit>
80102dac:	e8 4f 08 00 00       	call   80103600 <mycpu>
80102db1:	89 c2                	mov    %eax,%edx
80102db3:	b8 01 00 00 00       	mov    $0x1,%eax
80102db8:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
80102dbf:	e8 9c 0b 00 00       	call   80103960 <scheduler>
80102dc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102dca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102dd0 <mpenter>:
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	83 ec 08             	sub    $0x8,%esp
80102dd6:	e8 f5 38 00 00       	call   801066d0 <switchkvm>
80102ddb:	e8 30 38 00 00       	call   80106610 <seginit>
80102de0:	e8 8b f8 ff ff       	call   80102670 <lapicinit>
80102de5:	e8 96 ff ff ff       	call   80102d80 <mpmain>
80102dea:	66 90                	xchg   %ax,%ax
80102dec:	66 90                	xchg   %ax,%ax
80102dee:	66 90                	xchg   %ax,%ax

80102df0 <main>:
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	53                   	push   %ebx
80102df4:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80102df9:	83 e4 f0             	and    $0xfffffff0,%esp
80102dfc:	83 ec 10             	sub    $0x10,%esp
80102dff:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e06:	80 
80102e07:	c7 04 24 a8 55 11 80 	movl   $0x801155a8,(%esp)
80102e0e:	e8 cd f5 ff ff       	call   801023e0 <kinit1>
80102e13:	e8 48 3d 00 00       	call   80106b60 <kvmalloc>
80102e18:	e8 73 01 00 00       	call   80102f90 <mpinit>
80102e1d:	8d 76 00             	lea    0x0(%esi),%esi
80102e20:	e8 4b f8 ff ff       	call   80102670 <lapicinit>
80102e25:	e8 e6 37 00 00       	call   80106610 <seginit>
80102e2a:	e8 21 03 00 00       	call   80103150 <picinit>
80102e2f:	90                   	nop
80102e30:	e8 cb f3 ff ff       	call   80102200 <ioapicinit>
80102e35:	e8 16 db ff ff       	call   80100950 <consoleinit>
80102e3a:	e8 f1 2a 00 00       	call   80105930 <uartinit>
80102e3f:	90                   	nop
80102e40:	e8 9b 07 00 00       	call   801035e0 <pinit>
80102e45:	e8 26 27 00 00       	call   80105570 <tvinit>
80102e4a:	e8 f1 d1 ff ff       	call   80100040 <binit>
80102e4f:	90                   	nop
80102e50:	e8 fb de ff ff       	call   80100d50 <fileinit>
80102e55:	e8 a6 f1 ff ff       	call   80102000 <ideinit>
80102e5a:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102e61:	00 
80102e62:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102e69:	80 
80102e6a:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102e71:	e8 ea 15 00 00       	call   80104460 <memmove>
80102e76:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102e7d:	00 00 00 
80102e80:	05 80 27 11 80       	add    $0x80112780,%eax
80102e85:	39 d8                	cmp    %ebx,%eax
80102e87:	76 6a                	jbe    80102ef3 <main+0x103>
80102e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e90:	e8 6b 07 00 00       	call   80103600 <mycpu>
80102e95:	39 d8                	cmp    %ebx,%eax
80102e97:	74 41                	je     80102eda <main+0xea>
80102e99:	e8 02 f6 ff ff       	call   801024a0 <kalloc>
80102e9e:	c7 05 f8 6f 00 80 d0 	movl   $0x80102dd0,0x80006ff8
80102ea5:	2d 10 80 
80102ea8:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102eaf:	90 10 00 
80102eb2:	05 00 10 00 00       	add    $0x1000,%eax
80102eb7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
80102ebc:	0f b6 03             	movzbl (%ebx),%eax
80102ebf:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102ec6:	00 
80102ec7:	89 04 24             	mov    %eax,(%esp)
80102eca:	e8 e1 f8 ff ff       	call   801027b0 <lapicstartap>
80102ecf:	90                   	nop
80102ed0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102ed6:	85 c0                	test   %eax,%eax
80102ed8:	74 f6                	je     80102ed0 <main+0xe0>
80102eda:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102ee1:	00 00 00 
80102ee4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102eea:	05 80 27 11 80       	add    $0x80112780,%eax
80102eef:	39 c3                	cmp    %eax,%ebx
80102ef1:	72 9d                	jb     80102e90 <main+0xa0>
80102ef3:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102efa:	8e 
80102efb:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f02:	e8 49 f5 ff ff       	call   80102450 <kinit2>
80102f07:	e8 c4 07 00 00       	call   801036d0 <userinit>
80102f0c:	e8 6f fe ff ff       	call   80102d80 <mpmain>
80102f11:	66 90                	xchg   %ax,%ax
80102f13:	66 90                	xchg   %ax,%ax
80102f15:	66 90                	xchg   %ax,%ax
80102f17:	66 90                	xchg   %ax,%ax
80102f19:	66 90                	xchg   %ax,%ax
80102f1b:	66 90                	xchg   %ax,%ax
80102f1d:	66 90                	xchg   %ax,%ax
80102f1f:	90                   	nop

80102f20 <mpsearch1>:
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	56                   	push   %esi
80102f24:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80102f2a:	53                   	push   %ebx
80102f2b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
80102f2e:	83 ec 10             	sub    $0x10,%esp
80102f31:	39 de                	cmp    %ebx,%esi
80102f33:	73 3c                	jae    80102f71 <mpsearch1+0x51>
80102f35:	8d 76 00             	lea    0x0(%esi),%esi
80102f38:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f3f:	00 
80102f40:	c7 44 24 04 78 72 10 	movl   $0x80107278,0x4(%esp)
80102f47:	80 
80102f48:	89 34 24             	mov    %esi,(%esp)
80102f4b:	e8 c0 14 00 00       	call   80104410 <memcmp>
80102f50:	85 c0                	test   %eax,%eax
80102f52:	75 16                	jne    80102f6a <mpsearch1+0x4a>
80102f54:	31 c9                	xor    %ecx,%ecx
80102f56:	31 d2                	xor    %edx,%edx
80102f58:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
80102f5c:	83 c2 01             	add    $0x1,%edx
80102f5f:	01 c1                	add    %eax,%ecx
80102f61:	83 fa 10             	cmp    $0x10,%edx
80102f64:	75 f2                	jne    80102f58 <mpsearch1+0x38>
80102f66:	84 c9                	test   %cl,%cl
80102f68:	74 10                	je     80102f7a <mpsearch1+0x5a>
80102f6a:	83 c6 10             	add    $0x10,%esi
80102f6d:	39 f3                	cmp    %esi,%ebx
80102f6f:	77 c7                	ja     80102f38 <mpsearch1+0x18>
80102f71:	83 c4 10             	add    $0x10,%esp
80102f74:	31 c0                	xor    %eax,%eax
80102f76:	5b                   	pop    %ebx
80102f77:	5e                   	pop    %esi
80102f78:	5d                   	pop    %ebp
80102f79:	c3                   	ret    
80102f7a:	83 c4 10             	add    $0x10,%esp
80102f7d:	89 f0                	mov    %esi,%eax
80102f7f:	5b                   	pop    %ebx
80102f80:	5e                   	pop    %esi
80102f81:	5d                   	pop    %ebp
80102f82:	c3                   	ret    
80102f83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f90 <mpinit>:
80102f90:	55                   	push   %ebp
80102f91:	89 e5                	mov    %esp,%ebp
80102f93:	57                   	push   %edi
80102f94:	56                   	push   %esi
80102f95:	53                   	push   %ebx
80102f96:	83 ec 1c             	sub    $0x1c,%esp
80102f99:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102fa0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102fa7:	c1 e0 08             	shl    $0x8,%eax
80102faa:	09 d0                	or     %edx,%eax
80102fac:	c1 e0 04             	shl    $0x4,%eax
80102faf:	85 c0                	test   %eax,%eax
80102fb1:	75 1b                	jne    80102fce <mpinit+0x3e>
80102fb3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102fba:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102fc1:	c1 e0 08             	shl    $0x8,%eax
80102fc4:	09 d0                	or     %edx,%eax
80102fc6:	c1 e0 0a             	shl    $0xa,%eax
80102fc9:	2d 00 04 00 00       	sub    $0x400,%eax
80102fce:	ba 00 04 00 00       	mov    $0x400,%edx
80102fd3:	e8 48 ff ff ff       	call   80102f20 <mpsearch1>
80102fd8:	85 c0                	test   %eax,%eax
80102fda:	89 c7                	mov    %eax,%edi
80102fdc:	0f 84 22 01 00 00    	je     80103104 <mpinit+0x174>
80102fe2:	8b 77 04             	mov    0x4(%edi),%esi
80102fe5:	85 f6                	test   %esi,%esi
80102fe7:	0f 84 30 01 00 00    	je     8010311d <mpinit+0x18d>
80102fed:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80102ff3:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102ffa:	00 
80102ffb:	c7 44 24 04 7d 72 10 	movl   $0x8010727d,0x4(%esp)
80103002:	80 
80103003:	89 04 24             	mov    %eax,(%esp)
80103006:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103009:	e8 02 14 00 00       	call   80104410 <memcmp>
8010300e:	85 c0                	test   %eax,%eax
80103010:	0f 85 07 01 00 00    	jne    8010311d <mpinit+0x18d>
80103016:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010301d:	3c 04                	cmp    $0x4,%al
8010301f:	0f 85 0b 01 00 00    	jne    80103130 <mpinit+0x1a0>
80103025:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
8010302c:	85 c0                	test   %eax,%eax
8010302e:	74 21                	je     80103051 <mpinit+0xc1>
80103030:	31 c9                	xor    %ecx,%ecx
80103032:	31 d2                	xor    %edx,%edx
80103034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103038:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010303f:	80 
80103040:	83 c2 01             	add    $0x1,%edx
80103043:	01 d9                	add    %ebx,%ecx
80103045:	39 d0                	cmp    %edx,%eax
80103047:	7f ef                	jg     80103038 <mpinit+0xa8>
80103049:	84 c9                	test   %cl,%cl
8010304b:	0f 85 cc 00 00 00    	jne    8010311d <mpinit+0x18d>
80103051:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103054:	85 c0                	test   %eax,%eax
80103056:	0f 84 c1 00 00 00    	je     8010311d <mpinit+0x18d>
8010305c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103062:	bb 01 00 00 00       	mov    $0x1,%ebx
80103067:	a3 7c 26 11 80       	mov    %eax,0x8011267c
8010306c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103073:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103079:	03 55 e4             	add    -0x1c(%ebp),%edx
8010307c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103080:	39 c2                	cmp    %eax,%edx
80103082:	76 1b                	jbe    8010309f <mpinit+0x10f>
80103084:	0f b6 08             	movzbl (%eax),%ecx
80103087:	80 f9 04             	cmp    $0x4,%cl
8010308a:	77 74                	ja     80103100 <mpinit+0x170>
8010308c:	ff 24 8d bc 72 10 80 	jmp    *-0x7fef8d44(,%ecx,4)
80103093:	90                   	nop
80103094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103098:	83 c0 08             	add    $0x8,%eax
8010309b:	39 c2                	cmp    %eax,%edx
8010309d:	77 e5                	ja     80103084 <mpinit+0xf4>
8010309f:	85 db                	test   %ebx,%ebx
801030a1:	0f 84 93 00 00 00    	je     8010313a <mpinit+0x1aa>
801030a7:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801030ab:	74 12                	je     801030bf <mpinit+0x12f>
801030ad:	ba 22 00 00 00       	mov    $0x22,%edx
801030b2:	b8 70 00 00 00       	mov    $0x70,%eax
801030b7:	ee                   	out    %al,(%dx)
801030b8:	b2 23                	mov    $0x23,%dl
801030ba:	ec                   	in     (%dx),%al
801030bb:	83 c8 01             	or     $0x1,%eax
801030be:	ee                   	out    %al,(%dx)
801030bf:	83 c4 1c             	add    $0x1c,%esp
801030c2:	5b                   	pop    %ebx
801030c3:	5e                   	pop    %esi
801030c4:	5f                   	pop    %edi
801030c5:	5d                   	pop    %ebp
801030c6:	c3                   	ret    
801030c7:	90                   	nop
801030c8:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801030ce:	83 fe 07             	cmp    $0x7,%esi
801030d1:	7f 17                	jg     801030ea <mpinit+0x15a>
801030d3:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801030d7:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
801030dd:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
801030e4:	88 8e 80 27 11 80    	mov    %cl,-0x7feed880(%esi)
801030ea:	83 c0 14             	add    $0x14,%eax
801030ed:	eb 91                	jmp    80103080 <mpinit+0xf0>
801030ef:	90                   	nop
801030f0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801030f4:	83 c0 08             	add    $0x8,%eax
801030f7:	88 0d 60 27 11 80    	mov    %cl,0x80112760
801030fd:	eb 81                	jmp    80103080 <mpinit+0xf0>
801030ff:	90                   	nop
80103100:	31 db                	xor    %ebx,%ebx
80103102:	eb 83                	jmp    80103087 <mpinit+0xf7>
80103104:	ba 00 00 01 00       	mov    $0x10000,%edx
80103109:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010310e:	e8 0d fe ff ff       	call   80102f20 <mpsearch1>
80103113:	85 c0                	test   %eax,%eax
80103115:	89 c7                	mov    %eax,%edi
80103117:	0f 85 c5 fe ff ff    	jne    80102fe2 <mpinit+0x52>
8010311d:	c7 04 24 82 72 10 80 	movl   $0x80107282,(%esp)
80103124:	e8 37 d2 ff ff       	call   80100360 <panic>
80103129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103130:	3c 01                	cmp    $0x1,%al
80103132:	0f 84 ed fe ff ff    	je     80103025 <mpinit+0x95>
80103138:	eb e3                	jmp    8010311d <mpinit+0x18d>
8010313a:	c7 04 24 9c 72 10 80 	movl   $0x8010729c,(%esp)
80103141:	e8 1a d2 ff ff       	call   80100360 <panic>
80103146:	66 90                	xchg   %ax,%ax
80103148:	66 90                	xchg   %ax,%ax
8010314a:	66 90                	xchg   %ax,%ax
8010314c:	66 90                	xchg   %ax,%ax
8010314e:	66 90                	xchg   %ax,%ax

80103150 <picinit>:
80103150:	55                   	push   %ebp
80103151:	ba 21 00 00 00       	mov    $0x21,%edx
80103156:	89 e5                	mov    %esp,%ebp
80103158:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010315d:	ee                   	out    %al,(%dx)
8010315e:	b2 a1                	mov    $0xa1,%dl
80103160:	ee                   	out    %al,(%dx)
80103161:	5d                   	pop    %ebp
80103162:	c3                   	ret    
80103163:	66 90                	xchg   %ax,%ax
80103165:	66 90                	xchg   %ax,%ax
80103167:	66 90                	xchg   %ax,%ax
80103169:	66 90                	xchg   %ax,%ax
8010316b:	66 90                	xchg   %ax,%ax
8010316d:	66 90                	xchg   %ax,%ax
8010316f:	90                   	nop

80103170 <pipealloc>:
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	57                   	push   %edi
80103174:	56                   	push   %esi
80103175:	53                   	push   %ebx
80103176:	83 ec 1c             	sub    $0x1c,%esp
80103179:	8b 75 08             	mov    0x8(%ebp),%esi
8010317c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010317f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103185:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010318b:	e8 e0 db ff ff       	call   80100d70 <filealloc>
80103190:	85 c0                	test   %eax,%eax
80103192:	89 06                	mov    %eax,(%esi)
80103194:	0f 84 a4 00 00 00    	je     8010323e <pipealloc+0xce>
8010319a:	e8 d1 db ff ff       	call   80100d70 <filealloc>
8010319f:	85 c0                	test   %eax,%eax
801031a1:	89 03                	mov    %eax,(%ebx)
801031a3:	0f 84 87 00 00 00    	je     80103230 <pipealloc+0xc0>
801031a9:	e8 f2 f2 ff ff       	call   801024a0 <kalloc>
801031ae:	85 c0                	test   %eax,%eax
801031b0:	89 c7                	mov    %eax,%edi
801031b2:	74 7c                	je     80103230 <pipealloc+0xc0>
801031b4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801031bb:	00 00 00 
801031be:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801031c5:	00 00 00 
801031c8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801031cf:	00 00 00 
801031d2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801031d9:	00 00 00 
801031dc:	89 04 24             	mov    %eax,(%esp)
801031df:	c7 44 24 04 d0 72 10 	movl   $0x801072d0,0x4(%esp)
801031e6:	80 
801031e7:	e8 a4 0f 00 00       	call   80104190 <initlock>
801031ec:	8b 06                	mov    (%esi),%eax
801031ee:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
801031f4:	8b 06                	mov    (%esi),%eax
801031f6:	c6 40 08 01          	movb   $0x1,0x8(%eax)
801031fa:	8b 06                	mov    (%esi),%eax
801031fc:	c6 40 09 00          	movb   $0x0,0x9(%eax)
80103200:	8b 06                	mov    (%esi),%eax
80103202:	89 78 0c             	mov    %edi,0xc(%eax)
80103205:	8b 03                	mov    (%ebx),%eax
80103207:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
8010320d:	8b 03                	mov    (%ebx),%eax
8010320f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
80103213:	8b 03                	mov    (%ebx),%eax
80103215:	c6 40 09 01          	movb   $0x1,0x9(%eax)
80103219:	8b 03                	mov    (%ebx),%eax
8010321b:	31 db                	xor    %ebx,%ebx
8010321d:	89 78 0c             	mov    %edi,0xc(%eax)
80103220:	83 c4 1c             	add    $0x1c,%esp
80103223:	89 d8                	mov    %ebx,%eax
80103225:	5b                   	pop    %ebx
80103226:	5e                   	pop    %esi
80103227:	5f                   	pop    %edi
80103228:	5d                   	pop    %ebp
80103229:	c3                   	ret    
8010322a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103230:	8b 06                	mov    (%esi),%eax
80103232:	85 c0                	test   %eax,%eax
80103234:	74 08                	je     8010323e <pipealloc+0xce>
80103236:	89 04 24             	mov    %eax,(%esp)
80103239:	e8 f2 db ff ff       	call   80100e30 <fileclose>
8010323e:	8b 03                	mov    (%ebx),%eax
80103240:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103245:	85 c0                	test   %eax,%eax
80103247:	74 d7                	je     80103220 <pipealloc+0xb0>
80103249:	89 04 24             	mov    %eax,(%esp)
8010324c:	e8 df db ff ff       	call   80100e30 <fileclose>
80103251:	83 c4 1c             	add    $0x1c,%esp
80103254:	89 d8                	mov    %ebx,%eax
80103256:	5b                   	pop    %ebx
80103257:	5e                   	pop    %esi
80103258:	5f                   	pop    %edi
80103259:	5d                   	pop    %ebp
8010325a:	c3                   	ret    
8010325b:	90                   	nop
8010325c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103260 <pipeclose>:
80103260:	55                   	push   %ebp
80103261:	89 e5                	mov    %esp,%ebp
80103263:	56                   	push   %esi
80103264:	53                   	push   %ebx
80103265:	83 ec 10             	sub    $0x10,%esp
80103268:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010326b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010326e:	89 1c 24             	mov    %ebx,(%esp)
80103271:	e8 8a 10 00 00       	call   80104300 <acquire>
80103276:	85 f6                	test   %esi,%esi
80103278:	74 3e                	je     801032b8 <pipeclose+0x58>
8010327a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103280:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103287:	00 00 00 
8010328a:	89 04 24             	mov    %eax,(%esp)
8010328d:	e8 1e 0c 00 00       	call   80103eb0 <wakeup>
80103292:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103298:	85 d2                	test   %edx,%edx
8010329a:	75 0a                	jne    801032a6 <pipeclose+0x46>
8010329c:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801032a2:	85 c0                	test   %eax,%eax
801032a4:	74 32                	je     801032d8 <pipeclose+0x78>
801032a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801032a9:	83 c4 10             	add    $0x10,%esp
801032ac:	5b                   	pop    %ebx
801032ad:	5e                   	pop    %esi
801032ae:	5d                   	pop    %ebp
801032af:	e9 bc 10 00 00       	jmp    80104370 <release>
801032b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032b8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801032be:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801032c5:	00 00 00 
801032c8:	89 04 24             	mov    %eax,(%esp)
801032cb:	e8 e0 0b 00 00       	call   80103eb0 <wakeup>
801032d0:	eb c0                	jmp    80103292 <pipeclose+0x32>
801032d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801032d8:	89 1c 24             	mov    %ebx,(%esp)
801032db:	e8 90 10 00 00       	call   80104370 <release>
801032e0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801032e3:	83 c4 10             	add    $0x10,%esp
801032e6:	5b                   	pop    %ebx
801032e7:	5e                   	pop    %esi
801032e8:	5d                   	pop    %ebp
801032e9:	e9 02 f0 ff ff       	jmp    801022f0 <kfree>
801032ee:	66 90                	xchg   %ax,%ax

801032f0 <pipewrite>:
801032f0:	55                   	push   %ebp
801032f1:	89 e5                	mov    %esp,%ebp
801032f3:	57                   	push   %edi
801032f4:	56                   	push   %esi
801032f5:	53                   	push   %ebx
801032f6:	83 ec 1c             	sub    $0x1c,%esp
801032f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032fc:	89 1c 24             	mov    %ebx,(%esp)
801032ff:	e8 fc 0f 00 00       	call   80104300 <acquire>
80103304:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103307:	85 c9                	test   %ecx,%ecx
80103309:	0f 8e b2 00 00 00    	jle    801033c1 <pipewrite+0xd1>
8010330f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103312:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103318:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
8010331e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103324:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103327:	03 4d 10             	add    0x10(%ebp),%ecx
8010332a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010332d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103333:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103339:	39 c8                	cmp    %ecx,%eax
8010333b:	74 38                	je     80103375 <pipewrite+0x85>
8010333d:	eb 55                	jmp    80103394 <pipewrite+0xa4>
8010333f:	90                   	nop
80103340:	e8 5b 03 00 00       	call   801036a0 <myproc>
80103345:	8b 40 24             	mov    0x24(%eax),%eax
80103348:	85 c0                	test   %eax,%eax
8010334a:	75 33                	jne    8010337f <pipewrite+0x8f>
8010334c:	89 3c 24             	mov    %edi,(%esp)
8010334f:	e8 5c 0b 00 00       	call   80103eb0 <wakeup>
80103354:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103358:	89 34 24             	mov    %esi,(%esp)
8010335b:	e8 c0 09 00 00       	call   80103d20 <sleep>
80103360:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103366:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010336c:	05 00 02 00 00       	add    $0x200,%eax
80103371:	39 c2                	cmp    %eax,%edx
80103373:	75 23                	jne    80103398 <pipewrite+0xa8>
80103375:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010337b:	85 d2                	test   %edx,%edx
8010337d:	75 c1                	jne    80103340 <pipewrite+0x50>
8010337f:	89 1c 24             	mov    %ebx,(%esp)
80103382:	e8 e9 0f 00 00       	call   80104370 <release>
80103387:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010338c:	83 c4 1c             	add    $0x1c,%esp
8010338f:	5b                   	pop    %ebx
80103390:	5e                   	pop    %esi
80103391:	5f                   	pop    %edi
80103392:	5d                   	pop    %ebp
80103393:	c3                   	ret    
80103394:	89 c2                	mov    %eax,%edx
80103396:	66 90                	xchg   %ax,%ax
80103398:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010339b:	8d 42 01             	lea    0x1(%edx),%eax
8010339e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801033a4:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801033aa:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801033ae:	0f b6 09             	movzbl (%ecx),%ecx
801033b1:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
801033b5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033b8:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801033bb:	0f 85 6c ff ff ff    	jne    8010332d <pipewrite+0x3d>
801033c1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033c7:	89 04 24             	mov    %eax,(%esp)
801033ca:	e8 e1 0a 00 00       	call   80103eb0 <wakeup>
801033cf:	89 1c 24             	mov    %ebx,(%esp)
801033d2:	e8 99 0f 00 00       	call   80104370 <release>
801033d7:	8b 45 10             	mov    0x10(%ebp),%eax
801033da:	eb b0                	jmp    8010338c <pipewrite+0x9c>
801033dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033e0 <piperead>:
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	57                   	push   %edi
801033e4:	56                   	push   %esi
801033e5:	53                   	push   %ebx
801033e6:	83 ec 1c             	sub    $0x1c,%esp
801033e9:	8b 75 08             	mov    0x8(%ebp),%esi
801033ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
801033ef:	89 34 24             	mov    %esi,(%esp)
801033f2:	e8 09 0f 00 00       	call   80104300 <acquire>
801033f7:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801033fd:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103403:	75 5b                	jne    80103460 <piperead+0x80>
80103405:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010340b:	85 db                	test   %ebx,%ebx
8010340d:	74 51                	je     80103460 <piperead+0x80>
8010340f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103415:	eb 25                	jmp    8010343c <piperead+0x5c>
80103417:	90                   	nop
80103418:	89 74 24 04          	mov    %esi,0x4(%esp)
8010341c:	89 1c 24             	mov    %ebx,(%esp)
8010341f:	e8 fc 08 00 00       	call   80103d20 <sleep>
80103424:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010342a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103430:	75 2e                	jne    80103460 <piperead+0x80>
80103432:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103438:	85 d2                	test   %edx,%edx
8010343a:	74 24                	je     80103460 <piperead+0x80>
8010343c:	e8 5f 02 00 00       	call   801036a0 <myproc>
80103441:	8b 48 24             	mov    0x24(%eax),%ecx
80103444:	85 c9                	test   %ecx,%ecx
80103446:	74 d0                	je     80103418 <piperead+0x38>
80103448:	89 34 24             	mov    %esi,(%esp)
8010344b:	e8 20 0f 00 00       	call   80104370 <release>
80103450:	83 c4 1c             	add    $0x1c,%esp
80103453:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103458:	5b                   	pop    %ebx
80103459:	5e                   	pop    %esi
8010345a:	5f                   	pop    %edi
8010345b:	5d                   	pop    %ebp
8010345c:	c3                   	ret    
8010345d:	8d 76 00             	lea    0x0(%esi),%esi
80103460:	8b 55 10             	mov    0x10(%ebp),%edx
80103463:	31 db                	xor    %ebx,%ebx
80103465:	85 d2                	test   %edx,%edx
80103467:	7f 2b                	jg     80103494 <piperead+0xb4>
80103469:	eb 31                	jmp    8010349c <piperead+0xbc>
8010346b:	90                   	nop
8010346c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103470:	8d 48 01             	lea    0x1(%eax),%ecx
80103473:	25 ff 01 00 00       	and    $0x1ff,%eax
80103478:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010347e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103483:	88 04 1f             	mov    %al,(%edi,%ebx,1)
80103486:	83 c3 01             	add    $0x1,%ebx
80103489:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010348c:	74 0e                	je     8010349c <piperead+0xbc>
8010348e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103494:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010349a:	75 d4                	jne    80103470 <piperead+0x90>
8010349c:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801034a2:	89 04 24             	mov    %eax,(%esp)
801034a5:	e8 06 0a 00 00       	call   80103eb0 <wakeup>
801034aa:	89 34 24             	mov    %esi,(%esp)
801034ad:	e8 be 0e 00 00       	call   80104370 <release>
801034b2:	83 c4 1c             	add    $0x1c,%esp
801034b5:	89 d8                	mov    %ebx,%eax
801034b7:	5b                   	pop    %ebx
801034b8:	5e                   	pop    %esi
801034b9:	5f                   	pop    %edi
801034ba:	5d                   	pop    %ebp
801034bb:	c3                   	ret    
801034bc:	66 90                	xchg   %ax,%ax
801034be:	66 90                	xchg   %ax,%ax

801034c0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034c0:	55                   	push   %ebp
801034c1:	89 e5                	mov    %esp,%ebp
801034c3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034c4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801034c9:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801034cc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801034d3:	e8 28 0e 00 00       	call   80104300 <acquire>
801034d8:	eb 11                	jmp    801034eb <allocproc+0x2b>
801034da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034e0:	83 eb 80             	sub    $0xffffff80,%ebx
801034e3:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801034e9:	74 7d                	je     80103568 <allocproc+0xa8>
    if(p->state == UNUSED)
801034eb:	8b 43 0c             	mov    0xc(%ebx),%eax
801034ee:	85 c0                	test   %eax,%eax
801034f0:	75 ee                	jne    801034e0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801034f2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801034f7:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  p->state = EMBRYO;
801034fe:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103505:	8d 50 01             	lea    0x1(%eax),%edx
80103508:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
8010350e:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103511:	e8 5a 0e 00 00       	call   80104370 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103516:	e8 85 ef ff ff       	call   801024a0 <kalloc>
8010351b:	85 c0                	test   %eax,%eax
8010351d:	89 43 08             	mov    %eax,0x8(%ebx)
80103520:	74 5a                	je     8010357c <allocproc+0xbc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103522:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103528:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010352d:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103530:	c7 40 14 65 55 10 80 	movl   $0x80105565,0x14(%eax)
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103537:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010353e:	00 
8010353f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103546:	00 
80103547:	89 04 24             	mov    %eax,(%esp)
  p->context = (struct context*)sp;
8010354a:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010354d:	e8 6e 0e 00 00       	call   801043c0 <memset>
  p->context->eip = (uint)forkret;
80103552:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103555:	c7 40 10 90 35 10 80 	movl   $0x80103590,0x10(%eax)

  return p;
8010355c:	89 d8                	mov    %ebx,%eax
}
8010355e:	83 c4 14             	add    $0x14,%esp
80103561:	5b                   	pop    %ebx
80103562:	5d                   	pop    %ebp
80103563:	c3                   	ret    
80103564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103568:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010356f:	e8 fc 0d 00 00       	call   80104370 <release>
}
80103574:	83 c4 14             	add    $0x14,%esp
  return 0;
80103577:	31 c0                	xor    %eax,%eax
}
80103579:	5b                   	pop    %ebx
8010357a:	5d                   	pop    %ebp
8010357b:	c3                   	ret    
    p->state = UNUSED;
8010357c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103583:	eb d9                	jmp    8010355e <allocproc+0x9e>
80103585:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103590 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103596:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010359d:	e8 ce 0d 00 00       	call   80104370 <release>

  if (first) {
801035a2:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801035a7:	85 c0                	test   %eax,%eax
801035a9:	75 05                	jne    801035b0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035ab:	c9                   	leave  
801035ac:	c3                   	ret    
801035ad:	8d 76 00             	lea    0x0(%esi),%esi
    iinit(ROOTDEV);
801035b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    first = 0;
801035b7:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801035be:	00 00 00 
    iinit(ROOTDEV);
801035c1:	e8 aa de ff ff       	call   80101470 <iinit>
    initlog(ROOTDEV);
801035c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801035cd:	e8 9e f4 ff ff       	call   80102a70 <initlog>
}
801035d2:	c9                   	leave  
801035d3:	c3                   	ret    
801035d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801035da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801035e0 <pinit>:
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801035e6:	c7 44 24 04 d5 72 10 	movl   $0x801072d5,0x4(%esp)
801035ed:	80 
801035ee:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035f5:	e8 96 0b 00 00       	call   80104190 <initlock>
}
801035fa:	c9                   	leave  
801035fb:	c3                   	ret    
801035fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103600 <mycpu>:
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	56                   	push   %esi
80103604:	53                   	push   %ebx
80103605:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103608:	9c                   	pushf  
80103609:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010360a:	f6 c4 02             	test   $0x2,%ah
8010360d:	75 57                	jne    80103666 <mycpu+0x66>
  apicid = lapicid();
8010360f:	e8 4c f1 ff ff       	call   80102760 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103614:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010361a:	85 f6                	test   %esi,%esi
8010361c:	7e 3c                	jle    8010365a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010361e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103625:	39 c2                	cmp    %eax,%edx
80103627:	74 2d                	je     80103656 <mycpu+0x56>
80103629:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010362e:	31 d2                	xor    %edx,%edx
80103630:	83 c2 01             	add    $0x1,%edx
80103633:	39 f2                	cmp    %esi,%edx
80103635:	74 23                	je     8010365a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103637:	0f b6 19             	movzbl (%ecx),%ebx
8010363a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103640:	39 c3                	cmp    %eax,%ebx
80103642:	75 ec                	jne    80103630 <mycpu+0x30>
      return &cpus[i];
80103644:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
}
8010364a:	83 c4 10             	add    $0x10,%esp
8010364d:	5b                   	pop    %ebx
8010364e:	5e                   	pop    %esi
8010364f:	5d                   	pop    %ebp
      return &cpus[i];
80103650:	05 80 27 11 80       	add    $0x80112780,%eax
}
80103655:	c3                   	ret    
  for (i = 0; i < ncpu; ++i) {
80103656:	31 d2                	xor    %edx,%edx
80103658:	eb ea                	jmp    80103644 <mycpu+0x44>
  panic("unknown apicid\n");
8010365a:	c7 04 24 dc 72 10 80 	movl   $0x801072dc,(%esp)
80103661:	e8 fa cc ff ff       	call   80100360 <panic>
    panic("mycpu called with interrupts enabled\n");
80103666:	c7 04 24 b8 73 10 80 	movl   $0x801073b8,(%esp)
8010366d:	e8 ee cc ff ff       	call   80100360 <panic>
80103672:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103680 <cpuid>:
cpuid() {
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103686:	e8 75 ff ff ff       	call   80103600 <mycpu>
}
8010368b:	c9                   	leave  
  return mycpu()-cpus;
8010368c:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103691:	c1 f8 04             	sar    $0x4,%eax
80103694:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010369a:	c3                   	ret    
8010369b:	90                   	nop
8010369c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036a0 <myproc>:
myproc(void) {
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	53                   	push   %ebx
801036a4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801036a7:	e8 64 0b 00 00       	call   80104210 <pushcli>
  c = mycpu();
801036ac:	e8 4f ff ff ff       	call   80103600 <mycpu>
  p = c->proc;
801036b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801036b7:	e8 94 0b 00 00       	call   80104250 <popcli>
}
801036bc:	83 c4 04             	add    $0x4,%esp
801036bf:	89 d8                	mov    %ebx,%eax
801036c1:	5b                   	pop    %ebx
801036c2:	5d                   	pop    %ebp
801036c3:	c3                   	ret    
801036c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801036d0 <userinit>:
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	53                   	push   %ebx
801036d4:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
801036d7:	e8 e4 fd ff ff       	call   801034c0 <allocproc>
801036dc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801036de:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801036e3:	e8 e8 33 00 00       	call   80106ad0 <setupkvm>
801036e8:	85 c0                	test   %eax,%eax
801036ea:	89 43 04             	mov    %eax,0x4(%ebx)
801036ed:	0f 84 d4 00 00 00    	je     801037c7 <userinit+0xf7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801036f3:	89 04 24             	mov    %eax,(%esp)
801036f6:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
801036fd:	00 
801036fe:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80103705:	80 
80103706:	e8 f5 30 00 00       	call   80106800 <inituvm>
  p->sz = PGSIZE;
8010370b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103711:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103718:	00 
80103719:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103720:	00 
80103721:	8b 43 18             	mov    0x18(%ebx),%eax
80103724:	89 04 24             	mov    %eax,(%esp)
80103727:	e8 94 0c 00 00       	call   801043c0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010372c:	8b 43 18             	mov    0x18(%ebx),%eax
8010372f:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103734:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103739:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010373d:	8b 43 18             	mov    0x18(%ebx),%eax
80103740:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103744:	8b 43 18             	mov    0x18(%ebx),%eax
80103747:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010374b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010374f:	8b 43 18             	mov    0x18(%ebx),%eax
80103752:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103756:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010375a:	8b 43 18             	mov    0x18(%ebx),%eax
8010375d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103764:	8b 43 18             	mov    0x18(%ebx),%eax
80103767:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010376e:	8b 43 18             	mov    0x18(%ebx),%eax
80103771:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103778:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010377b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103782:	00 
80103783:	c7 44 24 04 05 73 10 	movl   $0x80107305,0x4(%esp)
8010378a:	80 
8010378b:	89 04 24             	mov    %eax,(%esp)
8010378e:	e8 0d 0e 00 00       	call   801045a0 <safestrcpy>
  p->cwd = namei("/");
80103793:	c7 04 24 0e 73 10 80 	movl   $0x8010730e,(%esp)
8010379a:	e8 61 e7 ff ff       	call   80101f00 <namei>
8010379f:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801037a2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037a9:	e8 52 0b 00 00       	call   80104300 <acquire>
  p->state = RUNNABLE;
801037ae:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801037b5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037bc:	e8 af 0b 00 00       	call   80104370 <release>
}
801037c1:	83 c4 14             	add    $0x14,%esp
801037c4:	5b                   	pop    %ebx
801037c5:	5d                   	pop    %ebp
801037c6:	c3                   	ret    
    panic("userinit: out of memory?");
801037c7:	c7 04 24 ec 72 10 80 	movl   $0x801072ec,(%esp)
801037ce:	e8 8d cb ff ff       	call   80100360 <panic>
801037d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037e0 <growproc>:
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	56                   	push   %esi
801037e4:	53                   	push   %ebx
801037e5:	83 ec 10             	sub    $0x10,%esp
801037e8:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
801037eb:	e8 b0 fe ff ff       	call   801036a0 <myproc>
  if(n > 0){
801037f0:	83 fe 00             	cmp    $0x0,%esi
  struct proc *curproc = myproc();
801037f3:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
801037f5:	8b 00                	mov    (%eax),%eax
  if(n > 0){
801037f7:	7e 2f                	jle    80103828 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801037f9:	01 c6                	add    %eax,%esi
801037fb:	89 74 24 08          	mov    %esi,0x8(%esp)
801037ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80103803:	8b 43 04             	mov    0x4(%ebx),%eax
80103806:	89 04 24             	mov    %eax,(%esp)
80103809:	e8 32 31 00 00       	call   80106940 <allocuvm>
8010380e:	85 c0                	test   %eax,%eax
80103810:	74 36                	je     80103848 <growproc+0x68>
  curproc->sz = sz;
80103812:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103814:	89 1c 24             	mov    %ebx,(%esp)
80103817:	e8 d4 2e 00 00       	call   801066f0 <switchuvm>
  return 0;
8010381c:	31 c0                	xor    %eax,%eax
}
8010381e:	83 c4 10             	add    $0x10,%esp
80103821:	5b                   	pop    %ebx
80103822:	5e                   	pop    %esi
80103823:	5d                   	pop    %ebp
80103824:	c3                   	ret    
80103825:	8d 76 00             	lea    0x0(%esi),%esi
  } else if(n < 0){
80103828:	74 e8                	je     80103812 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010382a:	01 c6                	add    %eax,%esi
8010382c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103830:	89 44 24 04          	mov    %eax,0x4(%esp)
80103834:	8b 43 04             	mov    0x4(%ebx),%eax
80103837:	89 04 24             	mov    %eax,(%esp)
8010383a:	e8 f1 31 00 00       	call   80106a30 <deallocuvm>
8010383f:	85 c0                	test   %eax,%eax
80103841:	75 cf                	jne    80103812 <growproc+0x32>
80103843:	90                   	nop
80103844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80103848:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010384d:	eb cf                	jmp    8010381e <growproc+0x3e>
8010384f:	90                   	nop

80103850 <fork>:
{
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	57                   	push   %edi
80103854:	56                   	push   %esi
80103855:	53                   	push   %ebx
80103856:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103859:	e8 42 fe ff ff       	call   801036a0 <myproc>
8010385e:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
80103860:	e8 5b fc ff ff       	call   801034c0 <allocproc>
80103865:	85 c0                	test   %eax,%eax
80103867:	89 c7                	mov    %eax,%edi
80103869:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010386c:	0f 84 bc 00 00 00    	je     8010392e <fork+0xde>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103872:	8b 03                	mov    (%ebx),%eax
80103874:	89 44 24 04          	mov    %eax,0x4(%esp)
80103878:	8b 43 04             	mov    0x4(%ebx),%eax
8010387b:	89 04 24             	mov    %eax,(%esp)
8010387e:	e8 2d 33 00 00       	call   80106bb0 <copyuvm>
80103883:	85 c0                	test   %eax,%eax
80103885:	89 47 04             	mov    %eax,0x4(%edi)
80103888:	0f 84 a7 00 00 00    	je     80103935 <fork+0xe5>
  np->sz = curproc->sz;
8010388e:	8b 03                	mov    (%ebx),%eax
80103890:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103893:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103895:	8b 79 18             	mov    0x18(%ecx),%edi
80103898:	89 c8                	mov    %ecx,%eax
  np->parent = curproc;
8010389a:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010389d:	8b 73 18             	mov    0x18(%ebx),%esi
801038a0:	b9 13 00 00 00       	mov    $0x13,%ecx
801038a5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801038a7:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801038a9:	8b 40 18             	mov    0x18(%eax),%eax
801038ac:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801038b3:	90                   	nop
801038b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
801038b8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801038bc:	85 c0                	test   %eax,%eax
801038be:	74 0f                	je     801038cf <fork+0x7f>
      np->ofile[i] = filedup(curproc->ofile[i]);
801038c0:	89 04 24             	mov    %eax,(%esp)
801038c3:	e8 18 d5 ff ff       	call   80100de0 <filedup>
801038c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801038cb:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801038cf:	83 c6 01             	add    $0x1,%esi
801038d2:	83 fe 10             	cmp    $0x10,%esi
801038d5:	75 e1                	jne    801038b8 <fork+0x68>
  np->cwd = idup(curproc->cwd);
801038d7:	8b 43 68             	mov    0x68(%ebx),%eax
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801038da:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801038dd:	89 04 24             	mov    %eax,(%esp)
801038e0:	e8 9b dd ff ff       	call   80101680 <idup>
801038e5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801038e8:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801038eb:	8d 47 6c             	lea    0x6c(%edi),%eax
801038ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801038f2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801038f9:	00 
801038fa:	89 04 24             	mov    %eax,(%esp)
801038fd:	e8 9e 0c 00 00       	call   801045a0 <safestrcpy>
  pid = np->pid;
80103902:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103905:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010390c:	e8 ef 09 00 00       	call   80104300 <acquire>
  np->state = RUNNABLE;
80103911:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103918:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010391f:	e8 4c 0a 00 00       	call   80104370 <release>
  return pid;
80103924:	89 d8                	mov    %ebx,%eax
}
80103926:	83 c4 1c             	add    $0x1c,%esp
80103929:	5b                   	pop    %ebx
8010392a:	5e                   	pop    %esi
8010392b:	5f                   	pop    %edi
8010392c:	5d                   	pop    %ebp
8010392d:	c3                   	ret    
    return -1;
8010392e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103933:	eb f1                	jmp    80103926 <fork+0xd6>
    kfree(np->kstack);
80103935:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103938:	8b 47 08             	mov    0x8(%edi),%eax
8010393b:	89 04 24             	mov    %eax,(%esp)
8010393e:	e8 ad e9 ff ff       	call   801022f0 <kfree>
    return -1;
80103943:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    np->kstack = 0;
80103948:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
8010394f:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103956:	eb ce                	jmp    80103926 <fork+0xd6>
80103958:	90                   	nop
80103959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103960 <scheduler>:
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	57                   	push   %edi
80103964:	56                   	push   %esi
80103965:	53                   	push   %ebx
80103966:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103969:	e8 92 fc ff ff       	call   80103600 <mycpu>
8010396e:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103970:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103977:	00 00 00 
8010397a:	8d 78 04             	lea    0x4(%eax),%edi
8010397d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103980:	fb                   	sti    
    acquire(&ptable.lock);
80103981:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103988:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
8010398d:	e8 6e 09 00 00       	call   80104300 <acquire>
80103992:	eb 0f                	jmp    801039a3 <scheduler+0x43>
80103994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103998:	83 eb 80             	sub    $0xffffff80,%ebx
8010399b:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801039a1:	74 45                	je     801039e8 <scheduler+0x88>
      if(p->state != RUNNABLE)
801039a3:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801039a7:	75 ef                	jne    80103998 <scheduler+0x38>
      c->proc = p;
801039a9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801039af:	89 1c 24             	mov    %ebx,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039b2:	83 eb 80             	sub    $0xffffff80,%ebx
      switchuvm(p);
801039b5:	e8 36 2d 00 00       	call   801066f0 <switchuvm>
      swtch(&(c->scheduler), p->context);
801039ba:	8b 43 9c             	mov    -0x64(%ebx),%eax
      p->state = RUNNING;
801039bd:	c7 43 8c 04 00 00 00 	movl   $0x4,-0x74(%ebx)
      swtch(&(c->scheduler), p->context);
801039c4:	89 3c 24             	mov    %edi,(%esp)
801039c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801039cb:	e8 2b 0c 00 00       	call   801045fb <swtch>
      switchkvm();
801039d0:	e8 fb 2c 00 00       	call   801066d0 <switchkvm>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039d5:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
      c->proc = 0;
801039db:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801039e2:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039e5:	75 bc                	jne    801039a3 <scheduler+0x43>
801039e7:	90                   	nop
    release(&ptable.lock);
801039e8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039ef:	e8 7c 09 00 00       	call   80104370 <release>
  }
801039f4:	eb 8a                	jmp    80103980 <scheduler+0x20>
801039f6:	8d 76 00             	lea    0x0(%esi),%esi
801039f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a00 <sched>:
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	56                   	push   %esi
80103a04:	53                   	push   %ebx
80103a05:	83 ec 10             	sub    $0x10,%esp
  struct proc *p = myproc();
80103a08:	e8 93 fc ff ff       	call   801036a0 <myproc>
  if(!holding(&ptable.lock))
80103a0d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *p = myproc();
80103a14:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103a16:	e8 a5 08 00 00       	call   801042c0 <holding>
80103a1b:	85 c0                	test   %eax,%eax
80103a1d:	74 4f                	je     80103a6e <sched+0x6e>
  if(mycpu()->ncli != 1)
80103a1f:	e8 dc fb ff ff       	call   80103600 <mycpu>
80103a24:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103a2b:	75 65                	jne    80103a92 <sched+0x92>
  if(p->state == RUNNING)
80103a2d:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103a31:	74 53                	je     80103a86 <sched+0x86>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a33:	9c                   	pushf  
80103a34:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a35:	f6 c4 02             	test   $0x2,%ah
80103a38:	75 40                	jne    80103a7a <sched+0x7a>
  intena = mycpu()->intena;
80103a3a:	e8 c1 fb ff ff       	call   80103600 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103a3f:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103a42:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103a48:	e8 b3 fb ff ff       	call   80103600 <mycpu>
80103a4d:	8b 40 04             	mov    0x4(%eax),%eax
80103a50:	89 1c 24             	mov    %ebx,(%esp)
80103a53:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a57:	e8 9f 0b 00 00       	call   801045fb <swtch>
  mycpu()->intena = intena;
80103a5c:	e8 9f fb ff ff       	call   80103600 <mycpu>
80103a61:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103a67:	83 c4 10             	add    $0x10,%esp
80103a6a:	5b                   	pop    %ebx
80103a6b:	5e                   	pop    %esi
80103a6c:	5d                   	pop    %ebp
80103a6d:	c3                   	ret    
    panic("sched ptable.lock");
80103a6e:	c7 04 24 10 73 10 80 	movl   $0x80107310,(%esp)
80103a75:	e8 e6 c8 ff ff       	call   80100360 <panic>
    panic("sched interruptible");
80103a7a:	c7 04 24 3c 73 10 80 	movl   $0x8010733c,(%esp)
80103a81:	e8 da c8 ff ff       	call   80100360 <panic>
    panic("sched running");
80103a86:	c7 04 24 2e 73 10 80 	movl   $0x8010732e,(%esp)
80103a8d:	e8 ce c8 ff ff       	call   80100360 <panic>
    panic("sched locks");
80103a92:	c7 04 24 22 73 10 80 	movl   $0x80107322,(%esp)
80103a99:	e8 c2 c8 ff ff       	call   80100360 <panic>
80103a9e:	66 90                	xchg   %ax,%ax

80103aa0 <exit>:
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	56                   	push   %esi
  if(curproc == initproc)
80103aa4:	31 f6                	xor    %esi,%esi
{
80103aa6:	53                   	push   %ebx
80103aa7:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103aaa:	e8 f1 fb ff ff       	call   801036a0 <myproc>
  if(curproc == initproc)
80103aaf:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
  struct proc *curproc = myproc();
80103ab5:	89 c3                	mov    %eax,%ebx
  if(curproc == initproc)
80103ab7:	0f 84 ea 00 00 00    	je     80103ba7 <exit+0x107>
80103abd:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103ac0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ac4:	85 c0                	test   %eax,%eax
80103ac6:	74 10                	je     80103ad8 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103ac8:	89 04 24             	mov    %eax,(%esp)
80103acb:	e8 60 d3 ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103ad0:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103ad7:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103ad8:	83 c6 01             	add    $0x1,%esi
80103adb:	83 fe 10             	cmp    $0x10,%esi
80103ade:	75 e0                	jne    80103ac0 <exit+0x20>
  begin_op();
80103ae0:	e8 2b f0 ff ff       	call   80102b10 <begin_op>
  iput(curproc->cwd);
80103ae5:	8b 43 68             	mov    0x68(%ebx),%eax
80103ae8:	89 04 24             	mov    %eax,(%esp)
80103aeb:	e8 e0 dc ff ff       	call   801017d0 <iput>
  end_op();
80103af0:	e8 8b f0 ff ff       	call   80102b80 <end_op>
  curproc->cwd = 0;
80103af5:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103afc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b03:	e8 f8 07 00 00       	call   80104300 <acquire>
  wakeup1(curproc->parent);
80103b08:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b0b:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b10:	eb 11                	jmp    80103b23 <exit+0x83>
80103b12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b18:	83 ea 80             	sub    $0xffffff80,%edx
80103b1b:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103b21:	74 1d                	je     80103b40 <exit+0xa0>
    if(p->state == SLEEPING && p->chan == chan)
80103b23:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103b27:	75 ef                	jne    80103b18 <exit+0x78>
80103b29:	3b 42 20             	cmp    0x20(%edx),%eax
80103b2c:	75 ea                	jne    80103b18 <exit+0x78>
      p->state = RUNNABLE;
80103b2e:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b35:	83 ea 80             	sub    $0xffffff80,%edx
80103b38:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103b3e:	75 e3                	jne    80103b23 <exit+0x83>
      p->parent = initproc;
80103b40:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103b45:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103b4a:	eb 0f                	jmp    80103b5b <exit+0xbb>
80103b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b50:	83 e9 80             	sub    $0xffffff80,%ecx
80103b53:	81 f9 54 4d 11 80    	cmp    $0x80114d54,%ecx
80103b59:	74 34                	je     80103b8f <exit+0xef>
    if(p->parent == curproc){
80103b5b:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103b5e:	75 f0                	jne    80103b50 <exit+0xb0>
      if(p->state == ZOMBIE)
80103b60:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
      p->parent = initproc;
80103b64:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103b67:	75 e7                	jne    80103b50 <exit+0xb0>
80103b69:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b6e:	eb 0b                	jmp    80103b7b <exit+0xdb>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b70:	83 ea 80             	sub    $0xffffff80,%edx
80103b73:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103b79:	74 d5                	je     80103b50 <exit+0xb0>
    if(p->state == SLEEPING && p->chan == chan)
80103b7b:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103b7f:	75 ef                	jne    80103b70 <exit+0xd0>
80103b81:	3b 42 20             	cmp    0x20(%edx),%eax
80103b84:	75 ea                	jne    80103b70 <exit+0xd0>
      p->state = RUNNABLE;
80103b86:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103b8d:	eb e1                	jmp    80103b70 <exit+0xd0>
  curproc->state = ZOMBIE;
80103b8f:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103b96:	e8 65 fe ff ff       	call   80103a00 <sched>
  panic("zombie exit");
80103b9b:	c7 04 24 5d 73 10 80 	movl   $0x8010735d,(%esp)
80103ba2:	e8 b9 c7 ff ff       	call   80100360 <panic>
    panic("init exiting");
80103ba7:	c7 04 24 50 73 10 80 	movl   $0x80107350,(%esp)
80103bae:	e8 ad c7 ff ff       	call   80100360 <panic>
80103bb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103bc0 <exitS>:
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	56                   	push   %esi
  if(curproc == initproc)
80103bc4:	31 f6                	xor    %esi,%esi
{
80103bc6:	53                   	push   %ebx
80103bc7:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103bca:	e8 d1 fa ff ff       	call   801036a0 <myproc>
  if(curproc == initproc)
80103bcf:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
  struct proc *curproc = myproc();
80103bd5:	89 c3                	mov    %eax,%ebx
  if(curproc == initproc)
80103bd7:	0f 84 f0 00 00 00    	je     80103ccd <exitS+0x10d>
80103bdd:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103be0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103be4:	85 c0                	test   %eax,%eax
80103be6:	74 10                	je     80103bf8 <exitS+0x38>
      fileclose(curproc->ofile[fd]);
80103be8:	89 04 24             	mov    %eax,(%esp)
80103beb:	e8 40 d2 ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103bf0:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103bf7:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103bf8:	83 c6 01             	add    $0x1,%esi
80103bfb:	83 fe 10             	cmp    $0x10,%esi
80103bfe:	75 e0                	jne    80103be0 <exitS+0x20>
  begin_op();
80103c00:	e8 0b ef ff ff       	call   80102b10 <begin_op>
  iput(curproc->cwd);
80103c05:	8b 43 68             	mov    0x68(%ebx),%eax
80103c08:	89 04 24             	mov    %eax,(%esp)
80103c0b:	e8 c0 db ff ff       	call   801017d0 <iput>
  end_op();
80103c10:	e8 6b ef ff ff       	call   80102b80 <end_op>
  curproc->cwd = 0;
80103c15:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103c1c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c23:	e8 d8 06 00 00       	call   80104300 <acquire>
  wakeup1(curproc->parent);
80103c28:	8b 43 14             	mov    0x14(%ebx),%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c2b:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103c30:	eb 11                	jmp    80103c43 <exitS+0x83>
80103c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c38:	83 ea 80             	sub    $0xffffff80,%edx
80103c3b:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103c41:	74 1d                	je     80103c60 <exitS+0xa0>
    if(p->state == SLEEPING && p->chan == chan)
80103c43:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103c47:	75 ef                	jne    80103c38 <exitS+0x78>
80103c49:	3b 42 20             	cmp    0x20(%edx),%eax
80103c4c:	75 ea                	jne    80103c38 <exitS+0x78>
      p->state = RUNNABLE;
80103c4e:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c55:	83 ea 80             	sub    $0xffffff80,%edx
80103c58:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103c5e:	75 e3                	jne    80103c43 <exitS+0x83>
      p->parent = initproc;
80103c60:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103c65:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103c6a:	eb 0f                	jmp    80103c7b <exitS+0xbb>
80103c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c70:	83 e9 80             	sub    $0xffffff80,%ecx
80103c73:	81 f9 54 4d 11 80    	cmp    $0x80114d54,%ecx
80103c79:	74 34                	je     80103caf <exitS+0xef>
    if(p->parent == curproc){
80103c7b:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103c7e:	75 f0                	jne    80103c70 <exitS+0xb0>
      if(p->state == ZOMBIE)
80103c80:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
      p->parent = initproc;
80103c84:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103c87:	75 e7                	jne    80103c70 <exitS+0xb0>
80103c89:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103c8e:	eb 0b                	jmp    80103c9b <exitS+0xdb>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c90:	83 ea 80             	sub    $0xffffff80,%edx
80103c93:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103c99:	74 d5                	je     80103c70 <exitS+0xb0>
    if(p->state == SLEEPING && p->chan == chan)
80103c9b:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103c9f:	75 ef                	jne    80103c90 <exitS+0xd0>
80103ca1:	3b 42 20             	cmp    0x20(%edx),%eax
80103ca4:	75 ea                	jne    80103c90 <exitS+0xd0>
      p->state = RUNNABLE;
80103ca6:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103cad:	eb e1                	jmp    80103c90 <exitS+0xd0>
  curproc->exitStat = passedExitStat;
80103caf:	8b 45 08             	mov    0x8(%ebp),%eax
  curproc->state = ZOMBIE;
80103cb2:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  curproc->exitStat = passedExitStat;
80103cb9:	89 43 7c             	mov    %eax,0x7c(%ebx)
  sched();
80103cbc:	e8 3f fd ff ff       	call   80103a00 <sched>
  panic("zombie exit");
80103cc1:	c7 04 24 5d 73 10 80 	movl   $0x8010735d,(%esp)
80103cc8:	e8 93 c6 ff ff       	call   80100360 <panic>
    panic("init exiting");
80103ccd:	c7 04 24 50 73 10 80 	movl   $0x80107350,(%esp)
80103cd4:	e8 87 c6 ff ff       	call   80100360 <panic>
80103cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ce0 <yield>:
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103ce6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ced:	e8 0e 06 00 00       	call   80104300 <acquire>
  myproc()->state = RUNNABLE;
80103cf2:	e8 a9 f9 ff ff       	call   801036a0 <myproc>
80103cf7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103cfe:	e8 fd fc ff ff       	call   80103a00 <sched>
  release(&ptable.lock);
80103d03:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d0a:	e8 61 06 00 00       	call   80104370 <release>
}
80103d0f:	c9                   	leave  
80103d10:	c3                   	ret    
80103d11:	eb 0d                	jmp    80103d20 <sleep>
80103d13:	90                   	nop
80103d14:	90                   	nop
80103d15:	90                   	nop
80103d16:	90                   	nop
80103d17:	90                   	nop
80103d18:	90                   	nop
80103d19:	90                   	nop
80103d1a:	90                   	nop
80103d1b:	90                   	nop
80103d1c:	90                   	nop
80103d1d:	90                   	nop
80103d1e:	90                   	nop
80103d1f:	90                   	nop

80103d20 <sleep>:
{
80103d20:	55                   	push   %ebp
80103d21:	89 e5                	mov    %esp,%ebp
80103d23:	57                   	push   %edi
80103d24:	56                   	push   %esi
80103d25:	53                   	push   %ebx
80103d26:	83 ec 1c             	sub    $0x1c,%esp
80103d29:	8b 7d 08             	mov    0x8(%ebp),%edi
80103d2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103d2f:	e8 6c f9 ff ff       	call   801036a0 <myproc>
  if(p == 0)
80103d34:	85 c0                	test   %eax,%eax
  struct proc *p = myproc();
80103d36:	89 c3                	mov    %eax,%ebx
  if(p == 0)
80103d38:	0f 84 7c 00 00 00    	je     80103dba <sleep+0x9a>
  if(lk == 0)
80103d3e:	85 f6                	test   %esi,%esi
80103d40:	74 6c                	je     80103dae <sleep+0x8e>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103d42:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103d48:	74 46                	je     80103d90 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103d4a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d51:	e8 aa 05 00 00       	call   80104300 <acquire>
    release(lk);
80103d56:	89 34 24             	mov    %esi,(%esp)
80103d59:	e8 12 06 00 00       	call   80104370 <release>
  p->chan = chan;
80103d5e:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103d61:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103d68:	e8 93 fc ff ff       	call   80103a00 <sched>
  p->chan = 0;
80103d6d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103d74:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d7b:	e8 f0 05 00 00       	call   80104370 <release>
    acquire(lk);
80103d80:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103d83:	83 c4 1c             	add    $0x1c,%esp
80103d86:	5b                   	pop    %ebx
80103d87:	5e                   	pop    %esi
80103d88:	5f                   	pop    %edi
80103d89:	5d                   	pop    %ebp
    acquire(lk);
80103d8a:	e9 71 05 00 00       	jmp    80104300 <acquire>
80103d8f:	90                   	nop
  p->chan = chan;
80103d90:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103d93:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103d9a:	e8 61 fc ff ff       	call   80103a00 <sched>
  p->chan = 0;
80103d9f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103da6:	83 c4 1c             	add    $0x1c,%esp
80103da9:	5b                   	pop    %ebx
80103daa:	5e                   	pop    %esi
80103dab:	5f                   	pop    %edi
80103dac:	5d                   	pop    %ebp
80103dad:	c3                   	ret    
    panic("sleep without lk");
80103dae:	c7 04 24 6f 73 10 80 	movl   $0x8010736f,(%esp)
80103db5:	e8 a6 c5 ff ff       	call   80100360 <panic>
    panic("sleep");
80103dba:	c7 04 24 69 73 10 80 	movl   $0x80107369,(%esp)
80103dc1:	e8 9a c5 ff ff       	call   80100360 <panic>
80103dc6:	8d 76 00             	lea    0x0(%esi),%esi
80103dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103dd0 <wait>:
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	56                   	push   %esi
80103dd4:	53                   	push   %ebx
80103dd5:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103dd8:	e8 c3 f8 ff ff       	call   801036a0 <myproc>
  acquire(&ptable.lock);
80103ddd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *curproc = myproc();
80103de4:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103de6:	e8 15 05 00 00       	call   80104300 <acquire>
    havekids = 0;
80103deb:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ded:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103df2:	eb 0f                	jmp    80103e03 <wait+0x33>
80103df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103df8:	83 eb 80             	sub    $0xffffff80,%ebx
80103dfb:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103e01:	74 1d                	je     80103e20 <wait+0x50>
      if(p->parent != curproc)
80103e03:	39 73 14             	cmp    %esi,0x14(%ebx)
80103e06:	75 f0                	jne    80103df8 <wait+0x28>
      if(p->state == ZOMBIE){
80103e08:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103e0c:	74 2f                	je     80103e3d <wait+0x6d>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e0e:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80103e11:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e16:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103e1c:	75 e5                	jne    80103e03 <wait+0x33>
80103e1e:	66 90                	xchg   %ax,%ax
    if(!havekids || curproc->killed){
80103e20:	85 c0                	test   %eax,%eax
80103e22:	74 6e                	je     80103e92 <wait+0xc2>
80103e24:	8b 46 24             	mov    0x24(%esi),%eax
80103e27:	85 c0                	test   %eax,%eax
80103e29:	75 67                	jne    80103e92 <wait+0xc2>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103e2b:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103e32:	80 
80103e33:	89 34 24             	mov    %esi,(%esp)
80103e36:	e8 e5 fe ff ff       	call   80103d20 <sleep>
  }
80103e3b:	eb ae                	jmp    80103deb <wait+0x1b>
        kfree(p->kstack);
80103e3d:	8b 43 08             	mov    0x8(%ebx),%eax
        pid = p->pid;
80103e40:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103e43:	89 04 24             	mov    %eax,(%esp)
80103e46:	e8 a5 e4 ff ff       	call   801022f0 <kfree>
        freevm(p->pgdir);
80103e4b:	8b 43 04             	mov    0x4(%ebx),%eax
        p->kstack = 0;
80103e4e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103e55:	89 04 24             	mov    %eax,(%esp)
80103e58:	e8 f3 2b 00 00       	call   80106a50 <freevm>
        release(&ptable.lock);
80103e5d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103e64:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103e6b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103e72:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103e76:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103e7d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103e84:	e8 e7 04 00 00       	call   80104370 <release>
}
80103e89:	83 c4 10             	add    $0x10,%esp
        return pid;
80103e8c:	89 f0                	mov    %esi,%eax
}
80103e8e:	5b                   	pop    %ebx
80103e8f:	5e                   	pop    %esi
80103e90:	5d                   	pop    %ebp
80103e91:	c3                   	ret    
      release(&ptable.lock);
80103e92:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e99:	e8 d2 04 00 00       	call   80104370 <release>
}
80103e9e:	83 c4 10             	add    $0x10,%esp
      return -1;
80103ea1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103ea6:	5b                   	pop    %ebx
80103ea7:	5e                   	pop    %esi
80103ea8:	5d                   	pop    %ebp
80103ea9:	c3                   	ret    
80103eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103eb0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	53                   	push   %ebx
80103eb4:	83 ec 14             	sub    $0x14,%esp
80103eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103eba:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ec1:	e8 3a 04 00 00       	call   80104300 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ec6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103ecb:	eb 0d                	jmp    80103eda <wakeup+0x2a>
80103ecd:	8d 76 00             	lea    0x0(%esi),%esi
80103ed0:	83 e8 80             	sub    $0xffffff80,%eax
80103ed3:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103ed8:	74 1e                	je     80103ef8 <wakeup+0x48>
    if(p->state == SLEEPING && p->chan == chan)
80103eda:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ede:	75 f0                	jne    80103ed0 <wakeup+0x20>
80103ee0:	3b 58 20             	cmp    0x20(%eax),%ebx
80103ee3:	75 eb                	jne    80103ed0 <wakeup+0x20>
      p->state = RUNNABLE;
80103ee5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103eec:	83 e8 80             	sub    $0xffffff80,%eax
80103eef:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103ef4:	75 e4                	jne    80103eda <wakeup+0x2a>
80103ef6:	66 90                	xchg   %ax,%ax
  wakeup1(chan);
  release(&ptable.lock);
80103ef8:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103eff:	83 c4 14             	add    $0x14,%esp
80103f02:	5b                   	pop    %ebx
80103f03:	5d                   	pop    %ebp
  release(&ptable.lock);
80103f04:	e9 67 04 00 00       	jmp    80104370 <release>
80103f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f10 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	53                   	push   %ebx
80103f14:	83 ec 14             	sub    $0x14,%esp
80103f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103f1a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f21:	e8 da 03 00 00       	call   80104300 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f26:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f2b:	eb 0d                	jmp    80103f3a <kill+0x2a>
80103f2d:	8d 76 00             	lea    0x0(%esi),%esi
80103f30:	83 e8 80             	sub    $0xffffff80,%eax
80103f33:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103f38:	74 36                	je     80103f70 <kill+0x60>
    if(p->pid == pid){
80103f3a:	39 58 10             	cmp    %ebx,0x10(%eax)
80103f3d:	75 f1                	jne    80103f30 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f3f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80103f43:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80103f4a:	74 14                	je     80103f60 <kill+0x50>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103f4c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f53:	e8 18 04 00 00       	call   80104370 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103f58:	83 c4 14             	add    $0x14,%esp
      return 0;
80103f5b:	31 c0                	xor    %eax,%eax
}
80103f5d:	5b                   	pop    %ebx
80103f5e:	5d                   	pop    %ebp
80103f5f:	c3                   	ret    
        p->state = RUNNABLE;
80103f60:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f67:	eb e3                	jmp    80103f4c <kill+0x3c>
80103f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103f70:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f77:	e8 f4 03 00 00       	call   80104370 <release>
}
80103f7c:	83 c4 14             	add    $0x14,%esp
  return -1;
80103f7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f84:	5b                   	pop    %ebx
80103f85:	5d                   	pop    %ebp
80103f86:	c3                   	ret    
80103f87:	89 f6                	mov    %esi,%esi
80103f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f90 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	57                   	push   %edi
80103f94:	56                   	push   %esi
80103f95:	53                   	push   %ebx
80103f96:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80103f9b:	83 ec 4c             	sub    $0x4c,%esp
80103f9e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103fa1:	eb 20                	jmp    80103fc3 <procdump+0x33>
80103fa3:	90                   	nop
80103fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103fa8:	c7 04 24 fb 76 10 80 	movl   $0x801076fb,(%esp)
80103faf:	e8 9c c6 ff ff       	call   80100650 <cprintf>
80103fb4:	83 eb 80             	sub    $0xffffff80,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fb7:	81 fb c0 4d 11 80    	cmp    $0x80114dc0,%ebx
80103fbd:	0f 84 8d 00 00 00    	je     80104050 <procdump+0xc0>
    if(p->state == UNUSED)
80103fc3:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103fc6:	85 c0                	test   %eax,%eax
80103fc8:	74 ea                	je     80103fb4 <procdump+0x24>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103fca:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80103fcd:	ba 80 73 10 80       	mov    $0x80107380,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103fd2:	77 11                	ja     80103fe5 <procdump+0x55>
80103fd4:	8b 14 85 e0 73 10 80 	mov    -0x7fef8c20(,%eax,4),%edx
      state = "???";
80103fdb:	b8 80 73 10 80       	mov    $0x80107380,%eax
80103fe0:	85 d2                	test   %edx,%edx
80103fe2:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103fe5:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103fe8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103fec:	89 54 24 08          	mov    %edx,0x8(%esp)
80103ff0:	c7 04 24 84 73 10 80 	movl   $0x80107384,(%esp)
80103ff7:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ffb:	e8 50 c6 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80104000:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104004:	75 a2                	jne    80103fa8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104006:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104009:	89 44 24 04          	mov    %eax,0x4(%esp)
8010400d:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104010:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104013:	8b 40 0c             	mov    0xc(%eax),%eax
80104016:	83 c0 08             	add    $0x8,%eax
80104019:	89 04 24             	mov    %eax,(%esp)
8010401c:	e8 8f 01 00 00       	call   801041b0 <getcallerpcs>
80104021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104028:	8b 17                	mov    (%edi),%edx
8010402a:	85 d2                	test   %edx,%edx
8010402c:	0f 84 76 ff ff ff    	je     80103fa8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104032:	89 54 24 04          	mov    %edx,0x4(%esp)
80104036:	83 c7 04             	add    $0x4,%edi
80104039:	c7 04 24 c1 6d 10 80 	movl   $0x80106dc1,(%esp)
80104040:	e8 0b c6 ff ff       	call   80100650 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104045:	39 f7                	cmp    %esi,%edi
80104047:	75 df                	jne    80104028 <procdump+0x98>
80104049:	e9 5a ff ff ff       	jmp    80103fa8 <procdump+0x18>
8010404e:	66 90                	xchg   %ax,%ax
  }
}
80104050:	83 c4 4c             	add    $0x4c,%esp
80104053:	5b                   	pop    %ebx
80104054:	5e                   	pop    %esi
80104055:	5f                   	pop    %edi
80104056:	5d                   	pop    %ebp
80104057:	c3                   	ret    
80104058:	66 90                	xchg   %ax,%ax
8010405a:	66 90                	xchg   %ax,%ax
8010405c:	66 90                	xchg   %ax,%ax
8010405e:	66 90                	xchg   %ax,%ax

80104060 <initsleeplock>:
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	53                   	push   %ebx
80104064:	83 ec 14             	sub    $0x14,%esp
80104067:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010406a:	c7 44 24 04 f8 73 10 	movl   $0x801073f8,0x4(%esp)
80104071:	80 
80104072:	8d 43 04             	lea    0x4(%ebx),%eax
80104075:	89 04 24             	mov    %eax,(%esp)
80104078:	e8 13 01 00 00       	call   80104190 <initlock>
8010407d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104080:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104086:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
8010408d:	89 43 38             	mov    %eax,0x38(%ebx)
80104090:	83 c4 14             	add    $0x14,%esp
80104093:	5b                   	pop    %ebx
80104094:	5d                   	pop    %ebp
80104095:	c3                   	ret    
80104096:	8d 76 00             	lea    0x0(%esi),%esi
80104099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040a0 <acquiresleep>:
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	56                   	push   %esi
801040a4:	53                   	push   %ebx
801040a5:	83 ec 10             	sub    $0x10,%esp
801040a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801040ab:	8d 73 04             	lea    0x4(%ebx),%esi
801040ae:	89 34 24             	mov    %esi,(%esp)
801040b1:	e8 4a 02 00 00       	call   80104300 <acquire>
801040b6:	8b 13                	mov    (%ebx),%edx
801040b8:	85 d2                	test   %edx,%edx
801040ba:	74 16                	je     801040d2 <acquiresleep+0x32>
801040bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040c0:	89 74 24 04          	mov    %esi,0x4(%esp)
801040c4:	89 1c 24             	mov    %ebx,(%esp)
801040c7:	e8 54 fc ff ff       	call   80103d20 <sleep>
801040cc:	8b 03                	mov    (%ebx),%eax
801040ce:	85 c0                	test   %eax,%eax
801040d0:	75 ee                	jne    801040c0 <acquiresleep+0x20>
801040d2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
801040d8:	e8 c3 f5 ff ff       	call   801036a0 <myproc>
801040dd:	8b 40 10             	mov    0x10(%eax),%eax
801040e0:	89 43 3c             	mov    %eax,0x3c(%ebx)
801040e3:	89 75 08             	mov    %esi,0x8(%ebp)
801040e6:	83 c4 10             	add    $0x10,%esp
801040e9:	5b                   	pop    %ebx
801040ea:	5e                   	pop    %esi
801040eb:	5d                   	pop    %ebp
801040ec:	e9 7f 02 00 00       	jmp    80104370 <release>
801040f1:	eb 0d                	jmp    80104100 <releasesleep>
801040f3:	90                   	nop
801040f4:	90                   	nop
801040f5:	90                   	nop
801040f6:	90                   	nop
801040f7:	90                   	nop
801040f8:	90                   	nop
801040f9:	90                   	nop
801040fa:	90                   	nop
801040fb:	90                   	nop
801040fc:	90                   	nop
801040fd:	90                   	nop
801040fe:	90                   	nop
801040ff:	90                   	nop

80104100 <releasesleep>:
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	56                   	push   %esi
80104104:	53                   	push   %ebx
80104105:	83 ec 10             	sub    $0x10,%esp
80104108:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010410b:	8d 73 04             	lea    0x4(%ebx),%esi
8010410e:	89 34 24             	mov    %esi,(%esp)
80104111:	e8 ea 01 00 00       	call   80104300 <acquire>
80104116:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010411c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
80104123:	89 1c 24             	mov    %ebx,(%esp)
80104126:	e8 85 fd ff ff       	call   80103eb0 <wakeup>
8010412b:	89 75 08             	mov    %esi,0x8(%ebp)
8010412e:	83 c4 10             	add    $0x10,%esp
80104131:	5b                   	pop    %ebx
80104132:	5e                   	pop    %esi
80104133:	5d                   	pop    %ebp
80104134:	e9 37 02 00 00       	jmp    80104370 <release>
80104139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104140 <holdingsleep>:
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	57                   	push   %edi
80104144:	31 ff                	xor    %edi,%edi
80104146:	56                   	push   %esi
80104147:	53                   	push   %ebx
80104148:	83 ec 1c             	sub    $0x1c,%esp
8010414b:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010414e:	8d 73 04             	lea    0x4(%ebx),%esi
80104151:	89 34 24             	mov    %esi,(%esp)
80104154:	e8 a7 01 00 00       	call   80104300 <acquire>
80104159:	8b 03                	mov    (%ebx),%eax
8010415b:	85 c0                	test   %eax,%eax
8010415d:	74 13                	je     80104172 <holdingsleep+0x32>
8010415f:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104162:	e8 39 f5 ff ff       	call   801036a0 <myproc>
80104167:	3b 58 10             	cmp    0x10(%eax),%ebx
8010416a:	0f 94 c0             	sete   %al
8010416d:	0f b6 c0             	movzbl %al,%eax
80104170:	89 c7                	mov    %eax,%edi
80104172:	89 34 24             	mov    %esi,(%esp)
80104175:	e8 f6 01 00 00       	call   80104370 <release>
8010417a:	83 c4 1c             	add    $0x1c,%esp
8010417d:	89 f8                	mov    %edi,%eax
8010417f:	5b                   	pop    %ebx
80104180:	5e                   	pop    %esi
80104181:	5f                   	pop    %edi
80104182:	5d                   	pop    %ebp
80104183:	c3                   	ret    
80104184:	66 90                	xchg   %ax,%ax
80104186:	66 90                	xchg   %ax,%ax
80104188:	66 90                	xchg   %ax,%ax
8010418a:	66 90                	xchg   %ax,%ax
8010418c:	66 90                	xchg   %ax,%ax
8010418e:	66 90                	xchg   %ax,%ax

80104190 <initlock>:
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	8b 45 08             	mov    0x8(%ebp),%eax
80104196:	8b 55 0c             	mov    0xc(%ebp),%edx
80104199:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010419f:	89 50 04             	mov    %edx,0x4(%eax)
801041a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
801041a9:	5d                   	pop    %ebp
801041aa:	c3                   	ret    
801041ab:	90                   	nop
801041ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801041b0 <getcallerpcs>:
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	8b 45 08             	mov    0x8(%ebp),%eax
801041b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801041b9:	53                   	push   %ebx
801041ba:	8d 50 f8             	lea    -0x8(%eax),%edx
801041bd:	31 c0                	xor    %eax,%eax
801041bf:	90                   	nop
801041c0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801041c6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801041cc:	77 1a                	ja     801041e8 <getcallerpcs+0x38>
801041ce:	8b 5a 04             	mov    0x4(%edx),%ebx
801041d1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
801041d4:	83 c0 01             	add    $0x1,%eax
801041d7:	8b 12                	mov    (%edx),%edx
801041d9:	83 f8 0a             	cmp    $0xa,%eax
801041dc:	75 e2                	jne    801041c0 <getcallerpcs+0x10>
801041de:	5b                   	pop    %ebx
801041df:	5d                   	pop    %ebp
801041e0:	c3                   	ret    
801041e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041e8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
801041ef:	83 c0 01             	add    $0x1,%eax
801041f2:	83 f8 0a             	cmp    $0xa,%eax
801041f5:	74 e7                	je     801041de <getcallerpcs+0x2e>
801041f7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
801041fe:	83 c0 01             	add    $0x1,%eax
80104201:	83 f8 0a             	cmp    $0xa,%eax
80104204:	75 e2                	jne    801041e8 <getcallerpcs+0x38>
80104206:	eb d6                	jmp    801041de <getcallerpcs+0x2e>
80104208:	90                   	nop
80104209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104210 <pushcli>:
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	53                   	push   %ebx
80104214:	83 ec 04             	sub    $0x4,%esp
80104217:	9c                   	pushf  
80104218:	5b                   	pop    %ebx
80104219:	fa                   	cli    
8010421a:	e8 e1 f3 ff ff       	call   80103600 <mycpu>
8010421f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104225:	85 c0                	test   %eax,%eax
80104227:	75 11                	jne    8010423a <pushcli+0x2a>
80104229:	e8 d2 f3 ff ff       	call   80103600 <mycpu>
8010422e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104234:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
8010423a:	e8 c1 f3 ff ff       	call   80103600 <mycpu>
8010423f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
80104246:	83 c4 04             	add    $0x4,%esp
80104249:	5b                   	pop    %ebx
8010424a:	5d                   	pop    %ebp
8010424b:	c3                   	ret    
8010424c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104250 <popcli>:
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	83 ec 18             	sub    $0x18,%esp
80104256:	9c                   	pushf  
80104257:	58                   	pop    %eax
80104258:	f6 c4 02             	test   $0x2,%ah
8010425b:	75 49                	jne    801042a6 <popcli+0x56>
8010425d:	e8 9e f3 ff ff       	call   80103600 <mycpu>
80104262:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104268:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010426b:	85 d2                	test   %edx,%edx
8010426d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104273:	78 25                	js     8010429a <popcli+0x4a>
80104275:	e8 86 f3 ff ff       	call   80103600 <mycpu>
8010427a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104280:	85 d2                	test   %edx,%edx
80104282:	74 04                	je     80104288 <popcli+0x38>
80104284:	c9                   	leave  
80104285:	c3                   	ret    
80104286:	66 90                	xchg   %ax,%ax
80104288:	e8 73 f3 ff ff       	call   80103600 <mycpu>
8010428d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104293:	85 c0                	test   %eax,%eax
80104295:	74 ed                	je     80104284 <popcli+0x34>
80104297:	fb                   	sti    
80104298:	c9                   	leave  
80104299:	c3                   	ret    
8010429a:	c7 04 24 1a 74 10 80 	movl   $0x8010741a,(%esp)
801042a1:	e8 ba c0 ff ff       	call   80100360 <panic>
801042a6:	c7 04 24 03 74 10 80 	movl   $0x80107403,(%esp)
801042ad:	e8 ae c0 ff ff       	call   80100360 <panic>
801042b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042c0 <holding>:
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	56                   	push   %esi
801042c4:	31 f6                	xor    %esi,%esi
801042c6:	53                   	push   %ebx
801042c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
801042ca:	e8 41 ff ff ff       	call   80104210 <pushcli>
801042cf:	8b 03                	mov    (%ebx),%eax
801042d1:	85 c0                	test   %eax,%eax
801042d3:	74 12                	je     801042e7 <holding+0x27>
801042d5:	8b 5b 08             	mov    0x8(%ebx),%ebx
801042d8:	e8 23 f3 ff ff       	call   80103600 <mycpu>
801042dd:	39 c3                	cmp    %eax,%ebx
801042df:	0f 94 c0             	sete   %al
801042e2:	0f b6 c0             	movzbl %al,%eax
801042e5:	89 c6                	mov    %eax,%esi
801042e7:	e8 64 ff ff ff       	call   80104250 <popcli>
801042ec:	89 f0                	mov    %esi,%eax
801042ee:	5b                   	pop    %ebx
801042ef:	5e                   	pop    %esi
801042f0:	5d                   	pop    %ebp
801042f1:	c3                   	ret    
801042f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104300 <acquire>:
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	53                   	push   %ebx
80104304:	83 ec 14             	sub    $0x14,%esp
80104307:	e8 04 ff ff ff       	call   80104210 <pushcli>
8010430c:	8b 45 08             	mov    0x8(%ebp),%eax
8010430f:	89 04 24             	mov    %eax,(%esp)
80104312:	e8 a9 ff ff ff       	call   801042c0 <holding>
80104317:	85 c0                	test   %eax,%eax
80104319:	75 3a                	jne    80104355 <acquire+0x55>
8010431b:	b9 01 00 00 00       	mov    $0x1,%ecx
80104320:	8b 55 08             	mov    0x8(%ebp),%edx
80104323:	89 c8                	mov    %ecx,%eax
80104325:	f0 87 02             	lock xchg %eax,(%edx)
80104328:	85 c0                	test   %eax,%eax
8010432a:	75 f4                	jne    80104320 <acquire+0x20>
8010432c:	0f ae f0             	mfence 
8010432f:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104332:	e8 c9 f2 ff ff       	call   80103600 <mycpu>
80104337:	89 43 08             	mov    %eax,0x8(%ebx)
8010433a:	8b 45 08             	mov    0x8(%ebp),%eax
8010433d:	83 c0 0c             	add    $0xc,%eax
80104340:	89 44 24 04          	mov    %eax,0x4(%esp)
80104344:	8d 45 08             	lea    0x8(%ebp),%eax
80104347:	89 04 24             	mov    %eax,(%esp)
8010434a:	e8 61 fe ff ff       	call   801041b0 <getcallerpcs>
8010434f:	83 c4 14             	add    $0x14,%esp
80104352:	5b                   	pop    %ebx
80104353:	5d                   	pop    %ebp
80104354:	c3                   	ret    
80104355:	c7 04 24 21 74 10 80 	movl   $0x80107421,(%esp)
8010435c:	e8 ff bf ff ff       	call   80100360 <panic>
80104361:	eb 0d                	jmp    80104370 <release>
80104363:	90                   	nop
80104364:	90                   	nop
80104365:	90                   	nop
80104366:	90                   	nop
80104367:	90                   	nop
80104368:	90                   	nop
80104369:	90                   	nop
8010436a:	90                   	nop
8010436b:	90                   	nop
8010436c:	90                   	nop
8010436d:	90                   	nop
8010436e:	90                   	nop
8010436f:	90                   	nop

80104370 <release>:
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	53                   	push   %ebx
80104374:	83 ec 14             	sub    $0x14,%esp
80104377:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010437a:	89 1c 24             	mov    %ebx,(%esp)
8010437d:	e8 3e ff ff ff       	call   801042c0 <holding>
80104382:	85 c0                	test   %eax,%eax
80104384:	74 21                	je     801043a7 <release+0x37>
80104386:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
8010438d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
80104394:	0f ae f0             	mfence 
80104397:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010439d:	83 c4 14             	add    $0x14,%esp
801043a0:	5b                   	pop    %ebx
801043a1:	5d                   	pop    %ebp
801043a2:	e9 a9 fe ff ff       	jmp    80104250 <popcli>
801043a7:	c7 04 24 29 74 10 80 	movl   $0x80107429,(%esp)
801043ae:	e8 ad bf ff ff       	call   80100360 <panic>
801043b3:	66 90                	xchg   %ax,%ax
801043b5:	66 90                	xchg   %ax,%ax
801043b7:	66 90                	xchg   %ax,%ax
801043b9:	66 90                	xchg   %ax,%ax
801043bb:	66 90                	xchg   %ax,%ax
801043bd:	66 90                	xchg   %ax,%ax
801043bf:	90                   	nop

801043c0 <memset>:
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	8b 55 08             	mov    0x8(%ebp),%edx
801043c6:	57                   	push   %edi
801043c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801043ca:	53                   	push   %ebx
801043cb:	f6 c2 03             	test   $0x3,%dl
801043ce:	75 05                	jne    801043d5 <memset+0x15>
801043d0:	f6 c1 03             	test   $0x3,%cl
801043d3:	74 13                	je     801043e8 <memset+0x28>
801043d5:	89 d7                	mov    %edx,%edi
801043d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801043da:	fc                   	cld    
801043db:	f3 aa                	rep stos %al,%es:(%edi)
801043dd:	5b                   	pop    %ebx
801043de:	89 d0                	mov    %edx,%eax
801043e0:	5f                   	pop    %edi
801043e1:	5d                   	pop    %ebp
801043e2:	c3                   	ret    
801043e3:	90                   	nop
801043e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043e8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
801043ec:	c1 e9 02             	shr    $0x2,%ecx
801043ef:	89 f8                	mov    %edi,%eax
801043f1:	89 fb                	mov    %edi,%ebx
801043f3:	c1 e0 18             	shl    $0x18,%eax
801043f6:	c1 e3 10             	shl    $0x10,%ebx
801043f9:	09 d8                	or     %ebx,%eax
801043fb:	09 f8                	or     %edi,%eax
801043fd:	c1 e7 08             	shl    $0x8,%edi
80104400:	09 f8                	or     %edi,%eax
80104402:	89 d7                	mov    %edx,%edi
80104404:	fc                   	cld    
80104405:	f3 ab                	rep stos %eax,%es:(%edi)
80104407:	5b                   	pop    %ebx
80104408:	89 d0                	mov    %edx,%eax
8010440a:	5f                   	pop    %edi
8010440b:	5d                   	pop    %ebp
8010440c:	c3                   	ret    
8010440d:	8d 76 00             	lea    0x0(%esi),%esi

80104410 <memcmp>:
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	8b 45 10             	mov    0x10(%ebp),%eax
80104416:	57                   	push   %edi
80104417:	56                   	push   %esi
80104418:	8b 75 0c             	mov    0xc(%ebp),%esi
8010441b:	53                   	push   %ebx
8010441c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010441f:	85 c0                	test   %eax,%eax
80104421:	8d 78 ff             	lea    -0x1(%eax),%edi
80104424:	74 26                	je     8010444c <memcmp+0x3c>
80104426:	0f b6 03             	movzbl (%ebx),%eax
80104429:	31 d2                	xor    %edx,%edx
8010442b:	0f b6 0e             	movzbl (%esi),%ecx
8010442e:	38 c8                	cmp    %cl,%al
80104430:	74 16                	je     80104448 <memcmp+0x38>
80104432:	eb 24                	jmp    80104458 <memcmp+0x48>
80104434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104438:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010443d:	83 c2 01             	add    $0x1,%edx
80104440:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104444:	38 c8                	cmp    %cl,%al
80104446:	75 10                	jne    80104458 <memcmp+0x48>
80104448:	39 fa                	cmp    %edi,%edx
8010444a:	75 ec                	jne    80104438 <memcmp+0x28>
8010444c:	5b                   	pop    %ebx
8010444d:	31 c0                	xor    %eax,%eax
8010444f:	5e                   	pop    %esi
80104450:	5f                   	pop    %edi
80104451:	5d                   	pop    %ebp
80104452:	c3                   	ret    
80104453:	90                   	nop
80104454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104458:	5b                   	pop    %ebx
80104459:	29 c8                	sub    %ecx,%eax
8010445b:	5e                   	pop    %esi
8010445c:	5f                   	pop    %edi
8010445d:	5d                   	pop    %ebp
8010445e:	c3                   	ret    
8010445f:	90                   	nop

80104460 <memmove>:
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	57                   	push   %edi
80104464:	8b 45 08             	mov    0x8(%ebp),%eax
80104467:	56                   	push   %esi
80104468:	8b 75 0c             	mov    0xc(%ebp),%esi
8010446b:	53                   	push   %ebx
8010446c:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010446f:	39 c6                	cmp    %eax,%esi
80104471:	73 35                	jae    801044a8 <memmove+0x48>
80104473:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104476:	39 c8                	cmp    %ecx,%eax
80104478:	73 2e                	jae    801044a8 <memmove+0x48>
8010447a:	85 db                	test   %ebx,%ebx
8010447c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
8010447f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104482:	74 1b                	je     8010449f <memmove+0x3f>
80104484:	f7 db                	neg    %ebx
80104486:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104489:	01 fb                	add    %edi,%ebx
8010448b:	90                   	nop
8010448c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104490:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104494:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
80104497:	83 ea 01             	sub    $0x1,%edx
8010449a:	83 fa ff             	cmp    $0xffffffff,%edx
8010449d:	75 f1                	jne    80104490 <memmove+0x30>
8010449f:	5b                   	pop    %ebx
801044a0:	5e                   	pop    %esi
801044a1:	5f                   	pop    %edi
801044a2:	5d                   	pop    %ebp
801044a3:	c3                   	ret    
801044a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044a8:	31 d2                	xor    %edx,%edx
801044aa:	85 db                	test   %ebx,%ebx
801044ac:	74 f1                	je     8010449f <memmove+0x3f>
801044ae:	66 90                	xchg   %ax,%ax
801044b0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801044b4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801044b7:	83 c2 01             	add    $0x1,%edx
801044ba:	39 da                	cmp    %ebx,%edx
801044bc:	75 f2                	jne    801044b0 <memmove+0x50>
801044be:	5b                   	pop    %ebx
801044bf:	5e                   	pop    %esi
801044c0:	5f                   	pop    %edi
801044c1:	5d                   	pop    %ebp
801044c2:	c3                   	ret    
801044c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044d0 <memcpy>:
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	5d                   	pop    %ebp
801044d4:	eb 8a                	jmp    80104460 <memmove>
801044d6:	8d 76 00             	lea    0x0(%esi),%esi
801044d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044e0 <strncmp>:
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	56                   	push   %esi
801044e4:	8b 75 10             	mov    0x10(%ebp),%esi
801044e7:	53                   	push   %ebx
801044e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801044eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801044ee:	85 f6                	test   %esi,%esi
801044f0:	74 30                	je     80104522 <strncmp+0x42>
801044f2:	0f b6 01             	movzbl (%ecx),%eax
801044f5:	84 c0                	test   %al,%al
801044f7:	74 2f                	je     80104528 <strncmp+0x48>
801044f9:	0f b6 13             	movzbl (%ebx),%edx
801044fc:	38 d0                	cmp    %dl,%al
801044fe:	75 46                	jne    80104546 <strncmp+0x66>
80104500:	8d 51 01             	lea    0x1(%ecx),%edx
80104503:	01 ce                	add    %ecx,%esi
80104505:	eb 14                	jmp    8010451b <strncmp+0x3b>
80104507:	90                   	nop
80104508:	0f b6 02             	movzbl (%edx),%eax
8010450b:	84 c0                	test   %al,%al
8010450d:	74 31                	je     80104540 <strncmp+0x60>
8010450f:	0f b6 19             	movzbl (%ecx),%ebx
80104512:	83 c2 01             	add    $0x1,%edx
80104515:	38 d8                	cmp    %bl,%al
80104517:	75 17                	jne    80104530 <strncmp+0x50>
80104519:	89 cb                	mov    %ecx,%ebx
8010451b:	39 f2                	cmp    %esi,%edx
8010451d:	8d 4b 01             	lea    0x1(%ebx),%ecx
80104520:	75 e6                	jne    80104508 <strncmp+0x28>
80104522:	5b                   	pop    %ebx
80104523:	31 c0                	xor    %eax,%eax
80104525:	5e                   	pop    %esi
80104526:	5d                   	pop    %ebp
80104527:	c3                   	ret    
80104528:	0f b6 1b             	movzbl (%ebx),%ebx
8010452b:	31 c0                	xor    %eax,%eax
8010452d:	8d 76 00             	lea    0x0(%esi),%esi
80104530:	0f b6 d3             	movzbl %bl,%edx
80104533:	29 d0                	sub    %edx,%eax
80104535:	5b                   	pop    %ebx
80104536:	5e                   	pop    %esi
80104537:	5d                   	pop    %ebp
80104538:	c3                   	ret    
80104539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104540:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104544:	eb ea                	jmp    80104530 <strncmp+0x50>
80104546:	89 d3                	mov    %edx,%ebx
80104548:	eb e6                	jmp    80104530 <strncmp+0x50>
8010454a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104550 <strncpy>:
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	8b 45 08             	mov    0x8(%ebp),%eax
80104556:	56                   	push   %esi
80104557:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010455a:	53                   	push   %ebx
8010455b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010455e:	89 c2                	mov    %eax,%edx
80104560:	eb 19                	jmp    8010457b <strncpy+0x2b>
80104562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104568:	83 c3 01             	add    $0x1,%ebx
8010456b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010456f:	83 c2 01             	add    $0x1,%edx
80104572:	84 c9                	test   %cl,%cl
80104574:	88 4a ff             	mov    %cl,-0x1(%edx)
80104577:	74 09                	je     80104582 <strncpy+0x32>
80104579:	89 f1                	mov    %esi,%ecx
8010457b:	85 c9                	test   %ecx,%ecx
8010457d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104580:	7f e6                	jg     80104568 <strncpy+0x18>
80104582:	31 c9                	xor    %ecx,%ecx
80104584:	85 f6                	test   %esi,%esi
80104586:	7e 0f                	jle    80104597 <strncpy+0x47>
80104588:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010458c:	89 f3                	mov    %esi,%ebx
8010458e:	83 c1 01             	add    $0x1,%ecx
80104591:	29 cb                	sub    %ecx,%ebx
80104593:	85 db                	test   %ebx,%ebx
80104595:	7f f1                	jg     80104588 <strncpy+0x38>
80104597:	5b                   	pop    %ebx
80104598:	5e                   	pop    %esi
80104599:	5d                   	pop    %ebp
8010459a:	c3                   	ret    
8010459b:	90                   	nop
8010459c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045a0 <safestrcpy>:
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
801045a6:	56                   	push   %esi
801045a7:	8b 45 08             	mov    0x8(%ebp),%eax
801045aa:	53                   	push   %ebx
801045ab:	8b 55 0c             	mov    0xc(%ebp),%edx
801045ae:	85 c9                	test   %ecx,%ecx
801045b0:	7e 26                	jle    801045d8 <safestrcpy+0x38>
801045b2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801045b6:	89 c1                	mov    %eax,%ecx
801045b8:	eb 17                	jmp    801045d1 <safestrcpy+0x31>
801045ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045c0:	83 c2 01             	add    $0x1,%edx
801045c3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801045c7:	83 c1 01             	add    $0x1,%ecx
801045ca:	84 db                	test   %bl,%bl
801045cc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801045cf:	74 04                	je     801045d5 <safestrcpy+0x35>
801045d1:	39 f2                	cmp    %esi,%edx
801045d3:	75 eb                	jne    801045c0 <safestrcpy+0x20>
801045d5:	c6 01 00             	movb   $0x0,(%ecx)
801045d8:	5b                   	pop    %ebx
801045d9:	5e                   	pop    %esi
801045da:	5d                   	pop    %ebp
801045db:	c3                   	ret    
801045dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045e0 <strlen>:
801045e0:	55                   	push   %ebp
801045e1:	31 c0                	xor    %eax,%eax
801045e3:	89 e5                	mov    %esp,%ebp
801045e5:	8b 55 08             	mov    0x8(%ebp),%edx
801045e8:	80 3a 00             	cmpb   $0x0,(%edx)
801045eb:	74 0c                	je     801045f9 <strlen+0x19>
801045ed:	8d 76 00             	lea    0x0(%esi),%esi
801045f0:	83 c0 01             	add    $0x1,%eax
801045f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801045f7:	75 f7                	jne    801045f0 <strlen+0x10>
801045f9:	5d                   	pop    %ebp
801045fa:	c3                   	ret    

801045fb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801045fb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801045ff:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104603:	55                   	push   %ebp
  pushl %ebx
80104604:	53                   	push   %ebx
  pushl %esi
80104605:	56                   	push   %esi
  pushl %edi
80104606:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104607:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104609:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010460b:	5f                   	pop    %edi
  popl %esi
8010460c:	5e                   	pop    %esi
  popl %ebx
8010460d:	5b                   	pop    %ebx
  popl %ebp
8010460e:	5d                   	pop    %ebp
  ret
8010460f:	c3                   	ret    

80104610 <fetchint>:
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	53                   	push   %ebx
80104614:	83 ec 04             	sub    $0x4,%esp
80104617:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010461a:	e8 81 f0 ff ff       	call   801036a0 <myproc>
8010461f:	8b 00                	mov    (%eax),%eax
80104621:	39 d8                	cmp    %ebx,%eax
80104623:	76 1b                	jbe    80104640 <fetchint+0x30>
80104625:	8d 53 04             	lea    0x4(%ebx),%edx
80104628:	39 d0                	cmp    %edx,%eax
8010462a:	72 14                	jb     80104640 <fetchint+0x30>
8010462c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010462f:	8b 13                	mov    (%ebx),%edx
80104631:	89 10                	mov    %edx,(%eax)
80104633:	31 c0                	xor    %eax,%eax
80104635:	83 c4 04             	add    $0x4,%esp
80104638:	5b                   	pop    %ebx
80104639:	5d                   	pop    %ebp
8010463a:	c3                   	ret    
8010463b:	90                   	nop
8010463c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104640:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104645:	eb ee                	jmp    80104635 <fetchint+0x25>
80104647:	89 f6                	mov    %esi,%esi
80104649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104650 <fetchstr>:
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	53                   	push   %ebx
80104654:	83 ec 04             	sub    $0x4,%esp
80104657:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010465a:	e8 41 f0 ff ff       	call   801036a0 <myproc>
8010465f:	39 18                	cmp    %ebx,(%eax)
80104661:	76 26                	jbe    80104689 <fetchstr+0x39>
80104663:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104666:	89 da                	mov    %ebx,%edx
80104668:	89 19                	mov    %ebx,(%ecx)
8010466a:	8b 00                	mov    (%eax),%eax
8010466c:	39 c3                	cmp    %eax,%ebx
8010466e:	73 19                	jae    80104689 <fetchstr+0x39>
80104670:	80 3b 00             	cmpb   $0x0,(%ebx)
80104673:	75 0d                	jne    80104682 <fetchstr+0x32>
80104675:	eb 21                	jmp    80104698 <fetchstr+0x48>
80104677:	90                   	nop
80104678:	80 3a 00             	cmpb   $0x0,(%edx)
8010467b:	90                   	nop
8010467c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104680:	74 16                	je     80104698 <fetchstr+0x48>
80104682:	83 c2 01             	add    $0x1,%edx
80104685:	39 d0                	cmp    %edx,%eax
80104687:	77 ef                	ja     80104678 <fetchstr+0x28>
80104689:	83 c4 04             	add    $0x4,%esp
8010468c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104691:	5b                   	pop    %ebx
80104692:	5d                   	pop    %ebp
80104693:	c3                   	ret    
80104694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104698:	83 c4 04             	add    $0x4,%esp
8010469b:	89 d0                	mov    %edx,%eax
8010469d:	29 d8                	sub    %ebx,%eax
8010469f:	5b                   	pop    %ebx
801046a0:	5d                   	pop    %ebp
801046a1:	c3                   	ret    
801046a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046b0 <argint>:
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	56                   	push   %esi
801046b4:	8b 75 0c             	mov    0xc(%ebp),%esi
801046b7:	53                   	push   %ebx
801046b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046bb:	e8 e0 ef ff ff       	call   801036a0 <myproc>
801046c0:	89 75 0c             	mov    %esi,0xc(%ebp)
801046c3:	8b 40 18             	mov    0x18(%eax),%eax
801046c6:	8b 40 44             	mov    0x44(%eax),%eax
801046c9:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
801046cd:	89 45 08             	mov    %eax,0x8(%ebp)
801046d0:	5b                   	pop    %ebx
801046d1:	5e                   	pop    %esi
801046d2:	5d                   	pop    %ebp
801046d3:	e9 38 ff ff ff       	jmp    80104610 <fetchint>
801046d8:	90                   	nop
801046d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046e0 <argptr>:
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	56                   	push   %esi
801046e4:	53                   	push   %ebx
801046e5:	83 ec 20             	sub    $0x20,%esp
801046e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
801046eb:	e8 b0 ef ff ff       	call   801036a0 <myproc>
801046f0:	89 c6                	mov    %eax,%esi
801046f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801046f5:	89 44 24 04          	mov    %eax,0x4(%esp)
801046f9:	8b 45 08             	mov    0x8(%ebp),%eax
801046fc:	89 04 24             	mov    %eax,(%esp)
801046ff:	e8 ac ff ff ff       	call   801046b0 <argint>
80104704:	85 c0                	test   %eax,%eax
80104706:	78 28                	js     80104730 <argptr+0x50>
80104708:	85 db                	test   %ebx,%ebx
8010470a:	78 24                	js     80104730 <argptr+0x50>
8010470c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010470f:	8b 06                	mov    (%esi),%eax
80104711:	39 c2                	cmp    %eax,%edx
80104713:	73 1b                	jae    80104730 <argptr+0x50>
80104715:	01 d3                	add    %edx,%ebx
80104717:	39 d8                	cmp    %ebx,%eax
80104719:	72 15                	jb     80104730 <argptr+0x50>
8010471b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010471e:	89 10                	mov    %edx,(%eax)
80104720:	83 c4 20             	add    $0x20,%esp
80104723:	31 c0                	xor    %eax,%eax
80104725:	5b                   	pop    %ebx
80104726:	5e                   	pop    %esi
80104727:	5d                   	pop    %ebp
80104728:	c3                   	ret    
80104729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104730:	83 c4 20             	add    $0x20,%esp
80104733:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104738:	5b                   	pop    %ebx
80104739:	5e                   	pop    %esi
8010473a:	5d                   	pop    %ebp
8010473b:	c3                   	ret    
8010473c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104740 <argstr>:
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	83 ec 28             	sub    $0x28,%esp
80104746:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104749:	89 44 24 04          	mov    %eax,0x4(%esp)
8010474d:	8b 45 08             	mov    0x8(%ebp),%eax
80104750:	89 04 24             	mov    %eax,(%esp)
80104753:	e8 58 ff ff ff       	call   801046b0 <argint>
80104758:	85 c0                	test   %eax,%eax
8010475a:	78 14                	js     80104770 <argstr+0x30>
8010475c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010475f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104763:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104766:	89 04 24             	mov    %eax,(%esp)
80104769:	e8 e2 fe ff ff       	call   80104650 <fetchstr>
8010476e:	c9                   	leave  
8010476f:	c3                   	ret    
80104770:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104775:	c9                   	leave  
80104776:	c3                   	ret    
80104777:	89 f6                	mov    %esi,%esi
80104779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104780 <syscall>:
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	56                   	push   %esi
80104784:	53                   	push   %ebx
80104785:	83 ec 10             	sub    $0x10,%esp
80104788:	e8 13 ef ff ff       	call   801036a0 <myproc>
8010478d:	8b 70 18             	mov    0x18(%eax),%esi
80104790:	89 c3                	mov    %eax,%ebx
80104792:	8b 46 1c             	mov    0x1c(%esi),%eax
80104795:	8d 50 ff             	lea    -0x1(%eax),%edx
80104798:	83 fa 15             	cmp    $0x15,%edx
8010479b:	77 1b                	ja     801047b8 <syscall+0x38>
8010479d:	8b 14 85 60 74 10 80 	mov    -0x7fef8ba0(,%eax,4),%edx
801047a4:	85 d2                	test   %edx,%edx
801047a6:	74 10                	je     801047b8 <syscall+0x38>
801047a8:	ff d2                	call   *%edx
801047aa:	89 46 1c             	mov    %eax,0x1c(%esi)
801047ad:	83 c4 10             	add    $0x10,%esp
801047b0:	5b                   	pop    %ebx
801047b1:	5e                   	pop    %esi
801047b2:	5d                   	pop    %ebp
801047b3:	c3                   	ret    
801047b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
801047bc:	8d 43 6c             	lea    0x6c(%ebx),%eax
801047bf:	89 44 24 08          	mov    %eax,0x8(%esp)
801047c3:	8b 43 10             	mov    0x10(%ebx),%eax
801047c6:	c7 04 24 31 74 10 80 	movl   $0x80107431,(%esp)
801047cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801047d1:	e8 7a be ff ff       	call   80100650 <cprintf>
801047d6:	8b 43 18             	mov    0x18(%ebx),%eax
801047d9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
801047e0:	83 c4 10             	add    $0x10,%esp
801047e3:	5b                   	pop    %ebx
801047e4:	5e                   	pop    %esi
801047e5:	5d                   	pop    %ebp
801047e6:	c3                   	ret    
801047e7:	66 90                	xchg   %ax,%ax
801047e9:	66 90                	xchg   %ax,%ax
801047eb:	66 90                	xchg   %ax,%ax
801047ed:	66 90                	xchg   %ax,%ax
801047ef:	90                   	nop

801047f0 <fdalloc>:
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	53                   	push   %ebx
801047f4:	89 c3                	mov    %eax,%ebx
801047f6:	83 ec 04             	sub    $0x4,%esp
801047f9:	e8 a2 ee ff ff       	call   801036a0 <myproc>
801047fe:	31 d2                	xor    %edx,%edx
80104800:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80104804:	85 c9                	test   %ecx,%ecx
80104806:	74 18                	je     80104820 <fdalloc+0x30>
80104808:	83 c2 01             	add    $0x1,%edx
8010480b:	83 fa 10             	cmp    $0x10,%edx
8010480e:	75 f0                	jne    80104800 <fdalloc+0x10>
80104810:	83 c4 04             	add    $0x4,%esp
80104813:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104818:	5b                   	pop    %ebx
80104819:	5d                   	pop    %ebp
8010481a:	c3                   	ret    
8010481b:	90                   	nop
8010481c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104820:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
80104824:	83 c4 04             	add    $0x4,%esp
80104827:	89 d0                	mov    %edx,%eax
80104829:	5b                   	pop    %ebx
8010482a:	5d                   	pop    %ebp
8010482b:	c3                   	ret    
8010482c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104830 <create>:
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	57                   	push   %edi
80104834:	56                   	push   %esi
80104835:	53                   	push   %ebx
80104836:	83 ec 3c             	sub    $0x3c,%esp
80104839:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010483c:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010483f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104842:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104846:	89 04 24             	mov    %eax,(%esp)
80104849:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010484c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
8010484f:	e8 cc d6 ff ff       	call   80101f20 <nameiparent>
80104854:	85 c0                	test   %eax,%eax
80104856:	89 c7                	mov    %eax,%edi
80104858:	0f 84 da 00 00 00    	je     80104938 <create+0x108>
8010485e:	89 04 24             	mov    %eax,(%esp)
80104861:	e8 4a ce ff ff       	call   801016b0 <ilock>
80104866:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010486d:	00 
8010486e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104872:	89 3c 24             	mov    %edi,(%esp)
80104875:	e8 46 d3 ff ff       	call   80101bc0 <dirlookup>
8010487a:	85 c0                	test   %eax,%eax
8010487c:	89 c6                	mov    %eax,%esi
8010487e:	74 40                	je     801048c0 <create+0x90>
80104880:	89 3c 24             	mov    %edi,(%esp)
80104883:	e8 88 d0 ff ff       	call   80101910 <iunlockput>
80104888:	89 34 24             	mov    %esi,(%esp)
8010488b:	e8 20 ce ff ff       	call   801016b0 <ilock>
80104890:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104895:	75 11                	jne    801048a8 <create+0x78>
80104897:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010489c:	89 f0                	mov    %esi,%eax
8010489e:	75 08                	jne    801048a8 <create+0x78>
801048a0:	83 c4 3c             	add    $0x3c,%esp
801048a3:	5b                   	pop    %ebx
801048a4:	5e                   	pop    %esi
801048a5:	5f                   	pop    %edi
801048a6:	5d                   	pop    %ebp
801048a7:	c3                   	ret    
801048a8:	89 34 24             	mov    %esi,(%esp)
801048ab:	e8 60 d0 ff ff       	call   80101910 <iunlockput>
801048b0:	83 c4 3c             	add    $0x3c,%esp
801048b3:	31 c0                	xor    %eax,%eax
801048b5:	5b                   	pop    %ebx
801048b6:	5e                   	pop    %esi
801048b7:	5f                   	pop    %edi
801048b8:	5d                   	pop    %ebp
801048b9:	c3                   	ret    
801048ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048c0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801048c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801048c8:	8b 07                	mov    (%edi),%eax
801048ca:	89 04 24             	mov    %eax,(%esp)
801048cd:	e8 4e cc ff ff       	call   80101520 <ialloc>
801048d2:	85 c0                	test   %eax,%eax
801048d4:	89 c6                	mov    %eax,%esi
801048d6:	0f 84 bf 00 00 00    	je     8010499b <create+0x16b>
801048dc:	89 04 24             	mov    %eax,(%esp)
801048df:	e8 cc cd ff ff       	call   801016b0 <ilock>
801048e4:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801048e8:	66 89 46 52          	mov    %ax,0x52(%esi)
801048ec:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801048f0:	66 89 46 54          	mov    %ax,0x54(%esi)
801048f4:	b8 01 00 00 00       	mov    $0x1,%eax
801048f9:	66 89 46 56          	mov    %ax,0x56(%esi)
801048fd:	89 34 24             	mov    %esi,(%esp)
80104900:	e8 eb cc ff ff       	call   801015f0 <iupdate>
80104905:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010490a:	74 34                	je     80104940 <create+0x110>
8010490c:	8b 46 04             	mov    0x4(%esi),%eax
8010490f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104913:	89 3c 24             	mov    %edi,(%esp)
80104916:	89 44 24 08          	mov    %eax,0x8(%esp)
8010491a:	e8 01 d5 ff ff       	call   80101e20 <dirlink>
8010491f:	85 c0                	test   %eax,%eax
80104921:	78 6c                	js     8010498f <create+0x15f>
80104923:	89 3c 24             	mov    %edi,(%esp)
80104926:	e8 e5 cf ff ff       	call   80101910 <iunlockput>
8010492b:	83 c4 3c             	add    $0x3c,%esp
8010492e:	89 f0                	mov    %esi,%eax
80104930:	5b                   	pop    %ebx
80104931:	5e                   	pop    %esi
80104932:	5f                   	pop    %edi
80104933:	5d                   	pop    %ebp
80104934:	c3                   	ret    
80104935:	8d 76 00             	lea    0x0(%esi),%esi
80104938:	31 c0                	xor    %eax,%eax
8010493a:	e9 61 ff ff ff       	jmp    801048a0 <create+0x70>
8010493f:	90                   	nop
80104940:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
80104945:	89 3c 24             	mov    %edi,(%esp)
80104948:	e8 a3 cc ff ff       	call   801015f0 <iupdate>
8010494d:	8b 46 04             	mov    0x4(%esi),%eax
80104950:	c7 44 24 04 d8 74 10 	movl   $0x801074d8,0x4(%esp)
80104957:	80 
80104958:	89 34 24             	mov    %esi,(%esp)
8010495b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010495f:	e8 bc d4 ff ff       	call   80101e20 <dirlink>
80104964:	85 c0                	test   %eax,%eax
80104966:	78 1b                	js     80104983 <create+0x153>
80104968:	8b 47 04             	mov    0x4(%edi),%eax
8010496b:	c7 44 24 04 d7 74 10 	movl   $0x801074d7,0x4(%esp)
80104972:	80 
80104973:	89 34 24             	mov    %esi,(%esp)
80104976:	89 44 24 08          	mov    %eax,0x8(%esp)
8010497a:	e8 a1 d4 ff ff       	call   80101e20 <dirlink>
8010497f:	85 c0                	test   %eax,%eax
80104981:	79 89                	jns    8010490c <create+0xdc>
80104983:	c7 04 24 cb 74 10 80 	movl   $0x801074cb,(%esp)
8010498a:	e8 d1 b9 ff ff       	call   80100360 <panic>
8010498f:	c7 04 24 da 74 10 80 	movl   $0x801074da,(%esp)
80104996:	e8 c5 b9 ff ff       	call   80100360 <panic>
8010499b:	c7 04 24 bc 74 10 80 	movl   $0x801074bc,(%esp)
801049a2:	e8 b9 b9 ff ff       	call   80100360 <panic>
801049a7:	89 f6                	mov    %esi,%esi
801049a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049b0 <argfd.constprop.0>:
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	56                   	push   %esi
801049b4:	89 c6                	mov    %eax,%esi
801049b6:	53                   	push   %ebx
801049b7:	89 d3                	mov    %edx,%ebx
801049b9:	83 ec 20             	sub    $0x20,%esp
801049bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801049c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801049ca:	e8 e1 fc ff ff       	call   801046b0 <argint>
801049cf:	85 c0                	test   %eax,%eax
801049d1:	78 2d                	js     80104a00 <argfd.constprop.0+0x50>
801049d3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801049d7:	77 27                	ja     80104a00 <argfd.constprop.0+0x50>
801049d9:	e8 c2 ec ff ff       	call   801036a0 <myproc>
801049de:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049e1:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801049e5:	85 c0                	test   %eax,%eax
801049e7:	74 17                	je     80104a00 <argfd.constprop.0+0x50>
801049e9:	85 f6                	test   %esi,%esi
801049eb:	74 02                	je     801049ef <argfd.constprop.0+0x3f>
801049ed:	89 16                	mov    %edx,(%esi)
801049ef:	85 db                	test   %ebx,%ebx
801049f1:	74 1d                	je     80104a10 <argfd.constprop.0+0x60>
801049f3:	89 03                	mov    %eax,(%ebx)
801049f5:	31 c0                	xor    %eax,%eax
801049f7:	83 c4 20             	add    $0x20,%esp
801049fa:	5b                   	pop    %ebx
801049fb:	5e                   	pop    %esi
801049fc:	5d                   	pop    %ebp
801049fd:	c3                   	ret    
801049fe:	66 90                	xchg   %ax,%ax
80104a00:	83 c4 20             	add    $0x20,%esp
80104a03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a08:	5b                   	pop    %ebx
80104a09:	5e                   	pop    %esi
80104a0a:	5d                   	pop    %ebp
80104a0b:	c3                   	ret    
80104a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a10:	31 c0                	xor    %eax,%eax
80104a12:	eb e3                	jmp    801049f7 <argfd.constprop.0+0x47>
80104a14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a20 <sys_dup>:
80104a20:	55                   	push   %ebp
80104a21:	31 c0                	xor    %eax,%eax
80104a23:	89 e5                	mov    %esp,%ebp
80104a25:	53                   	push   %ebx
80104a26:	83 ec 24             	sub    $0x24,%esp
80104a29:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104a2c:	e8 7f ff ff ff       	call   801049b0 <argfd.constprop.0>
80104a31:	85 c0                	test   %eax,%eax
80104a33:	78 23                	js     80104a58 <sys_dup+0x38>
80104a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a38:	e8 b3 fd ff ff       	call   801047f0 <fdalloc>
80104a3d:	85 c0                	test   %eax,%eax
80104a3f:	89 c3                	mov    %eax,%ebx
80104a41:	78 15                	js     80104a58 <sys_dup+0x38>
80104a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a46:	89 04 24             	mov    %eax,(%esp)
80104a49:	e8 92 c3 ff ff       	call   80100de0 <filedup>
80104a4e:	89 d8                	mov    %ebx,%eax
80104a50:	83 c4 24             	add    $0x24,%esp
80104a53:	5b                   	pop    %ebx
80104a54:	5d                   	pop    %ebp
80104a55:	c3                   	ret    
80104a56:	66 90                	xchg   %ax,%ax
80104a58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a5d:	eb f1                	jmp    80104a50 <sys_dup+0x30>
80104a5f:	90                   	nop

80104a60 <sys_read>:
80104a60:	55                   	push   %ebp
80104a61:	31 c0                	xor    %eax,%eax
80104a63:	89 e5                	mov    %esp,%ebp
80104a65:	83 ec 28             	sub    $0x28,%esp
80104a68:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104a6b:	e8 40 ff ff ff       	call   801049b0 <argfd.constprop.0>
80104a70:	85 c0                	test   %eax,%eax
80104a72:	78 54                	js     80104ac8 <sys_read+0x68>
80104a74:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a77:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a7b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104a82:	e8 29 fc ff ff       	call   801046b0 <argint>
80104a87:	85 c0                	test   %eax,%eax
80104a89:	78 3d                	js     80104ac8 <sys_read+0x68>
80104a8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a8e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a95:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a99:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104aa0:	e8 3b fc ff ff       	call   801046e0 <argptr>
80104aa5:	85 c0                	test   %eax,%eax
80104aa7:	78 1f                	js     80104ac8 <sys_read+0x68>
80104aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104aac:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab3:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ab7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104aba:	89 04 24             	mov    %eax,(%esp)
80104abd:	e8 7e c4 ff ff       	call   80100f40 <fileread>
80104ac2:	c9                   	leave  
80104ac3:	c3                   	ret    
80104ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ac8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104acd:	c9                   	leave  
80104ace:	c3                   	ret    
80104acf:	90                   	nop

80104ad0 <sys_write>:
80104ad0:	55                   	push   %ebp
80104ad1:	31 c0                	xor    %eax,%eax
80104ad3:	89 e5                	mov    %esp,%ebp
80104ad5:	83 ec 28             	sub    $0x28,%esp
80104ad8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104adb:	e8 d0 fe ff ff       	call   801049b0 <argfd.constprop.0>
80104ae0:	85 c0                	test   %eax,%eax
80104ae2:	78 54                	js     80104b38 <sys_write+0x68>
80104ae4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104aeb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104af2:	e8 b9 fb ff ff       	call   801046b0 <argint>
80104af7:	85 c0                	test   %eax,%eax
80104af9:	78 3d                	js     80104b38 <sys_write+0x68>
80104afb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104afe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b05:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b09:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b10:	e8 cb fb ff ff       	call   801046e0 <argptr>
80104b15:	85 c0                	test   %eax,%eax
80104b17:	78 1f                	js     80104b38 <sys_write+0x68>
80104b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b1c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b23:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b27:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b2a:	89 04 24             	mov    %eax,(%esp)
80104b2d:	e8 ae c4 ff ff       	call   80100fe0 <filewrite>
80104b32:	c9                   	leave  
80104b33:	c3                   	ret    
80104b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b3d:	c9                   	leave  
80104b3e:	c3                   	ret    
80104b3f:	90                   	nop

80104b40 <sys_close>:
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	83 ec 28             	sub    $0x28,%esp
80104b46:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104b49:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b4c:	e8 5f fe ff ff       	call   801049b0 <argfd.constprop.0>
80104b51:	85 c0                	test   %eax,%eax
80104b53:	78 23                	js     80104b78 <sys_close+0x38>
80104b55:	e8 46 eb ff ff       	call   801036a0 <myproc>
80104b5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b5d:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104b64:	00 
80104b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b68:	89 04 24             	mov    %eax,(%esp)
80104b6b:	e8 c0 c2 ff ff       	call   80100e30 <fileclose>
80104b70:	31 c0                	xor    %eax,%eax
80104b72:	c9                   	leave  
80104b73:	c3                   	ret    
80104b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b7d:	c9                   	leave  
80104b7e:	c3                   	ret    
80104b7f:	90                   	nop

80104b80 <sys_fstat>:
80104b80:	55                   	push   %ebp
80104b81:	31 c0                	xor    %eax,%eax
80104b83:	89 e5                	mov    %esp,%ebp
80104b85:	83 ec 28             	sub    $0x28,%esp
80104b88:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104b8b:	e8 20 fe ff ff       	call   801049b0 <argfd.constprop.0>
80104b90:	85 c0                	test   %eax,%eax
80104b92:	78 34                	js     80104bc8 <sys_fstat+0x48>
80104b94:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b97:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104b9e:	00 
80104b9f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ba3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104baa:	e8 31 fb ff ff       	call   801046e0 <argptr>
80104baf:	85 c0                	test   %eax,%eax
80104bb1:	78 15                	js     80104bc8 <sys_fstat+0x48>
80104bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb6:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bbd:	89 04 24             	mov    %eax,(%esp)
80104bc0:	e8 2b c3 ff ff       	call   80100ef0 <filestat>
80104bc5:	c9                   	leave  
80104bc6:	c3                   	ret    
80104bc7:	90                   	nop
80104bc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bcd:	c9                   	leave  
80104bce:	c3                   	ret    
80104bcf:	90                   	nop

80104bd0 <sys_link>:
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	57                   	push   %edi
80104bd4:	56                   	push   %esi
80104bd5:	53                   	push   %ebx
80104bd6:	83 ec 3c             	sub    $0x3c,%esp
80104bd9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104be0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104be7:	e8 54 fb ff ff       	call   80104740 <argstr>
80104bec:	85 c0                	test   %eax,%eax
80104bee:	0f 88 e6 00 00 00    	js     80104cda <sys_link+0x10a>
80104bf4:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bfb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c02:	e8 39 fb ff ff       	call   80104740 <argstr>
80104c07:	85 c0                	test   %eax,%eax
80104c09:	0f 88 cb 00 00 00    	js     80104cda <sys_link+0x10a>
80104c0f:	e8 fc de ff ff       	call   80102b10 <begin_op>
80104c14:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104c17:	89 04 24             	mov    %eax,(%esp)
80104c1a:	e8 e1 d2 ff ff       	call   80101f00 <namei>
80104c1f:	85 c0                	test   %eax,%eax
80104c21:	89 c3                	mov    %eax,%ebx
80104c23:	0f 84 ac 00 00 00    	je     80104cd5 <sys_link+0x105>
80104c29:	89 04 24             	mov    %eax,(%esp)
80104c2c:	e8 7f ca ff ff       	call   801016b0 <ilock>
80104c31:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c36:	0f 84 91 00 00 00    	je     80104ccd <sys_link+0xfd>
80104c3c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
80104c41:	8d 7d da             	lea    -0x26(%ebp),%edi
80104c44:	89 1c 24             	mov    %ebx,(%esp)
80104c47:	e8 a4 c9 ff ff       	call   801015f0 <iupdate>
80104c4c:	89 1c 24             	mov    %ebx,(%esp)
80104c4f:	e8 3c cb ff ff       	call   80101790 <iunlock>
80104c54:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104c57:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104c5b:	89 04 24             	mov    %eax,(%esp)
80104c5e:	e8 bd d2 ff ff       	call   80101f20 <nameiparent>
80104c63:	85 c0                	test   %eax,%eax
80104c65:	89 c6                	mov    %eax,%esi
80104c67:	74 4f                	je     80104cb8 <sys_link+0xe8>
80104c69:	89 04 24             	mov    %eax,(%esp)
80104c6c:	e8 3f ca ff ff       	call   801016b0 <ilock>
80104c71:	8b 03                	mov    (%ebx),%eax
80104c73:	39 06                	cmp    %eax,(%esi)
80104c75:	75 39                	jne    80104cb0 <sys_link+0xe0>
80104c77:	8b 43 04             	mov    0x4(%ebx),%eax
80104c7a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104c7e:	89 34 24             	mov    %esi,(%esp)
80104c81:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c85:	e8 96 d1 ff ff       	call   80101e20 <dirlink>
80104c8a:	85 c0                	test   %eax,%eax
80104c8c:	78 22                	js     80104cb0 <sys_link+0xe0>
80104c8e:	89 34 24             	mov    %esi,(%esp)
80104c91:	e8 7a cc ff ff       	call   80101910 <iunlockput>
80104c96:	89 1c 24             	mov    %ebx,(%esp)
80104c99:	e8 32 cb ff ff       	call   801017d0 <iput>
80104c9e:	e8 dd de ff ff       	call   80102b80 <end_op>
80104ca3:	83 c4 3c             	add    $0x3c,%esp
80104ca6:	31 c0                	xor    %eax,%eax
80104ca8:	5b                   	pop    %ebx
80104ca9:	5e                   	pop    %esi
80104caa:	5f                   	pop    %edi
80104cab:	5d                   	pop    %ebp
80104cac:	c3                   	ret    
80104cad:	8d 76 00             	lea    0x0(%esi),%esi
80104cb0:	89 34 24             	mov    %esi,(%esp)
80104cb3:	e8 58 cc ff ff       	call   80101910 <iunlockput>
80104cb8:	89 1c 24             	mov    %ebx,(%esp)
80104cbb:	e8 f0 c9 ff ff       	call   801016b0 <ilock>
80104cc0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
80104cc5:	89 1c 24             	mov    %ebx,(%esp)
80104cc8:	e8 23 c9 ff ff       	call   801015f0 <iupdate>
80104ccd:	89 1c 24             	mov    %ebx,(%esp)
80104cd0:	e8 3b cc ff ff       	call   80101910 <iunlockput>
80104cd5:	e8 a6 de ff ff       	call   80102b80 <end_op>
80104cda:	83 c4 3c             	add    $0x3c,%esp
80104cdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ce2:	5b                   	pop    %ebx
80104ce3:	5e                   	pop    %esi
80104ce4:	5f                   	pop    %edi
80104ce5:	5d                   	pop    %ebp
80104ce6:	c3                   	ret    
80104ce7:	89 f6                	mov    %esi,%esi
80104ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cf0 <sys_unlink>:
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	57                   	push   %edi
80104cf4:	56                   	push   %esi
80104cf5:	53                   	push   %ebx
80104cf6:	83 ec 5c             	sub    $0x5c,%esp
80104cf9:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d00:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104d07:	e8 34 fa ff ff       	call   80104740 <argstr>
80104d0c:	85 c0                	test   %eax,%eax
80104d0e:	0f 88 76 01 00 00    	js     80104e8a <sys_unlink+0x19a>
80104d14:	e8 f7 dd ff ff       	call   80102b10 <begin_op>
80104d19:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104d1c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104d1f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104d23:	89 04 24             	mov    %eax,(%esp)
80104d26:	e8 f5 d1 ff ff       	call   80101f20 <nameiparent>
80104d2b:	85 c0                	test   %eax,%eax
80104d2d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104d30:	0f 84 4f 01 00 00    	je     80104e85 <sys_unlink+0x195>
80104d36:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104d39:	89 34 24             	mov    %esi,(%esp)
80104d3c:	e8 6f c9 ff ff       	call   801016b0 <ilock>
80104d41:	c7 44 24 04 d8 74 10 	movl   $0x801074d8,0x4(%esp)
80104d48:	80 
80104d49:	89 1c 24             	mov    %ebx,(%esp)
80104d4c:	e8 3f ce ff ff       	call   80101b90 <namecmp>
80104d51:	85 c0                	test   %eax,%eax
80104d53:	0f 84 21 01 00 00    	je     80104e7a <sys_unlink+0x18a>
80104d59:	c7 44 24 04 d7 74 10 	movl   $0x801074d7,0x4(%esp)
80104d60:	80 
80104d61:	89 1c 24             	mov    %ebx,(%esp)
80104d64:	e8 27 ce ff ff       	call   80101b90 <namecmp>
80104d69:	85 c0                	test   %eax,%eax
80104d6b:	0f 84 09 01 00 00    	je     80104e7a <sys_unlink+0x18a>
80104d71:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104d74:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104d78:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d7c:	89 34 24             	mov    %esi,(%esp)
80104d7f:	e8 3c ce ff ff       	call   80101bc0 <dirlookup>
80104d84:	85 c0                	test   %eax,%eax
80104d86:	89 c3                	mov    %eax,%ebx
80104d88:	0f 84 ec 00 00 00    	je     80104e7a <sys_unlink+0x18a>
80104d8e:	89 04 24             	mov    %eax,(%esp)
80104d91:	e8 1a c9 ff ff       	call   801016b0 <ilock>
80104d96:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104d9b:	0f 8e 24 01 00 00    	jle    80104ec5 <sys_unlink+0x1d5>
80104da1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104da6:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104da9:	74 7d                	je     80104e28 <sys_unlink+0x138>
80104dab:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104db2:	00 
80104db3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104dba:	00 
80104dbb:	89 34 24             	mov    %esi,(%esp)
80104dbe:	e8 fd f5 ff ff       	call   801043c0 <memset>
80104dc3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104dc6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104dcd:	00 
80104dce:	89 74 24 04          	mov    %esi,0x4(%esp)
80104dd2:	89 44 24 08          	mov    %eax,0x8(%esp)
80104dd6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104dd9:	89 04 24             	mov    %eax,(%esp)
80104ddc:	e8 7f cc ff ff       	call   80101a60 <writei>
80104de1:	83 f8 10             	cmp    $0x10,%eax
80104de4:	0f 85 cf 00 00 00    	jne    80104eb9 <sys_unlink+0x1c9>
80104dea:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104def:	0f 84 a3 00 00 00    	je     80104e98 <sys_unlink+0x1a8>
80104df5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104df8:	89 04 24             	mov    %eax,(%esp)
80104dfb:	e8 10 cb ff ff       	call   80101910 <iunlockput>
80104e00:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
80104e05:	89 1c 24             	mov    %ebx,(%esp)
80104e08:	e8 e3 c7 ff ff       	call   801015f0 <iupdate>
80104e0d:	89 1c 24             	mov    %ebx,(%esp)
80104e10:	e8 fb ca ff ff       	call   80101910 <iunlockput>
80104e15:	e8 66 dd ff ff       	call   80102b80 <end_op>
80104e1a:	83 c4 5c             	add    $0x5c,%esp
80104e1d:	31 c0                	xor    %eax,%eax
80104e1f:	5b                   	pop    %ebx
80104e20:	5e                   	pop    %esi
80104e21:	5f                   	pop    %edi
80104e22:	5d                   	pop    %ebp
80104e23:	c3                   	ret    
80104e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e28:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104e2c:	0f 86 79 ff ff ff    	jbe    80104dab <sys_unlink+0xbb>
80104e32:	bf 20 00 00 00       	mov    $0x20,%edi
80104e37:	eb 15                	jmp    80104e4e <sys_unlink+0x15e>
80104e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e40:	8d 57 10             	lea    0x10(%edi),%edx
80104e43:	3b 53 58             	cmp    0x58(%ebx),%edx
80104e46:	0f 83 5f ff ff ff    	jae    80104dab <sys_unlink+0xbb>
80104e4c:	89 d7                	mov    %edx,%edi
80104e4e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104e55:	00 
80104e56:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104e5a:	89 74 24 04          	mov    %esi,0x4(%esp)
80104e5e:	89 1c 24             	mov    %ebx,(%esp)
80104e61:	e8 fa ca ff ff       	call   80101960 <readi>
80104e66:	83 f8 10             	cmp    $0x10,%eax
80104e69:	75 42                	jne    80104ead <sys_unlink+0x1bd>
80104e6b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104e70:	74 ce                	je     80104e40 <sys_unlink+0x150>
80104e72:	89 1c 24             	mov    %ebx,(%esp)
80104e75:	e8 96 ca ff ff       	call   80101910 <iunlockput>
80104e7a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e7d:	89 04 24             	mov    %eax,(%esp)
80104e80:	e8 8b ca ff ff       	call   80101910 <iunlockput>
80104e85:	e8 f6 dc ff ff       	call   80102b80 <end_op>
80104e8a:	83 c4 5c             	add    $0x5c,%esp
80104e8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e92:	5b                   	pop    %ebx
80104e93:	5e                   	pop    %esi
80104e94:	5f                   	pop    %edi
80104e95:	5d                   	pop    %ebp
80104e96:	c3                   	ret    
80104e97:	90                   	nop
80104e98:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e9b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
80104ea0:	89 04 24             	mov    %eax,(%esp)
80104ea3:	e8 48 c7 ff ff       	call   801015f0 <iupdate>
80104ea8:	e9 48 ff ff ff       	jmp    80104df5 <sys_unlink+0x105>
80104ead:	c7 04 24 fc 74 10 80 	movl   $0x801074fc,(%esp)
80104eb4:	e8 a7 b4 ff ff       	call   80100360 <panic>
80104eb9:	c7 04 24 0e 75 10 80 	movl   $0x8010750e,(%esp)
80104ec0:	e8 9b b4 ff ff       	call   80100360 <panic>
80104ec5:	c7 04 24 ea 74 10 80 	movl   $0x801074ea,(%esp)
80104ecc:	e8 8f b4 ff ff       	call   80100360 <panic>
80104ed1:	eb 0d                	jmp    80104ee0 <sys_open>
80104ed3:	90                   	nop
80104ed4:	90                   	nop
80104ed5:	90                   	nop
80104ed6:	90                   	nop
80104ed7:	90                   	nop
80104ed8:	90                   	nop
80104ed9:	90                   	nop
80104eda:	90                   	nop
80104edb:	90                   	nop
80104edc:	90                   	nop
80104edd:	90                   	nop
80104ede:	90                   	nop
80104edf:	90                   	nop

80104ee0 <sys_open>:
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	57                   	push   %edi
80104ee4:	56                   	push   %esi
80104ee5:	53                   	push   %ebx
80104ee6:	83 ec 2c             	sub    $0x2c,%esp
80104ee9:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104eec:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ef0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ef7:	e8 44 f8 ff ff       	call   80104740 <argstr>
80104efc:	85 c0                	test   %eax,%eax
80104efe:	0f 88 d1 00 00 00    	js     80104fd5 <sys_open+0xf5>
80104f04:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104f07:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f12:	e8 99 f7 ff ff       	call   801046b0 <argint>
80104f17:	85 c0                	test   %eax,%eax
80104f19:	0f 88 b6 00 00 00    	js     80104fd5 <sys_open+0xf5>
80104f1f:	e8 ec db ff ff       	call   80102b10 <begin_op>
80104f24:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104f28:	0f 85 82 00 00 00    	jne    80104fb0 <sys_open+0xd0>
80104f2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f31:	89 04 24             	mov    %eax,(%esp)
80104f34:	e8 c7 cf ff ff       	call   80101f00 <namei>
80104f39:	85 c0                	test   %eax,%eax
80104f3b:	89 c6                	mov    %eax,%esi
80104f3d:	0f 84 8d 00 00 00    	je     80104fd0 <sys_open+0xf0>
80104f43:	89 04 24             	mov    %eax,(%esp)
80104f46:	e8 65 c7 ff ff       	call   801016b0 <ilock>
80104f4b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104f50:	0f 84 92 00 00 00    	je     80104fe8 <sys_open+0x108>
80104f56:	e8 15 be ff ff       	call   80100d70 <filealloc>
80104f5b:	85 c0                	test   %eax,%eax
80104f5d:	89 c3                	mov    %eax,%ebx
80104f5f:	0f 84 93 00 00 00    	je     80104ff8 <sys_open+0x118>
80104f65:	e8 86 f8 ff ff       	call   801047f0 <fdalloc>
80104f6a:	85 c0                	test   %eax,%eax
80104f6c:	89 c7                	mov    %eax,%edi
80104f6e:	0f 88 94 00 00 00    	js     80105008 <sys_open+0x128>
80104f74:	89 34 24             	mov    %esi,(%esp)
80104f77:	e8 14 c8 ff ff       	call   80101790 <iunlock>
80104f7c:	e8 ff db ff ff       	call   80102b80 <end_op>
80104f81:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
80104f87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104f8a:	89 73 10             	mov    %esi,0x10(%ebx)
80104f8d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
80104f94:	89 c2                	mov    %eax,%edx
80104f96:	83 e2 01             	and    $0x1,%edx
80104f99:	83 f2 01             	xor    $0x1,%edx
80104f9c:	a8 03                	test   $0x3,%al
80104f9e:	88 53 08             	mov    %dl,0x8(%ebx)
80104fa1:	89 f8                	mov    %edi,%eax
80104fa3:	0f 95 43 09          	setne  0x9(%ebx)
80104fa7:	83 c4 2c             	add    $0x2c,%esp
80104faa:	5b                   	pop    %ebx
80104fab:	5e                   	pop    %esi
80104fac:	5f                   	pop    %edi
80104fad:	5d                   	pop    %ebp
80104fae:	c3                   	ret    
80104faf:	90                   	nop
80104fb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104fb3:	31 c9                	xor    %ecx,%ecx
80104fb5:	ba 02 00 00 00       	mov    $0x2,%edx
80104fba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fc1:	e8 6a f8 ff ff       	call   80104830 <create>
80104fc6:	85 c0                	test   %eax,%eax
80104fc8:	89 c6                	mov    %eax,%esi
80104fca:	75 8a                	jne    80104f56 <sys_open+0x76>
80104fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fd0:	e8 ab db ff ff       	call   80102b80 <end_op>
80104fd5:	83 c4 2c             	add    $0x2c,%esp
80104fd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fdd:	5b                   	pop    %ebx
80104fde:	5e                   	pop    %esi
80104fdf:	5f                   	pop    %edi
80104fe0:	5d                   	pop    %ebp
80104fe1:	c3                   	ret    
80104fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fe8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104feb:	85 c0                	test   %eax,%eax
80104fed:	0f 84 63 ff ff ff    	je     80104f56 <sys_open+0x76>
80104ff3:	90                   	nop
80104ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ff8:	89 34 24             	mov    %esi,(%esp)
80104ffb:	e8 10 c9 ff ff       	call   80101910 <iunlockput>
80105000:	eb ce                	jmp    80104fd0 <sys_open+0xf0>
80105002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105008:	89 1c 24             	mov    %ebx,(%esp)
8010500b:	e8 20 be ff ff       	call   80100e30 <fileclose>
80105010:	eb e6                	jmp    80104ff8 <sys_open+0x118>
80105012:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105020 <sys_mkdir>:
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	83 ec 28             	sub    $0x28,%esp
80105026:	e8 e5 da ff ff       	call   80102b10 <begin_op>
8010502b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010502e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105032:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105039:	e8 02 f7 ff ff       	call   80104740 <argstr>
8010503e:	85 c0                	test   %eax,%eax
80105040:	78 2e                	js     80105070 <sys_mkdir+0x50>
80105042:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105045:	31 c9                	xor    %ecx,%ecx
80105047:	ba 01 00 00 00       	mov    $0x1,%edx
8010504c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105053:	e8 d8 f7 ff ff       	call   80104830 <create>
80105058:	85 c0                	test   %eax,%eax
8010505a:	74 14                	je     80105070 <sys_mkdir+0x50>
8010505c:	89 04 24             	mov    %eax,(%esp)
8010505f:	e8 ac c8 ff ff       	call   80101910 <iunlockput>
80105064:	e8 17 db ff ff       	call   80102b80 <end_op>
80105069:	31 c0                	xor    %eax,%eax
8010506b:	c9                   	leave  
8010506c:	c3                   	ret    
8010506d:	8d 76 00             	lea    0x0(%esi),%esi
80105070:	e8 0b db ff ff       	call   80102b80 <end_op>
80105075:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010507a:	c9                   	leave  
8010507b:	c3                   	ret    
8010507c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105080 <sys_mknod>:
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	83 ec 28             	sub    $0x28,%esp
80105086:	e8 85 da ff ff       	call   80102b10 <begin_op>
8010508b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010508e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105092:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105099:	e8 a2 f6 ff ff       	call   80104740 <argstr>
8010509e:	85 c0                	test   %eax,%eax
801050a0:	78 5e                	js     80105100 <sys_mknod+0x80>
801050a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050a5:	89 44 24 04          	mov    %eax,0x4(%esp)
801050a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801050b0:	e8 fb f5 ff ff       	call   801046b0 <argint>
801050b5:	85 c0                	test   %eax,%eax
801050b7:	78 47                	js     80105100 <sys_mknod+0x80>
801050b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050bc:	89 44 24 04          	mov    %eax,0x4(%esp)
801050c0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801050c7:	e8 e4 f5 ff ff       	call   801046b0 <argint>
801050cc:	85 c0                	test   %eax,%eax
801050ce:	78 30                	js     80105100 <sys_mknod+0x80>
801050d0:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801050d4:	ba 03 00 00 00       	mov    $0x3,%edx
801050d9:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801050dd:	89 04 24             	mov    %eax,(%esp)
801050e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801050e3:	e8 48 f7 ff ff       	call   80104830 <create>
801050e8:	85 c0                	test   %eax,%eax
801050ea:	74 14                	je     80105100 <sys_mknod+0x80>
801050ec:	89 04 24             	mov    %eax,(%esp)
801050ef:	e8 1c c8 ff ff       	call   80101910 <iunlockput>
801050f4:	e8 87 da ff ff       	call   80102b80 <end_op>
801050f9:	31 c0                	xor    %eax,%eax
801050fb:	c9                   	leave  
801050fc:	c3                   	ret    
801050fd:	8d 76 00             	lea    0x0(%esi),%esi
80105100:	e8 7b da ff ff       	call   80102b80 <end_op>
80105105:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010510a:	c9                   	leave  
8010510b:	c3                   	ret    
8010510c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105110 <sys_chdir>:
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	56                   	push   %esi
80105114:	53                   	push   %ebx
80105115:	83 ec 20             	sub    $0x20,%esp
80105118:	e8 83 e5 ff ff       	call   801036a0 <myproc>
8010511d:	89 c6                	mov    %eax,%esi
8010511f:	e8 ec d9 ff ff       	call   80102b10 <begin_op>
80105124:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105127:	89 44 24 04          	mov    %eax,0x4(%esp)
8010512b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105132:	e8 09 f6 ff ff       	call   80104740 <argstr>
80105137:	85 c0                	test   %eax,%eax
80105139:	78 4a                	js     80105185 <sys_chdir+0x75>
8010513b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010513e:	89 04 24             	mov    %eax,(%esp)
80105141:	e8 ba cd ff ff       	call   80101f00 <namei>
80105146:	85 c0                	test   %eax,%eax
80105148:	89 c3                	mov    %eax,%ebx
8010514a:	74 39                	je     80105185 <sys_chdir+0x75>
8010514c:	89 04 24             	mov    %eax,(%esp)
8010514f:	e8 5c c5 ff ff       	call   801016b0 <ilock>
80105154:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105159:	89 1c 24             	mov    %ebx,(%esp)
8010515c:	75 22                	jne    80105180 <sys_chdir+0x70>
8010515e:	e8 2d c6 ff ff       	call   80101790 <iunlock>
80105163:	8b 46 68             	mov    0x68(%esi),%eax
80105166:	89 04 24             	mov    %eax,(%esp)
80105169:	e8 62 c6 ff ff       	call   801017d0 <iput>
8010516e:	e8 0d da ff ff       	call   80102b80 <end_op>
80105173:	31 c0                	xor    %eax,%eax
80105175:	89 5e 68             	mov    %ebx,0x68(%esi)
80105178:	83 c4 20             	add    $0x20,%esp
8010517b:	5b                   	pop    %ebx
8010517c:	5e                   	pop    %esi
8010517d:	5d                   	pop    %ebp
8010517e:	c3                   	ret    
8010517f:	90                   	nop
80105180:	e8 8b c7 ff ff       	call   80101910 <iunlockput>
80105185:	e8 f6 d9 ff ff       	call   80102b80 <end_op>
8010518a:	83 c4 20             	add    $0x20,%esp
8010518d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105192:	5b                   	pop    %ebx
80105193:	5e                   	pop    %esi
80105194:	5d                   	pop    %ebp
80105195:	c3                   	ret    
80105196:	8d 76 00             	lea    0x0(%esi),%esi
80105199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051a0 <sys_exec>:
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	57                   	push   %edi
801051a4:	56                   	push   %esi
801051a5:	53                   	push   %ebx
801051a6:	81 ec ac 00 00 00    	sub    $0xac,%esp
801051ac:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
801051b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801051b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051bd:	e8 7e f5 ff ff       	call   80104740 <argstr>
801051c2:	85 c0                	test   %eax,%eax
801051c4:	0f 88 84 00 00 00    	js     8010524e <sys_exec+0xae>
801051ca:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801051d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801051d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801051db:	e8 d0 f4 ff ff       	call   801046b0 <argint>
801051e0:	85 c0                	test   %eax,%eax
801051e2:	78 6a                	js     8010524e <sys_exec+0xae>
801051e4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801051ea:	31 db                	xor    %ebx,%ebx
801051ec:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801051f3:	00 
801051f4:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801051fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105201:	00 
80105202:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105208:	89 04 24             	mov    %eax,(%esp)
8010520b:	e8 b0 f1 ff ff       	call   801043c0 <memset>
80105210:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105216:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010521a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010521d:	89 04 24             	mov    %eax,(%esp)
80105220:	e8 eb f3 ff ff       	call   80104610 <fetchint>
80105225:	85 c0                	test   %eax,%eax
80105227:	78 25                	js     8010524e <sys_exec+0xae>
80105229:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010522f:	85 c0                	test   %eax,%eax
80105231:	74 2d                	je     80105260 <sys_exec+0xc0>
80105233:	89 74 24 04          	mov    %esi,0x4(%esp)
80105237:	89 04 24             	mov    %eax,(%esp)
8010523a:	e8 11 f4 ff ff       	call   80104650 <fetchstr>
8010523f:	85 c0                	test   %eax,%eax
80105241:	78 0b                	js     8010524e <sys_exec+0xae>
80105243:	83 c3 01             	add    $0x1,%ebx
80105246:	83 c6 04             	add    $0x4,%esi
80105249:	83 fb 20             	cmp    $0x20,%ebx
8010524c:	75 c2                	jne    80105210 <sys_exec+0x70>
8010524e:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105254:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105259:	5b                   	pop    %ebx
8010525a:	5e                   	pop    %esi
8010525b:	5f                   	pop    %edi
8010525c:	5d                   	pop    %ebp
8010525d:	c3                   	ret    
8010525e:	66 90                	xchg   %ax,%ax
80105260:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105266:	89 44 24 04          	mov    %eax,0x4(%esp)
8010526a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
80105270:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105277:	00 00 00 00 
8010527b:	89 04 24             	mov    %eax,(%esp)
8010527e:	e8 1d b7 ff ff       	call   801009a0 <exec>
80105283:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105289:	5b                   	pop    %ebx
8010528a:	5e                   	pop    %esi
8010528b:	5f                   	pop    %edi
8010528c:	5d                   	pop    %ebp
8010528d:	c3                   	ret    
8010528e:	66 90                	xchg   %ax,%ax

80105290 <sys_pipe>:
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	53                   	push   %ebx
80105294:	83 ec 24             	sub    $0x24,%esp
80105297:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010529a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
801052a1:	00 
801052a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801052a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052ad:	e8 2e f4 ff ff       	call   801046e0 <argptr>
801052b2:	85 c0                	test   %eax,%eax
801052b4:	78 6d                	js     80105323 <sys_pipe+0x93>
801052b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801052bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052c0:	89 04 24             	mov    %eax,(%esp)
801052c3:	e8 a8 de ff ff       	call   80103170 <pipealloc>
801052c8:	85 c0                	test   %eax,%eax
801052ca:	78 57                	js     80105323 <sys_pipe+0x93>
801052cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052cf:	e8 1c f5 ff ff       	call   801047f0 <fdalloc>
801052d4:	85 c0                	test   %eax,%eax
801052d6:	89 c3                	mov    %eax,%ebx
801052d8:	78 33                	js     8010530d <sys_pipe+0x7d>
801052da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052dd:	e8 0e f5 ff ff       	call   801047f0 <fdalloc>
801052e2:	85 c0                	test   %eax,%eax
801052e4:	78 1a                	js     80105300 <sys_pipe+0x70>
801052e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801052e9:	89 1a                	mov    %ebx,(%edx)
801052eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
801052ee:	89 42 04             	mov    %eax,0x4(%edx)
801052f1:	83 c4 24             	add    $0x24,%esp
801052f4:	31 c0                	xor    %eax,%eax
801052f6:	5b                   	pop    %ebx
801052f7:	5d                   	pop    %ebp
801052f8:	c3                   	ret    
801052f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105300:	e8 9b e3 ff ff       	call   801036a0 <myproc>
80105305:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
8010530c:	00 
8010530d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105310:	89 04 24             	mov    %eax,(%esp)
80105313:	e8 18 bb ff ff       	call   80100e30 <fileclose>
80105318:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010531b:	89 04 24             	mov    %eax,(%esp)
8010531e:	e8 0d bb ff ff       	call   80100e30 <fileclose>
80105323:	83 c4 24             	add    $0x24,%esp
80105326:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010532b:	5b                   	pop    %ebx
8010532c:	5d                   	pop    %ebp
8010532d:	c3                   	ret    
8010532e:	66 90                	xchg   %ax,%ax

80105330 <sys_fork>:
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	5d                   	pop    %ebp
80105334:	e9 17 e5 ff ff       	jmp    80103850 <fork>
80105339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105340 <sys_exit>:
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	83 ec 08             	sub    $0x8,%esp
80105346:	e8 55 e7 ff ff       	call   80103aa0 <exit>
8010534b:	31 c0                	xor    %eax,%eax
8010534d:	c9                   	leave  
8010534e:	c3                   	ret    
8010534f:	90                   	nop

80105350 <sys_exitS>:
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	83 ec 28             	sub    $0x28,%esp
80105356:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105359:	89 44 24 04          	mov    %eax,0x4(%esp)
8010535d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105364:	e8 47 f3 ff ff       	call   801046b0 <argint>
80105369:	85 c0                	test   %eax,%eax
8010536b:	78 13                	js     80105380 <sys_exitS+0x30>
8010536d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105370:	89 04 24             	mov    %eax,(%esp)
80105373:	e8 48 e8 ff ff       	call   80103bc0 <exitS>
80105378:	31 c0                	xor    %eax,%eax
8010537a:	c9                   	leave  
8010537b:	c3                   	ret    
8010537c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105380:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105385:	c9                   	leave  
80105386:	c3                   	ret    
80105387:	89 f6                	mov    %esi,%esi
80105389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105390 <sys_wait>:
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	53                   	push   %ebx
80105394:	83 ec 24             	sub    $0x24,%esp
80105397:	8d 5d f4             	lea    -0xc(%ebp),%ebx
8010539a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010539e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053a5:	e8 06 f3 ff ff       	call   801046b0 <argint>
801053aa:	85 c0                	test   %eax,%eax
801053ac:	78 12                	js     801053c0 <sys_wait+0x30>
801053ae:	89 1c 24             	mov    %ebx,(%esp)
801053b1:	e8 1a ea ff ff       	call   80103dd0 <wait>
801053b6:	83 c4 24             	add    $0x24,%esp
801053b9:	5b                   	pop    %ebx
801053ba:	5d                   	pop    %ebp
801053bb:	c3                   	ret    
801053bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053c5:	eb ef                	jmp    801053b6 <sys_wait+0x26>
801053c7:	89 f6                	mov    %esi,%esi
801053c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053d0 <sys_kill>:
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	83 ec 28             	sub    $0x28,%esp
801053d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801053dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053e4:	e8 c7 f2 ff ff       	call   801046b0 <argint>
801053e9:	85 c0                	test   %eax,%eax
801053eb:	78 13                	js     80105400 <sys_kill+0x30>
801053ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053f0:	89 04 24             	mov    %eax,(%esp)
801053f3:	e8 18 eb ff ff       	call   80103f10 <kill>
801053f8:	c9                   	leave  
801053f9:	c3                   	ret    
801053fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105400:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105405:	c9                   	leave  
80105406:	c3                   	ret    
80105407:	89 f6                	mov    %esi,%esi
80105409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105410 <sys_getpid>:
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	83 ec 08             	sub    $0x8,%esp
80105416:	e8 85 e2 ff ff       	call   801036a0 <myproc>
8010541b:	8b 40 10             	mov    0x10(%eax),%eax
8010541e:	c9                   	leave  
8010541f:	c3                   	ret    

80105420 <sys_sbrk>:
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	53                   	push   %ebx
80105424:	83 ec 24             	sub    $0x24,%esp
80105427:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010542a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010542e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105435:	e8 76 f2 ff ff       	call   801046b0 <argint>
8010543a:	85 c0                	test   %eax,%eax
8010543c:	78 22                	js     80105460 <sys_sbrk+0x40>
8010543e:	e8 5d e2 ff ff       	call   801036a0 <myproc>
80105443:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105446:	8b 18                	mov    (%eax),%ebx
80105448:	89 14 24             	mov    %edx,(%esp)
8010544b:	e8 90 e3 ff ff       	call   801037e0 <growproc>
80105450:	85 c0                	test   %eax,%eax
80105452:	78 0c                	js     80105460 <sys_sbrk+0x40>
80105454:	89 d8                	mov    %ebx,%eax
80105456:	83 c4 24             	add    $0x24,%esp
80105459:	5b                   	pop    %ebx
8010545a:	5d                   	pop    %ebp
8010545b:	c3                   	ret    
8010545c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105465:	eb ef                	jmp    80105456 <sys_sbrk+0x36>
80105467:	89 f6                	mov    %esi,%esi
80105469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105470 <sys_sleep>:
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	53                   	push   %ebx
80105474:	83 ec 24             	sub    $0x24,%esp
80105477:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010547a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010547e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105485:	e8 26 f2 ff ff       	call   801046b0 <argint>
8010548a:	85 c0                	test   %eax,%eax
8010548c:	78 7e                	js     8010550c <sys_sleep+0x9c>
8010548e:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105495:	e8 66 ee ff ff       	call   80104300 <acquire>
8010549a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010549d:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
801054a3:	85 d2                	test   %edx,%edx
801054a5:	75 29                	jne    801054d0 <sys_sleep+0x60>
801054a7:	eb 4f                	jmp    801054f8 <sys_sleep+0x88>
801054a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054b0:	c7 44 24 04 60 4d 11 	movl   $0x80114d60,0x4(%esp)
801054b7:	80 
801054b8:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)
801054bf:	e8 5c e8 ff ff       	call   80103d20 <sleep>
801054c4:	a1 a0 55 11 80       	mov    0x801155a0,%eax
801054c9:	29 d8                	sub    %ebx,%eax
801054cb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801054ce:	73 28                	jae    801054f8 <sys_sleep+0x88>
801054d0:	e8 cb e1 ff ff       	call   801036a0 <myproc>
801054d5:	8b 40 24             	mov    0x24(%eax),%eax
801054d8:	85 c0                	test   %eax,%eax
801054da:	74 d4                	je     801054b0 <sys_sleep+0x40>
801054dc:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801054e3:	e8 88 ee ff ff       	call   80104370 <release>
801054e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ed:	83 c4 24             	add    $0x24,%esp
801054f0:	5b                   	pop    %ebx
801054f1:	5d                   	pop    %ebp
801054f2:	c3                   	ret    
801054f3:	90                   	nop
801054f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054f8:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801054ff:	e8 6c ee ff ff       	call   80104370 <release>
80105504:	83 c4 24             	add    $0x24,%esp
80105507:	31 c0                	xor    %eax,%eax
80105509:	5b                   	pop    %ebx
8010550a:	5d                   	pop    %ebp
8010550b:	c3                   	ret    
8010550c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105511:	eb da                	jmp    801054ed <sys_sleep+0x7d>
80105513:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105520 <sys_uptime>:
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	53                   	push   %ebx
80105524:	83 ec 14             	sub    $0x14,%esp
80105527:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
8010552e:	e8 cd ed ff ff       	call   80104300 <acquire>
80105533:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
80105539:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105540:	e8 2b ee ff ff       	call   80104370 <release>
80105545:	83 c4 14             	add    $0x14,%esp
80105548:	89 d8                	mov    %ebx,%eax
8010554a:	5b                   	pop    %ebx
8010554b:	5d                   	pop    %ebp
8010554c:	c3                   	ret    

8010554d <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010554d:	1e                   	push   %ds
  pushl %es
8010554e:	06                   	push   %es
  pushl %fs
8010554f:	0f a0                	push   %fs
  pushl %gs
80105551:	0f a8                	push   %gs
  pushal
80105553:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105554:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105558:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010555a:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010555c:	54                   	push   %esp
  call trap
8010555d:	e8 de 00 00 00       	call   80105640 <trap>
  addl $4, %esp
80105562:	83 c4 04             	add    $0x4,%esp

80105565 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105565:	61                   	popa   
  popl %gs
80105566:	0f a9                	pop    %gs
  popl %fs
80105568:	0f a1                	pop    %fs
  popl %es
8010556a:	07                   	pop    %es
  popl %ds
8010556b:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010556c:	83 c4 08             	add    $0x8,%esp
  iret
8010556f:	cf                   	iret   

80105570 <tvinit>:
80105570:	31 c0                	xor    %eax,%eax
80105572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105578:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010557f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105584:	66 89 0c c5 a2 4d 11 	mov    %cx,-0x7feeb25e(,%eax,8)
8010558b:	80 
8010558c:	c6 04 c5 a4 4d 11 80 	movb   $0x0,-0x7feeb25c(,%eax,8)
80105593:	00 
80105594:	c6 04 c5 a5 4d 11 80 	movb   $0x8e,-0x7feeb25b(,%eax,8)
8010559b:	8e 
8010559c:	66 89 14 c5 a0 4d 11 	mov    %dx,-0x7feeb260(,%eax,8)
801055a3:	80 
801055a4:	c1 ea 10             	shr    $0x10,%edx
801055a7:	66 89 14 c5 a6 4d 11 	mov    %dx,-0x7feeb25a(,%eax,8)
801055ae:	80 
801055af:	83 c0 01             	add    $0x1,%eax
801055b2:	3d 00 01 00 00       	cmp    $0x100,%eax
801055b7:	75 bf                	jne    80105578 <tvinit+0x8>
801055b9:	55                   	push   %ebp
801055ba:	ba 08 00 00 00       	mov    $0x8,%edx
801055bf:	89 e5                	mov    %esp,%ebp
801055c1:	83 ec 18             	sub    $0x18,%esp
801055c4:	a1 08 a1 10 80       	mov    0x8010a108,%eax
801055c9:	c7 44 24 04 1d 75 10 	movl   $0x8010751d,0x4(%esp)
801055d0:	80 
801055d1:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801055d8:	66 89 15 a2 4f 11 80 	mov    %dx,0x80114fa2
801055df:	66 a3 a0 4f 11 80    	mov    %ax,0x80114fa0
801055e5:	c1 e8 10             	shr    $0x10,%eax
801055e8:	c6 05 a4 4f 11 80 00 	movb   $0x0,0x80114fa4
801055ef:	c6 05 a5 4f 11 80 ef 	movb   $0xef,0x80114fa5
801055f6:	66 a3 a6 4f 11 80    	mov    %ax,0x80114fa6
801055fc:	e8 8f eb ff ff       	call   80104190 <initlock>
80105601:	c9                   	leave  
80105602:	c3                   	ret    
80105603:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105610 <idtinit>:
80105610:	55                   	push   %ebp
80105611:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105616:	89 e5                	mov    %esp,%ebp
80105618:	83 ec 10             	sub    $0x10,%esp
8010561b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
8010561f:	b8 a0 4d 11 80       	mov    $0x80114da0,%eax
80105624:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80105628:	c1 e8 10             	shr    $0x10,%eax
8010562b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
8010562f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105632:	0f 01 18             	lidtl  (%eax)
80105635:	c9                   	leave  
80105636:	c3                   	ret    
80105637:	89 f6                	mov    %esi,%esi
80105639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105640 <trap>:
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	57                   	push   %edi
80105644:	56                   	push   %esi
80105645:	53                   	push   %ebx
80105646:	83 ec 3c             	sub    $0x3c,%esp
80105649:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010564c:	8b 43 30             	mov    0x30(%ebx),%eax
8010564f:	83 f8 40             	cmp    $0x40,%eax
80105652:	0f 84 a0 01 00 00    	je     801057f8 <trap+0x1b8>
80105658:	83 e8 20             	sub    $0x20,%eax
8010565b:	83 f8 1f             	cmp    $0x1f,%eax
8010565e:	77 08                	ja     80105668 <trap+0x28>
80105660:	ff 24 85 c4 75 10 80 	jmp    *-0x7fef8a3c(,%eax,4)
80105667:	90                   	nop
80105668:	e8 33 e0 ff ff       	call   801036a0 <myproc>
8010566d:	85 c0                	test   %eax,%eax
8010566f:	90                   	nop
80105670:	0f 84 fa 01 00 00    	je     80105870 <trap+0x230>
80105676:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010567a:	0f 84 f0 01 00 00    	je     80105870 <trap+0x230>
80105680:	0f 20 d1             	mov    %cr2,%ecx
80105683:	8b 53 38             	mov    0x38(%ebx),%edx
80105686:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105689:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010568c:	e8 ef df ff ff       	call   80103680 <cpuid>
80105691:	8b 73 30             	mov    0x30(%ebx),%esi
80105694:	89 c7                	mov    %eax,%edi
80105696:	8b 43 34             	mov    0x34(%ebx),%eax
80105699:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010569c:	e8 ff df ff ff       	call   801036a0 <myproc>
801056a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
801056a4:	e8 f7 df ff ff       	call   801036a0 <myproc>
801056a9:	8b 55 dc             	mov    -0x24(%ebp),%edx
801056ac:	89 74 24 0c          	mov    %esi,0xc(%esp)
801056b0:	8b 75 e0             	mov    -0x20(%ebp),%esi
801056b3:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801056b6:	89 7c 24 14          	mov    %edi,0x14(%esp)
801056ba:	89 54 24 18          	mov    %edx,0x18(%esp)
801056be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801056c1:	83 c6 6c             	add    $0x6c,%esi
801056c4:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
801056c8:	89 74 24 08          	mov    %esi,0x8(%esp)
801056cc:	89 54 24 10          	mov    %edx,0x10(%esp)
801056d0:	8b 40 10             	mov    0x10(%eax),%eax
801056d3:	c7 04 24 80 75 10 80 	movl   $0x80107580,(%esp)
801056da:	89 44 24 04          	mov    %eax,0x4(%esp)
801056de:	e8 6d af ff ff       	call   80100650 <cprintf>
801056e3:	e8 b8 df ff ff       	call   801036a0 <myproc>
801056e8:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801056ef:	90                   	nop
801056f0:	e8 ab df ff ff       	call   801036a0 <myproc>
801056f5:	85 c0                	test   %eax,%eax
801056f7:	74 0c                	je     80105705 <trap+0xc5>
801056f9:	e8 a2 df ff ff       	call   801036a0 <myproc>
801056fe:	8b 50 24             	mov    0x24(%eax),%edx
80105701:	85 d2                	test   %edx,%edx
80105703:	75 4b                	jne    80105750 <trap+0x110>
80105705:	e8 96 df ff ff       	call   801036a0 <myproc>
8010570a:	85 c0                	test   %eax,%eax
8010570c:	74 0d                	je     8010571b <trap+0xdb>
8010570e:	66 90                	xchg   %ax,%ax
80105710:	e8 8b df ff ff       	call   801036a0 <myproc>
80105715:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105719:	74 4d                	je     80105768 <trap+0x128>
8010571b:	e8 80 df ff ff       	call   801036a0 <myproc>
80105720:	85 c0                	test   %eax,%eax
80105722:	74 1d                	je     80105741 <trap+0x101>
80105724:	e8 77 df ff ff       	call   801036a0 <myproc>
80105729:	8b 40 24             	mov    0x24(%eax),%eax
8010572c:	85 c0                	test   %eax,%eax
8010572e:	74 11                	je     80105741 <trap+0x101>
80105730:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105734:	83 e0 03             	and    $0x3,%eax
80105737:	66 83 f8 03          	cmp    $0x3,%ax
8010573b:	0f 84 e8 00 00 00    	je     80105829 <trap+0x1e9>
80105741:	83 c4 3c             	add    $0x3c,%esp
80105744:	5b                   	pop    %ebx
80105745:	5e                   	pop    %esi
80105746:	5f                   	pop    %edi
80105747:	5d                   	pop    %ebp
80105748:	c3                   	ret    
80105749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105750:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105754:	83 e0 03             	and    $0x3,%eax
80105757:	66 83 f8 03          	cmp    $0x3,%ax
8010575b:	75 a8                	jne    80105705 <trap+0xc5>
8010575d:	e8 3e e3 ff ff       	call   80103aa0 <exit>
80105762:	eb a1                	jmp    80105705 <trap+0xc5>
80105764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105768:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010576c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105770:	75 a9                	jne    8010571b <trap+0xdb>
80105772:	e8 69 e5 ff ff       	call   80103ce0 <yield>
80105777:	eb a2                	jmp    8010571b <trap+0xdb>
80105779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105780:	e8 fb de ff ff       	call   80103680 <cpuid>
80105785:	85 c0                	test   %eax,%eax
80105787:	0f 84 b3 00 00 00    	je     80105840 <trap+0x200>
8010578d:	8d 76 00             	lea    0x0(%esi),%esi
80105790:	e8 eb cf ff ff       	call   80102780 <lapiceoi>
80105795:	e9 56 ff ff ff       	jmp    801056f0 <trap+0xb0>
8010579a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801057a0:	e8 2b ce ff ff       	call   801025d0 <kbdintr>
801057a5:	e8 d6 cf ff ff       	call   80102780 <lapiceoi>
801057aa:	e9 41 ff ff ff       	jmp    801056f0 <trap+0xb0>
801057af:	90                   	nop
801057b0:	e8 1b 02 00 00       	call   801059d0 <uartintr>
801057b5:	e8 c6 cf ff ff       	call   80102780 <lapiceoi>
801057ba:	e9 31 ff ff ff       	jmp    801056f0 <trap+0xb0>
801057bf:	90                   	nop
801057c0:	8b 7b 38             	mov    0x38(%ebx),%edi
801057c3:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801057c7:	e8 b4 de ff ff       	call   80103680 <cpuid>
801057cc:	c7 04 24 28 75 10 80 	movl   $0x80107528,(%esp)
801057d3:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801057d7:	89 74 24 08          	mov    %esi,0x8(%esp)
801057db:	89 44 24 04          	mov    %eax,0x4(%esp)
801057df:	e8 6c ae ff ff       	call   80100650 <cprintf>
801057e4:	e8 97 cf ff ff       	call   80102780 <lapiceoi>
801057e9:	e9 02 ff ff ff       	jmp    801056f0 <trap+0xb0>
801057ee:	66 90                	xchg   %ax,%ax
801057f0:	e8 8b c8 ff ff       	call   80102080 <ideintr>
801057f5:	eb 96                	jmp    8010578d <trap+0x14d>
801057f7:	90                   	nop
801057f8:	90                   	nop
801057f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105800:	e8 9b de ff ff       	call   801036a0 <myproc>
80105805:	8b 70 24             	mov    0x24(%eax),%esi
80105808:	85 f6                	test   %esi,%esi
8010580a:	75 2c                	jne    80105838 <trap+0x1f8>
8010580c:	e8 8f de ff ff       	call   801036a0 <myproc>
80105811:	89 58 18             	mov    %ebx,0x18(%eax)
80105814:	e8 67 ef ff ff       	call   80104780 <syscall>
80105819:	e8 82 de ff ff       	call   801036a0 <myproc>
8010581e:	8b 48 24             	mov    0x24(%eax),%ecx
80105821:	85 c9                	test   %ecx,%ecx
80105823:	0f 84 18 ff ff ff    	je     80105741 <trap+0x101>
80105829:	83 c4 3c             	add    $0x3c,%esp
8010582c:	5b                   	pop    %ebx
8010582d:	5e                   	pop    %esi
8010582e:	5f                   	pop    %edi
8010582f:	5d                   	pop    %ebp
80105830:	e9 6b e2 ff ff       	jmp    80103aa0 <exit>
80105835:	8d 76 00             	lea    0x0(%esi),%esi
80105838:	e8 63 e2 ff ff       	call   80103aa0 <exit>
8010583d:	eb cd                	jmp    8010580c <trap+0x1cc>
8010583f:	90                   	nop
80105840:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105847:	e8 b4 ea ff ff       	call   80104300 <acquire>
8010584c:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)
80105853:	83 05 a0 55 11 80 01 	addl   $0x1,0x801155a0
8010585a:	e8 51 e6 ff ff       	call   80103eb0 <wakeup>
8010585f:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105866:	e8 05 eb ff ff       	call   80104370 <release>
8010586b:	e9 1d ff ff ff       	jmp    8010578d <trap+0x14d>
80105870:	0f 20 d7             	mov    %cr2,%edi
80105873:	8b 73 38             	mov    0x38(%ebx),%esi
80105876:	e8 05 de ff ff       	call   80103680 <cpuid>
8010587b:	89 7c 24 10          	mov    %edi,0x10(%esp)
8010587f:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105883:	89 44 24 08          	mov    %eax,0x8(%esp)
80105887:	8b 43 30             	mov    0x30(%ebx),%eax
8010588a:	c7 04 24 4c 75 10 80 	movl   $0x8010754c,(%esp)
80105891:	89 44 24 04          	mov    %eax,0x4(%esp)
80105895:	e8 b6 ad ff ff       	call   80100650 <cprintf>
8010589a:	c7 04 24 22 75 10 80 	movl   $0x80107522,(%esp)
801058a1:	e8 ba aa ff ff       	call   80100360 <panic>
801058a6:	66 90                	xchg   %ax,%ax
801058a8:	66 90                	xchg   %ax,%ax
801058aa:	66 90                	xchg   %ax,%ax
801058ac:	66 90                	xchg   %ax,%ax
801058ae:	66 90                	xchg   %ax,%ax

801058b0 <uartgetc>:
801058b0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
801058b5:	55                   	push   %ebp
801058b6:	89 e5                	mov    %esp,%ebp
801058b8:	85 c0                	test   %eax,%eax
801058ba:	74 14                	je     801058d0 <uartgetc+0x20>
801058bc:	ba fd 03 00 00       	mov    $0x3fd,%edx
801058c1:	ec                   	in     (%dx),%al
801058c2:	a8 01                	test   $0x1,%al
801058c4:	74 0a                	je     801058d0 <uartgetc+0x20>
801058c6:	b2 f8                	mov    $0xf8,%dl
801058c8:	ec                   	in     (%dx),%al
801058c9:	0f b6 c0             	movzbl %al,%eax
801058cc:	5d                   	pop    %ebp
801058cd:	c3                   	ret    
801058ce:	66 90                	xchg   %ax,%ax
801058d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d5:	5d                   	pop    %ebp
801058d6:	c3                   	ret    
801058d7:	89 f6                	mov    %esi,%esi
801058d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058e0 <uartputc>:
801058e0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
801058e5:	85 c0                	test   %eax,%eax
801058e7:	74 3f                	je     80105928 <uartputc+0x48>
801058e9:	55                   	push   %ebp
801058ea:	89 e5                	mov    %esp,%ebp
801058ec:	56                   	push   %esi
801058ed:	be fd 03 00 00       	mov    $0x3fd,%esi
801058f2:	53                   	push   %ebx
801058f3:	bb 80 00 00 00       	mov    $0x80,%ebx
801058f8:	83 ec 10             	sub    $0x10,%esp
801058fb:	eb 14                	jmp    80105911 <uartputc+0x31>
801058fd:	8d 76 00             	lea    0x0(%esi),%esi
80105900:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105907:	e8 94 ce ff ff       	call   801027a0 <microdelay>
8010590c:	83 eb 01             	sub    $0x1,%ebx
8010590f:	74 07                	je     80105918 <uartputc+0x38>
80105911:	89 f2                	mov    %esi,%edx
80105913:	ec                   	in     (%dx),%al
80105914:	a8 20                	test   $0x20,%al
80105916:	74 e8                	je     80105900 <uartputc+0x20>
80105918:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
8010591c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105921:	ee                   	out    %al,(%dx)
80105922:	83 c4 10             	add    $0x10,%esp
80105925:	5b                   	pop    %ebx
80105926:	5e                   	pop    %esi
80105927:	5d                   	pop    %ebp
80105928:	f3 c3                	repz ret 
8010592a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105930 <uartinit>:
80105930:	55                   	push   %ebp
80105931:	31 c9                	xor    %ecx,%ecx
80105933:	89 e5                	mov    %esp,%ebp
80105935:	89 c8                	mov    %ecx,%eax
80105937:	57                   	push   %edi
80105938:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010593d:	56                   	push   %esi
8010593e:	89 fa                	mov    %edi,%edx
80105940:	53                   	push   %ebx
80105941:	83 ec 1c             	sub    $0x1c,%esp
80105944:	ee                   	out    %al,(%dx)
80105945:	be fb 03 00 00       	mov    $0x3fb,%esi
8010594a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010594f:	89 f2                	mov    %esi,%edx
80105951:	ee                   	out    %al,(%dx)
80105952:	b8 0c 00 00 00       	mov    $0xc,%eax
80105957:	b2 f8                	mov    $0xf8,%dl
80105959:	ee                   	out    %al,(%dx)
8010595a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
8010595f:	89 c8                	mov    %ecx,%eax
80105961:	89 da                	mov    %ebx,%edx
80105963:	ee                   	out    %al,(%dx)
80105964:	b8 03 00 00 00       	mov    $0x3,%eax
80105969:	89 f2                	mov    %esi,%edx
8010596b:	ee                   	out    %al,(%dx)
8010596c:	b2 fc                	mov    $0xfc,%dl
8010596e:	89 c8                	mov    %ecx,%eax
80105970:	ee                   	out    %al,(%dx)
80105971:	b8 01 00 00 00       	mov    $0x1,%eax
80105976:	89 da                	mov    %ebx,%edx
80105978:	ee                   	out    %al,(%dx)
80105979:	b2 fd                	mov    $0xfd,%dl
8010597b:	ec                   	in     (%dx),%al
8010597c:	3c ff                	cmp    $0xff,%al
8010597e:	74 42                	je     801059c2 <uartinit+0x92>
80105980:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105987:	00 00 00 
8010598a:	89 fa                	mov    %edi,%edx
8010598c:	ec                   	in     (%dx),%al
8010598d:	b2 f8                	mov    $0xf8,%dl
8010598f:	ec                   	in     (%dx),%al
80105990:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105997:	00 
80105998:	bb 44 76 10 80       	mov    $0x80107644,%ebx
8010599d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801059a4:	e8 07 c9 ff ff       	call   801022b0 <ioapicenable>
801059a9:	b8 78 00 00 00       	mov    $0x78,%eax
801059ae:	66 90                	xchg   %ax,%ax
801059b0:	89 04 24             	mov    %eax,(%esp)
801059b3:	83 c3 01             	add    $0x1,%ebx
801059b6:	e8 25 ff ff ff       	call   801058e0 <uartputc>
801059bb:	0f be 03             	movsbl (%ebx),%eax
801059be:	84 c0                	test   %al,%al
801059c0:	75 ee                	jne    801059b0 <uartinit+0x80>
801059c2:	83 c4 1c             	add    $0x1c,%esp
801059c5:	5b                   	pop    %ebx
801059c6:	5e                   	pop    %esi
801059c7:	5f                   	pop    %edi
801059c8:	5d                   	pop    %ebp
801059c9:	c3                   	ret    
801059ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801059d0 <uartintr>:
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	83 ec 18             	sub    $0x18,%esp
801059d6:	c7 04 24 b0 58 10 80 	movl   $0x801058b0,(%esp)
801059dd:	e8 ce ad ff ff       	call   801007b0 <consoleintr>
801059e2:	c9                   	leave  
801059e3:	c3                   	ret    

801059e4 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801059e4:	6a 00                	push   $0x0
  pushl $0
801059e6:	6a 00                	push   $0x0
  jmp alltraps
801059e8:	e9 60 fb ff ff       	jmp    8010554d <alltraps>

801059ed <vector1>:
.globl vector1
vector1:
  pushl $0
801059ed:	6a 00                	push   $0x0
  pushl $1
801059ef:	6a 01                	push   $0x1
  jmp alltraps
801059f1:	e9 57 fb ff ff       	jmp    8010554d <alltraps>

801059f6 <vector2>:
.globl vector2
vector2:
  pushl $0
801059f6:	6a 00                	push   $0x0
  pushl $2
801059f8:	6a 02                	push   $0x2
  jmp alltraps
801059fa:	e9 4e fb ff ff       	jmp    8010554d <alltraps>

801059ff <vector3>:
.globl vector3
vector3:
  pushl $0
801059ff:	6a 00                	push   $0x0
  pushl $3
80105a01:	6a 03                	push   $0x3
  jmp alltraps
80105a03:	e9 45 fb ff ff       	jmp    8010554d <alltraps>

80105a08 <vector4>:
.globl vector4
vector4:
  pushl $0
80105a08:	6a 00                	push   $0x0
  pushl $4
80105a0a:	6a 04                	push   $0x4
  jmp alltraps
80105a0c:	e9 3c fb ff ff       	jmp    8010554d <alltraps>

80105a11 <vector5>:
.globl vector5
vector5:
  pushl $0
80105a11:	6a 00                	push   $0x0
  pushl $5
80105a13:	6a 05                	push   $0x5
  jmp alltraps
80105a15:	e9 33 fb ff ff       	jmp    8010554d <alltraps>

80105a1a <vector6>:
.globl vector6
vector6:
  pushl $0
80105a1a:	6a 00                	push   $0x0
  pushl $6
80105a1c:	6a 06                	push   $0x6
  jmp alltraps
80105a1e:	e9 2a fb ff ff       	jmp    8010554d <alltraps>

80105a23 <vector7>:
.globl vector7
vector7:
  pushl $0
80105a23:	6a 00                	push   $0x0
  pushl $7
80105a25:	6a 07                	push   $0x7
  jmp alltraps
80105a27:	e9 21 fb ff ff       	jmp    8010554d <alltraps>

80105a2c <vector8>:
.globl vector8
vector8:
  pushl $8
80105a2c:	6a 08                	push   $0x8
  jmp alltraps
80105a2e:	e9 1a fb ff ff       	jmp    8010554d <alltraps>

80105a33 <vector9>:
.globl vector9
vector9:
  pushl $0
80105a33:	6a 00                	push   $0x0
  pushl $9
80105a35:	6a 09                	push   $0x9
  jmp alltraps
80105a37:	e9 11 fb ff ff       	jmp    8010554d <alltraps>

80105a3c <vector10>:
.globl vector10
vector10:
  pushl $10
80105a3c:	6a 0a                	push   $0xa
  jmp alltraps
80105a3e:	e9 0a fb ff ff       	jmp    8010554d <alltraps>

80105a43 <vector11>:
.globl vector11
vector11:
  pushl $11
80105a43:	6a 0b                	push   $0xb
  jmp alltraps
80105a45:	e9 03 fb ff ff       	jmp    8010554d <alltraps>

80105a4a <vector12>:
.globl vector12
vector12:
  pushl $12
80105a4a:	6a 0c                	push   $0xc
  jmp alltraps
80105a4c:	e9 fc fa ff ff       	jmp    8010554d <alltraps>

80105a51 <vector13>:
.globl vector13
vector13:
  pushl $13
80105a51:	6a 0d                	push   $0xd
  jmp alltraps
80105a53:	e9 f5 fa ff ff       	jmp    8010554d <alltraps>

80105a58 <vector14>:
.globl vector14
vector14:
  pushl $14
80105a58:	6a 0e                	push   $0xe
  jmp alltraps
80105a5a:	e9 ee fa ff ff       	jmp    8010554d <alltraps>

80105a5f <vector15>:
.globl vector15
vector15:
  pushl $0
80105a5f:	6a 00                	push   $0x0
  pushl $15
80105a61:	6a 0f                	push   $0xf
  jmp alltraps
80105a63:	e9 e5 fa ff ff       	jmp    8010554d <alltraps>

80105a68 <vector16>:
.globl vector16
vector16:
  pushl $0
80105a68:	6a 00                	push   $0x0
  pushl $16
80105a6a:	6a 10                	push   $0x10
  jmp alltraps
80105a6c:	e9 dc fa ff ff       	jmp    8010554d <alltraps>

80105a71 <vector17>:
.globl vector17
vector17:
  pushl $17
80105a71:	6a 11                	push   $0x11
  jmp alltraps
80105a73:	e9 d5 fa ff ff       	jmp    8010554d <alltraps>

80105a78 <vector18>:
.globl vector18
vector18:
  pushl $0
80105a78:	6a 00                	push   $0x0
  pushl $18
80105a7a:	6a 12                	push   $0x12
  jmp alltraps
80105a7c:	e9 cc fa ff ff       	jmp    8010554d <alltraps>

80105a81 <vector19>:
.globl vector19
vector19:
  pushl $0
80105a81:	6a 00                	push   $0x0
  pushl $19
80105a83:	6a 13                	push   $0x13
  jmp alltraps
80105a85:	e9 c3 fa ff ff       	jmp    8010554d <alltraps>

80105a8a <vector20>:
.globl vector20
vector20:
  pushl $0
80105a8a:	6a 00                	push   $0x0
  pushl $20
80105a8c:	6a 14                	push   $0x14
  jmp alltraps
80105a8e:	e9 ba fa ff ff       	jmp    8010554d <alltraps>

80105a93 <vector21>:
.globl vector21
vector21:
  pushl $0
80105a93:	6a 00                	push   $0x0
  pushl $21
80105a95:	6a 15                	push   $0x15
  jmp alltraps
80105a97:	e9 b1 fa ff ff       	jmp    8010554d <alltraps>

80105a9c <vector22>:
.globl vector22
vector22:
  pushl $0
80105a9c:	6a 00                	push   $0x0
  pushl $22
80105a9e:	6a 16                	push   $0x16
  jmp alltraps
80105aa0:	e9 a8 fa ff ff       	jmp    8010554d <alltraps>

80105aa5 <vector23>:
.globl vector23
vector23:
  pushl $0
80105aa5:	6a 00                	push   $0x0
  pushl $23
80105aa7:	6a 17                	push   $0x17
  jmp alltraps
80105aa9:	e9 9f fa ff ff       	jmp    8010554d <alltraps>

80105aae <vector24>:
.globl vector24
vector24:
  pushl $0
80105aae:	6a 00                	push   $0x0
  pushl $24
80105ab0:	6a 18                	push   $0x18
  jmp alltraps
80105ab2:	e9 96 fa ff ff       	jmp    8010554d <alltraps>

80105ab7 <vector25>:
.globl vector25
vector25:
  pushl $0
80105ab7:	6a 00                	push   $0x0
  pushl $25
80105ab9:	6a 19                	push   $0x19
  jmp alltraps
80105abb:	e9 8d fa ff ff       	jmp    8010554d <alltraps>

80105ac0 <vector26>:
.globl vector26
vector26:
  pushl $0
80105ac0:	6a 00                	push   $0x0
  pushl $26
80105ac2:	6a 1a                	push   $0x1a
  jmp alltraps
80105ac4:	e9 84 fa ff ff       	jmp    8010554d <alltraps>

80105ac9 <vector27>:
.globl vector27
vector27:
  pushl $0
80105ac9:	6a 00                	push   $0x0
  pushl $27
80105acb:	6a 1b                	push   $0x1b
  jmp alltraps
80105acd:	e9 7b fa ff ff       	jmp    8010554d <alltraps>

80105ad2 <vector28>:
.globl vector28
vector28:
  pushl $0
80105ad2:	6a 00                	push   $0x0
  pushl $28
80105ad4:	6a 1c                	push   $0x1c
  jmp alltraps
80105ad6:	e9 72 fa ff ff       	jmp    8010554d <alltraps>

80105adb <vector29>:
.globl vector29
vector29:
  pushl $0
80105adb:	6a 00                	push   $0x0
  pushl $29
80105add:	6a 1d                	push   $0x1d
  jmp alltraps
80105adf:	e9 69 fa ff ff       	jmp    8010554d <alltraps>

80105ae4 <vector30>:
.globl vector30
vector30:
  pushl $0
80105ae4:	6a 00                	push   $0x0
  pushl $30
80105ae6:	6a 1e                	push   $0x1e
  jmp alltraps
80105ae8:	e9 60 fa ff ff       	jmp    8010554d <alltraps>

80105aed <vector31>:
.globl vector31
vector31:
  pushl $0
80105aed:	6a 00                	push   $0x0
  pushl $31
80105aef:	6a 1f                	push   $0x1f
  jmp alltraps
80105af1:	e9 57 fa ff ff       	jmp    8010554d <alltraps>

80105af6 <vector32>:
.globl vector32
vector32:
  pushl $0
80105af6:	6a 00                	push   $0x0
  pushl $32
80105af8:	6a 20                	push   $0x20
  jmp alltraps
80105afa:	e9 4e fa ff ff       	jmp    8010554d <alltraps>

80105aff <vector33>:
.globl vector33
vector33:
  pushl $0
80105aff:	6a 00                	push   $0x0
  pushl $33
80105b01:	6a 21                	push   $0x21
  jmp alltraps
80105b03:	e9 45 fa ff ff       	jmp    8010554d <alltraps>

80105b08 <vector34>:
.globl vector34
vector34:
  pushl $0
80105b08:	6a 00                	push   $0x0
  pushl $34
80105b0a:	6a 22                	push   $0x22
  jmp alltraps
80105b0c:	e9 3c fa ff ff       	jmp    8010554d <alltraps>

80105b11 <vector35>:
.globl vector35
vector35:
  pushl $0
80105b11:	6a 00                	push   $0x0
  pushl $35
80105b13:	6a 23                	push   $0x23
  jmp alltraps
80105b15:	e9 33 fa ff ff       	jmp    8010554d <alltraps>

80105b1a <vector36>:
.globl vector36
vector36:
  pushl $0
80105b1a:	6a 00                	push   $0x0
  pushl $36
80105b1c:	6a 24                	push   $0x24
  jmp alltraps
80105b1e:	e9 2a fa ff ff       	jmp    8010554d <alltraps>

80105b23 <vector37>:
.globl vector37
vector37:
  pushl $0
80105b23:	6a 00                	push   $0x0
  pushl $37
80105b25:	6a 25                	push   $0x25
  jmp alltraps
80105b27:	e9 21 fa ff ff       	jmp    8010554d <alltraps>

80105b2c <vector38>:
.globl vector38
vector38:
  pushl $0
80105b2c:	6a 00                	push   $0x0
  pushl $38
80105b2e:	6a 26                	push   $0x26
  jmp alltraps
80105b30:	e9 18 fa ff ff       	jmp    8010554d <alltraps>

80105b35 <vector39>:
.globl vector39
vector39:
  pushl $0
80105b35:	6a 00                	push   $0x0
  pushl $39
80105b37:	6a 27                	push   $0x27
  jmp alltraps
80105b39:	e9 0f fa ff ff       	jmp    8010554d <alltraps>

80105b3e <vector40>:
.globl vector40
vector40:
  pushl $0
80105b3e:	6a 00                	push   $0x0
  pushl $40
80105b40:	6a 28                	push   $0x28
  jmp alltraps
80105b42:	e9 06 fa ff ff       	jmp    8010554d <alltraps>

80105b47 <vector41>:
.globl vector41
vector41:
  pushl $0
80105b47:	6a 00                	push   $0x0
  pushl $41
80105b49:	6a 29                	push   $0x29
  jmp alltraps
80105b4b:	e9 fd f9 ff ff       	jmp    8010554d <alltraps>

80105b50 <vector42>:
.globl vector42
vector42:
  pushl $0
80105b50:	6a 00                	push   $0x0
  pushl $42
80105b52:	6a 2a                	push   $0x2a
  jmp alltraps
80105b54:	e9 f4 f9 ff ff       	jmp    8010554d <alltraps>

80105b59 <vector43>:
.globl vector43
vector43:
  pushl $0
80105b59:	6a 00                	push   $0x0
  pushl $43
80105b5b:	6a 2b                	push   $0x2b
  jmp alltraps
80105b5d:	e9 eb f9 ff ff       	jmp    8010554d <alltraps>

80105b62 <vector44>:
.globl vector44
vector44:
  pushl $0
80105b62:	6a 00                	push   $0x0
  pushl $44
80105b64:	6a 2c                	push   $0x2c
  jmp alltraps
80105b66:	e9 e2 f9 ff ff       	jmp    8010554d <alltraps>

80105b6b <vector45>:
.globl vector45
vector45:
  pushl $0
80105b6b:	6a 00                	push   $0x0
  pushl $45
80105b6d:	6a 2d                	push   $0x2d
  jmp alltraps
80105b6f:	e9 d9 f9 ff ff       	jmp    8010554d <alltraps>

80105b74 <vector46>:
.globl vector46
vector46:
  pushl $0
80105b74:	6a 00                	push   $0x0
  pushl $46
80105b76:	6a 2e                	push   $0x2e
  jmp alltraps
80105b78:	e9 d0 f9 ff ff       	jmp    8010554d <alltraps>

80105b7d <vector47>:
.globl vector47
vector47:
  pushl $0
80105b7d:	6a 00                	push   $0x0
  pushl $47
80105b7f:	6a 2f                	push   $0x2f
  jmp alltraps
80105b81:	e9 c7 f9 ff ff       	jmp    8010554d <alltraps>

80105b86 <vector48>:
.globl vector48
vector48:
  pushl $0
80105b86:	6a 00                	push   $0x0
  pushl $48
80105b88:	6a 30                	push   $0x30
  jmp alltraps
80105b8a:	e9 be f9 ff ff       	jmp    8010554d <alltraps>

80105b8f <vector49>:
.globl vector49
vector49:
  pushl $0
80105b8f:	6a 00                	push   $0x0
  pushl $49
80105b91:	6a 31                	push   $0x31
  jmp alltraps
80105b93:	e9 b5 f9 ff ff       	jmp    8010554d <alltraps>

80105b98 <vector50>:
.globl vector50
vector50:
  pushl $0
80105b98:	6a 00                	push   $0x0
  pushl $50
80105b9a:	6a 32                	push   $0x32
  jmp alltraps
80105b9c:	e9 ac f9 ff ff       	jmp    8010554d <alltraps>

80105ba1 <vector51>:
.globl vector51
vector51:
  pushl $0
80105ba1:	6a 00                	push   $0x0
  pushl $51
80105ba3:	6a 33                	push   $0x33
  jmp alltraps
80105ba5:	e9 a3 f9 ff ff       	jmp    8010554d <alltraps>

80105baa <vector52>:
.globl vector52
vector52:
  pushl $0
80105baa:	6a 00                	push   $0x0
  pushl $52
80105bac:	6a 34                	push   $0x34
  jmp alltraps
80105bae:	e9 9a f9 ff ff       	jmp    8010554d <alltraps>

80105bb3 <vector53>:
.globl vector53
vector53:
  pushl $0
80105bb3:	6a 00                	push   $0x0
  pushl $53
80105bb5:	6a 35                	push   $0x35
  jmp alltraps
80105bb7:	e9 91 f9 ff ff       	jmp    8010554d <alltraps>

80105bbc <vector54>:
.globl vector54
vector54:
  pushl $0
80105bbc:	6a 00                	push   $0x0
  pushl $54
80105bbe:	6a 36                	push   $0x36
  jmp alltraps
80105bc0:	e9 88 f9 ff ff       	jmp    8010554d <alltraps>

80105bc5 <vector55>:
.globl vector55
vector55:
  pushl $0
80105bc5:	6a 00                	push   $0x0
  pushl $55
80105bc7:	6a 37                	push   $0x37
  jmp alltraps
80105bc9:	e9 7f f9 ff ff       	jmp    8010554d <alltraps>

80105bce <vector56>:
.globl vector56
vector56:
  pushl $0
80105bce:	6a 00                	push   $0x0
  pushl $56
80105bd0:	6a 38                	push   $0x38
  jmp alltraps
80105bd2:	e9 76 f9 ff ff       	jmp    8010554d <alltraps>

80105bd7 <vector57>:
.globl vector57
vector57:
  pushl $0
80105bd7:	6a 00                	push   $0x0
  pushl $57
80105bd9:	6a 39                	push   $0x39
  jmp alltraps
80105bdb:	e9 6d f9 ff ff       	jmp    8010554d <alltraps>

80105be0 <vector58>:
.globl vector58
vector58:
  pushl $0
80105be0:	6a 00                	push   $0x0
  pushl $58
80105be2:	6a 3a                	push   $0x3a
  jmp alltraps
80105be4:	e9 64 f9 ff ff       	jmp    8010554d <alltraps>

80105be9 <vector59>:
.globl vector59
vector59:
  pushl $0
80105be9:	6a 00                	push   $0x0
  pushl $59
80105beb:	6a 3b                	push   $0x3b
  jmp alltraps
80105bed:	e9 5b f9 ff ff       	jmp    8010554d <alltraps>

80105bf2 <vector60>:
.globl vector60
vector60:
  pushl $0
80105bf2:	6a 00                	push   $0x0
  pushl $60
80105bf4:	6a 3c                	push   $0x3c
  jmp alltraps
80105bf6:	e9 52 f9 ff ff       	jmp    8010554d <alltraps>

80105bfb <vector61>:
.globl vector61
vector61:
  pushl $0
80105bfb:	6a 00                	push   $0x0
  pushl $61
80105bfd:	6a 3d                	push   $0x3d
  jmp alltraps
80105bff:	e9 49 f9 ff ff       	jmp    8010554d <alltraps>

80105c04 <vector62>:
.globl vector62
vector62:
  pushl $0
80105c04:	6a 00                	push   $0x0
  pushl $62
80105c06:	6a 3e                	push   $0x3e
  jmp alltraps
80105c08:	e9 40 f9 ff ff       	jmp    8010554d <alltraps>

80105c0d <vector63>:
.globl vector63
vector63:
  pushl $0
80105c0d:	6a 00                	push   $0x0
  pushl $63
80105c0f:	6a 3f                	push   $0x3f
  jmp alltraps
80105c11:	e9 37 f9 ff ff       	jmp    8010554d <alltraps>

80105c16 <vector64>:
.globl vector64
vector64:
  pushl $0
80105c16:	6a 00                	push   $0x0
  pushl $64
80105c18:	6a 40                	push   $0x40
  jmp alltraps
80105c1a:	e9 2e f9 ff ff       	jmp    8010554d <alltraps>

80105c1f <vector65>:
.globl vector65
vector65:
  pushl $0
80105c1f:	6a 00                	push   $0x0
  pushl $65
80105c21:	6a 41                	push   $0x41
  jmp alltraps
80105c23:	e9 25 f9 ff ff       	jmp    8010554d <alltraps>

80105c28 <vector66>:
.globl vector66
vector66:
  pushl $0
80105c28:	6a 00                	push   $0x0
  pushl $66
80105c2a:	6a 42                	push   $0x42
  jmp alltraps
80105c2c:	e9 1c f9 ff ff       	jmp    8010554d <alltraps>

80105c31 <vector67>:
.globl vector67
vector67:
  pushl $0
80105c31:	6a 00                	push   $0x0
  pushl $67
80105c33:	6a 43                	push   $0x43
  jmp alltraps
80105c35:	e9 13 f9 ff ff       	jmp    8010554d <alltraps>

80105c3a <vector68>:
.globl vector68
vector68:
  pushl $0
80105c3a:	6a 00                	push   $0x0
  pushl $68
80105c3c:	6a 44                	push   $0x44
  jmp alltraps
80105c3e:	e9 0a f9 ff ff       	jmp    8010554d <alltraps>

80105c43 <vector69>:
.globl vector69
vector69:
  pushl $0
80105c43:	6a 00                	push   $0x0
  pushl $69
80105c45:	6a 45                	push   $0x45
  jmp alltraps
80105c47:	e9 01 f9 ff ff       	jmp    8010554d <alltraps>

80105c4c <vector70>:
.globl vector70
vector70:
  pushl $0
80105c4c:	6a 00                	push   $0x0
  pushl $70
80105c4e:	6a 46                	push   $0x46
  jmp alltraps
80105c50:	e9 f8 f8 ff ff       	jmp    8010554d <alltraps>

80105c55 <vector71>:
.globl vector71
vector71:
  pushl $0
80105c55:	6a 00                	push   $0x0
  pushl $71
80105c57:	6a 47                	push   $0x47
  jmp alltraps
80105c59:	e9 ef f8 ff ff       	jmp    8010554d <alltraps>

80105c5e <vector72>:
.globl vector72
vector72:
  pushl $0
80105c5e:	6a 00                	push   $0x0
  pushl $72
80105c60:	6a 48                	push   $0x48
  jmp alltraps
80105c62:	e9 e6 f8 ff ff       	jmp    8010554d <alltraps>

80105c67 <vector73>:
.globl vector73
vector73:
  pushl $0
80105c67:	6a 00                	push   $0x0
  pushl $73
80105c69:	6a 49                	push   $0x49
  jmp alltraps
80105c6b:	e9 dd f8 ff ff       	jmp    8010554d <alltraps>

80105c70 <vector74>:
.globl vector74
vector74:
  pushl $0
80105c70:	6a 00                	push   $0x0
  pushl $74
80105c72:	6a 4a                	push   $0x4a
  jmp alltraps
80105c74:	e9 d4 f8 ff ff       	jmp    8010554d <alltraps>

80105c79 <vector75>:
.globl vector75
vector75:
  pushl $0
80105c79:	6a 00                	push   $0x0
  pushl $75
80105c7b:	6a 4b                	push   $0x4b
  jmp alltraps
80105c7d:	e9 cb f8 ff ff       	jmp    8010554d <alltraps>

80105c82 <vector76>:
.globl vector76
vector76:
  pushl $0
80105c82:	6a 00                	push   $0x0
  pushl $76
80105c84:	6a 4c                	push   $0x4c
  jmp alltraps
80105c86:	e9 c2 f8 ff ff       	jmp    8010554d <alltraps>

80105c8b <vector77>:
.globl vector77
vector77:
  pushl $0
80105c8b:	6a 00                	push   $0x0
  pushl $77
80105c8d:	6a 4d                	push   $0x4d
  jmp alltraps
80105c8f:	e9 b9 f8 ff ff       	jmp    8010554d <alltraps>

80105c94 <vector78>:
.globl vector78
vector78:
  pushl $0
80105c94:	6a 00                	push   $0x0
  pushl $78
80105c96:	6a 4e                	push   $0x4e
  jmp alltraps
80105c98:	e9 b0 f8 ff ff       	jmp    8010554d <alltraps>

80105c9d <vector79>:
.globl vector79
vector79:
  pushl $0
80105c9d:	6a 00                	push   $0x0
  pushl $79
80105c9f:	6a 4f                	push   $0x4f
  jmp alltraps
80105ca1:	e9 a7 f8 ff ff       	jmp    8010554d <alltraps>

80105ca6 <vector80>:
.globl vector80
vector80:
  pushl $0
80105ca6:	6a 00                	push   $0x0
  pushl $80
80105ca8:	6a 50                	push   $0x50
  jmp alltraps
80105caa:	e9 9e f8 ff ff       	jmp    8010554d <alltraps>

80105caf <vector81>:
.globl vector81
vector81:
  pushl $0
80105caf:	6a 00                	push   $0x0
  pushl $81
80105cb1:	6a 51                	push   $0x51
  jmp alltraps
80105cb3:	e9 95 f8 ff ff       	jmp    8010554d <alltraps>

80105cb8 <vector82>:
.globl vector82
vector82:
  pushl $0
80105cb8:	6a 00                	push   $0x0
  pushl $82
80105cba:	6a 52                	push   $0x52
  jmp alltraps
80105cbc:	e9 8c f8 ff ff       	jmp    8010554d <alltraps>

80105cc1 <vector83>:
.globl vector83
vector83:
  pushl $0
80105cc1:	6a 00                	push   $0x0
  pushl $83
80105cc3:	6a 53                	push   $0x53
  jmp alltraps
80105cc5:	e9 83 f8 ff ff       	jmp    8010554d <alltraps>

80105cca <vector84>:
.globl vector84
vector84:
  pushl $0
80105cca:	6a 00                	push   $0x0
  pushl $84
80105ccc:	6a 54                	push   $0x54
  jmp alltraps
80105cce:	e9 7a f8 ff ff       	jmp    8010554d <alltraps>

80105cd3 <vector85>:
.globl vector85
vector85:
  pushl $0
80105cd3:	6a 00                	push   $0x0
  pushl $85
80105cd5:	6a 55                	push   $0x55
  jmp alltraps
80105cd7:	e9 71 f8 ff ff       	jmp    8010554d <alltraps>

80105cdc <vector86>:
.globl vector86
vector86:
  pushl $0
80105cdc:	6a 00                	push   $0x0
  pushl $86
80105cde:	6a 56                	push   $0x56
  jmp alltraps
80105ce0:	e9 68 f8 ff ff       	jmp    8010554d <alltraps>

80105ce5 <vector87>:
.globl vector87
vector87:
  pushl $0
80105ce5:	6a 00                	push   $0x0
  pushl $87
80105ce7:	6a 57                	push   $0x57
  jmp alltraps
80105ce9:	e9 5f f8 ff ff       	jmp    8010554d <alltraps>

80105cee <vector88>:
.globl vector88
vector88:
  pushl $0
80105cee:	6a 00                	push   $0x0
  pushl $88
80105cf0:	6a 58                	push   $0x58
  jmp alltraps
80105cf2:	e9 56 f8 ff ff       	jmp    8010554d <alltraps>

80105cf7 <vector89>:
.globl vector89
vector89:
  pushl $0
80105cf7:	6a 00                	push   $0x0
  pushl $89
80105cf9:	6a 59                	push   $0x59
  jmp alltraps
80105cfb:	e9 4d f8 ff ff       	jmp    8010554d <alltraps>

80105d00 <vector90>:
.globl vector90
vector90:
  pushl $0
80105d00:	6a 00                	push   $0x0
  pushl $90
80105d02:	6a 5a                	push   $0x5a
  jmp alltraps
80105d04:	e9 44 f8 ff ff       	jmp    8010554d <alltraps>

80105d09 <vector91>:
.globl vector91
vector91:
  pushl $0
80105d09:	6a 00                	push   $0x0
  pushl $91
80105d0b:	6a 5b                	push   $0x5b
  jmp alltraps
80105d0d:	e9 3b f8 ff ff       	jmp    8010554d <alltraps>

80105d12 <vector92>:
.globl vector92
vector92:
  pushl $0
80105d12:	6a 00                	push   $0x0
  pushl $92
80105d14:	6a 5c                	push   $0x5c
  jmp alltraps
80105d16:	e9 32 f8 ff ff       	jmp    8010554d <alltraps>

80105d1b <vector93>:
.globl vector93
vector93:
  pushl $0
80105d1b:	6a 00                	push   $0x0
  pushl $93
80105d1d:	6a 5d                	push   $0x5d
  jmp alltraps
80105d1f:	e9 29 f8 ff ff       	jmp    8010554d <alltraps>

80105d24 <vector94>:
.globl vector94
vector94:
  pushl $0
80105d24:	6a 00                	push   $0x0
  pushl $94
80105d26:	6a 5e                	push   $0x5e
  jmp alltraps
80105d28:	e9 20 f8 ff ff       	jmp    8010554d <alltraps>

80105d2d <vector95>:
.globl vector95
vector95:
  pushl $0
80105d2d:	6a 00                	push   $0x0
  pushl $95
80105d2f:	6a 5f                	push   $0x5f
  jmp alltraps
80105d31:	e9 17 f8 ff ff       	jmp    8010554d <alltraps>

80105d36 <vector96>:
.globl vector96
vector96:
  pushl $0
80105d36:	6a 00                	push   $0x0
  pushl $96
80105d38:	6a 60                	push   $0x60
  jmp alltraps
80105d3a:	e9 0e f8 ff ff       	jmp    8010554d <alltraps>

80105d3f <vector97>:
.globl vector97
vector97:
  pushl $0
80105d3f:	6a 00                	push   $0x0
  pushl $97
80105d41:	6a 61                	push   $0x61
  jmp alltraps
80105d43:	e9 05 f8 ff ff       	jmp    8010554d <alltraps>

80105d48 <vector98>:
.globl vector98
vector98:
  pushl $0
80105d48:	6a 00                	push   $0x0
  pushl $98
80105d4a:	6a 62                	push   $0x62
  jmp alltraps
80105d4c:	e9 fc f7 ff ff       	jmp    8010554d <alltraps>

80105d51 <vector99>:
.globl vector99
vector99:
  pushl $0
80105d51:	6a 00                	push   $0x0
  pushl $99
80105d53:	6a 63                	push   $0x63
  jmp alltraps
80105d55:	e9 f3 f7 ff ff       	jmp    8010554d <alltraps>

80105d5a <vector100>:
.globl vector100
vector100:
  pushl $0
80105d5a:	6a 00                	push   $0x0
  pushl $100
80105d5c:	6a 64                	push   $0x64
  jmp alltraps
80105d5e:	e9 ea f7 ff ff       	jmp    8010554d <alltraps>

80105d63 <vector101>:
.globl vector101
vector101:
  pushl $0
80105d63:	6a 00                	push   $0x0
  pushl $101
80105d65:	6a 65                	push   $0x65
  jmp alltraps
80105d67:	e9 e1 f7 ff ff       	jmp    8010554d <alltraps>

80105d6c <vector102>:
.globl vector102
vector102:
  pushl $0
80105d6c:	6a 00                	push   $0x0
  pushl $102
80105d6e:	6a 66                	push   $0x66
  jmp alltraps
80105d70:	e9 d8 f7 ff ff       	jmp    8010554d <alltraps>

80105d75 <vector103>:
.globl vector103
vector103:
  pushl $0
80105d75:	6a 00                	push   $0x0
  pushl $103
80105d77:	6a 67                	push   $0x67
  jmp alltraps
80105d79:	e9 cf f7 ff ff       	jmp    8010554d <alltraps>

80105d7e <vector104>:
.globl vector104
vector104:
  pushl $0
80105d7e:	6a 00                	push   $0x0
  pushl $104
80105d80:	6a 68                	push   $0x68
  jmp alltraps
80105d82:	e9 c6 f7 ff ff       	jmp    8010554d <alltraps>

80105d87 <vector105>:
.globl vector105
vector105:
  pushl $0
80105d87:	6a 00                	push   $0x0
  pushl $105
80105d89:	6a 69                	push   $0x69
  jmp alltraps
80105d8b:	e9 bd f7 ff ff       	jmp    8010554d <alltraps>

80105d90 <vector106>:
.globl vector106
vector106:
  pushl $0
80105d90:	6a 00                	push   $0x0
  pushl $106
80105d92:	6a 6a                	push   $0x6a
  jmp alltraps
80105d94:	e9 b4 f7 ff ff       	jmp    8010554d <alltraps>

80105d99 <vector107>:
.globl vector107
vector107:
  pushl $0
80105d99:	6a 00                	push   $0x0
  pushl $107
80105d9b:	6a 6b                	push   $0x6b
  jmp alltraps
80105d9d:	e9 ab f7 ff ff       	jmp    8010554d <alltraps>

80105da2 <vector108>:
.globl vector108
vector108:
  pushl $0
80105da2:	6a 00                	push   $0x0
  pushl $108
80105da4:	6a 6c                	push   $0x6c
  jmp alltraps
80105da6:	e9 a2 f7 ff ff       	jmp    8010554d <alltraps>

80105dab <vector109>:
.globl vector109
vector109:
  pushl $0
80105dab:	6a 00                	push   $0x0
  pushl $109
80105dad:	6a 6d                	push   $0x6d
  jmp alltraps
80105daf:	e9 99 f7 ff ff       	jmp    8010554d <alltraps>

80105db4 <vector110>:
.globl vector110
vector110:
  pushl $0
80105db4:	6a 00                	push   $0x0
  pushl $110
80105db6:	6a 6e                	push   $0x6e
  jmp alltraps
80105db8:	e9 90 f7 ff ff       	jmp    8010554d <alltraps>

80105dbd <vector111>:
.globl vector111
vector111:
  pushl $0
80105dbd:	6a 00                	push   $0x0
  pushl $111
80105dbf:	6a 6f                	push   $0x6f
  jmp alltraps
80105dc1:	e9 87 f7 ff ff       	jmp    8010554d <alltraps>

80105dc6 <vector112>:
.globl vector112
vector112:
  pushl $0
80105dc6:	6a 00                	push   $0x0
  pushl $112
80105dc8:	6a 70                	push   $0x70
  jmp alltraps
80105dca:	e9 7e f7 ff ff       	jmp    8010554d <alltraps>

80105dcf <vector113>:
.globl vector113
vector113:
  pushl $0
80105dcf:	6a 00                	push   $0x0
  pushl $113
80105dd1:	6a 71                	push   $0x71
  jmp alltraps
80105dd3:	e9 75 f7 ff ff       	jmp    8010554d <alltraps>

80105dd8 <vector114>:
.globl vector114
vector114:
  pushl $0
80105dd8:	6a 00                	push   $0x0
  pushl $114
80105dda:	6a 72                	push   $0x72
  jmp alltraps
80105ddc:	e9 6c f7 ff ff       	jmp    8010554d <alltraps>

80105de1 <vector115>:
.globl vector115
vector115:
  pushl $0
80105de1:	6a 00                	push   $0x0
  pushl $115
80105de3:	6a 73                	push   $0x73
  jmp alltraps
80105de5:	e9 63 f7 ff ff       	jmp    8010554d <alltraps>

80105dea <vector116>:
.globl vector116
vector116:
  pushl $0
80105dea:	6a 00                	push   $0x0
  pushl $116
80105dec:	6a 74                	push   $0x74
  jmp alltraps
80105dee:	e9 5a f7 ff ff       	jmp    8010554d <alltraps>

80105df3 <vector117>:
.globl vector117
vector117:
  pushl $0
80105df3:	6a 00                	push   $0x0
  pushl $117
80105df5:	6a 75                	push   $0x75
  jmp alltraps
80105df7:	e9 51 f7 ff ff       	jmp    8010554d <alltraps>

80105dfc <vector118>:
.globl vector118
vector118:
  pushl $0
80105dfc:	6a 00                	push   $0x0
  pushl $118
80105dfe:	6a 76                	push   $0x76
  jmp alltraps
80105e00:	e9 48 f7 ff ff       	jmp    8010554d <alltraps>

80105e05 <vector119>:
.globl vector119
vector119:
  pushl $0
80105e05:	6a 00                	push   $0x0
  pushl $119
80105e07:	6a 77                	push   $0x77
  jmp alltraps
80105e09:	e9 3f f7 ff ff       	jmp    8010554d <alltraps>

80105e0e <vector120>:
.globl vector120
vector120:
  pushl $0
80105e0e:	6a 00                	push   $0x0
  pushl $120
80105e10:	6a 78                	push   $0x78
  jmp alltraps
80105e12:	e9 36 f7 ff ff       	jmp    8010554d <alltraps>

80105e17 <vector121>:
.globl vector121
vector121:
  pushl $0
80105e17:	6a 00                	push   $0x0
  pushl $121
80105e19:	6a 79                	push   $0x79
  jmp alltraps
80105e1b:	e9 2d f7 ff ff       	jmp    8010554d <alltraps>

80105e20 <vector122>:
.globl vector122
vector122:
  pushl $0
80105e20:	6a 00                	push   $0x0
  pushl $122
80105e22:	6a 7a                	push   $0x7a
  jmp alltraps
80105e24:	e9 24 f7 ff ff       	jmp    8010554d <alltraps>

80105e29 <vector123>:
.globl vector123
vector123:
  pushl $0
80105e29:	6a 00                	push   $0x0
  pushl $123
80105e2b:	6a 7b                	push   $0x7b
  jmp alltraps
80105e2d:	e9 1b f7 ff ff       	jmp    8010554d <alltraps>

80105e32 <vector124>:
.globl vector124
vector124:
  pushl $0
80105e32:	6a 00                	push   $0x0
  pushl $124
80105e34:	6a 7c                	push   $0x7c
  jmp alltraps
80105e36:	e9 12 f7 ff ff       	jmp    8010554d <alltraps>

80105e3b <vector125>:
.globl vector125
vector125:
  pushl $0
80105e3b:	6a 00                	push   $0x0
  pushl $125
80105e3d:	6a 7d                	push   $0x7d
  jmp alltraps
80105e3f:	e9 09 f7 ff ff       	jmp    8010554d <alltraps>

80105e44 <vector126>:
.globl vector126
vector126:
  pushl $0
80105e44:	6a 00                	push   $0x0
  pushl $126
80105e46:	6a 7e                	push   $0x7e
  jmp alltraps
80105e48:	e9 00 f7 ff ff       	jmp    8010554d <alltraps>

80105e4d <vector127>:
.globl vector127
vector127:
  pushl $0
80105e4d:	6a 00                	push   $0x0
  pushl $127
80105e4f:	6a 7f                	push   $0x7f
  jmp alltraps
80105e51:	e9 f7 f6 ff ff       	jmp    8010554d <alltraps>

80105e56 <vector128>:
.globl vector128
vector128:
  pushl $0
80105e56:	6a 00                	push   $0x0
  pushl $128
80105e58:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105e5d:	e9 eb f6 ff ff       	jmp    8010554d <alltraps>

80105e62 <vector129>:
.globl vector129
vector129:
  pushl $0
80105e62:	6a 00                	push   $0x0
  pushl $129
80105e64:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105e69:	e9 df f6 ff ff       	jmp    8010554d <alltraps>

80105e6e <vector130>:
.globl vector130
vector130:
  pushl $0
80105e6e:	6a 00                	push   $0x0
  pushl $130
80105e70:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105e75:	e9 d3 f6 ff ff       	jmp    8010554d <alltraps>

80105e7a <vector131>:
.globl vector131
vector131:
  pushl $0
80105e7a:	6a 00                	push   $0x0
  pushl $131
80105e7c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105e81:	e9 c7 f6 ff ff       	jmp    8010554d <alltraps>

80105e86 <vector132>:
.globl vector132
vector132:
  pushl $0
80105e86:	6a 00                	push   $0x0
  pushl $132
80105e88:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105e8d:	e9 bb f6 ff ff       	jmp    8010554d <alltraps>

80105e92 <vector133>:
.globl vector133
vector133:
  pushl $0
80105e92:	6a 00                	push   $0x0
  pushl $133
80105e94:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105e99:	e9 af f6 ff ff       	jmp    8010554d <alltraps>

80105e9e <vector134>:
.globl vector134
vector134:
  pushl $0
80105e9e:	6a 00                	push   $0x0
  pushl $134
80105ea0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105ea5:	e9 a3 f6 ff ff       	jmp    8010554d <alltraps>

80105eaa <vector135>:
.globl vector135
vector135:
  pushl $0
80105eaa:	6a 00                	push   $0x0
  pushl $135
80105eac:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105eb1:	e9 97 f6 ff ff       	jmp    8010554d <alltraps>

80105eb6 <vector136>:
.globl vector136
vector136:
  pushl $0
80105eb6:	6a 00                	push   $0x0
  pushl $136
80105eb8:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105ebd:	e9 8b f6 ff ff       	jmp    8010554d <alltraps>

80105ec2 <vector137>:
.globl vector137
vector137:
  pushl $0
80105ec2:	6a 00                	push   $0x0
  pushl $137
80105ec4:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105ec9:	e9 7f f6 ff ff       	jmp    8010554d <alltraps>

80105ece <vector138>:
.globl vector138
vector138:
  pushl $0
80105ece:	6a 00                	push   $0x0
  pushl $138
80105ed0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105ed5:	e9 73 f6 ff ff       	jmp    8010554d <alltraps>

80105eda <vector139>:
.globl vector139
vector139:
  pushl $0
80105eda:	6a 00                	push   $0x0
  pushl $139
80105edc:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105ee1:	e9 67 f6 ff ff       	jmp    8010554d <alltraps>

80105ee6 <vector140>:
.globl vector140
vector140:
  pushl $0
80105ee6:	6a 00                	push   $0x0
  pushl $140
80105ee8:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105eed:	e9 5b f6 ff ff       	jmp    8010554d <alltraps>

80105ef2 <vector141>:
.globl vector141
vector141:
  pushl $0
80105ef2:	6a 00                	push   $0x0
  pushl $141
80105ef4:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105ef9:	e9 4f f6 ff ff       	jmp    8010554d <alltraps>

80105efe <vector142>:
.globl vector142
vector142:
  pushl $0
80105efe:	6a 00                	push   $0x0
  pushl $142
80105f00:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105f05:	e9 43 f6 ff ff       	jmp    8010554d <alltraps>

80105f0a <vector143>:
.globl vector143
vector143:
  pushl $0
80105f0a:	6a 00                	push   $0x0
  pushl $143
80105f0c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105f11:	e9 37 f6 ff ff       	jmp    8010554d <alltraps>

80105f16 <vector144>:
.globl vector144
vector144:
  pushl $0
80105f16:	6a 00                	push   $0x0
  pushl $144
80105f18:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105f1d:	e9 2b f6 ff ff       	jmp    8010554d <alltraps>

80105f22 <vector145>:
.globl vector145
vector145:
  pushl $0
80105f22:	6a 00                	push   $0x0
  pushl $145
80105f24:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105f29:	e9 1f f6 ff ff       	jmp    8010554d <alltraps>

80105f2e <vector146>:
.globl vector146
vector146:
  pushl $0
80105f2e:	6a 00                	push   $0x0
  pushl $146
80105f30:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105f35:	e9 13 f6 ff ff       	jmp    8010554d <alltraps>

80105f3a <vector147>:
.globl vector147
vector147:
  pushl $0
80105f3a:	6a 00                	push   $0x0
  pushl $147
80105f3c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105f41:	e9 07 f6 ff ff       	jmp    8010554d <alltraps>

80105f46 <vector148>:
.globl vector148
vector148:
  pushl $0
80105f46:	6a 00                	push   $0x0
  pushl $148
80105f48:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105f4d:	e9 fb f5 ff ff       	jmp    8010554d <alltraps>

80105f52 <vector149>:
.globl vector149
vector149:
  pushl $0
80105f52:	6a 00                	push   $0x0
  pushl $149
80105f54:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105f59:	e9 ef f5 ff ff       	jmp    8010554d <alltraps>

80105f5e <vector150>:
.globl vector150
vector150:
  pushl $0
80105f5e:	6a 00                	push   $0x0
  pushl $150
80105f60:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105f65:	e9 e3 f5 ff ff       	jmp    8010554d <alltraps>

80105f6a <vector151>:
.globl vector151
vector151:
  pushl $0
80105f6a:	6a 00                	push   $0x0
  pushl $151
80105f6c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105f71:	e9 d7 f5 ff ff       	jmp    8010554d <alltraps>

80105f76 <vector152>:
.globl vector152
vector152:
  pushl $0
80105f76:	6a 00                	push   $0x0
  pushl $152
80105f78:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105f7d:	e9 cb f5 ff ff       	jmp    8010554d <alltraps>

80105f82 <vector153>:
.globl vector153
vector153:
  pushl $0
80105f82:	6a 00                	push   $0x0
  pushl $153
80105f84:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105f89:	e9 bf f5 ff ff       	jmp    8010554d <alltraps>

80105f8e <vector154>:
.globl vector154
vector154:
  pushl $0
80105f8e:	6a 00                	push   $0x0
  pushl $154
80105f90:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105f95:	e9 b3 f5 ff ff       	jmp    8010554d <alltraps>

80105f9a <vector155>:
.globl vector155
vector155:
  pushl $0
80105f9a:	6a 00                	push   $0x0
  pushl $155
80105f9c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105fa1:	e9 a7 f5 ff ff       	jmp    8010554d <alltraps>

80105fa6 <vector156>:
.globl vector156
vector156:
  pushl $0
80105fa6:	6a 00                	push   $0x0
  pushl $156
80105fa8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105fad:	e9 9b f5 ff ff       	jmp    8010554d <alltraps>

80105fb2 <vector157>:
.globl vector157
vector157:
  pushl $0
80105fb2:	6a 00                	push   $0x0
  pushl $157
80105fb4:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105fb9:	e9 8f f5 ff ff       	jmp    8010554d <alltraps>

80105fbe <vector158>:
.globl vector158
vector158:
  pushl $0
80105fbe:	6a 00                	push   $0x0
  pushl $158
80105fc0:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105fc5:	e9 83 f5 ff ff       	jmp    8010554d <alltraps>

80105fca <vector159>:
.globl vector159
vector159:
  pushl $0
80105fca:	6a 00                	push   $0x0
  pushl $159
80105fcc:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105fd1:	e9 77 f5 ff ff       	jmp    8010554d <alltraps>

80105fd6 <vector160>:
.globl vector160
vector160:
  pushl $0
80105fd6:	6a 00                	push   $0x0
  pushl $160
80105fd8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105fdd:	e9 6b f5 ff ff       	jmp    8010554d <alltraps>

80105fe2 <vector161>:
.globl vector161
vector161:
  pushl $0
80105fe2:	6a 00                	push   $0x0
  pushl $161
80105fe4:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105fe9:	e9 5f f5 ff ff       	jmp    8010554d <alltraps>

80105fee <vector162>:
.globl vector162
vector162:
  pushl $0
80105fee:	6a 00                	push   $0x0
  pushl $162
80105ff0:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105ff5:	e9 53 f5 ff ff       	jmp    8010554d <alltraps>

80105ffa <vector163>:
.globl vector163
vector163:
  pushl $0
80105ffa:	6a 00                	push   $0x0
  pushl $163
80105ffc:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106001:	e9 47 f5 ff ff       	jmp    8010554d <alltraps>

80106006 <vector164>:
.globl vector164
vector164:
  pushl $0
80106006:	6a 00                	push   $0x0
  pushl $164
80106008:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010600d:	e9 3b f5 ff ff       	jmp    8010554d <alltraps>

80106012 <vector165>:
.globl vector165
vector165:
  pushl $0
80106012:	6a 00                	push   $0x0
  pushl $165
80106014:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106019:	e9 2f f5 ff ff       	jmp    8010554d <alltraps>

8010601e <vector166>:
.globl vector166
vector166:
  pushl $0
8010601e:	6a 00                	push   $0x0
  pushl $166
80106020:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106025:	e9 23 f5 ff ff       	jmp    8010554d <alltraps>

8010602a <vector167>:
.globl vector167
vector167:
  pushl $0
8010602a:	6a 00                	push   $0x0
  pushl $167
8010602c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106031:	e9 17 f5 ff ff       	jmp    8010554d <alltraps>

80106036 <vector168>:
.globl vector168
vector168:
  pushl $0
80106036:	6a 00                	push   $0x0
  pushl $168
80106038:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010603d:	e9 0b f5 ff ff       	jmp    8010554d <alltraps>

80106042 <vector169>:
.globl vector169
vector169:
  pushl $0
80106042:	6a 00                	push   $0x0
  pushl $169
80106044:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106049:	e9 ff f4 ff ff       	jmp    8010554d <alltraps>

8010604e <vector170>:
.globl vector170
vector170:
  pushl $0
8010604e:	6a 00                	push   $0x0
  pushl $170
80106050:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106055:	e9 f3 f4 ff ff       	jmp    8010554d <alltraps>

8010605a <vector171>:
.globl vector171
vector171:
  pushl $0
8010605a:	6a 00                	push   $0x0
  pushl $171
8010605c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106061:	e9 e7 f4 ff ff       	jmp    8010554d <alltraps>

80106066 <vector172>:
.globl vector172
vector172:
  pushl $0
80106066:	6a 00                	push   $0x0
  pushl $172
80106068:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010606d:	e9 db f4 ff ff       	jmp    8010554d <alltraps>

80106072 <vector173>:
.globl vector173
vector173:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $173
80106074:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106079:	e9 cf f4 ff ff       	jmp    8010554d <alltraps>

8010607e <vector174>:
.globl vector174
vector174:
  pushl $0
8010607e:	6a 00                	push   $0x0
  pushl $174
80106080:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106085:	e9 c3 f4 ff ff       	jmp    8010554d <alltraps>

8010608a <vector175>:
.globl vector175
vector175:
  pushl $0
8010608a:	6a 00                	push   $0x0
  pushl $175
8010608c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106091:	e9 b7 f4 ff ff       	jmp    8010554d <alltraps>

80106096 <vector176>:
.globl vector176
vector176:
  pushl $0
80106096:	6a 00                	push   $0x0
  pushl $176
80106098:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010609d:	e9 ab f4 ff ff       	jmp    8010554d <alltraps>

801060a2 <vector177>:
.globl vector177
vector177:
  pushl $0
801060a2:	6a 00                	push   $0x0
  pushl $177
801060a4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801060a9:	e9 9f f4 ff ff       	jmp    8010554d <alltraps>

801060ae <vector178>:
.globl vector178
vector178:
  pushl $0
801060ae:	6a 00                	push   $0x0
  pushl $178
801060b0:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801060b5:	e9 93 f4 ff ff       	jmp    8010554d <alltraps>

801060ba <vector179>:
.globl vector179
vector179:
  pushl $0
801060ba:	6a 00                	push   $0x0
  pushl $179
801060bc:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801060c1:	e9 87 f4 ff ff       	jmp    8010554d <alltraps>

801060c6 <vector180>:
.globl vector180
vector180:
  pushl $0
801060c6:	6a 00                	push   $0x0
  pushl $180
801060c8:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801060cd:	e9 7b f4 ff ff       	jmp    8010554d <alltraps>

801060d2 <vector181>:
.globl vector181
vector181:
  pushl $0
801060d2:	6a 00                	push   $0x0
  pushl $181
801060d4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801060d9:	e9 6f f4 ff ff       	jmp    8010554d <alltraps>

801060de <vector182>:
.globl vector182
vector182:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $182
801060e0:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801060e5:	e9 63 f4 ff ff       	jmp    8010554d <alltraps>

801060ea <vector183>:
.globl vector183
vector183:
  pushl $0
801060ea:	6a 00                	push   $0x0
  pushl $183
801060ec:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801060f1:	e9 57 f4 ff ff       	jmp    8010554d <alltraps>

801060f6 <vector184>:
.globl vector184
vector184:
  pushl $0
801060f6:	6a 00                	push   $0x0
  pushl $184
801060f8:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801060fd:	e9 4b f4 ff ff       	jmp    8010554d <alltraps>

80106102 <vector185>:
.globl vector185
vector185:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $185
80106104:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106109:	e9 3f f4 ff ff       	jmp    8010554d <alltraps>

8010610e <vector186>:
.globl vector186
vector186:
  pushl $0
8010610e:	6a 00                	push   $0x0
  pushl $186
80106110:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106115:	e9 33 f4 ff ff       	jmp    8010554d <alltraps>

8010611a <vector187>:
.globl vector187
vector187:
  pushl $0
8010611a:	6a 00                	push   $0x0
  pushl $187
8010611c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106121:	e9 27 f4 ff ff       	jmp    8010554d <alltraps>

80106126 <vector188>:
.globl vector188
vector188:
  pushl $0
80106126:	6a 00                	push   $0x0
  pushl $188
80106128:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010612d:	e9 1b f4 ff ff       	jmp    8010554d <alltraps>

80106132 <vector189>:
.globl vector189
vector189:
  pushl $0
80106132:	6a 00                	push   $0x0
  pushl $189
80106134:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106139:	e9 0f f4 ff ff       	jmp    8010554d <alltraps>

8010613e <vector190>:
.globl vector190
vector190:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $190
80106140:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106145:	e9 03 f4 ff ff       	jmp    8010554d <alltraps>

8010614a <vector191>:
.globl vector191
vector191:
  pushl $0
8010614a:	6a 00                	push   $0x0
  pushl $191
8010614c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106151:	e9 f7 f3 ff ff       	jmp    8010554d <alltraps>

80106156 <vector192>:
.globl vector192
vector192:
  pushl $0
80106156:	6a 00                	push   $0x0
  pushl $192
80106158:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010615d:	e9 eb f3 ff ff       	jmp    8010554d <alltraps>

80106162 <vector193>:
.globl vector193
vector193:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $193
80106164:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106169:	e9 df f3 ff ff       	jmp    8010554d <alltraps>

8010616e <vector194>:
.globl vector194
vector194:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $194
80106170:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106175:	e9 d3 f3 ff ff       	jmp    8010554d <alltraps>

8010617a <vector195>:
.globl vector195
vector195:
  pushl $0
8010617a:	6a 00                	push   $0x0
  pushl $195
8010617c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106181:	e9 c7 f3 ff ff       	jmp    8010554d <alltraps>

80106186 <vector196>:
.globl vector196
vector196:
  pushl $0
80106186:	6a 00                	push   $0x0
  pushl $196
80106188:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010618d:	e9 bb f3 ff ff       	jmp    8010554d <alltraps>

80106192 <vector197>:
.globl vector197
vector197:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $197
80106194:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106199:	e9 af f3 ff ff       	jmp    8010554d <alltraps>

8010619e <vector198>:
.globl vector198
vector198:
  pushl $0
8010619e:	6a 00                	push   $0x0
  pushl $198
801061a0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801061a5:	e9 a3 f3 ff ff       	jmp    8010554d <alltraps>

801061aa <vector199>:
.globl vector199
vector199:
  pushl $0
801061aa:	6a 00                	push   $0x0
  pushl $199
801061ac:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801061b1:	e9 97 f3 ff ff       	jmp    8010554d <alltraps>

801061b6 <vector200>:
.globl vector200
vector200:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $200
801061b8:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801061bd:	e9 8b f3 ff ff       	jmp    8010554d <alltraps>

801061c2 <vector201>:
.globl vector201
vector201:
  pushl $0
801061c2:	6a 00                	push   $0x0
  pushl $201
801061c4:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801061c9:	e9 7f f3 ff ff       	jmp    8010554d <alltraps>

801061ce <vector202>:
.globl vector202
vector202:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $202
801061d0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801061d5:	e9 73 f3 ff ff       	jmp    8010554d <alltraps>

801061da <vector203>:
.globl vector203
vector203:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $203
801061dc:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801061e1:	e9 67 f3 ff ff       	jmp    8010554d <alltraps>

801061e6 <vector204>:
.globl vector204
vector204:
  pushl $0
801061e6:	6a 00                	push   $0x0
  pushl $204
801061e8:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801061ed:	e9 5b f3 ff ff       	jmp    8010554d <alltraps>

801061f2 <vector205>:
.globl vector205
vector205:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $205
801061f4:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801061f9:	e9 4f f3 ff ff       	jmp    8010554d <alltraps>

801061fe <vector206>:
.globl vector206
vector206:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $206
80106200:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106205:	e9 43 f3 ff ff       	jmp    8010554d <alltraps>

8010620a <vector207>:
.globl vector207
vector207:
  pushl $0
8010620a:	6a 00                	push   $0x0
  pushl $207
8010620c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106211:	e9 37 f3 ff ff       	jmp    8010554d <alltraps>

80106216 <vector208>:
.globl vector208
vector208:
  pushl $0
80106216:	6a 00                	push   $0x0
  pushl $208
80106218:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010621d:	e9 2b f3 ff ff       	jmp    8010554d <alltraps>

80106222 <vector209>:
.globl vector209
vector209:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $209
80106224:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106229:	e9 1f f3 ff ff       	jmp    8010554d <alltraps>

8010622e <vector210>:
.globl vector210
vector210:
  pushl $0
8010622e:	6a 00                	push   $0x0
  pushl $210
80106230:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106235:	e9 13 f3 ff ff       	jmp    8010554d <alltraps>

8010623a <vector211>:
.globl vector211
vector211:
  pushl $0
8010623a:	6a 00                	push   $0x0
  pushl $211
8010623c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106241:	e9 07 f3 ff ff       	jmp    8010554d <alltraps>

80106246 <vector212>:
.globl vector212
vector212:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $212
80106248:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010624d:	e9 fb f2 ff ff       	jmp    8010554d <alltraps>

80106252 <vector213>:
.globl vector213
vector213:
  pushl $0
80106252:	6a 00                	push   $0x0
  pushl $213
80106254:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106259:	e9 ef f2 ff ff       	jmp    8010554d <alltraps>

8010625e <vector214>:
.globl vector214
vector214:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $214
80106260:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106265:	e9 e3 f2 ff ff       	jmp    8010554d <alltraps>

8010626a <vector215>:
.globl vector215
vector215:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $215
8010626c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106271:	e9 d7 f2 ff ff       	jmp    8010554d <alltraps>

80106276 <vector216>:
.globl vector216
vector216:
  pushl $0
80106276:	6a 00                	push   $0x0
  pushl $216
80106278:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010627d:	e9 cb f2 ff ff       	jmp    8010554d <alltraps>

80106282 <vector217>:
.globl vector217
vector217:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $217
80106284:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106289:	e9 bf f2 ff ff       	jmp    8010554d <alltraps>

8010628e <vector218>:
.globl vector218
vector218:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $218
80106290:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106295:	e9 b3 f2 ff ff       	jmp    8010554d <alltraps>

8010629a <vector219>:
.globl vector219
vector219:
  pushl $0
8010629a:	6a 00                	push   $0x0
  pushl $219
8010629c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801062a1:	e9 a7 f2 ff ff       	jmp    8010554d <alltraps>

801062a6 <vector220>:
.globl vector220
vector220:
  pushl $0
801062a6:	6a 00                	push   $0x0
  pushl $220
801062a8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801062ad:	e9 9b f2 ff ff       	jmp    8010554d <alltraps>

801062b2 <vector221>:
.globl vector221
vector221:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $221
801062b4:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801062b9:	e9 8f f2 ff ff       	jmp    8010554d <alltraps>

801062be <vector222>:
.globl vector222
vector222:
  pushl $0
801062be:	6a 00                	push   $0x0
  pushl $222
801062c0:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801062c5:	e9 83 f2 ff ff       	jmp    8010554d <alltraps>

801062ca <vector223>:
.globl vector223
vector223:
  pushl $0
801062ca:	6a 00                	push   $0x0
  pushl $223
801062cc:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801062d1:	e9 77 f2 ff ff       	jmp    8010554d <alltraps>

801062d6 <vector224>:
.globl vector224
vector224:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $224
801062d8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801062dd:	e9 6b f2 ff ff       	jmp    8010554d <alltraps>

801062e2 <vector225>:
.globl vector225
vector225:
  pushl $0
801062e2:	6a 00                	push   $0x0
  pushl $225
801062e4:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801062e9:	e9 5f f2 ff ff       	jmp    8010554d <alltraps>

801062ee <vector226>:
.globl vector226
vector226:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $226
801062f0:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801062f5:	e9 53 f2 ff ff       	jmp    8010554d <alltraps>

801062fa <vector227>:
.globl vector227
vector227:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $227
801062fc:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106301:	e9 47 f2 ff ff       	jmp    8010554d <alltraps>

80106306 <vector228>:
.globl vector228
vector228:
  pushl $0
80106306:	6a 00                	push   $0x0
  pushl $228
80106308:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010630d:	e9 3b f2 ff ff       	jmp    8010554d <alltraps>

80106312 <vector229>:
.globl vector229
vector229:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $229
80106314:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106319:	e9 2f f2 ff ff       	jmp    8010554d <alltraps>

8010631e <vector230>:
.globl vector230
vector230:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $230
80106320:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106325:	e9 23 f2 ff ff       	jmp    8010554d <alltraps>

8010632a <vector231>:
.globl vector231
vector231:
  pushl $0
8010632a:	6a 00                	push   $0x0
  pushl $231
8010632c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106331:	e9 17 f2 ff ff       	jmp    8010554d <alltraps>

80106336 <vector232>:
.globl vector232
vector232:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $232
80106338:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010633d:	e9 0b f2 ff ff       	jmp    8010554d <alltraps>

80106342 <vector233>:
.globl vector233
vector233:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $233
80106344:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106349:	e9 ff f1 ff ff       	jmp    8010554d <alltraps>

8010634e <vector234>:
.globl vector234
vector234:
  pushl $0
8010634e:	6a 00                	push   $0x0
  pushl $234
80106350:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106355:	e9 f3 f1 ff ff       	jmp    8010554d <alltraps>

8010635a <vector235>:
.globl vector235
vector235:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $235
8010635c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106361:	e9 e7 f1 ff ff       	jmp    8010554d <alltraps>

80106366 <vector236>:
.globl vector236
vector236:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $236
80106368:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010636d:	e9 db f1 ff ff       	jmp    8010554d <alltraps>

80106372 <vector237>:
.globl vector237
vector237:
  pushl $0
80106372:	6a 00                	push   $0x0
  pushl $237
80106374:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106379:	e9 cf f1 ff ff       	jmp    8010554d <alltraps>

8010637e <vector238>:
.globl vector238
vector238:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $238
80106380:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106385:	e9 c3 f1 ff ff       	jmp    8010554d <alltraps>

8010638a <vector239>:
.globl vector239
vector239:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $239
8010638c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106391:	e9 b7 f1 ff ff       	jmp    8010554d <alltraps>

80106396 <vector240>:
.globl vector240
vector240:
  pushl $0
80106396:	6a 00                	push   $0x0
  pushl $240
80106398:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010639d:	e9 ab f1 ff ff       	jmp    8010554d <alltraps>

801063a2 <vector241>:
.globl vector241
vector241:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $241
801063a4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801063a9:	e9 9f f1 ff ff       	jmp    8010554d <alltraps>

801063ae <vector242>:
.globl vector242
vector242:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $242
801063b0:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801063b5:	e9 93 f1 ff ff       	jmp    8010554d <alltraps>

801063ba <vector243>:
.globl vector243
vector243:
  pushl $0
801063ba:	6a 00                	push   $0x0
  pushl $243
801063bc:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801063c1:	e9 87 f1 ff ff       	jmp    8010554d <alltraps>

801063c6 <vector244>:
.globl vector244
vector244:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $244
801063c8:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801063cd:	e9 7b f1 ff ff       	jmp    8010554d <alltraps>

801063d2 <vector245>:
.globl vector245
vector245:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $245
801063d4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801063d9:	e9 6f f1 ff ff       	jmp    8010554d <alltraps>

801063de <vector246>:
.globl vector246
vector246:
  pushl $0
801063de:	6a 00                	push   $0x0
  pushl $246
801063e0:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801063e5:	e9 63 f1 ff ff       	jmp    8010554d <alltraps>

801063ea <vector247>:
.globl vector247
vector247:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $247
801063ec:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801063f1:	e9 57 f1 ff ff       	jmp    8010554d <alltraps>

801063f6 <vector248>:
.globl vector248
vector248:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $248
801063f8:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801063fd:	e9 4b f1 ff ff       	jmp    8010554d <alltraps>

80106402 <vector249>:
.globl vector249
vector249:
  pushl $0
80106402:	6a 00                	push   $0x0
  pushl $249
80106404:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106409:	e9 3f f1 ff ff       	jmp    8010554d <alltraps>

8010640e <vector250>:
.globl vector250
vector250:
  pushl $0
8010640e:	6a 00                	push   $0x0
  pushl $250
80106410:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106415:	e9 33 f1 ff ff       	jmp    8010554d <alltraps>

8010641a <vector251>:
.globl vector251
vector251:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $251
8010641c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106421:	e9 27 f1 ff ff       	jmp    8010554d <alltraps>

80106426 <vector252>:
.globl vector252
vector252:
  pushl $0
80106426:	6a 00                	push   $0x0
  pushl $252
80106428:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010642d:	e9 1b f1 ff ff       	jmp    8010554d <alltraps>

80106432 <vector253>:
.globl vector253
vector253:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $253
80106434:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106439:	e9 0f f1 ff ff       	jmp    8010554d <alltraps>

8010643e <vector254>:
.globl vector254
vector254:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $254
80106440:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106445:	e9 03 f1 ff ff       	jmp    8010554d <alltraps>

8010644a <vector255>:
.globl vector255
vector255:
  pushl $0
8010644a:	6a 00                	push   $0x0
  pushl $255
8010644c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106451:	e9 f7 f0 ff ff       	jmp    8010554d <alltraps>
80106456:	66 90                	xchg   %ax,%ax
80106458:	66 90                	xchg   %ax,%ax
8010645a:	66 90                	xchg   %ax,%ax
8010645c:	66 90                	xchg   %ax,%ax
8010645e:	66 90                	xchg   %ax,%ax

80106460 <walkpgdir>:
80106460:	55                   	push   %ebp
80106461:	89 e5                	mov    %esp,%ebp
80106463:	57                   	push   %edi
80106464:	56                   	push   %esi
80106465:	89 d6                	mov    %edx,%esi
80106467:	c1 ea 16             	shr    $0x16,%edx
8010646a:	53                   	push   %ebx
8010646b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010646e:	83 ec 1c             	sub    $0x1c,%esp
80106471:	8b 1f                	mov    (%edi),%ebx
80106473:	f6 c3 01             	test   $0x1,%bl
80106476:	74 28                	je     801064a0 <walkpgdir+0x40>
80106478:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010647e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106484:	c1 ee 0a             	shr    $0xa,%esi
80106487:	83 c4 1c             	add    $0x1c,%esp
8010648a:	89 f2                	mov    %esi,%edx
8010648c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106492:	8d 04 13             	lea    (%ebx,%edx,1),%eax
80106495:	5b                   	pop    %ebx
80106496:	5e                   	pop    %esi
80106497:	5f                   	pop    %edi
80106498:	5d                   	pop    %ebp
80106499:	c3                   	ret    
8010649a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801064a0:	85 c9                	test   %ecx,%ecx
801064a2:	74 34                	je     801064d8 <walkpgdir+0x78>
801064a4:	e8 f7 bf ff ff       	call   801024a0 <kalloc>
801064a9:	85 c0                	test   %eax,%eax
801064ab:	89 c3                	mov    %eax,%ebx
801064ad:	74 29                	je     801064d8 <walkpgdir+0x78>
801064af:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801064b6:	00 
801064b7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801064be:	00 
801064bf:	89 04 24             	mov    %eax,(%esp)
801064c2:	e8 f9 de ff ff       	call   801043c0 <memset>
801064c7:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801064cd:	83 c8 07             	or     $0x7,%eax
801064d0:	89 07                	mov    %eax,(%edi)
801064d2:	eb b0                	jmp    80106484 <walkpgdir+0x24>
801064d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801064d8:	83 c4 1c             	add    $0x1c,%esp
801064db:	31 c0                	xor    %eax,%eax
801064dd:	5b                   	pop    %ebx
801064de:	5e                   	pop    %esi
801064df:	5f                   	pop    %edi
801064e0:	5d                   	pop    %ebp
801064e1:	c3                   	ret    
801064e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801064f0 <mappages>:
801064f0:	55                   	push   %ebp
801064f1:	89 e5                	mov    %esp,%ebp
801064f3:	57                   	push   %edi
801064f4:	56                   	push   %esi
801064f5:	53                   	push   %ebx
801064f6:	89 d3                	mov    %edx,%ebx
801064f8:	83 ec 1c             	sub    $0x1c,%esp
801064fb:	8b 7d 08             	mov    0x8(%ebp),%edi
801064fe:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106504:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106507:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
8010650b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010650e:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
80106512:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
80106519:	29 df                	sub    %ebx,%edi
8010651b:	eb 18                	jmp    80106535 <mappages+0x45>
8010651d:	8d 76 00             	lea    0x0(%esi),%esi
80106520:	f6 00 01             	testb  $0x1,(%eax)
80106523:	75 3d                	jne    80106562 <mappages+0x72>
80106525:	0b 75 0c             	or     0xc(%ebp),%esi
80106528:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
8010652b:	89 30                	mov    %esi,(%eax)
8010652d:	74 29                	je     80106558 <mappages+0x68>
8010652f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106535:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106538:	b9 01 00 00 00       	mov    $0x1,%ecx
8010653d:	89 da                	mov    %ebx,%edx
8010653f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106542:	e8 19 ff ff ff       	call   80106460 <walkpgdir>
80106547:	85 c0                	test   %eax,%eax
80106549:	75 d5                	jne    80106520 <mappages+0x30>
8010654b:	83 c4 1c             	add    $0x1c,%esp
8010654e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106553:	5b                   	pop    %ebx
80106554:	5e                   	pop    %esi
80106555:	5f                   	pop    %edi
80106556:	5d                   	pop    %ebp
80106557:	c3                   	ret    
80106558:	83 c4 1c             	add    $0x1c,%esp
8010655b:	31 c0                	xor    %eax,%eax
8010655d:	5b                   	pop    %ebx
8010655e:	5e                   	pop    %esi
8010655f:	5f                   	pop    %edi
80106560:	5d                   	pop    %ebp
80106561:	c3                   	ret    
80106562:	c7 04 24 4c 76 10 80 	movl   $0x8010764c,(%esp)
80106569:	e8 f2 9d ff ff       	call   80100360 <panic>
8010656e:	66 90                	xchg   %ax,%ax

80106570 <deallocuvm.part.0>:
80106570:	55                   	push   %ebp
80106571:	89 e5                	mov    %esp,%ebp
80106573:	57                   	push   %edi
80106574:	89 c7                	mov    %eax,%edi
80106576:	56                   	push   %esi
80106577:	89 d6                	mov    %edx,%esi
80106579:	53                   	push   %ebx
8010657a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106580:	83 ec 1c             	sub    $0x1c,%esp
80106583:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106589:	39 d3                	cmp    %edx,%ebx
8010658b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010658e:	72 3b                	jb     801065cb <deallocuvm.part.0+0x5b>
80106590:	eb 5e                	jmp    801065f0 <deallocuvm.part.0+0x80>
80106592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106598:	8b 10                	mov    (%eax),%edx
8010659a:	f6 c2 01             	test   $0x1,%dl
8010659d:	74 22                	je     801065c1 <deallocuvm.part.0+0x51>
8010659f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801065a5:	74 54                	je     801065fb <deallocuvm.part.0+0x8b>
801065a7:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801065ad:	89 14 24             	mov    %edx,(%esp)
801065b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801065b3:	e8 38 bd ff ff       	call   801022f0 <kfree>
801065b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801065bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801065c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801065c7:	39 f3                	cmp    %esi,%ebx
801065c9:	73 25                	jae    801065f0 <deallocuvm.part.0+0x80>
801065cb:	31 c9                	xor    %ecx,%ecx
801065cd:	89 da                	mov    %ebx,%edx
801065cf:	89 f8                	mov    %edi,%eax
801065d1:	e8 8a fe ff ff       	call   80106460 <walkpgdir>
801065d6:	85 c0                	test   %eax,%eax
801065d8:	75 be                	jne    80106598 <deallocuvm.part.0+0x28>
801065da:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801065e0:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
801065e6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801065ec:	39 f3                	cmp    %esi,%ebx
801065ee:	72 db                	jb     801065cb <deallocuvm.part.0+0x5b>
801065f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801065f3:	83 c4 1c             	add    $0x1c,%esp
801065f6:	5b                   	pop    %ebx
801065f7:	5e                   	pop    %esi
801065f8:	5f                   	pop    %edi
801065f9:	5d                   	pop    %ebp
801065fa:	c3                   	ret    
801065fb:	c7 04 24 e6 6f 10 80 	movl   $0x80106fe6,(%esp)
80106602:	e8 59 9d ff ff       	call   80100360 <panic>
80106607:	89 f6                	mov    %esi,%esi
80106609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106610 <seginit>:
80106610:	55                   	push   %ebp
80106611:	89 e5                	mov    %esp,%ebp
80106613:	83 ec 18             	sub    $0x18,%esp
80106616:	e8 65 d0 ff ff       	call   80103680 <cpuid>
8010661b:	31 c9                	xor    %ecx,%ecx
8010661d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106622:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106628:	05 80 27 11 80       	add    $0x80112780,%eax
8010662d:	66 89 50 78          	mov    %dx,0x78(%eax)
80106631:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106636:	83 c0 70             	add    $0x70,%eax
80106639:	66 89 48 0a          	mov    %cx,0xa(%eax)
8010663d:	31 c9                	xor    %ecx,%ecx
8010663f:	66 89 50 10          	mov    %dx,0x10(%eax)
80106643:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106648:	66 89 48 12          	mov    %cx,0x12(%eax)
8010664c:	31 c9                	xor    %ecx,%ecx
8010664e:	66 89 50 18          	mov    %dx,0x18(%eax)
80106652:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106657:	66 89 48 1a          	mov    %cx,0x1a(%eax)
8010665b:	31 c9                	xor    %ecx,%ecx
8010665d:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
80106661:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
80106665:	c6 40 15 92          	movb   $0x92,0x15(%eax)
80106669:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
8010666d:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
80106671:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
80106675:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
80106679:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
8010667d:	66 89 50 20          	mov    %dx,0x20(%eax)
80106681:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106686:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
8010668a:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
8010668e:	c6 40 14 00          	movb   $0x0,0x14(%eax)
80106692:	c6 40 17 00          	movb   $0x0,0x17(%eax)
80106696:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
8010669a:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
8010669e:	66 89 48 22          	mov    %cx,0x22(%eax)
801066a2:	c6 40 24 00          	movb   $0x0,0x24(%eax)
801066a6:	c6 40 27 00          	movb   $0x0,0x27(%eax)
801066aa:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
801066ae:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
801066b2:	c1 e8 10             	shr    $0x10,%eax
801066b5:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
801066b9:	8d 45 f2             	lea    -0xe(%ebp),%eax
801066bc:	0f 01 10             	lgdtl  (%eax)
801066bf:	c9                   	leave  
801066c0:	c3                   	ret    
801066c1:	eb 0d                	jmp    801066d0 <switchkvm>
801066c3:	90                   	nop
801066c4:	90                   	nop
801066c5:	90                   	nop
801066c6:	90                   	nop
801066c7:	90                   	nop
801066c8:	90                   	nop
801066c9:	90                   	nop
801066ca:	90                   	nop
801066cb:	90                   	nop
801066cc:	90                   	nop
801066cd:	90                   	nop
801066ce:	90                   	nop
801066cf:	90                   	nop

801066d0 <switchkvm>:
801066d0:	a1 a4 55 11 80       	mov    0x801155a4,%eax
801066d5:	55                   	push   %ebp
801066d6:	89 e5                	mov    %esp,%ebp
801066d8:	05 00 00 00 80       	add    $0x80000000,%eax
801066dd:	0f 22 d8             	mov    %eax,%cr3
801066e0:	5d                   	pop    %ebp
801066e1:	c3                   	ret    
801066e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066f0 <switchuvm>:
801066f0:	55                   	push   %ebp
801066f1:	89 e5                	mov    %esp,%ebp
801066f3:	57                   	push   %edi
801066f4:	56                   	push   %esi
801066f5:	53                   	push   %ebx
801066f6:	83 ec 1c             	sub    $0x1c,%esp
801066f9:	8b 75 08             	mov    0x8(%ebp),%esi
801066fc:	85 f6                	test   %esi,%esi
801066fe:	0f 84 cd 00 00 00    	je     801067d1 <switchuvm+0xe1>
80106704:	8b 46 08             	mov    0x8(%esi),%eax
80106707:	85 c0                	test   %eax,%eax
80106709:	0f 84 da 00 00 00    	je     801067e9 <switchuvm+0xf9>
8010670f:	8b 7e 04             	mov    0x4(%esi),%edi
80106712:	85 ff                	test   %edi,%edi
80106714:	0f 84 c3 00 00 00    	je     801067dd <switchuvm+0xed>
8010671a:	e8 f1 da ff ff       	call   80104210 <pushcli>
8010671f:	e8 dc ce ff ff       	call   80103600 <mycpu>
80106724:	89 c3                	mov    %eax,%ebx
80106726:	e8 d5 ce ff ff       	call   80103600 <mycpu>
8010672b:	89 c7                	mov    %eax,%edi
8010672d:	e8 ce ce ff ff       	call   80103600 <mycpu>
80106732:	83 c7 08             	add    $0x8,%edi
80106735:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106738:	e8 c3 ce ff ff       	call   80103600 <mycpu>
8010673d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106740:	ba 67 00 00 00       	mov    $0x67,%edx
80106745:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
8010674c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106753:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
8010675a:	83 c1 08             	add    $0x8,%ecx
8010675d:	c1 e9 10             	shr    $0x10,%ecx
80106760:	83 c0 08             	add    $0x8,%eax
80106763:	c1 e8 18             	shr    $0x18,%eax
80106766:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010676c:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106773:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106779:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010677e:	e8 7d ce ff ff       	call   80103600 <mycpu>
80106783:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
8010678a:	e8 71 ce ff ff       	call   80103600 <mycpu>
8010678f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106794:	66 89 48 10          	mov    %cx,0x10(%eax)
80106798:	e8 63 ce ff ff       	call   80103600 <mycpu>
8010679d:	8b 56 08             	mov    0x8(%esi),%edx
801067a0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
801067a6:	89 48 0c             	mov    %ecx,0xc(%eax)
801067a9:	e8 52 ce ff ff       	call   80103600 <mycpu>
801067ae:	66 89 58 6e          	mov    %bx,0x6e(%eax)
801067b2:	b8 28 00 00 00       	mov    $0x28,%eax
801067b7:	0f 00 d8             	ltr    %ax
801067ba:	8b 46 04             	mov    0x4(%esi),%eax
801067bd:	05 00 00 00 80       	add    $0x80000000,%eax
801067c2:	0f 22 d8             	mov    %eax,%cr3
801067c5:	83 c4 1c             	add    $0x1c,%esp
801067c8:	5b                   	pop    %ebx
801067c9:	5e                   	pop    %esi
801067ca:	5f                   	pop    %edi
801067cb:	5d                   	pop    %ebp
801067cc:	e9 7f da ff ff       	jmp    80104250 <popcli>
801067d1:	c7 04 24 52 76 10 80 	movl   $0x80107652,(%esp)
801067d8:	e8 83 9b ff ff       	call   80100360 <panic>
801067dd:	c7 04 24 7d 76 10 80 	movl   $0x8010767d,(%esp)
801067e4:	e8 77 9b ff ff       	call   80100360 <panic>
801067e9:	c7 04 24 68 76 10 80 	movl   $0x80107668,(%esp)
801067f0:	e8 6b 9b ff ff       	call   80100360 <panic>
801067f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801067f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106800 <inituvm>:
80106800:	55                   	push   %ebp
80106801:	89 e5                	mov    %esp,%ebp
80106803:	57                   	push   %edi
80106804:	56                   	push   %esi
80106805:	53                   	push   %ebx
80106806:	83 ec 1c             	sub    $0x1c,%esp
80106809:	8b 75 10             	mov    0x10(%ebp),%esi
8010680c:	8b 45 08             	mov    0x8(%ebp),%eax
8010680f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106812:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106818:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010681b:	77 54                	ja     80106871 <inituvm+0x71>
8010681d:	e8 7e bc ff ff       	call   801024a0 <kalloc>
80106822:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106829:	00 
8010682a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106831:	00 
80106832:	89 c3                	mov    %eax,%ebx
80106834:	89 04 24             	mov    %eax,(%esp)
80106837:	e8 84 db ff ff       	call   801043c0 <memset>
8010683c:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106842:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106847:	89 04 24             	mov    %eax,(%esp)
8010684a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010684d:	31 d2                	xor    %edx,%edx
8010684f:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106856:	00 
80106857:	e8 94 fc ff ff       	call   801064f0 <mappages>
8010685c:	89 75 10             	mov    %esi,0x10(%ebp)
8010685f:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106862:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106865:	83 c4 1c             	add    $0x1c,%esp
80106868:	5b                   	pop    %ebx
80106869:	5e                   	pop    %esi
8010686a:	5f                   	pop    %edi
8010686b:	5d                   	pop    %ebp
8010686c:	e9 ef db ff ff       	jmp    80104460 <memmove>
80106871:	c7 04 24 91 76 10 80 	movl   $0x80107691,(%esp)
80106878:	e8 e3 9a ff ff       	call   80100360 <panic>
8010687d:	8d 76 00             	lea    0x0(%esi),%esi

80106880 <loaduvm>:
80106880:	55                   	push   %ebp
80106881:	89 e5                	mov    %esp,%ebp
80106883:	57                   	push   %edi
80106884:	56                   	push   %esi
80106885:	53                   	push   %ebx
80106886:	83 ec 1c             	sub    $0x1c,%esp
80106889:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106890:	0f 85 98 00 00 00    	jne    8010692e <loaduvm+0xae>
80106896:	8b 75 18             	mov    0x18(%ebp),%esi
80106899:	31 db                	xor    %ebx,%ebx
8010689b:	85 f6                	test   %esi,%esi
8010689d:	75 1a                	jne    801068b9 <loaduvm+0x39>
8010689f:	eb 77                	jmp    80106918 <loaduvm+0x98>
801068a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068a8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068ae:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801068b4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801068b7:	76 5f                	jbe    80106918 <loaduvm+0x98>
801068b9:	8b 55 0c             	mov    0xc(%ebp),%edx
801068bc:	31 c9                	xor    %ecx,%ecx
801068be:	8b 45 08             	mov    0x8(%ebp),%eax
801068c1:	01 da                	add    %ebx,%edx
801068c3:	e8 98 fb ff ff       	call   80106460 <walkpgdir>
801068c8:	85 c0                	test   %eax,%eax
801068ca:	74 56                	je     80106922 <loaduvm+0xa2>
801068cc:	8b 00                	mov    (%eax),%eax
801068ce:	bf 00 10 00 00       	mov    $0x1000,%edi
801068d3:	8b 4d 14             	mov    0x14(%ebp),%ecx
801068d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801068db:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
801068e1:	0f 42 fe             	cmovb  %esi,%edi
801068e4:	05 00 00 00 80       	add    $0x80000000,%eax
801068e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801068ed:	8b 45 10             	mov    0x10(%ebp),%eax
801068f0:	01 d9                	add    %ebx,%ecx
801068f2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801068f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801068fa:	89 04 24             	mov    %eax,(%esp)
801068fd:	e8 5e b0 ff ff       	call   80101960 <readi>
80106902:	39 f8                	cmp    %edi,%eax
80106904:	74 a2                	je     801068a8 <loaduvm+0x28>
80106906:	83 c4 1c             	add    $0x1c,%esp
80106909:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010690e:	5b                   	pop    %ebx
8010690f:	5e                   	pop    %esi
80106910:	5f                   	pop    %edi
80106911:	5d                   	pop    %ebp
80106912:	c3                   	ret    
80106913:	90                   	nop
80106914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106918:	83 c4 1c             	add    $0x1c,%esp
8010691b:	31 c0                	xor    %eax,%eax
8010691d:	5b                   	pop    %ebx
8010691e:	5e                   	pop    %esi
8010691f:	5f                   	pop    %edi
80106920:	5d                   	pop    %ebp
80106921:	c3                   	ret    
80106922:	c7 04 24 ab 76 10 80 	movl   $0x801076ab,(%esp)
80106929:	e8 32 9a ff ff       	call   80100360 <panic>
8010692e:	c7 04 24 4c 77 10 80 	movl   $0x8010774c,(%esp)
80106935:	e8 26 9a ff ff       	call   80100360 <panic>
8010693a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106940 <allocuvm>:
80106940:	55                   	push   %ebp
80106941:	89 e5                	mov    %esp,%ebp
80106943:	57                   	push   %edi
80106944:	56                   	push   %esi
80106945:	53                   	push   %ebx
80106946:	83 ec 1c             	sub    $0x1c,%esp
80106949:	8b 7d 10             	mov    0x10(%ebp),%edi
8010694c:	85 ff                	test   %edi,%edi
8010694e:	0f 88 7e 00 00 00    	js     801069d2 <allocuvm+0x92>
80106954:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106957:	8b 45 0c             	mov    0xc(%ebp),%eax
8010695a:	72 78                	jb     801069d4 <allocuvm+0x94>
8010695c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106962:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106968:	39 df                	cmp    %ebx,%edi
8010696a:	77 4a                	ja     801069b6 <allocuvm+0x76>
8010696c:	eb 72                	jmp    801069e0 <allocuvm+0xa0>
8010696e:	66 90                	xchg   %ax,%ax
80106970:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106977:	00 
80106978:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010697f:	00 
80106980:	89 04 24             	mov    %eax,(%esp)
80106983:	e8 38 da ff ff       	call   801043c0 <memset>
80106988:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010698e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106993:	89 04 24             	mov    %eax,(%esp)
80106996:	8b 45 08             	mov    0x8(%ebp),%eax
80106999:	89 da                	mov    %ebx,%edx
8010699b:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
801069a2:	00 
801069a3:	e8 48 fb ff ff       	call   801064f0 <mappages>
801069a8:	85 c0                	test   %eax,%eax
801069aa:	78 44                	js     801069f0 <allocuvm+0xb0>
801069ac:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801069b2:	39 df                	cmp    %ebx,%edi
801069b4:	76 2a                	jbe    801069e0 <allocuvm+0xa0>
801069b6:	e8 e5 ba ff ff       	call   801024a0 <kalloc>
801069bb:	85 c0                	test   %eax,%eax
801069bd:	89 c6                	mov    %eax,%esi
801069bf:	75 af                	jne    80106970 <allocuvm+0x30>
801069c1:	c7 04 24 c9 76 10 80 	movl   $0x801076c9,(%esp)
801069c8:	e8 83 9c ff ff       	call   80100650 <cprintf>
801069cd:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801069d0:	77 48                	ja     80106a1a <allocuvm+0xda>
801069d2:	31 c0                	xor    %eax,%eax
801069d4:	83 c4 1c             	add    $0x1c,%esp
801069d7:	5b                   	pop    %ebx
801069d8:	5e                   	pop    %esi
801069d9:	5f                   	pop    %edi
801069da:	5d                   	pop    %ebp
801069db:	c3                   	ret    
801069dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801069e0:	83 c4 1c             	add    $0x1c,%esp
801069e3:	89 f8                	mov    %edi,%eax
801069e5:	5b                   	pop    %ebx
801069e6:	5e                   	pop    %esi
801069e7:	5f                   	pop    %edi
801069e8:	5d                   	pop    %ebp
801069e9:	c3                   	ret    
801069ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801069f0:	c7 04 24 e1 76 10 80 	movl   $0x801076e1,(%esp)
801069f7:	e8 54 9c ff ff       	call   80100650 <cprintf>
801069fc:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801069ff:	76 0d                	jbe    80106a0e <allocuvm+0xce>
80106a01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106a04:	89 fa                	mov    %edi,%edx
80106a06:	8b 45 08             	mov    0x8(%ebp),%eax
80106a09:	e8 62 fb ff ff       	call   80106570 <deallocuvm.part.0>
80106a0e:	89 34 24             	mov    %esi,(%esp)
80106a11:	e8 da b8 ff ff       	call   801022f0 <kfree>
80106a16:	31 c0                	xor    %eax,%eax
80106a18:	eb ba                	jmp    801069d4 <allocuvm+0x94>
80106a1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106a1d:	89 fa                	mov    %edi,%edx
80106a1f:	8b 45 08             	mov    0x8(%ebp),%eax
80106a22:	e8 49 fb ff ff       	call   80106570 <deallocuvm.part.0>
80106a27:	31 c0                	xor    %eax,%eax
80106a29:	eb a9                	jmp    801069d4 <allocuvm+0x94>
80106a2b:	90                   	nop
80106a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a30 <deallocuvm>:
80106a30:	55                   	push   %ebp
80106a31:	89 e5                	mov    %esp,%ebp
80106a33:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a36:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106a39:	8b 45 08             	mov    0x8(%ebp),%eax
80106a3c:	39 d1                	cmp    %edx,%ecx
80106a3e:	73 08                	jae    80106a48 <deallocuvm+0x18>
80106a40:	5d                   	pop    %ebp
80106a41:	e9 2a fb ff ff       	jmp    80106570 <deallocuvm.part.0>
80106a46:	66 90                	xchg   %ax,%ax
80106a48:	89 d0                	mov    %edx,%eax
80106a4a:	5d                   	pop    %ebp
80106a4b:	c3                   	ret    
80106a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a50 <freevm>:
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	56                   	push   %esi
80106a54:	53                   	push   %ebx
80106a55:	83 ec 10             	sub    $0x10,%esp
80106a58:	8b 75 08             	mov    0x8(%ebp),%esi
80106a5b:	85 f6                	test   %esi,%esi
80106a5d:	74 59                	je     80106ab8 <freevm+0x68>
80106a5f:	31 c9                	xor    %ecx,%ecx
80106a61:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106a66:	89 f0                	mov    %esi,%eax
80106a68:	31 db                	xor    %ebx,%ebx
80106a6a:	e8 01 fb ff ff       	call   80106570 <deallocuvm.part.0>
80106a6f:	eb 12                	jmp    80106a83 <freevm+0x33>
80106a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a78:	83 c3 01             	add    $0x1,%ebx
80106a7b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106a81:	74 27                	je     80106aaa <freevm+0x5a>
80106a83:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106a86:	f6 c2 01             	test   $0x1,%dl
80106a89:	74 ed                	je     80106a78 <freevm+0x28>
80106a8b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106a91:	83 c3 01             	add    $0x1,%ebx
80106a94:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106a9a:	89 14 24             	mov    %edx,(%esp)
80106a9d:	e8 4e b8 ff ff       	call   801022f0 <kfree>
80106aa2:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106aa8:	75 d9                	jne    80106a83 <freevm+0x33>
80106aaa:	89 75 08             	mov    %esi,0x8(%ebp)
80106aad:	83 c4 10             	add    $0x10,%esp
80106ab0:	5b                   	pop    %ebx
80106ab1:	5e                   	pop    %esi
80106ab2:	5d                   	pop    %ebp
80106ab3:	e9 38 b8 ff ff       	jmp    801022f0 <kfree>
80106ab8:	c7 04 24 fd 76 10 80 	movl   $0x801076fd,(%esp)
80106abf:	e8 9c 98 ff ff       	call   80100360 <panic>
80106ac4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106aca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106ad0 <setupkvm>:
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	56                   	push   %esi
80106ad4:	53                   	push   %ebx
80106ad5:	83 ec 10             	sub    $0x10,%esp
80106ad8:	e8 c3 b9 ff ff       	call   801024a0 <kalloc>
80106add:	85 c0                	test   %eax,%eax
80106adf:	89 c6                	mov    %eax,%esi
80106ae1:	74 6d                	je     80106b50 <setupkvm+0x80>
80106ae3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106aea:	00 
80106aeb:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
80106af0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106af7:	00 
80106af8:	89 04 24             	mov    %eax,(%esp)
80106afb:	e8 c0 d8 ff ff       	call   801043c0 <memset>
80106b00:	8b 53 0c             	mov    0xc(%ebx),%edx
80106b03:	8b 43 04             	mov    0x4(%ebx),%eax
80106b06:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106b09:	89 54 24 04          	mov    %edx,0x4(%esp)
80106b0d:	8b 13                	mov    (%ebx),%edx
80106b0f:	89 04 24             	mov    %eax,(%esp)
80106b12:	29 c1                	sub    %eax,%ecx
80106b14:	89 f0                	mov    %esi,%eax
80106b16:	e8 d5 f9 ff ff       	call   801064f0 <mappages>
80106b1b:	85 c0                	test   %eax,%eax
80106b1d:	78 19                	js     80106b38 <setupkvm+0x68>
80106b1f:	83 c3 10             	add    $0x10,%ebx
80106b22:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106b28:	72 d6                	jb     80106b00 <setupkvm+0x30>
80106b2a:	89 f0                	mov    %esi,%eax
80106b2c:	83 c4 10             	add    $0x10,%esp
80106b2f:	5b                   	pop    %ebx
80106b30:	5e                   	pop    %esi
80106b31:	5d                   	pop    %ebp
80106b32:	c3                   	ret    
80106b33:	90                   	nop
80106b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b38:	89 34 24             	mov    %esi,(%esp)
80106b3b:	e8 10 ff ff ff       	call   80106a50 <freevm>
80106b40:	83 c4 10             	add    $0x10,%esp
80106b43:	31 c0                	xor    %eax,%eax
80106b45:	5b                   	pop    %ebx
80106b46:	5e                   	pop    %esi
80106b47:	5d                   	pop    %ebp
80106b48:	c3                   	ret    
80106b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b50:	31 c0                	xor    %eax,%eax
80106b52:	eb d8                	jmp    80106b2c <setupkvm+0x5c>
80106b54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106b60 <kvmalloc>:
80106b60:	55                   	push   %ebp
80106b61:	89 e5                	mov    %esp,%ebp
80106b63:	83 ec 08             	sub    $0x8,%esp
80106b66:	e8 65 ff ff ff       	call   80106ad0 <setupkvm>
80106b6b:	a3 a4 55 11 80       	mov    %eax,0x801155a4
80106b70:	05 00 00 00 80       	add    $0x80000000,%eax
80106b75:	0f 22 d8             	mov    %eax,%cr3
80106b78:	c9                   	leave  
80106b79:	c3                   	ret    
80106b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b80 <clearpteu>:
80106b80:	55                   	push   %ebp
80106b81:	31 c9                	xor    %ecx,%ecx
80106b83:	89 e5                	mov    %esp,%ebp
80106b85:	83 ec 18             	sub    $0x18,%esp
80106b88:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b8b:	8b 45 08             	mov    0x8(%ebp),%eax
80106b8e:	e8 cd f8 ff ff       	call   80106460 <walkpgdir>
80106b93:	85 c0                	test   %eax,%eax
80106b95:	74 05                	je     80106b9c <clearpteu+0x1c>
80106b97:	83 20 fb             	andl   $0xfffffffb,(%eax)
80106b9a:	c9                   	leave  
80106b9b:	c3                   	ret    
80106b9c:	c7 04 24 0e 77 10 80 	movl   $0x8010770e,(%esp)
80106ba3:	e8 b8 97 ff ff       	call   80100360 <panic>
80106ba8:	90                   	nop
80106ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106bb0 <copyuvm>:
80106bb0:	55                   	push   %ebp
80106bb1:	89 e5                	mov    %esp,%ebp
80106bb3:	57                   	push   %edi
80106bb4:	56                   	push   %esi
80106bb5:	53                   	push   %ebx
80106bb6:	83 ec 2c             	sub    $0x2c,%esp
80106bb9:	e8 12 ff ff ff       	call   80106ad0 <setupkvm>
80106bbe:	85 c0                	test   %eax,%eax
80106bc0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106bc3:	0f 84 b9 00 00 00    	je     80106c82 <copyuvm+0xd2>
80106bc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bcc:	85 c0                	test   %eax,%eax
80106bce:	0f 84 94 00 00 00    	je     80106c68 <copyuvm+0xb8>
80106bd4:	31 ff                	xor    %edi,%edi
80106bd6:	eb 48                	jmp    80106c20 <copyuvm+0x70>
80106bd8:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80106bde:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106be5:	00 
80106be6:	89 74 24 04          	mov    %esi,0x4(%esp)
80106bea:	89 04 24             	mov    %eax,(%esp)
80106bed:	e8 6e d8 ff ff       	call   80104460 <memmove>
80106bf2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bf5:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106bfa:	89 fa                	mov    %edi,%edx
80106bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c00:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c06:	89 04 24             	mov    %eax,(%esp)
80106c09:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c0c:	e8 df f8 ff ff       	call   801064f0 <mappages>
80106c11:	85 c0                	test   %eax,%eax
80106c13:	78 63                	js     80106c78 <copyuvm+0xc8>
80106c15:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106c1b:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106c1e:	76 48                	jbe    80106c68 <copyuvm+0xb8>
80106c20:	8b 45 08             	mov    0x8(%ebp),%eax
80106c23:	31 c9                	xor    %ecx,%ecx
80106c25:	89 fa                	mov    %edi,%edx
80106c27:	e8 34 f8 ff ff       	call   80106460 <walkpgdir>
80106c2c:	85 c0                	test   %eax,%eax
80106c2e:	74 62                	je     80106c92 <copyuvm+0xe2>
80106c30:	8b 00                	mov    (%eax),%eax
80106c32:	a8 01                	test   $0x1,%al
80106c34:	74 50                	je     80106c86 <copyuvm+0xd6>
80106c36:	89 c6                	mov    %eax,%esi
80106c38:	25 ff 0f 00 00       	and    $0xfff,%eax
80106c3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c40:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80106c46:	e8 55 b8 ff ff       	call   801024a0 <kalloc>
80106c4b:	85 c0                	test   %eax,%eax
80106c4d:	89 c3                	mov    %eax,%ebx
80106c4f:	75 87                	jne    80106bd8 <copyuvm+0x28>
80106c51:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c54:	89 04 24             	mov    %eax,(%esp)
80106c57:	e8 f4 fd ff ff       	call   80106a50 <freevm>
80106c5c:	31 c0                	xor    %eax,%eax
80106c5e:	83 c4 2c             	add    $0x2c,%esp
80106c61:	5b                   	pop    %ebx
80106c62:	5e                   	pop    %esi
80106c63:	5f                   	pop    %edi
80106c64:	5d                   	pop    %ebp
80106c65:	c3                   	ret    
80106c66:	66 90                	xchg   %ax,%ax
80106c68:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c6b:	83 c4 2c             	add    $0x2c,%esp
80106c6e:	5b                   	pop    %ebx
80106c6f:	5e                   	pop    %esi
80106c70:	5f                   	pop    %edi
80106c71:	5d                   	pop    %ebp
80106c72:	c3                   	ret    
80106c73:	90                   	nop
80106c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c78:	89 1c 24             	mov    %ebx,(%esp)
80106c7b:	e8 70 b6 ff ff       	call   801022f0 <kfree>
80106c80:	eb cf                	jmp    80106c51 <copyuvm+0xa1>
80106c82:	31 c0                	xor    %eax,%eax
80106c84:	eb d8                	jmp    80106c5e <copyuvm+0xae>
80106c86:	c7 04 24 32 77 10 80 	movl   $0x80107732,(%esp)
80106c8d:	e8 ce 96 ff ff       	call   80100360 <panic>
80106c92:	c7 04 24 18 77 10 80 	movl   $0x80107718,(%esp)
80106c99:	e8 c2 96 ff ff       	call   80100360 <panic>
80106c9e:	66 90                	xchg   %ax,%ax

80106ca0 <uva2ka>:
80106ca0:	55                   	push   %ebp
80106ca1:	31 c9                	xor    %ecx,%ecx
80106ca3:	89 e5                	mov    %esp,%ebp
80106ca5:	83 ec 08             	sub    $0x8,%esp
80106ca8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106cab:	8b 45 08             	mov    0x8(%ebp),%eax
80106cae:	e8 ad f7 ff ff       	call   80106460 <walkpgdir>
80106cb3:	8b 00                	mov    (%eax),%eax
80106cb5:	89 c2                	mov    %eax,%edx
80106cb7:	83 e2 05             	and    $0x5,%edx
80106cba:	83 fa 05             	cmp    $0x5,%edx
80106cbd:	75 11                	jne    80106cd0 <uva2ka+0x30>
80106cbf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106cc4:	05 00 00 00 80       	add    $0x80000000,%eax
80106cc9:	c9                   	leave  
80106cca:	c3                   	ret    
80106ccb:	90                   	nop
80106ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106cd0:	31 c0                	xor    %eax,%eax
80106cd2:	c9                   	leave  
80106cd3:	c3                   	ret    
80106cd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106cda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106ce0 <copyout>:
80106ce0:	55                   	push   %ebp
80106ce1:	89 e5                	mov    %esp,%ebp
80106ce3:	57                   	push   %edi
80106ce4:	56                   	push   %esi
80106ce5:	53                   	push   %ebx
80106ce6:	83 ec 1c             	sub    $0x1c,%esp
80106ce9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106cec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106cef:	8b 7d 10             	mov    0x10(%ebp),%edi
80106cf2:	85 db                	test   %ebx,%ebx
80106cf4:	75 3a                	jne    80106d30 <copyout+0x50>
80106cf6:	eb 68                	jmp    80106d60 <copyout+0x80>
80106cf8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106cfb:	89 f2                	mov    %esi,%edx
80106cfd:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106d01:	29 ca                	sub    %ecx,%edx
80106d03:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106d09:	39 da                	cmp    %ebx,%edx
80106d0b:	0f 47 d3             	cmova  %ebx,%edx
80106d0e:	29 f1                	sub    %esi,%ecx
80106d10:	01 c8                	add    %ecx,%eax
80106d12:	89 54 24 08          	mov    %edx,0x8(%esp)
80106d16:	89 04 24             	mov    %eax,(%esp)
80106d19:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106d1c:	e8 3f d7 ff ff       	call   80104460 <memmove>
80106d21:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106d24:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
80106d2a:	01 d7                	add    %edx,%edi
80106d2c:	29 d3                	sub    %edx,%ebx
80106d2e:	74 30                	je     80106d60 <copyout+0x80>
80106d30:	8b 45 08             	mov    0x8(%ebp),%eax
80106d33:	89 ce                	mov    %ecx,%esi
80106d35:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80106d3b:	89 74 24 04          	mov    %esi,0x4(%esp)
80106d3f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106d42:	89 04 24             	mov    %eax,(%esp)
80106d45:	e8 56 ff ff ff       	call   80106ca0 <uva2ka>
80106d4a:	85 c0                	test   %eax,%eax
80106d4c:	75 aa                	jne    80106cf8 <copyout+0x18>
80106d4e:	83 c4 1c             	add    $0x1c,%esp
80106d51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d56:	5b                   	pop    %ebx
80106d57:	5e                   	pop    %esi
80106d58:	5f                   	pop    %edi
80106d59:	5d                   	pop    %ebp
80106d5a:	c3                   	ret    
80106d5b:	90                   	nop
80106d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d60:	83 c4 1c             	add    $0x1c,%esp
80106d63:	31 c0                	xor    %eax,%eax
80106d65:	5b                   	pop    %ebx
80106d66:	5e                   	pop    %esi
80106d67:	5f                   	pop    %edi
80106d68:	5d                   	pop    %ebp
80106d69:	c3                   	ret    
