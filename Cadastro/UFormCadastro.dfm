object Form5: TForm5
  Left = 0
  Top = 0
  Caption = 'Cadastro'
  ClientHeight = 409
  ClientWidth = 542
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 470
    Top = 242
    Width = 13
    Height = 13
    Caption = 'UF'
  end
  object edtCep: TLabeledEdit
    Left = 24
    Top = 176
    Width = 121
    Height = 21
    EditLabel.Width = 19
    EditLabel.Height = 13
    EditLabel.Caption = 'Cep'
    MaxLength = 9
    NumbersOnly = True
    TabOrder = 5
    OnEnter = edtCepEnter
    OnExit = edtCepExit
    OnKeyDown = edtCepKeyDown
  end
  object edtLogradouro: TLabeledEdit
    Left = 152
    Top = 176
    Width = 299
    Height = 21
    EditLabel.Width = 104
    EditLabel.Height = 13
    EditLabel.Caption = 'Endere'#231'o\Logradouro'
    TabOrder = 6
  end
  object edtComplemento: TLabeledEdit
    Left = 24
    Top = 219
    Width = 377
    Height = 21
    EditLabel.Width = 65
    EditLabel.Height = 13
    EditLabel.Caption = 'Complemento'
    TabOrder = 8
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 365
    Width = 536
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Color = 15921906
    ParentBackground = False
    ShowCaption = False
    TabOrder = 13
    ExplicitLeft = 8
    ExplicitTop = 272
    ExplicitWidth = 185
    object SpeedButton1: TSpeedButton
      Left = 419
      Top = 1
      Width = 98
      Height = 30
      AllowAllUp = True
      Caption = 'Enviar email'
      OnClick = SpeedButton1Click
    end
  end
  object edtBairro: TLabeledEdit
    Left = 25
    Top = 258
    Width = 217
    Height = 21
    EditLabel.Width = 28
    EditLabel.Height = 13
    EditLabel.Caption = 'Bairro'
    TabOrder = 9
  end
  object edtLocalidade: TLabeledEdit
    Left = 247
    Top = 258
    Width = 217
    Height = 21
    EditLabel.Width = 33
    EditLabel.Height = 13
    EditLabel.Caption = 'Cidade'
    TabOrder = 10
  end
  object cbUF: TComboBox
    Left = 469
    Top = 258
    Width = 51
    Height = 21
    TabOrder = 11
    Items.Strings = (
      'AC'
      'AL'
      'AM'
      'AP'
      'BA'
      'CE'
      'DF'
      'ES'
      'GO'
      'MA'
      'MG'
      'MS'
      'MT'
      'PA'
      'PB'
      'PE'
      'PI'
      'PR'
      'RJ'
      'RN'
      'RO'
      'RR'
      'RS'
      'SC'
      'SE'
      'SP'
      'TO')
  end
  object edtNome: TLabeledEdit
    Left = 24
    Top = 32
    Width = 497
    Height = 21
    EditLabel.Width = 27
    EditLabel.Height = 13
    EditLabel.Caption = 'Nome'
    TabOrder = 0
    OnEnter = edtCepEnter
    OnExit = edtCepExit
  end
  object edtCPF: TLabeledEdit
    Left = 171
    Top = 73
    Width = 137
    Height = 21
    EditLabel.Width = 19
    EditLabel.Height = 13
    EditLabel.Caption = 'CPF'
    MaxLength = 11
    NumbersOnly = True
    TabOrder = 2
    OnEnter = edtCepEnter
    OnExit = edtCepExit
  end
  object edtRG: TLabeledEdit
    Left = 24
    Top = 73
    Width = 137
    Height = 21
    EditLabel.Width = 14
    EditLabel.Height = 13
    EditLabel.Caption = 'RG'
    NumbersOnly = True
    TabOrder = 1
    OnEnter = edtCepEnter
    OnExit = edtCepExit
  end
  object edtTelefone: TLabeledEdit
    Left = 24
    Top = 120
    Width = 137
    Height = 21
    EditLabel.Width = 42
    EditLabel.Height = 13
    EditLabel.Caption = 'Telefone'
    MaxLength = 11
    NumbersOnly = True
    TabOrder = 3
    OnEnter = edtCepEnter
    OnExit = edtCepExit
  end
  object edtemail: TLabeledEdit
    Left = 171
    Top = 120
    Width = 350
    Height = 21
    EditLabel.Width = 24
    EditLabel.Height = 13
    EditLabel.Caption = 'Email'
    TabOrder = 4
    OnEnter = edtCepEnter
    OnExit = edtCepExit
  end
  object edtNumero: TLabeledEdit
    Left = 456
    Top = 176
    Width = 64
    Height = 21
    EditLabel.Width = 16
    EditLabel.Height = 13
    EditLabel.Caption = 'N.'#186
    TabOrder = 7
    OnEnter = edtCepEnter
    OnExit = edtCepExit
  end
  object edtPais: TLabeledEdit
    Left = 25
    Top = 299
    Width = 217
    Height = 21
    EditLabel.Width = 19
    EditLabel.Height = 13
    EditLabel.Caption = 'Pa'#237's'
    TabOrder = 12
    Text = 'Brasil'
  end
  object Client: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    BaseURL = 'https://viacep.com.br/ws/72261011/json/'
    Params = <>
    HandleRedirects = True
    Left = 408
    Top = 168
  end
  object Request: TRESTRequest
    Client = Client
    Params = <>
    Response = Response
    SynchronizedEvents = False
    Left = 472
    Top = 168
  end
  object Response: TRESTResponse
    ContentType = 'application/json'
    Left = 528
    Top = 168
  end
  object smtp: TIdSMTP
    IOHandler = IdSSLIOHandlerSocketOpenSSL1
    Port = 465
    SASLMechanisms = <>
    UseTLS = utUseImplicitTLS
    Left = 224
    Top = 288
  end
  object idMessage: TIdMessage
    AttachmentEncoding = 'MIME'
    BccList = <>
    CCList = <>
    Encoding = meDefault
    FromList = <
      item
      end>
    Recipients = <>
    ReplyTo = <>
    ConvertPreamble = True
    Left = 112
    Top = 296
  end
  object IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL
    Destination = ':465'
    MaxLineAction = maException
    Port = 465
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 264
    Top = 176
  end
end
