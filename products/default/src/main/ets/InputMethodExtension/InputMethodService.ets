import InputMethodExtensionAbility from '@ohos.InputMethodExtensionAbility';
import inputMethod from '@ohos.InputMethod';
import hilog from '@ohos.hilog';

// Define the standard key color and radius
const KEY_COLOR = '#3C3C3C'; // Medium Dark Gray for standard keys
const SPECIAL_KEY_COLOR = '#505050'; // Darker Gray for functional keys
const BACKGROUND_COLOR = '#1F1F1F'; // Very Dark Gray for keyboard background
const KEY_RADIUS = 8; // Curved corners

@Entry
@Component
struct KeyboardService {
  private inputMethodAbility: inputMethod.InputMethodAbility = inputMethod.getInputMethodAbility();
  @State isUpperCase: boolean = false
  @State showNumbers: boolean = false

  // Helper function to build a standard character button
  @Builder buildCharKey(char: string) {
    Button(char)
      .fontSize(18)
      .fontColor(Color.White)
      .width('9%')
      .height(48)
      .backgroundColor(KEY_COLOR)
      .borderRadius(KEY_RADIUS)
      .onClick(() => this.insertText(char))
  }

  build() {
    Column() {
      if (this.showNumbers) {
        this.buildNumberKeyboard()
      } else {
        if (this.isUpperCase) {
          this.buildUpperCaseKeyboard()
        } else {
          this.buildLowerCaseKeyboard()
        }
      }
    }
    .width('100%')
    .height(280)
    .backgroundColor(BACKGROUND_COLOR) // Dark Background
    .padding(8)
  }

