﻿;use this for debug
;ListVars
;Pause


;==========================
;Initialization
;==========================

; Here's a more complex group for MS Outlook 2002.
; In the autoexecute section at the top of the script:
 SetTitleMatchMode, 2
 ;GroupAdd, VC, Visual Studio ; This is for mails currently being composed
 GroupAdd, VC, Visual Studio ;
 GroupAdd, VC, Sublime Text ;
 GroupAdd, VC, Virtua Writer ;
 GroupAdd, VC, vwTestGui ;
 GroupAdd, VC, Open ;
 GroupAdd, EMACS, ahk_class Emacs

;======================

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#InstallKeybdHook
#UseHook
#Persistent

enabledIcon := "EmacsEverywhere_on.ico"
disabledIcon := "EmacsEverywhere_off.ico"
; C-x status
is_pre_x = 0
; C-Space status
is_pre_spc = 0

EmacsModeStat := false
EmacsModeStatStored := false

ProgWinTitle1 = ahk_class Emacs
WinTrigger1 = Active
ProgWinTitle2 = ahk_group VC
WinTrigger2 = Active

; SetTimer Period
CheckPeriod = 200

SetEmacsMode(false)

SetTimer, LabelCheckTrigger, %CheckPeriod%
Return

; ------ ------ ------

LabelCheckTrigger:
  While ( ProgWinTitle%A_Index% != "" && WinTrigger := WinTrigger%A_Index% )
    if ( !ProgRunning%A_Index% != !Win%WinTrigger%( ProgWinTitle := ProgWinTitle%A_Index% ) )
      GoSubSafe( "LabelTriggerO" ( (ProgRunning%A_Index% := !ProgRunning%A_Index%) ? "n" : "ff" ) A_Index )
Return

; ------ ------ ------

GoSubSafe(mySub)
{
  if IsLabel(mySub)
    GoSub %mySub%
}

; ------ ------ CUSTOM LABEL SECTION ------ ------

LabelTriggerOn1:
  SetEmacsMode(false)
Return
LabelTriggerOff1:
  SetEmacsMode(EmacsModeStatStored)
Return
LabelTriggerOn2:
  SetEmacsMode(true)
Return
LabelTriggerOff2:
  SetEmacsMode(EmacsModeStatStored)
Return


;==========================
;Emacs mode toggle
;==========================
+CapsLock::
	SetEmacsMode(!EmacsModeStat)
return

