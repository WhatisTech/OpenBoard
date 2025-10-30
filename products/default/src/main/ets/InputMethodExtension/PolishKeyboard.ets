import { inputMethod } from '@ohos.InputMethod';

@Component
export struct PolishKeyboard {
  @Link inputMethodAbility: inputMethod.InputMethodAbility
  @State showPopup: boolean = false
  @State popupX: number = 0
  @State popupY: number = 0
  @State currentBaseChar: string = ''
  @State popupChars: string[] = []
  @State isUpperCase: boolean = false
  @State showNumbers: boolean = false
  @State currentLanguage: string = 'PL'

  build() {
    Column() {
      if (this.showNumbers) {
        this.buildNumberRow()
        this.buildSymbolsFirstRow()
        this.buildSymbolsSecondRow()
        this.buildSymbolsThirdRow()
      } else {
        if (this.isUpperCase) {
          this.buildUpperFirstRow()
          this.buildUpperSecondRow()
          this.buildUpperThirdRow()
          this.buildUpperFourthRow()
        } else {
          this.buildFirstRow()
          this.buildSecondRow()
          this.buildThirdRow()
          this.buildFourthRow()
        }
      }

      // Bottom row (always visible)
      this.buildBottomRow()

      // Popup for long-press characters
      if (this.showPopup) {
        this.buildPopup()
      }
    }
    .width('100%')
    .height(320)
    .backgroundColor('#E5E5E5')
    .padding(8)
  }

