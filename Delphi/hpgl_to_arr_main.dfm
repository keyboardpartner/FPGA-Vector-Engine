object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'VectorEngine HPGL Logo Converter 1.1'
  ClientHeight = 727
  ClientWidth = 1630
  Color = clBtnFace
  Constraints.MinHeight = 766
  Constraints.MinWidth = 1210
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  DesignSize = (
    1630
    727)
  PixelsPerInch = 96
  TextHeight = 13
  object DrawingBox: TPaintBox
    Left = 8
    Top = 8
    Width = 512
    Height = 512
    Cursor = crSizeAll
    Color = 16384
    DragCursor = crCross
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    OnMouseDown = DrawingBoxMouseDown
    OnMouseMove = DrawingBoxMouseMove
    OnMouseUp = DrawingBoxMouseUp
  end
  object LabelMax: TLabel
    Left = 134
    Top = 626
    Width = 24
    Height = 13
    Caption = 'Max:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object LabelMin: TLabel
    Left = 134
    Top = 610
    Width = 23
    Height = 13
    Caption = 'Min: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object LabelVectorsWritten: TLabel
    Left = 8
    Top = 610
    Width = 59
    Height = 13
    Caption = 'Vectors: 0 '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object PaintBox1: TPaintBox
    Left = 1461
    Top = 569
    Width = 32
    Height = 32
  end
  object Memo1: TMemo
    Left = 863
    Top = 448
    Width = 322
    Height = 270
    Anchors = [akLeft, akBottom]
    Lines.Strings = (
      'HPGL Logo Converter'
      ''
      'Grafik als "HP Graphic Language"-Datei (HPGL) speichern und '
      'dann mit "Open HPGL File" '#246'ffnen. Getestet mit Inkscape und '
      'CorelDraw. Nicht mehr als 2047 Vektoren!'
      ''
      'Die Bitmap-Darstellung umfasst den Wertebereich Int8, -'
      '128..127 bzw. Integer -2048..2047. Zeichnung wird '
      'automatisch skaliert, ggf. Scale  so anpassen, dass die Grafik '
      'vollst'#228'ndig in die Darstellung passt.'
      ''
      'Linksklick auf Grafik: Verschieben'
      'Rechtsklick auf Grafik: Objekt ausw'#228'hlen'
      'Werte k'#246'nnen in Vectors-Tabelle direkt ge'#228'ndert werden '
      '(Beam, Scale etc).'
      ''
      'BEAM-Vektor enth'#228'lt als Y-Wert ggf.die Adresse des '
      'n'#228'chsten Initialisierungsblocks (noch nicht verwendet)'
      ''
      'Pascal-Array-Daten werden in Int8-Darstellung exportiert.'
      ''
      'TODO: '
      'Laden mehrerer unabh'#228'ngiger HPGL-Files '#252'ber Tabelle')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object ButtonOpenHPGL: TButton
    Left = 8
    Top = 526
    Width = 113
    Height = 25
    Caption = 'Open HPGL File'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = ButtonOpenHPGLClick
  end
  object SgBlocks: TStringGrid
    Tag = 3
    Left = 534
    Top = 25
    Width = 323
    Height = 694
    Hint = 
      'Left-click to find aperture, right-click to set reference point ' +
      'zero'
    Anchors = [akLeft, akTop, akBottom]
    ColCount = 6
    DefaultRowHeight = 18
    DrawingStyle = gdsClassic
    RowCount = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goEditing, goThumbTracking]
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
    OnDrawCell = SgBlocksDrawCell
    OnExit = SgBlocksExit
    OnKeyDown = SgBlocksKeyDown
    OnMouseDown = SgBlocksMouseDown
    OnSelectCell = SgBlocksSelectCell
    ColWidths = (
      36
      41
      56
      57
      53
      53)
    RowHeights = (
      18
      18)
  end
  object StaticText1: TStaticText
    Left = 8
    Top = 634
    Width = 44
    Height = 17
    Caption = 'Scaling'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object TrackBarScale: TTrackBar
    Left = 8
    Top = 654
    Width = 233
    Height = 33
    Max = 100
    Min = 1
    Frequency = 20
    Position = 50
    TabOrder = 4
    OnChange = TrackBarScaleChange
  end
  object ButtonExportArrayData: TButton
    Left = 127
    Top = 694
    Width = 114
    Height = 25
    Caption = 'Export Pascal Array'
    TabOrder = 5
    OnClick = ButtonExportArrayDataClick
  end
  object ButtonExportVectorFile: TButton
    Left = 8
    Top = 694
    Width = 113
    Height = 25
    Caption = 'Export Vector File'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = ButtonExportVectorFileClick
  end
  object StaticText3: TStaticText
    Left = 264
    Top = 571
    Width = 176
    Height = 17
    Caption = '#1 Beam Intensity (8..15), Default:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
  end
  object StaticText4: TStaticText
    Left = 264
    Top = 593
    Width = 203
    Height = 17
    Caption = '#2 Scale XY (1024=100%), #3 Offset XY'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
  end
  object StaticText5: TStaticText
    Left = 264
    Top = 637
    Width = 197
    Height = 17
    Caption = '#6 Deflection Speed (4095..1), Default:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
  end
  object StaticText6: TStaticText
    Left = 264
    Top = 615
    Width = 207
    Height = 17
    Caption = '#4 Rotation'#176',   #5 Object Rot Midpoint XY'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 10
  end
  object BtnSettings: TBitBtn
    Left = 1213
    Top = 626
    Width = 70
    Height = 25
    Caption = 'Open COM'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
    OnClick = BtnSettingsClick
  end
  object BtnSend: TBitBtn
    Left = 1289
    Top = 626
    Width = 104
    Height = 25
    Caption = 'Serial Send Vectors'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 12
    OnClick = BtnSendClick
  end
  object ButtonOpenVec: TButton
    Left = 127
    Top = 526
    Width = 114
    Height = 25
    Caption = 'Open VEC File'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 13
    OnClick = ButtonOpenVecClick
  end
  object SgPens: TStringGrid
    Tag = 3
    Left = 1213
    Top = 296
    Width = 146
    Height = 270
    Hint = 
      'Left-click to find aperture, right-click to set reference point ' +
      'zero'
    ColCount = 3
    DefaultRowHeight = 18
    DrawingStyle = gdsClassic
    RowCount = 11
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goEditing, goThumbTracking]
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 14
    OnDrawCell = SgPensDrawCell
    ColWidths = (
      36
      44
      42)
    RowHeights = (
      18
      18
      18
      18
      18
      18
      18
      18
      18
      18
      18)
  end
  object StaticText7: TStaticText
    Left = 1213
    Top = 278
    Width = 130
    Height = 17
    Caption = 'Pen/Beam Translation'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 15
  end
  object BtnReprocess: TBitBtn
    Left = 8
    Top = 575
    Width = 113
    Height = 25
    Caption = 'Reload HPGL'
    Enabled = False
    TabOrder = 16
    OnClick = BtnReprocessClick
  end
  object SgFiles: TStringGrid
    Tag = 3
    Left = 1213
    Top = 31
    Width = 180
    Height = 202
    Hint = 
      'Left-click to find aperture, right-click to set reference point ' +
      'zero'
    Anchors = [akLeft, akTop, akBottom]
    ColCount = 4
    DefaultRowHeight = 18
    DrawingStyle = gdsClassic
    RowCount = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goEditing, goThumbTracking]
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 17
    ColWidths = (
      36
      32
      32
      139)
    RowHeights = (
      18
      18)
  end
  object StaticText2: TStaticText
    Left = 1213
    Top = 8
    Width = 102
    Height = 17
    Caption = 'HPGL Files loaded'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 18
  end
  object SgObjects: TStringGrid
    Tag = 3
    Left = 863
    Top = 24
    Width = 322
    Height = 418
    Hint = 
      'Left-click to find aperture, right-click to set reference point ' +
      'zero'
    Anchors = [akLeft, akTop, akBottom]
    ColCount = 7
    DefaultRowHeight = 18
    DrawingStyle = gdsClassic
    RowCount = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goRowSelect, goThumbTracking]
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 19
    OnDrawCell = SgObjectsDrawCell
    OnMouseDown = SgObjectsMouseDown
    OnMouseMove = SgObjectsMouseMove
    OnSelectCell = SgObjectsSelectCell
    ColWidths = (
      36
      44
      44
      43
      42
      42
      40)
    RowHeights = (
      18
      18)
  end
  object StaticText8: TStaticText
    Left = 864
    Top = 6
    Width = 93
    Height = 17
    Caption = 'Graphic Objects'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 20
  end
  object StaticText9: TStaticText
    Left = 535
    Top = 6
    Width = 47
    Height = 17
    Caption = 'Vectors'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 21
  end
  object ProgressBar1: TProgressBar
    Left = 1215
    Top = 696
    Width = 178
    Height = 17
    TabOrder = 22
  end
  object CheckBoxUsePencolors: TCheckBox
    Left = 12
    Top = 553
    Width = 121
    Height = 20
    Caption = 'Use Pen (SP) Colors'
    TabOrder = 23
  end
  object StaticText10: TStaticText
    Left = 262
    Top = 526
    Width = 110
    Height = 17
    Caption = 'Vector Init Params'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 24
  end
  object StaticText11: TStaticText
    Left = 264
    Top = 549
    Width = 146
    Height = 17
    Caption = '#0 Skip (Object Start Marker)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 25
  end
  object CheckBoxReplaceSkip: TCheckBox
    Left = 1215
    Top = 600
    Width = 169
    Height = 20
    Caption = 'Replace Skip by NOP on Send'
    Checked = True
    State = cbChecked
    TabOrder = 26
  end
  object BtnSendReset: TBitBtn
    Left = 1213
    Top = 662
    Width = 70
    Height = 25
    Caption = 'Send Reset'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 27
    OnClick = BtnSendResetClick
  end
  object EditBeam: TEdit
    Left = 440
    Top = 568
    Width = 40
    Height = 21
    NumbersOnly = True
    TabOrder = 28
    Text = '12'
  end
  object EditSpeed: TEdit
    Left = 461
    Top = 635
    Width = 40
    Height = 21
    NumbersOnly = True
    TabOrder = 29
    Text = '8'
  end
  object BtnSendFPGA: TBitBtn
    Left = 1289
    Top = 662
    Width = 104
    Height = 25
    Caption = 'Send FPGA Bitfile'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 30
    OnClick = BtnSendFPGAClick
  end
  object BtnSendBitmap: TBitBtn
    Left = 1417
    Top = 662
    Width = 104
    Height = 25
    Caption = 'Send Bitmap'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 31
    OnClick = BtnSendBitmapClick
  end
  object ScrollBar1: TScrollBar
    Left = 1417
    Top = 626
    Width = 121
    Height = 17
    Max = 350
    PageSize = 0
    TabOrder = 32
    OnChange = ScrollBar1Change
  end
  object ScrollBar2: TScrollBar
    Left = 1417
    Top = 480
    Width = 17
    Height = 121
    Kind = sbVertical
    Max = 280
    PageSize = 0
    TabOrder = 33
    OnChange = ScrollBar2Change
  end
  object ComboBox1: TComboBox
    Left = 1417
    Top = 448
    Width = 73
    Height = 21
    AutoComplete = False
    AutoDropDown = True
    AutoCloseUp = True
    Color = clBtnFace
    ItemIndex = 0
    TabOrder = 34
    Text = 'Sprite 1'
    OnChange = ComboBox1Change
    Items.Strings = (
      'Sprite 1'
      'Sprite 2'
      'Sprite 3'
      'Sprite 4')
  end
  object ComboBox2: TComboBox
    Left = 1496
    Top = 448
    Width = 73
    Height = 21
    AutoComplete = False
    AutoDropDown = True
    AutoCloseUp = True
    Color = clBtnFace
    ItemIndex = 0
    TabOrder = 35
    Text = 'Vari 1'
    OnChange = ComboBox2Change
    Items.Strings = (
      'Vari 1'
      'Vari 2'
      'Vari 3'
      'Vari 4')
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.hpgl;*.plt'
    Filter = 
      'HPGL File|*.plt;*.hpgl|VECTOR File|*.vec|BIT File|*.bit|Bitmap F' +
      'ile|*.bmp'
    Left = 392
    Top = 391
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Vector File|*.VEC|Text File|*.TXT'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 408
    Top = 348
  end
  object ComPort1: TComPort
    BaudRate = br57600
    Port = 'COM1'
    Parity.Bits = prNone
    StopBits = sbOneStopBit
    DataBits = dbEight
    Events = [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR, evError, evRLSD, evRx80Full]
    FlowControl.OutCTSFlow = False
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrDisable
    FlowControl.ControlRTS = rtsDisable
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    Left = 447
    Top = 152
  end
  object Timer1: TTimer
    Interval = 50
    OnTimer = Timer1Timer
    Left = 444
    Top = 248
  end
  object PopupMenu1: TPopupMenu
    Left = 664
    Top = 144
    object FindNextMove1: TMenuItem
      AutoHotkeys = maAutomatic
      Bitmap.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000120B0000120B00000000000000000000FF00FF4A667C
        BE9596FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FF6B9CC31E89E84B7AA3C89693FF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF4BB4FE51B5FF
        2089E94B7AA2C69592FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FF51B7FE51B3FF1D87E64E7AA0CA9792FF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        51B7FE4EB2FF1F89E64E7BA2B99497FF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF52B8FE4BB1FF2787D95F6A76FF
        00FFB0857FC09F94C09F96BC988EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FF55BDFFB5D6EDBF9D92BB9B8CE7DAC2FFFFE3FFFFE5FDFADAD8C3
        B3B58D85FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFCEA795FD
        EEBEFFFFD8FFFFDAFFFFDBFFFFE6FFFFFBEADDDCAE837FFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFC1A091FBDCA8FEF7D0FFFFDBFFFFE3FFFFF8FFFF
        FDFFFFFDC6A99CFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC1A091FEE3ACF1
        C491FCF2CAFFFFDDFFFFE4FFFFF7FFFFF7FFFFE9EEE5CBB9948CFF00FFFF00FF
        FF00FFFF00FFFF00FFC2A191FFE6AEEEB581F7DCAEFEFDD8FFFFDFFFFFE3FFFF
        E4FFFFE0F3ECD2BB968EFF00FFFF00FFFF00FFFF00FFFF00FFBC978CFBE7B7F4
        C791F2C994F8E5B9FEFCD8FFFFDDFFFFDCFFFFE0E2D2BAB68E86FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFD9C3A9FFFEE5F7DCB8F2C994F5D4A5FAE8BDFDF4
        C9FDFBD6B69089FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB58D85E8
        DEDDFFFEF2F9D8A3F4C48CF9D49FFDEAB8D0B49FB89086FF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFAD827FC9AA9EEFE0B7EFDFB2E7CEACB890
        86B89086FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFBA968ABB988CB79188FF00FFFF00FFFF00FFFF00FF}
      Caption = 'Find Next Object'
      ShortCut = 114
      OnClick = FindNextMove1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object InsertBlankRow1: TMenuItem
      Caption = 'Insert Blank Row'
      OnClick = InsertBlankRow1Click
    end
    object InsertRowSpeed1: TMenuItem
      Caption = 'Insert Row "Speed" '
      OnClick = InsertRowSpeed1Click
    end
    object PopupInsertRow: TMenuItem
      Bitmap.Data = {
        36050000424D3605000000000000360400002800000010000000100000000100
        0800000000000001000000000000000000000001000000010000FE00FE00FE00
        FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
        FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
        FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
        FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
        FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
        FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FD00FD00FB00
        FB00F901F900F602F600F203F200EB05EB00E207E200D60BD600C410C400AC17
        AC0092209200712A7100533453003D3D3D003E3E3E003F3F3F00404040004141
        410042424200434343004444440045454500464646004747470048484800464A
        4E00444C5500424F5C00405162003E5368003C556D003A56720036587A00335A
        8100305C88002C5D8F00285E950024609B002264A5002066AB00236AAF002770
        B4002B76BB00317DC1003985C8003B87C9003D88CA003D89CD003D8ACE00418E
        D2004391D6004393D8004391D600418ED2003D8ACE003D89CD003D88CA003C87
        C9003985C8003480C3002E79BE002D76B9002D72B3002D6EAD002E6AA5002F66
        9D0034679B00386898003D699500446B92004B6D8F00536F8B00587189005D72
        8700637485006976830070798100777B7F007E7E7E007F7F7F00808080008181
        8100828282008383830084848400858585008686860087878700888888008989
        89008A8A8A008B8B8B008C8C8C008D8D8D008E8E8E008F8F8F00909090009191
        9100929292009393930094949400959595009696960097979700989898009999
        99009A9A9A009B9B9B009C9C9C009D9D9D009E9E9E009F9F9F00A0A0A000A1A1
        A100A2A2A200A3A3A300A4A4A400A5A5A500A6A6A600A7A7A700A8A8A800A9A9
        A900AAAAAA00ABABAB00ACACAC00ADADAD00AEAEAE00AFAFAF00AFB3B400B1B1
        B100B2B2B200B3B3B300B4B4B400B5B5B500B6B6B600B7B7B700B8B8B800B9B9
        B900BABABA00BBBBBB00BCBCBC00BDBDBD00BEBEBE00BFBFBF00C0C0C000C1C1
        C100C2C2C200C3C3C300C4C4C400C5C5C500C6C6C600BEC6C000B7C7BB00B0C7
        B600A9C8B400A5C8AE00A1C8AB009DC8A80092C79F0084C4930074C1860068BF
        7C005DBC720050B9670044B65D003EB2560039B0510034AE4C0030AB47002CA8
        420029A63F0025A43A0021A034001E9E2F001A9A2A0017972600159323001591
        2200158F2100148C2100158A2100158720001585200015832000158320001583
        20001583200015832000158320001583200014831F0014831F0014821F001482
        1F0013811E00127F1C00107C19000E7A16000B75110007700B00046C06000269
        0400016702000067010000660000006600000067000000670000191919191919
        19191919191919191919ECECECECECECECECECECECEC19191919ECECECECECEC
        ECECECECECEC1919191919191919191919191919191919191919191957191919
        19FCFCFCFCFCFC19191919195757191919FCD4D8DDE0FC191919575763635719
        19FCFCFCFCFCFC19191957CACE63635719191919191919191919575763D05719
        19FCFCFCFCFCFCFCFCFC19195757191919FCD3D4D4D6DADDDFF7191957191919
        19FCFCFCFCFCFCFCFCFC19191919191919191919191919191919ECECECECECEC
        ECECECECECEC19191919ECECECECECECECECECECECEC19191919191919191919
        1919191919191919191919191919191919191919191919191919}
      Caption = 'Insert Row "Beam"'
      OnClick = PopupInsertRowBeamClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object PopupDeleteRow: TMenuItem
      Bitmap.Data = {
        36050000424D3605000000000000360400002800000010000000100000000100
        0800000000000001000000000000000000000001000000010000000000000101
        0100020202000303030004040400050505000606060007070700080808000909
        09000A0A0A000B0B0B000C0C0C000D0D0D000E0E0E000F0F0F00101010001111
        1100121212001313130014141400151515001616160017171700181818001919
        19001A1A1A001B1B1B001C1C1C001D1D1D001E1E1E001F1F1F00202020001F25
        1F001D2A1D001C2E1C001B331B001A371A00183D18001542150013471300114B
        11000F500F000D540D000A570A00095A0900075D0700065E0600046004000461
        040003620300046104000461040005600500065F0600085E08000A5D0A000C5B
        0C000F5A0F0012581200155615001A541A001E521E0023502300284D28002F4B
        2F00334A3300374937003B483B00404740004646460047474700484848004949
        49004A4A4A004B4B4B004C4C4C004D4D4D004E4E4E004F4F4F00505050005151
        5100525252005353530054545400555555005656560057575700585858005959
        59005A5A5A005B5B5B005C5C5C005D5D5D005E5E5E005F5F5F00606060006161
        6100626262006363630064646400656565006666660067676700686868006969
        69006A6A6A006B6B6B006C6C6C006D6D6D006E6E6E006F6F6F00707070007171
        7100727272007373730074747400757575007676760077777700787878007979
        79007A7A7A007B7B7B007C7C7C007D7D7D007E7E7E007F7F7F00808080008181
        8100828282008383830084848400858585008686860087878700888888008989
        89008A8A8A008B8B8B008C8C8C008D8D8D008E8E8E008F8F8F00909090009191
        9100929292009393930094949400959595009696960097979700989898009999
        99009A9A9A009B9B9B009C9C9C009D9D9D009E9E9E009F9F9F00A0A0A000A1A1
        A100A2A2A200A3A3A300A4A4A400A5A5A500A6A6A600A7A7A700A8A8A800A9A9
        A900AAAAAA00ABABAB00B1B0B000BFBDBC00CECCCA00DEDCD900EBE9E600F5F2
        EF00FAF7F400FDFAF600FDFBF800FEFBF800FEFCF900FEFCF900FEFCF900FEFB
        F800FEFAF600FEF9F300FEF8F000FEF7EE00FEF6ED00FEF6EB00FEF5EA00FEF4
        E800FEF3E600FEF2E400FEF1E100FEF0DF00FEEEDC00FEEDDA00FEECD800FEEC
        D700FEECD600FEEBD400FEEAD300FDE9D100FDE8CF00FDE7CD00FCE6CB00FAE0
        C300F7D8B600F1C99E00E7AF7500DE985100D5812D00D0761B00CE6E0F00CC69
        0700CB670300CA660200C9640200C7630100C6610100C25D0000BD580000B852
        0000B04A0000A8420000A23C00009F3900009D3700009B3500009A3400009B34
        02009E330900A3301500AC2B2C00B9244E00C81C7400D9139F00E80BC600F803
        ED00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
        FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00F8F8F8F8F8F8
        F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8DADADADADADA
        DADADAF8F8F8F8F8F8F8B7B9BCC1C4C7CCCFDAF8F8F8F8F8F8F8B7B6BBBEC3C6
        CBCFDAF8F8F8F8F8F8F8B7B7BABDC2C5C9CDDAF8F8F8F8F8F8F8E8E8E8E8E8E8
        E8E8E8E8E8DAF832F8F8B7B6BABCC0C3C5C8CCCFD0DAF83232F8B7B7BABBBEC2
        C4C7CBCED0DAF8329A32B7B7B9BBBDC1C4C6CBCDCFDAF83232F8E8E8E8E8E8E8
        E8E8E8E8E8DAF832F8F8B7B7BABDC3C6CBCFDAF8F8F8F8F8F8F8B7B7B9BCC1C5
        C9CEDAF8F8F8F8F8F8F8B7B7B7BABEC3C7CBDAF8F8F8F8F8F8F8DADADADADADA
        DADADAF8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8F8}
      Caption = 'Delete Row'
      OnClick = PopupDeleteRowClick
    end
    object ClearTable1: TMenuItem
      Bitmap.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FF0732DE0732DEFF00FF0732DE0732DEFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FF0732DE0732DEFF00FFFF00FF0732DE
        0732DE0732DEFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0732
        DE0732DEFF00FFFF00FFFF00FF0732DE0732DD0732DE0732DEFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FF0732DE0732DEFF00FFFF00FFFF00FFFF00FFFF00FF
        0534ED0732DF0732DE0732DEFF00FFFF00FFFF00FFFF00FF0732DE0732DEFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0732DE0732DE0732DDFF
        00FF0732DD0732DE0732DEFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF0732DD0633E60633E60633E90732DCFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0633E307
        32E30534EFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FF0732DD0534ED0533E90434EF0434F5FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0434F40534EF0533EBFF
        00FFFF00FF0434F40335F8FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FF0335FC0534EF0434F8FF00FFFF00FFFF00FFFF00FF0335FC0335FBFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FF0335FB0335FB0335FCFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FF0335FB0335FBFF00FFFF00FFFF00FFFF00FF0335FB
        0335FB0335FBFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FF0335FBFF00FFFF00FF0335FB0335FB0335FBFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0335FB0335FB
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      Caption = 'Clear Table'
      OnClick = BtnClearTableClick
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 1016
    Top = 136
    object SelectObject1: TMenuItem
      Bitmap.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000120B0000120B00000000000000000000FF00FF4A667C
        BE9596FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FF6B9CC31E89E84B7AA3C89693FF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF4BB4FE51B5FF
        2089E94B7AA2C69592FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FF51B7FE51B3FF1D87E64E7AA0CA9792FF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        51B7FE4EB2FF1F89E64E7BA2B99497FF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF52B8FE4BB1FF2787D95F6A76FF
        00FFB0857FC09F94C09F96BC988EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FF55BDFFB5D6EDBF9D92BB9B8CE7DAC2FFFFE3FFFFE5FDFADAD8C3
        B3B58D85FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFCEA795FD
        EEBEFFFFD8FFFFDAFFFFDBFFFFE6FFFFFBEADDDCAE837FFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFC1A091FBDCA8FEF7D0FFFFDBFFFFE3FFFFF8FFFF
        FDFFFFFDC6A99CFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC1A091FEE3ACF1
        C491FCF2CAFFFFDDFFFFE4FFFFF7FFFFF7FFFFE9EEE5CBB9948CFF00FFFF00FF
        FF00FFFF00FFFF00FFC2A191FFE6AEEEB581F7DCAEFEFDD8FFFFDFFFFFE3FFFF
        E4FFFFE0F3ECD2BB968EFF00FFFF00FFFF00FFFF00FFFF00FFBC978CFBE7B7F4
        C791F2C994F8E5B9FEFCD8FFFFDDFFFFDCFFFFE0E2D2BAB68E86FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFD9C3A9FFFEE5F7DCB8F2C994F5D4A5FAE8BDFDF4
        C9FDFBD6B69089FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB58D85E8
        DEDDFFFEF2F9D8A3F4C48CF9D49FFDEAB8D0B49FB89086FF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFAD827FC9AA9EEFE0B7EFDFB2E7CEACB890
        86B89086FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFBA968ABB988CB79188FF00FFFF00FFFF00FFFF00FF}
      Caption = 'Show Object in Vector Table'
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object InsertRowBeamforallObjects2: TMenuItem
      Caption = 'Insert Row "Beam" for selected Object(s)'
      OnClick = InsertRowBeamforallSelectedClick
    end
    object MenuItem8: TMenuItem
      Bitmap.Data = {
        36050000424D3605000000000000360400002800000010000000100000000100
        0800000000000001000000000000000000000001000000010000FE00FE00FE00
        FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
        FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
        FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
        FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
        FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00
        FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FE00FD00FD00FB00
        FB00F901F900F602F600F203F200EB05EB00E207E200D60BD600C410C400AC17
        AC0092209200712A7100533453003D3D3D003E3E3E003F3F3F00404040004141
        410042424200434343004444440045454500464646004747470048484800464A
        4E00444C5500424F5C00405162003E5368003C556D003A56720036587A00335A
        8100305C88002C5D8F00285E950024609B002264A5002066AB00236AAF002770
        B4002B76BB00317DC1003985C8003B87C9003D88CA003D89CD003D8ACE00418E
        D2004391D6004393D8004391D600418ED2003D8ACE003D89CD003D88CA003C87
        C9003985C8003480C3002E79BE002D76B9002D72B3002D6EAD002E6AA5002F66
        9D0034679B00386898003D699500446B92004B6D8F00536F8B00587189005D72
        8700637485006976830070798100777B7F007E7E7E007F7F7F00808080008181
        8100828282008383830084848400858585008686860087878700888888008989
        89008A8A8A008B8B8B008C8C8C008D8D8D008E8E8E008F8F8F00909090009191
        9100929292009393930094949400959595009696960097979700989898009999
        99009A9A9A009B9B9B009C9C9C009D9D9D009E9E9E009F9F9F00A0A0A000A1A1
        A100A2A2A200A3A3A300A4A4A400A5A5A500A6A6A600A7A7A700A8A8A800A9A9
        A900AAAAAA00ABABAB00ACACAC00ADADAD00AEAEAE00AFAFAF00AFB3B400B1B1
        B100B2B2B200B3B3B300B4B4B400B5B5B500B6B6B600B7B7B700B8B8B800B9B9
        B900BABABA00BBBBBB00BCBCBC00BDBDBD00BEBEBE00BFBFBF00C0C0C000C1C1
        C100C2C2C200C3C3C300C4C4C400C5C5C500C6C6C600BEC6C000B7C7BB00B0C7
        B600A9C8B400A5C8AE00A1C8AB009DC8A80092C79F0084C4930074C1860068BF
        7C005DBC720050B9670044B65D003EB2560039B0510034AE4C0030AB47002CA8
        420029A63F0025A43A0021A034001E9E2F001A9A2A0017972600159323001591
        2200158F2100148C2100158A2100158720001585200015832000158320001583
        20001583200015832000158320001583200014831F0014831F0014821F001482
        1F0013811E00127F1C00107C19000E7A16000B75110007700B00046C06000269
        0400016702000067010000660000006600000067000000670000191919191919
        19191919191919191919ECECECECECECECECECECECEC19191919ECECECECECEC
        ECECECECECEC1919191919191919191919191919191919191919191957191919
        19FCFCFCFCFCFC19191919195757191919FCD4D8DDE0FC191919575763635719
        19FCFCFCFCFCFC19191957CACE63635719191919191919191919575763D05719
        19FCFCFCFCFCFCFCFCFC19195757191919FCD3D4D4D6DADDDFF7191957191919
        19FCFCFCFCFCFCFCFCFC19191919191919191919191919191919ECECECECECEC
        ECECECECECEC19191919ECECECECECECECECECECECEC19191919191919191919
        1919191919191919191919191919191919191919191919191919}
      Caption = 'Insert Vector Inits for selected Object(s)'
      OnClick = BtnAddInitToSelectedClick
    end
    object ApplyBeamandSpeedValuestoselectedObjects1: TMenuItem
      Caption = 'Apply "Beam" and "Speed" Values to selected Object(s)'
      OnClick = BtnApplyToAllClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object DeleteInitRowsforthisObject2: TMenuItem
      Bitmap.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFA54208A74407A23F08FF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA23F08A54208A2
        3F08A54208FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFA74407FF00FFFF00FFA23F08A23F08FF00FFA23F08A744
        07FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA74407FF00FFFF
        00FFA23F08FF00FFA23F08A23F08A23F08A54208FF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFA54208A23F08A23F08A23F08FF00FFA23F08FF00FFFF00
        FFA64307FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA23F08A7
        4407A54208A23F08A54208FF00FFFF00FFA23F08FF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FF9E410DA14E22A23F08A74407A54208A542
        08A23F08FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF95
        7D758D766CA55E39A23F08A23F08A23F08FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FF8E7C72AC928E8E7C728E7C72FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF8E7C72D3BDBD8E
        7C72AD938F8E7C72FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FF8E7C72E9DEDE8E7C72A9958FD2BABA8E7C72FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF8E7C72FCFAFA8E7C72FF00FF8E
        7C72DFCECE8E7C72FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FF8E7C728E7C72FF00FFFF00FF8E7C72ECE2E28E7C72FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF8E7C72FF00FFFF00FFFF00FF8E
        7C72F9F5F58E7C72FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FF8E7C728E7C72FF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF8E
        7C72FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      Caption = 'Delete Init Rows for selected Object(s)'
      OnClick = DeleteInitRowsforSelectedClick
    end
  end
end