SetEmacsMode(toActive) {
	local iconFile := toActive ? enabledIcon : disabledIcon
	local state := toActive ? "ON" : "OFF"

  EmacsModeStatStored := EmacsModeStat
	EmacsModeStat := toActive
	;TrayTip, Emacs Everywhere, Emacs mode is %state%, 10, 1
	Menu, Tray, Icon, %iconFile%,
	Menu, Tray, Tip, Emacs Everywhere`nEmacs mode is %state%

	Send {Shift Up}
}

is_target() {
	if !WinActive("ahk_class Emacs") {
		return true
	} else {
		return false
	}
}

IsInEmacsMode() {
	global EmacsModeStat
	if (EmacsModeStat  && is_target()) {
		return true
	} else {
		return false
	}
}

iSChrome() {
  return WinActive("ahk_class Chrome_WidgetWin_0")
}

;==========================
;Action Functions
;==========================
delete_char() {
	Send {Del}
	global is_pre_spc = 0
	Return
}

delete_backward_char() {
	Send {BS}
	global is_pre_spc = 0
	Return
}

delete_word() {
  ; [Shift]+[del] to delete word (chars up to and including the first space to the right)
  ;$+Del::Send, {blind}^{Right}{BS}
  Send ^{Del}
	global is_pre_spc = 0
	Return
}

delete_backward_word() {
  ; [Shift]+[backspace] to delete word (chars up to the first space to the left)
  ;$+BS::Send, {blind}^{Left}{BS} ; [ctrl]+[shift]+[left/right] = select chars up to space ('right' includes the space, 'left' doesn't)
  Send +{BS}
	global is_pre_spc = 0
	Return
}

kill_line() {
	Send {ShiftDown}{END}{SHIFTUP}
	Sleep 10 ;[ms]
	Send ^x
	;if (RegExMatch(clipboard, "aa") > 0)
	;{
	;	Send ^o
	;}


	global is_pre_spc = 0
	Return
}

open_line() {
	Send {END}{Enter}{Up}
	global is_pre_spc = 0
	Return
}

quit() {
	Send {ESC}
	global is_pre_spc = 0
	Return
}

newline() {
	Send {Enter}
	global is_pre_spc = 0
	Return
}

indent_for_tab_command() {
	Send {Tab}
	global is_pre_spc = 0
	Return
}

newline_and_indent() {
	Send {Enter}{Tab}
	global is_pre_spc = 0
	Return
}

isearch_forward() {
	Send ^f
	global is_pre_spc = 0
	Return
}

isearch_backward() {
	Send ^f
	global is_pre_spc = 0
	Return
}

kill_region() {
	Send ^x
	global is_pre_spc = 0
	Return
}

kill_ring_save() {
	Send ^c
	global is_pre_spc = 0
	Return
}

yank() {
	Send ^v
	global is_pre_spc = 0
	Return
}

undo() {
	Send ^z
	global is_pre_spc = 0
	Return
}

find_file() {
	Send ^o
	global is_pre_x = 0
	Return
}

save_buffer() {
	Send, ^s
	global is_pre_x = 0
	Return
}

kill_emacs() {
	Send !{F4}
	global is_pre_x = 0
	Return
}

move_beginning_of_line() {
	global
	if is_pre_spc
		Send +{HOME}
	Else
		Send {HOME}
	Return
}

move_end_of_line() {
	global
	if is_pre_spc
		Send +{END}
	Else
		Send {END}
	Return
}

previous_line() {
	global
	if is_pre_spc
		Send +{Up}
	Else
		Send {Up}
	Return
}

next_line() {
	global
	if is_pre_spc
		Send +{Down}
	Else
		Send {Down}
	Return
}

backward_char() {
	global
	if is_pre_spc
		Send +{Left}
	Else
		Send {Left}
	Return
}

backward_word() {
	global
	if is_pre_spc
		Send +^{Left}
	Else
		Send ^{Left}
	Return
}

forward_word() {
	global
	if is_pre_spc
		Send +^{Right}
	Else
		Send ^{Right}
	Return
}

scroll_up() {
	global
	if is_pre_spc
		Send +{PgUp}
	Else
		Send {PgUp}
	Return
}

scroll_down() {
        global
	if is_pre_spc
		Send +{PgDn}
	Else
		Send {PgDn}
	Return
}

fallbackToDefault() {
  Send %A_ThisHotkey%
}

;==========================
;Keybindings
;==========================
#IfWinActive ahk_class Emacs 
{ 
  Capslock::Ctrl 
  RCtrl::Capslock 
} 
#IfWinNotActive ahk_group VC

^x::
  If IsInEmacsMode()
    is_pre_x = 1
  Else
    fallbackToDefault()
  Return

h::
  If (IsInEmacsMode() && is_pre_x) {
    send ^a
    is_pre_x = 0
  }
  Else
    fallbackToDefault()
  Return

^f::
  If IsInEmacsMode() {
    If is_pre_x {
      Send ^o
      is_pre_x = 0
    } Else {
      if is_pre_spc
        Send +{Right}
      Else
        Send {Right}
    }
  } Else
    Send %A_ThisHotkey%
  Return

^c::
	If IsInEmacsMode()
	{
		If is_pre_x
		kill_emacs()
	}
	Else
		Send %A_ThisHotkey%
	Return
^d::
	If IsInEmacsMode()
		delete_char()
	Else
		Send %A_ThisHotkey%
	Return
^h::
	If IsInEmacsMode()
		delete_backward_char()
	Else
		Send %A_ThisHotkey%
	Return
^k::
	If IsInEmacsMode()
		kill_line()
	Else
		Send %A_ThisHotkey%
	Return
^o::
	If IsInEmacsMode()
		open_line()
	Else
		Send %A_ThisHotkey%
	Return
^g::
	If IsInEmacsMode()
		quit()
	Else
		Send %A_ThisHotkey%
	Return
^j::
	If IsInEmacsMode()
		newline_and_indent()
	Else
		Send %A_ThisHotkey%
	Return
^m::
	If IsInEmacsMode()
		newline()
	Else
		Send %A_ThisHotkey%
	Return
^i::
	If IsInEmacsMode()
		indent_for_tab_command()
	Else
		Send %A_ThisHotkey%
	Return
^s::
	If IsInEmacsMode()
	{
		If is_pre_x
			save_buffer()
		Else
			isearch_forward()
	}
	Else
		Send %A_ThisHotkey%
	Return
^r::
	If IsInEmacsMode()
		isearch_backward()
	Else
		Send %A_ThisHotkey%
	Return
^w::
	If IsInEmacsMode() and !isChrome()
		kill_region()
	Else
		Send %A_ThisHotkey%
	Return
!w::
	If IsInEmacsMode() and !Is
		kill_ring_save()
	Else
		Send %A_ThisHotkey%
	Return
^y::
	If IsInEmacsMode()
		yank()
	Else
		Send %A_ThisHotkey%
	Return
^/::
	If IsInEmacsMode()
		undo()
	Else
		Send %A_ThisHotkey%
	Return

;$^{Space}::
^vk20sc039::
	If IsInEmacsMode()
	{
		If is_pre_spc
			is_pre_spc = 0
		Else
			is_pre_spc = 1
	}
	Else
		Send {CtrlDown}{Space}{CtrlUp}
	Return
^@::
	If IsInEmacsMode()
	{
		If is_pre_spc
			is_pre_spc = 0
		Else
			is_pre_spc = 1
	}
	Else
		Send %A_ThisHotkey%
	Return

!f::
	If IsInEmacsMode()
		forward_word()
	Else
		Send %A_ThisHotkey%
	Return
!b::
	If IsInEmacsMode()
		backward_word()
	Else
		Send %A_ThisHotkey%
	Return
!d::
	If IsInEmacsMode()
		delete_word()
	Else
		Send %A_ThisHotkey%
	Return
;!Backspace::
;	If IsInEmacsMode()
;		delete_backward_word()
;	Else
;		Send %A_ThisHotkey%
;	Return
^b::
	If IsInEmacsMode()
		backward_char()
	Else
		Send %A_ThisHotkey%
	Return
^v::
	If IsInEmacsMode()
		scroll_down()
	Else
		Send %A_ThisHotkey%
	Return
!v::
	If IsInEmacsMode()
		scroll_up()
	Else
		Send %A_ThisHotkey%
	Return
#k::
	MsgBox, 4,, スクリプトを終了しますか?,
	IfMsgBox, Yes
		ExitApp
	Return
	^a::
	If IsInEmacsMode()
		move_beginning_of_line()
	Else
		Send %A_ThisHotkey%
	Return
^e::
	If IsInEmacsMode()
		move_end_of_line()
	Else
		Send %A_ThisHotkey%
	Return
#IfWinActive

^p::
	If IsInEmacsMode()
		previous_line()
	Else
		Send %A_ThisHotkey%
	Return
^n::
	If IsInEmacsMode()
		next_line()
	Else
		Send %A_ThisHotkey%
	Return