  // First row - numbers or QWERTY top row
  buildNumberRow() {
    Row() {
      ForEach(['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'], (num: string) => {
        Button(num)
          .fontSize(18)
          .width('10%')
          .height(50)
          .backgroundColor(Color.White)
          .onClick(() => this.insertText(num))
      })
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ bottom: 8 })
  }

  buildSymbolsFirstRow() {
    Row() {
      ForEach(['!', '@', '#', '$', '%', '^', '&', '*', '(', ')'], (symbol: string) => {
        Button(symbol)
          .fontSize(18)
          .width('10%')
          .height(50)
          .backgroundColor(Color.White)
          .onClick(() => this.insertText(symbol))
      })
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ bottom: 8 })
  }

  buildSymbolsSecondRow() {
    Row() {
      ForEach(['-', '/', ':', ';', '(', ')', '$', '&', '@', '"'], (symbol: string) => {
        Button(symbol)
          .fontSize(18)
          .width('10%')
          .height(50)
          .backgroundColor(Color.White)
          .onClick(() => this.insertText(symbol))
      })
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ bottom: 8 })
  }

  buildSymbolsThirdRow() {
    Row() {
      Button('ABC')
        .fontSize(14)
        .width('15%')
        .height(50)
        .backgroundColor(Color.White)
        .onClick(() => { this.showNumbers = false })
      Button('.')
        .fontSize(18)
        .width('10%')
        .height(50)
        .backgroundColor(Color.White)
        .onClick(() => this.insertText('.'))
      Button(',')
        .fontSize(18)
        .width('10%')
        .height(50)
        .backgroundColor(Color.White)
        .onClick(() => this.insertText(','))
      Button('?')
        .fontSize(18)
        .width('10%')
        .height(50)
        .backgroundColor(Color.White)
        .onClick(() => this.insertText('?'))
      Button('!')
        .fontSize(18)
        .width('10%')
        .height(50)
        .backgroundColor(Color.White)
        .onClick(() => this.insertText('!'))
      Button("'")
        .fontSize(18)
        .width('10%')
        .height(50)
        .backgroundColor(Color.White)
        .onClick(() => this.insertText("'"))
      Button('"')
        .fontSize(18)
        .width('10%')
        .height(50)
        .backgroundColor(Color.White)
        .onClick(() => this.insertText('"'))
      Button('ABC')
        .fontSize(14)
        .width('15%')
        .height(50)
        .backgroundColor(Color.White)
        .onClick(() => { this.showNumbers = false })
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ bottom: 8 })
  }

  // Standard QWERTY Rows (lowercase)
  buildFirstRow() {
    Row() {
      ForEach(['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'], (char: string) => {
        this.buildKey(char, this.getPolishVariants(char))
      })
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ bottom: 8 })
  }

  buildSecondRow() {
    Row() {
      ForEach(['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'], (char: string) => {
        this.buildKey(char, this.getPolishVariants(char))
      })
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ bottom: 8 })
  }

  buildThirdRow() {
    Row() {
      Button('↑')
        .fontSize(16)
        .width('12%')
        .height(50)
        .backgroundColor(Color.White)
        .onClick(() => { this.isUpperCase = !this.isUpperCase })
      ForEach(['z', 'x', 'c', 'v', 'b', 'n', 'm'], (char: string) => {
        this.buildKey(char, this.getPolishVariants(char))
      })
      Button('⌫')
        .fontSize(18)
        .width('12%')
        .height(50)
        .backgroundColor(Color.White)
        .onClick(() => this.deleteText())
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ bottom: 8 })
  }

  // Uppercase QWERTY Rows
  buildUpperFirstRow() {
    Row() {
      ForEach(['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'], (char: string) => {
        this.buildKey(char, this.getPolishVariants(char))
      })
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ bottom: 8 })
  }

  buildUpperSecondRow() {
    Row() {
      ForEach(['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'], (char: string) => {
        this.buildKey(char, this.getPolishVariants(char))
      })
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ bottom: 8 })
  }

  buildUpperThirdRow() {
    Row() {
      Button('↓')
        .fontSize(16)
        .width('12%')
        .height(50)
        .backgroundColor(Color.White)
        .onClick(() => { this.isUpperCase = !this.isUpperCase })
      ForEach(['Z', 'X', 'C', 'V', 'B', 'N', 'M'], (char: string) => {
        this.buildKey(char, this.getPolishVariants(char))
      })
      Button('⌫')
        .fontSize(18)
        .width('12%')
        .height(50)
        .backgroundColor(Color.White)
        .onClick(() => this.deleteText())
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ bottom: 8 })
  }

  buildFourthRow() {
    Row() {
      Button('?123')
        .fontSize(14)
        .width('20%')
        .height(50)
        .backgroundColor(Color.White)
        .onClick(() => { this.showNumbers = true })
      Button(',')
        .fontSize(18)
        .width('10%')
        .height(50)
        .backgroundColor(Color.White)
        .onClick(() => this.insertText(','))
      Button(' ')
        .fontSize(14)
        .width('40%')
        .height(50)
        .backgroundColor(Color.White)
        .onClick(() => this.insertText(' '))
      Button('.')
        .fontSize(18)
        .width('10%')
        .height(50)
        .backgroundColor(Color.White)
        .onClick(() => this.insertText('.'))
      Button(this.currentLanguage)
        .fontSize(14)
        .width('20%')
        .height(50)
        .backgroundColor(Color.White)
        .onClick(() => {
          this.currentLanguage = this.currentLanguage === 'PL' ? 'EN' : 'PL'
        })
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }

  buildUpperFourthRow() {
    Row() {
      Button('?123')
        .fontSize(14)
        .width('20%')
        .height(50)
        .backgroundColor(Color.White)
        .onClick(() => { this.showNumbers = true })
      Button(',')
        .fontSize(18)
        .width('10%')
        .height(50)
        .backgroundColor(Color.White)
        .onClick(() => this.insertText(','))
      Button(' ')
        .fontSize(14)
        .width('40%')
        .height(50)
        .backgroundColor(Color.White)
        .onClick(() => this.insertText(' '))
      Button('.')
        .fontSize(18)
        .width('10%')
        .height(50)
        .backgroundColor(Color.White)
        .onClick(() => this.insertText('.'))
      Button(this.currentLanguage)
        .fontSize(14)
        .width('20%')
        .height(50)
        .backgroundColor(Color.White)
        .onClick(() => {
          this.currentLanguage = this.currentLanguage === 'PL' ? 'EN' : 'PL'
        })
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }

  buildBottomRow() {
    // This would be the very bottom system row in Gboard
    // For now, we'll keep it simple
  }

  @Builder buildKey(baseChar: string, popupCharacters: string[]) {
    Button(baseChar)
      .fontSize(18)
      .width(this.getKeyWidth(baseChar))
      .height(50)
      .backgroundColor(Color.White)
      .onClick(() => {
        if (!this.showPopup) {
          this.insertText(baseChar)
          // Auto-switch to lowercase after typing (except for shift lock)
          if (this.isUpperCase && baseChar !== '↑' && baseChar !== '↓') {
            this.isUpperCase = false
          }
        }
      })
      .onTouch((event: TouchEvent) => {
        if (event.type === TouchType.Down && popupCharacters.length > 1) {
          // Start long-press timer
          setTimeout(() => {
            if (popupCharacters.length > 1) {
              this.showCharacterPopup(baseChar, popupCharacters, event)
            }
          }, 500) // 500ms long-press
        } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
          this.hidePopup()
        }
      })
  }

  @Builder buildPopup() {
    Column() {
      Row() {
        ForEach(this.popupChars, (char: string) => {
          Button(char)
            .fontSize(16)
            .width(40)
            .height(40)
            .margin(2)
            .backgroundColor(Color.White)
            .onClick(() => {
              this.insertText(char)
              this.hidePopup()
            })
        })
      }
      .backgroundColor(Color.White)
      .border({ width: 1, color: '#CCCCCC' })
      .borderRadius(8)
      .padding(5)
      .shadow({ radius: 10, color: '#000000', offsetX: 0, offsetY: 2 })
    }
    .position({ x: this.popupX, y: this.popupY })
  }

  private getKeyWidth(char: string): string {
    const topRow = ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p']
    const middleRow = ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l']
    const bottomRow = ['z', 'x', 'c', 'v', 'b', 'n', 'm']

    if (topRow.includes(char.toLowerCase())) return '9%'
    if (middleRow.includes(char.toLowerCase())) return '10%'
    if (bottomRow.includes(char.toLowerCase())) return '11%'
    return '10%'
  }

  private getPolishVariants(baseChar: string): string[] {
    const polishMap: { [key: string]: string[] } = {
      'a': ['a', 'ą'],
      'A': ['A', 'Ą'],
      'c': ['c', 'ć'],
      'C': ['C', 'Ć'],
      'e': ['e', 'ę'],
      'E': ['E', 'Ę'],
      'l': ['l', 'ł'],
      'L': ['L', 'Ł'],
      'n': ['n', 'ń'],
      'N': ['N', 'Ń'],
      'o': ['o', 'ó'],
      'O': ['O', 'Ó'],
      's': ['s', 'ś'],
      'S': ['S', 'Ś'],
      'z': ['z', 'ż', 'ź'],
      'Z': ['Z', 'Ż', 'Ź']
    }
    return polishMap[baseChar] || [baseChar]
  }

  private showCharacterPopup(baseChar: string, popupChars: string[], event: TouchEvent): void {
    this.currentBaseChar = baseChar
    this.popupChars = popupChars
    this.popupX = event.touches[0].x - 50
    this.popupY = event.touches[0].y - 60
    this.showPopup = true
  }

  private hidePopup(): void {
    this.showPopup = false
    this.popupChars = []
    this.currentBaseChar = ''
  }

  private insertText(text: string): void {
    if (this.inputMethodAbility) {
      this.inputMethodAbility.insertText(text)
    }
  }

  private deleteText(): void {
    if (this.inputMethodAbility) {
      this.inputMethodAbility.deleteBackward(1)
    }
  }
}