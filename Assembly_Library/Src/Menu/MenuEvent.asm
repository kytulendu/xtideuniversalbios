; File name		:	MenuEvent.asm
; Project name	:	Assembly Library
; Created date	:	13.7.2010
; Last update	:	11.8.2010
; Author		:	Tomi Tilli
; Description	:	Functions for initializing menu system.

; Section containing code
SECTION .text

;--------------------------------------------------------------------
; MenuEvent_InitializeMenuinit
;	Parameters
;		SS:BP:	Ptr to MENU
;	Returns:
;		DS:SI:	Ptr to MENU with MENUINIT initialized from user handler
;		CF:		Set if event processed
;				Cleared if event not processed
;	Corrupts registers:
;		AX, BX, DX
;--------------------------------------------------------------------
ALIGN JUMP_ALIGN
MenuEvent_InitializeMenuinit:
	push	ss
	pop		ds
	mov		si, bp
	mov		bx, MENUEVENT.InitializeMenuinitFromDSSI
	jmp		SHORT MenuEvent_SendFromBX


;--------------------------------------------------------------------
; MenuEvent_ExitMenu
;	Parameters
;		SS:BP:	Ptr to MENU
;	Returns:
;		CF:		Set if event processed
;				Cleared if event not processed
;	Corrupts registers:
;		AX, BX, DX
;--------------------------------------------------------------------
ALIGN JUMP_ALIGN
MenuEvent_ExitMenu:
	mov		bx, MENUEVENT.ExitMenu
	jmp		SHORT MenuEvent_SendFromBX


;--------------------------------------------------------------------
; MenuEvent_IdleProcessing
;	Parameters
;		SS:BP:	Ptr to MENU
;	Returns:
;		CF:		Set if event processed
;				Cleared if event not processed
;	Corrupts registers:
;		AX, BX, DX
;--------------------------------------------------------------------
ALIGN JUMP_ALIGN
MenuEvent_IdleProcessing:
	mov		bx, MENUEVENT.IdleProcessing
	jmp		SHORT MenuEvent_SendFromBX


;--------------------------------------------------------------------
; MenuEvent_RefreshTitle
; MenuEvent_RefreshInformation
;	Parameters
;		Cursor will be positioned to beginning of window
;	Returns:
;		CF:		Set if event processed
;				Cleared if event not processed
;	Corrupts registers:
;		AX, BX, DX
;--------------------------------------------------------------------
ALIGN JUMP_ALIGN
MenuEvent_RefreshTitle:
	mov		bx, MENUEVENT.RefreshTitle
	jmp		SHORT MenuEvent_SendFromBX
ALIGN JUMP_ALIGN
MenuEvent_RefreshInformation:
	mov		bx, MENUEVENT.RefreshInformation
	jmp		SHORT MenuEvent_SendFromBX


;--------------------------------------------------------------------
; MenuEvent_RefreshItemFromCX
;	Parameters
;		CX:		Index of item to refresh
;		Cursor has been positioned to the beginning of item line
;	Returns:
;		CF:		Set if event processed
;				Cleared if event not processed
;	Corrupts registers:
;		AX, BX, DX
;--------------------------------------------------------------------
ALIGN JUMP_ALIGN
MenuEvent_RefreshItemFromCX:
	mov		bx, MENUEVENT.RefreshItemFromCX
	jmp		SHORT MenuEvent_SendFromBX


;--------------------------------------------------------------------
; MenuEvent_HighlightItemFromCX
;	Parameters
;		CX:		Index of item to highlight
;	Returns:
;		Nothing
;	Corrupts registers:
;		AX, BX, DX, SI, DI
;--------------------------------------------------------------------
ALIGN JUMP_ALIGN
MenuEvent_HighlightItemFromCX:
	mov		dx, cx
	xchg	dx, [bp+MENU.wHighlightedItem]
	push	dx

	mov		bx, MENUEVENT.ItemHighlightedFromCX
	call	MenuEvent_SendFromBX

	pop		ax
	call	MenuText_RefreshItemFromAX
	mov		ax, [bp+MENU.wHighlightedItem]
	jmp		MenuText_RefreshItemFromAX


;--------------------------------------------------------------------
; MenuEvent_KeyStrokeInAX
;	Parameters
;		AL:		ASCII character for the key
;		AH:		Keyboard library scan code for the key
;	Returns:
;		CF:		Set if event processed
;				Cleared if event not processed
;	Corrupts registers:
;		AX, BX, DX
;--------------------------------------------------------------------
ALIGN JUMP_ALIGN
MenuEvent_KeyStrokeInAX:
	mov		bx, MENUEVENT.KeyStrokeInAX
	jmp		SHORT MenuEvent_SendFromBX


;--------------------------------------------------------------------
; MenuEvent_ItemSelectedFromCX
;	Parameters
;		CX:		Index of selected item
;	Returns:
;		CF:		Set if event processed
;				Cleared if event not processed
;	Corrupts registers:
;		AX, BX, DX
;--------------------------------------------------------------------
ALIGN JUMP_ALIGN
MenuEvent_ItemSelectedFromCX:
	mov		bx, MENUEVENT.ItemSelectedFromCX
	jmp		SHORT MenuEvent_SendFromBX


;--------------------------------------------------------------------
; MenuEvent_SendFromBX
;	Parameters
;		BX:					Menu event to send
;		SS:BP:				Ptr to MENU
;		Other registers:	Event specific parameters
;	Returns:
;		AX, DX:				Event specific return values
;		CF:					Set if event processed
;							Cleared if event not processed
;	Corrupts registers:
;		BX
;--------------------------------------------------------------------
ALIGN JUMP_ALIGN
MenuEvent_SendFromBX:
	push	es
	push	ds
	push	di
	push	si
	push	cx
	call	[bp+MENU.fnEventHandler]
	pop		cx
	pop		si
	pop		di
	pop		ds
	pop		es
	ret