  buildNumberKeyboard() {
    Column() {
      // Number row 1
      Row() {
        ForEach(['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'], (num: string) => {
          Button(num)
            .fontSize(18)
            .fontColor(Color.White)
            .width('9%')
            .height(48)
            .backgroundColor(KEY_COLOR) // Key color
            .borderRadius(KEY_RADIUS)
            .onClick(() => this.insertText(num))
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ bottom: 6 })

      // Symbol row 1
      Row() {
        ForEach(['!', '@', '#', '$', '%', '^', '&', '*', '(', ')'], (symbol: string) => {
          Button(symbol)
            .fontSize(16)
            .fontColor(Color.White)
            .width('9%')
            .height(48)
            .backgroundColor(KEY_COLOR) // Key color
            .borderRadius(KEY_RADIUS)
            .onClick(() => this.insertText(symbol))
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ bottom: 6 })

      // Symbol row 2
      Row() {
        ForEach(['-', '/', ':', ';', '(', ')', '$', '&', '@', '"'], (symbol: string) => {
          Button(symbol)
            .fontSize(16)
            .fontColor(Color.White)
            .width('9%')
            .height(48)
            .backgroundColor(KEY_COLOR) // Key color
            .borderRadius(KEY_RADIUS)
            .onClick(() => this.insertText(symbol))
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ bottom: 6 })

      // Bottom row for numbers (Special Keys)
      Row() {
        Button('ABC')
          .fontSize(14)
          .fontColor(Color.White)
          .width('20%')
          .height(48)
          .backgroundColor(SPECIAL_KEY_COLOR) // Special Key color
          .borderRadius(KEY_RADIUS)
          .onClick(() => { this.showNumbers = false })
        Button('.')
          .fontSize(18)
          .fontColor(Color.White)
          .width('12%')
          .height(48)
          .backgroundColor(KEY_COLOR) // Key color
          .borderRadius(KEY_RADIUS)
          .onClick(() => this.insertText('.'))
        Button(',')
          .fontSize(18)
          .fontColor(Color.White)
          .width('12%')
          .height(48)
          .backgroundColor(KEY_COLOR) // Key color
          .borderRadius(KEY_RADIUS)
          .onClick(() => this.insertText(','))
        Button('?')
          .fontSize(18)
          .fontColor(Color.White)
          .width('12%')
          .height(48)
          .backgroundColor(KEY_COLOR) // Key color
          .borderRadius(KEY_RADIUS)
          .onClick(() => this.insertText('?'))
        Button('!')
          .fontSize(18)
          .fontColor(Color.White)
          .width('12%')
          .height(48)
          .backgroundColor(KEY_COLOR) // Key color
          .borderRadius(KEY_RADIUS)
          .onClick(() => this.insertText('!'))
        Button('ABC')
          .fontSize(14)
          .fontColor(Color.White)
          .width('20%')
          .height(48)
          .backgroundColor(SPECIAL_KEY_COLOR) // Special Key color
          .borderRadius(KEY_RADIUS)
          .onClick(() => { this.showNumbers = false })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
  }

  buildLowerCaseKeyboard() {
    Column() {
      // Row 1: Q W E R T Y U I O P
      Row() {
        ForEach(['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'], (char: string) => {
          this.buildCharKey(char)
            .width('9%')
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ bottom: 6 })

      // Row 2: A S D F G H J K L
      Row() {
        ForEach(['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'], (char: string) => {
          this.buildCharKey(char)
            .width('10%')
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ bottom: 6 })

      // Row 3: Shift Z X C V B N M Backspace
      Row() {
        // Shift Key (Special)
        Button('↑')
          .fontSize(16)
          .fontColor(Color.White)
          .width('12%')
          .height(48)
          .backgroundColor(SPECIAL_KEY_COLOR) // Special Key color
          .borderRadius(KEY_RADIUS)
          .onClick(() => { this.isUpperCase = true })
        ForEach(['z', 'x', 'c', 'v', 'b', 'n', 'm'], (char: string) => {
          this.buildCharKey(char)
            .width('10%')
        })
        // Backspace Key (Special)
        Button('⌫')
          .fontSize(18)
          .fontColor(Color.White)
          .width('12%')
          .height(48)
          .backgroundColor(SPECIAL_KEY_COLOR) // Special Key color
          .borderRadius(KEY_RADIUS)
          .onClick(() => this.deleteText())
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ bottom: 6 })

      // Row 4: ?123 , Space .
      Row() {
        // ?123 Key (Special)
        Button('?123')
          .fontSize(14)
          .fontColor(Color.White)
          .width('25%')
          .height(48)
          .backgroundColor(SPECIAL_KEY_COLOR) // Special Key color
          .borderRadius(KEY_RADIUS)
          .onClick(() => { this.showNumbers = true })
        // , Key
        Button(',')
          .fontSize(18)
          .fontColor(Color.White)
          .width('12%')
          .height(48)
          .backgroundColor(KEY_COLOR) // Key color
          .borderRadius(KEY_RADIUS)
          .onClick(() => this.insertText(','))
        // Space Key (Special)
        Button(' ')
          .fontSize(14)
          .width('38%')
          .height(48)
          .backgroundColor(SPECIAL_KEY_COLOR) // Special Key color
          .borderRadius(KEY_RADIUS)
          .onClick(() => this.insertText(' '))
        // . Key
        Button('.')
          .fontSize(18)
          .fontColor(Color.White)
          .width('12%')
          .height(48)
          .backgroundColor(KEY_COLOR) // Key color
          .borderRadius(KEY_RADIUS)
          .onClick(() => this.insertText('.'))
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
  }

  buildUpperCaseKeyboard() {
    Column() {
      // Row 1: Q W E R T Y U I O P
      Row() {
        ForEach(['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'], (char: string) => {
          Button(char)
            .fontSize(18)
            .fontColor(Color.White)
            .width('9%')
            .height(48)
            .backgroundColor(KEY_COLOR) // Key color
            .borderRadius(KEY_RADIUS)
            .onClick(() => {
              this.insertText(char)
              this.isUpperCase = false // Auto switch off
            })
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ bottom: 6 })

      // Row 2: A S D F G H J K L
      Row() {
        ForEach(['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'], (char: string) => {
          Button(char)
            .fontSize(18)
            .fontColor(Color.White)
            .width('10%')
            .height(48)
            .backgroundColor(KEY_COLOR) // Key color
            .borderRadius(KEY_RADIUS)
            .onClick(() => {
              this.insertText(char)
              this.isUpperCase = false // Auto switch off
            })
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ bottom: 6 })

      // Row 3: Shift Z X C V B N M Backspace
      Row() {
        // Shift Down Key (Special)
        Button('↓')
          .fontSize(16)
          .fontColor(Color.White)
          .width('12%')
          .height(48)
          .backgroundColor(SPECIAL_KEY_COLOR) // Special Key color
          .borderRadius(KEY_RADIUS)
          .onClick(() => { this.isUpperCase = false })
        ForEach(['Z', 'X', 'C', 'V', 'B', 'N', 'M'], (char: string) => {
          Button(char)
            .fontSize(18)
            .fontColor(Color.White)
            .width('10%')
            .height(48)
            .backgroundColor(KEY_COLOR) // Key color
            .borderRadius(KEY_RADIUS)
            .onClick(() => {
              this.insertText(char)
              this.isUpperCase = false // Auto switch off
            })
        })
        // Backspace Key (Special)
        Button('⌫')
          .fontSize(18)
          .fontColor(Color.White)
          .width('12%')
          .height(48)
          .backgroundColor(SPECIAL_KEY_COLOR) // Special Key color
          .borderRadius(KEY_RADIUS)
          .onClick(() => this.deleteText())
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ bottom: 6 })

      // Row 4: ?123 , Space . (Special Keys)
      Row() {
        // ?123 Key (Special)
        Button('?123')
          .fontSize(14)
          .fontColor(Color.White)
          .width('25%')
          .height(48)
          .backgroundColor(SPECIAL_KEY_COLOR) // Special Key color
          .borderRadius(KEY_RADIUS)
          .onClick(() => { this.showNumbers = true })
        // , Key
        Button(',')
          .fontSize(18)
          .fontColor(Color.White)
          .width('12%')
          .height(48)
          .backgroundColor(KEY_COLOR) // Key color
          .borderRadius(KEY_RADIUS)
          .onClick(() => this.insertText(','))
        // Space Key (Special)
        Button(' ')
          .fontSize(14)
          .width('38%')
          .height(48)
          .backgroundColor(SPECIAL_KEY_COLOR) // Special Key color
          .borderRadius(KEY_RADIUS)
          .onClick(() => this.insertText(' '))
        // . Key
        Button('.')
          .fontSize(18)
          .fontColor(Color.White)
          .width('12%')
          .height(48)
          .backgroundColor(KEY_COLOR) // Key color
          .borderRadius(KEY_RADIUS)
          .onClick(() => this.insertText('.'))
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
  }

  private insertText(text: string): void {
    hilog.info(0x0000, 'OpenBoard', 'Inserting text: %{public}s', text);
    this.inputMethodAbility.insertText(text);
  }

  private deleteText(): void {
    hilog.info(0x0000, 'OpenBoard', 'Deleting character');
    this.inputMethodAbility.deleteBackward(1);
  }
}

export default class InputMethodService extends InputMethodExtensionAbility {
  onCreate(): void {
    hilog.info(0x0000, 'OpenBoard', 'OpenBoard Keyboard Service Created');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'OpenBoard', 'OpenBoard Keyboard Service Destroyed');
  }

  onSetPanel(): void {
    hilog.info(0x0000, 'OpenBoard', 'Keyboard panel requested - displaying Polish keyboard');
  }
}
