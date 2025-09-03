#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode "Input"

; ==============================
; Convert Language Tool (อังกฤษ ↔ ไทย)
; Default Hotkey: Ctrl+Shift+T
; ==============================

global configPath := A_AppData "\ConvertLang\config.ini"

; สร้างโฟลเดอร์ถ้าไม่มี
if !DirExist(A_AppData "\ConvertLang")
    DirCreate(A_AppData "\ConvertLang")
global HotkeyLang := "^+t"
global eng_to_th := Map()
global th_to_eng := Map()

; โหลดค่า Config และ Mapping
LoadConfig()
InitMapping()

; ------------------------------
; Tray Menu
; ------------------------------
A_TrayMenu.Delete()
A_TrayMenu.Add("Edit Hotkey", EditConfig)
A_TrayMenu.Add("Reload Script", (*) => Reload())
A_TrayMenu.Add()
A_TrayMenu.Add("Exit", (*) => ExitApp())
TraySetIcon(A_ScriptDir "\convertLang.ico")
TrayTip("ConvertLang", "Hotkey: " HotkeyLang)

; ------------------------------
; Register Hotkey
; ------------------------------
Hotkey(HotkeyLang, ConvertLang)

; ------------------------------
; ฟังก์ชัน
; ------------------------------

LoadConfig() {
    global HotkeyLang, configPath

    ; ถ้าไม่มีไฟล์ ให้สร้างใหม่
    if !FileExist(configPath) {
        IniWrite("^+t", configPath, "Hotkeys", "ToggleLang")
    }

    try {
        HotkeyLang := IniRead(configPath, "Hotkeys", "ToggleLang", "^+t")
    } catch {
        HotkeyLang := "^+t"
    }
}

EditConfig(*) {
    global HotkeyLang, configPath

    hint := "Enter Hotkey in AHK format, e.g. `^+t` = Ctrl+Shift+T, `#h` = Win+H"
    newHotkey := InputBox(
        "Current Hotkey is: " HotkeyLang "`n" hint,
        "Edit Hotkey"
    )

    if newHotkey.Result = "Cancel"
        return

    if (newHotkey.Value != "") {
        Hotkey(HotkeyLang, "")  ; ลบ hotkey เก่า
        Hotkey(newHotkey.Value, ConvertLang) ; ลงทะเบียน hotkey ใหม่
        HotkeyLang := newHotkey.Value
        IniWrite(newHotkey.Value, configPath, "Hotkeys", "ToggleLang")
        MsgBox("Hotkey updated to " newHotkey.Value, "Config Updated", "64")
    }
}

