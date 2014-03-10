;lifebios.asm
             .model small
             .stack 100h        ;EXE - file
             .code
             .386
start:
             push        FAR_BSS
             pop         ds

             xor         ax, ax
             int         1Ah

             mov         di, 320*200+1
	     push	 ds
	     push	 0040h
             pop	 ds
             mov	 eax, dword ptr ds:006Ch
	     pop	 ds

fill_buffer:
             imul        dx, 4E35h
             inc         dx
             mov         ax, dx
             shr         ax, 15
             mov         byte ptr [di], al

             dec         di
             jnz         fill_buffer

             mov         ax, 0013h
             int         10h

             mov         ax, 0
             int         33h
	     mov	 ax, 1
	     int	 33h	

             mov       ax, 000Ch
             mov       cx, 0002h
             push      cs
	     pop       es	 
	     mov       dx, offset handler
             int       33h

new_cycle:
             mov         di, 320*200+1
step_1:
             mov         al, byte ptr [di+1]
             add         al, byte ptr [di-1]
             add         al, byte ptr [di+319]
             add         al, byte ptr [di-319]
             add         al, byte ptr [di+320]
             add         al, byte ptr [di-320]
             add         al, byte ptr [di+321]
             add         al, byte ptr [di-321]
             shl         al, 4

             or          byte ptr [di], al

             dec         di
             jnz         step_1

             mov         di, 320*200+1

flip_cycle:
             mov         al, byte ptr [di]
             shr         al, 4
             cmp         al, 3
             je          birth
             cmp         al, 2
             je          f_c_continue
             mov         byte ptr [di], 0
             jmp         short f_c_continue
birth:
             mov         byte ptr [di], 1
f_c_continue:
             and         byte ptr [di], 0Fh

             dec         di
             jnz         flip_cycle

             mov         si, 320*200+1
             mov         cx, 319
             mov         dx, 199
zdisplay:
             ;mov         ax, 2
             ;int         33h

             mov         al, byte ptr [si]
             mov         ah, 0Ch
             int         10h
             dec         si
             dec         cx
             jns         zdisplay
             mov         cx, 319
             dec         dx
             jns         zdisplay

            ; mov         ax, 1
            ; int         33h

             mov         ah, 1
             int         16h
             jz          new_cycle

             mov       ax, 000Ch
             mov       cx, 0000h
             int       33h
             
             mov         ax, 03h
             int         10h
             mov         ax, 4C00h
             int         21h
handler:
             push      bx
             push      cx
             push      dx

             mov       ax, 3
             int       33h
             
             mov       ax, 0C01h
             int       10h
             
             mov       ax, 3
             int       33h
             
             inc       cx	
             inc       dx
	     mov       ax, 320
             mul       dx
             add       ax, cx
             mov       si, ax
             mov       al, 1
             mov       byte ptr [si], al		
	     
             pop       dx
             pop       cx
             pop       bx

             retf
             .fardata?
                      db        320*200+1 dup(?)
             end      start
