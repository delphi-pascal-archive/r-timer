object Form2: TForm2
  Left = 0
  Top = 0
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'Form2'
  ClientHeight = 93
  ClientWidth = 942
  Color = clRed
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesigned
  OnClick = FormClick
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 942
    Height = 81
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -64
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Transparent = False
    Layout = tlCenter
    OnClick = Label1Click
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 552
    Top = 16
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer2Timer
    Left = 600
    Top = 16
  end
end