InitMapping() {
    global eng_to_th, th_to_eng

    eng_to_th := Map()
    ; --- ตัวเลข / สัญลักษณ์ ---
    eng_to_th["1"] := "ๅ"
    eng_to_th["2"] := "/"
    eng_to_th["3"] := "-"
    eng_to_th["4"] := "ภ"
    eng_to_th["5"] := "ถ"
    eng_to_th["6"] := "ุ"
    eng_to_th["7"] := "ึ"
    eng_to_th["8"] := "ค"
    eng_to_th["9"] := "ต"
    eng_to_th["0"] := "จ"
    eng_to_th["-"] := "ข"
    eng_to_th["="] := "ช"
    eng_to_th["!"] := "+"
    eng_to_th["@"] := "๑"
    eng_to_th["#"] := "๒"
    eng_to_th["$"] := "๓"
    eng_to_th["%"] := "๔"
    eng_to_th["^"] := "ู"
    eng_to_th["&"] := "฿"
    eng_to_th["*"] := "๕"
    eng_to_th["("] := "๖"
    eng_to_th[")"] := "๗"
    eng_to_th["_"] := "๘"
    eng_to_th["+"] := "๙"

    ; --- ตัวอักษรเล็ก ---
    eng_to_th["q"] := "ๆ"
    eng_to_th["w"] := "ไ"
    eng_to_th["e"] := "ำ"
    eng_to_th["r"] := "พ"
    eng_to_th["t"] := "ะ"
    eng_to_th["y"] := "ั"
    eng_to_th["u"] := "ี"
    eng_to_th["i"] := "ร"
    eng_to_th["o"] := "น"
    eng_to_th["p"] := "ย"
    eng_to_th["a"] := "ฟ"
    eng_to_th["s"] := "ห"
    eng_to_th["d"] := "ก"
    eng_to_th["f"] := "ด"
    eng_to_th["g"] := "เ"
    eng_to_th["h"] := "้"
    eng_to_th["j"] := "่"
    eng_to_th["k"] := "า"
    eng_to_th["l"] := "ส"
    eng_to_th[";"] := "ว"
    eng_to_th["'"] := "ง"
    eng_to_th["z"] := "ผ"
    eng_to_th["x"] := "ป"
    eng_to_th["c"] := "แ"
    eng_to_th["v"] := "อ"
    eng_to_th["b"] := "ิ"
    eng_to_th["n"] := "ท"
    eng_to_th["m"] := "ท"
    eng_to_th[","] := "ม"
    eng_to_th["."] := "ใ"
    eng_to_th["/"] := "ฝ"

    ; --- ตัวอักษรใหญ่ (Shift) ---
    eng_to_th["Q"] := "๐"
    eng_to_th["W"] := '"'
    eng_to_th["E"] := "ฎ"
    eng_to_th["R"] := "ฑ"
    eng_to_th["T"] := "ธ"
    eng_to_th["Y"] := "ํ"
    eng_to_th["U"] := "๊"
    eng_to_th["I"] := "ณ"
    eng_to_th["O"] := "ฯ"
    eng_to_th["P"] := "ญ"
    eng_to_th["A"] := "ฤ"
    eng_to_th["S"] := "ฆ"
    eng_to_th["D"] := "ฏ"
    eng_to_th["F"] := "โ"
    eng_to_th["G"] := "ฌ"
    eng_to_th["H"] := "็"
    eng_to_th["J"] := "๋"
    eng_to_th["K"] := "ษ"
    eng_to_th["L"] := "ศ"
    eng_to_th[":"] := "ซ"
    eng_to_th['"'] := "."
    eng_to_th["Z"] := "("
    eng_to_th["X"] := ")"
    eng_to_th["C"] := "ฉ"
    eng_to_th["V"] := "ฮ"
    eng_to_th["B"] := "ฺ"
    eng_to_th["N"] := "์"
    eng_to_th["M"] := "?"
    eng_to_th["<"] := "ฒ"
    eng_to_th[">"] := "ฬ"
    eng_to_th["?"] := "ฦ"
    eng_to_th[Chr(96)] := "_"
    eng_to_th["~"] := "%"
    eng_to_th["\\"] := "ฃ"
    eng_to_th["|"] := "ฅ"

    ; =========================
    ; ไทย → อังกฤษ (reverse)
    ; =========================
    th_to_eng := Map()
    for key, val in eng_to_th
        th_to_eng[val] := key
}

ConvertLang(*) {
    global eng_to_th, th_to_eng

    Send("^c")
    Sleep(100)
    ClipWait(1)

    text := A_Clipboard
    if (text = "")
        return

    ; ตรวจสอบว่ามีตัวไทยหรือไม่
    isThai := false
    for char in StrSplit(text) {
        if th_to_eng.Has(char) {
            isThai := true
            break
        }
    }

    ; แปลงข้อความ
    converted := ""
    for char in StrSplit(text) {
        if isThai
            converted .= th_to_eng.Has(char) ? th_to_eng[char] : char
        else
            converted .= eng_to_th.Has(char) ? eng_to_th[char] : char
    }

    A_Clipboard := converted
    Sleep(50)
    Send("^v")
}
