object FormuOSCR: TFormuOSCR
  Left = 290
  Top = 129
  Caption = 'FormuOSCR NEW DLL'
  ClientHeight = 517
  ClientWidth = 1155
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 13
  object img1: TImage
    Left = 0
    Top = 121
    Width = 289
    Height = 212
    Align = alLeft
    ExplicitTop = 89
    ExplicitHeight = 244
  end
  object PaintBox1: TPaintBox
    Left = 0
    Top = 336
    Width = 1155
    Height = 181
    Align = alBottom
    ExplicitTop = 339
    ExplicitWidth = 1115
  end
  object Splitter1: TSplitter
    Left = 0
    Top = 333
    Width = 1155
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 89
    ExplicitWidth = 247
  end
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 1155
    Height = 121
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 856
      Top = 59
      Width = 31
      Height = 13
      Caption = 'Label1'
    end
    object lst1: TListBox
      Left = 8
      Top = 16
      Width = 129
      Height = 57
      ItemHeight = 13
      TabOrder = 0
      OnClick = lst1Click
    end
    object btnReadGraph: TButton
      Left = 176
      Top = 16
      Width = 75
      Height = 25
      Caption = 'read device'
      TabOrder = 1
      OnClick = btnReadGraphClick
    end
    object btn3: TButton
      Left = 176
      Top = 47
      Width = 75
      Height = 25
      Caption = 'stop device'
      TabOrder = 2
      OnClick = btn3Click
    end
    object btnReadTV: TButton
      Left = 257
      Top = 17
      Width = 75
      Height = 25
      Caption = 'read TV'
      TabOrder = 3
      OnClick = btnReadTVClick
    end
    object btn6: TButton
      Left = 257
      Top = 48
      Width = 75
      Height = 25
      Caption = 'stop TV'
      TabOrder = 4
      OnClick = btn6Click
    end
    object tbGain: TTrackBar
      Left = 560
      Top = 16
      Width = 193
      Height = 49
      Max = 50
      Min = 1
      Position = 30
      TabOrder = 5
      OnChange = tbDeltaChange
    end
    object tbDelta: TTrackBar
      Left = 560
      Top = 54
      Width = 177
      Height = 45
      Max = 50
      Min = 1
      Position = 30
      TabOrder = 6
      OnChange = tbDeltaChange
    end
    object TrackBar1: TTrackBar
      Left = 952
      Top = 12
      Width = 150
      Height = 29
      Max = 100
      Min = 1
      Position = 1
      TabOrder = 7
    end
    object TrackBar2: TTrackBar
      Left = 952
      Top = 54
      Width = 150
      Height = 29
      Max = 1000
      Min = 1
      Position = 10
      TabOrder = 8
    end
    object ComboBoxChannelRange: TComboBox
      Left = 352
      Top = 35
      Width = 73
      Height = 21
      ItemIndex = 5
      TabOrder = 9
      Text = '5000'
      OnChange = ComboBoxChannelRangeChange
      Items.Strings = (
        '100'
        '200'
        '500'
        '1000'
        '2000'
        '5000')
    end
    object CheckBoxACDC: TCheckBox
      Left = 448
      Top = 37
      Width = 65
      Height = 17
      Caption = 'AC/DC'
      TabOrder = 10
      OnClick = CheckBoxACDCClick
    end
    object ButtonFinishDll: TButton
      Left = 16
      Top = 79
      Width = 97
      Height = 25
      Caption = 'FinishDll'
      TabOrder = 11
      OnClick = ButtonFinishDllClick
    end
    object ButtonResetDevice: TButton
      Left = 136
      Top = 79
      Width = 97
      Height = 25
      Caption = 'ResetDevice'
      TabOrder = 12
      OnClick = ButtonResetDeviceClick
    end
  end
  object Memo1: TMemo
    Left = 856
    Top = 8
    Width = 65
    Height = 45
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 289
    Top = 121
    Width = 489
    Height = 212
    Align = alClient
    TabOrder = 2
    object Splitter2: TSplitter
      Left = 1
      Top = 1
      Height = 210
      ExplicitLeft = 0
      ExplicitTop = 104
      ExplicitHeight = 100
    end
    object bbDDSOutputEnable: TButton
      Left = 32
      Top = 16
      Width = 145
      Height = 25
      Caption = 'DDS on'
      TabOrder = 0
      OnClick = bbDDSOutputEnableClick
    end
    object Button1: TButton
      Left = 32
      Top = 47
      Width = 145
      Height = 25
      Caption = 'DDS off'
      TabOrder = 1
      OnClick = Button1Click
    end
    object TrackBarSetDDSPinlv: TTrackBar
      Left = 32
      Top = 78
      Width = 150
      Height = 45
      Max = 20000
      Position = 1000
      TabOrder = 2
      OnChange = TrackBarSetDDSPinlvChange
    end
    object TrackBarDDSDutyCycle: TTrackBar
      Left = 27
      Top = 112
      Width = 150
      Height = 45
      Max = 100
      Position = 50
      TabOrder = 3
      OnChange = TrackBarDDSDutyCycleChange
    end
    object ComboBoxDDSBoxingStyle: TComboBox
      Left = 27
      Top = 177
      Width = 136
      Height = 21
      ItemIndex = 0
      TabOrder = 4
      Text = 'Sine'
      OnChange = ComboBoxDDSBoxingStyleChange
      Items.Strings = (
        'Sine'
        'Square'
        'Triangular'
        'Up Sawtooth'
        'Down Sawtoot')
    end
  end
  object Panel2: TPanel
    Left = 778
    Top = 121
    Width = 377
    Height = 212
    Align = alRight
    TabOrder = 3
    ExplicitLeft = 488
    ExplicitTop = 1
    ExplicitHeight = 210
    object CheckBoxTrigger: TCheckBox
      Left = 32
      Top = 6
      Width = 161
      Height = 17
      Caption = 'Trigger AUTO/LIANXU'
      TabOrder = 0
      OnClick = CheckBoxTriggerClick
    end
    object ComboBoxTriggerStyle: TComboBox
      Left = 32
      Top = 47
      Width = 233
      Height = 21
      TabOrder = 1
      Text = 'TRIGGER_STYLE_NONE'
      OnChange = ComboBoxTriggerStyleChange
      Items.Strings = (
        'TRIGGER_STYLE_NONE'
        'TRIGGER_STYLE_RISE_EDGE'
        'TRIGGER_STYLE_FALL_EDGE'
        'TRIGGER_STYLE_EDGE'
        'TRIGGER_STYLE_P_MORE'
        'TRIGGER_STYLE_P_LESS '
        'TRIGGER_STYLE_P'
        'TRIGGER_STYLE_N_MORE'
        'TRIGGER_STYLE_N_LESS'
        'TRIGGER_STYLE_N')
    end
    object ComboBoxTriggerSource: TComboBox
      Left = 160
      Top = 102
      Width = 73
      Height = 21
      ItemIndex = 0
      TabOrder = 2
      Text = 'CH0'
      OnChange = ComboBoxTriggerSourceChange
      Items.Strings = (
        'CH0'
        'CH1')
    end
    object GroupBox1: TGroupBox
      Left = 6
      Top = 94
      Width = 105
      Height = 75
      Caption = 'Trigger Level mV'
      TabOrder = 3
      object SpinEditTriggerLevel: TSpinEdit
        Left = 24
        Top = 35
        Width = 73
        Height = 22
        Increment = 100
        MaxValue = 0
        MinValue = 0
        TabOrder = 0
        Value = 5000
        OnChange = SpinEditTriggerLevelChange
      end
    end
  end
  object odmain: TOpenDialog
    Filter = '*.osc|*.osc'
    Left = 112
    Top = 128
  end
end
