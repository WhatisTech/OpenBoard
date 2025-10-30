import inputMethod from '@ohos.inputMethod';
import hilog from '@ohos.hilog';

// --- Styling Constants ---
const KEY_COLOR = '#3C3C3C';
const SPECIAL_KEY_COLOR = '#505050';
const BACKGROUND_COLOR = '#1F1F1F';
const KEY_RADIUS = 8;
const FONT_SIZE = 18;

// Define interface for input method ability
interface InputMethodAbilityInterface {
  insertText?(text: string): void;
  deleteBackward?(length: number): void;
}

@Component
export struct KeyboardLayout {
  @Prop inputMethodAbility: Object;

  @State isUpperCase: boolean = false;
  @State showNumbers: boolean = false;
  @State currentLanguage: string = 'PL';

  private POLISH_DIACRITICS: Record<string, string> = {
    'a': 'ą', 'c': 'ć', 'e': 'ę', 'l': 'ł', 'n': 'ń', 'o': 'ó', 's': 'ś', 'z': 'ż'
  };

  private getDisplayChar(baseChar: string): string {
    const lowerChar = baseChar.toLowerCase();

    if (this.isUpperCase) {
      return (this.POLISH_DIACRITICS[lowerChar]?.toUpperCase() || baseChar.toUpperCase());
    }

    return (this.POLISH_DIACRITICS[lowerChar] || lowerChar);
  }

  private insertText(text: string): void {
    const ability = this.inputMethodAbility as InputMethodAbilityInterface;
    if (ability?.insertText) {
      ability.insertText(text);
      if (this.isUpperCase && text.length === 1 && text.match(/[A-Za-z]/i)) {
        this.isUpperCase = false;
      }
    }
  }

  private deleteText(): void {
    const ability = this.inputMethodAbility as InputMethodAbilityInterface;
    if (ability?.deleteBackward) {
      ability.deleteBackward(1);
    }
  }

  // Precompute display characters for each row
  get letterRow1(): string[] {
    return ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'].map(char => this.getDisplayChar(char));
  }

  get letterRow2(): string[] {
    return ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'].map(char => this.getDisplayChar(char));
  }

  get letterRow3(): string[] {
    return ['z', 'x', 'c', 'v', 'b', 'n', 'm'].map(char => this.getDisplayChar(char));
  }

  get symbolSwitchChar(): string {
    return this.showNumbers ? 'ABC' : '?123';
  }

  build() {
    Column() {
      // Candidate/Suggestion Bar
      Row() {
        Text('Polski Słownik: [Sugestie]')
          .fontSize(14)
          .fontColor('#AAAAAA')
          .padding({ left: 15, right: 15, top: 8, bottom: 4 })
          .textAlign(TextAlign.Center)
          .flexGrow(1)
      }
      .width('100%')
      .backgroundColor('#333333')
      .borderRadius({topLeft: KEY_RADIUS, topRight: KEY_RADIUS})

      // Main Keyboard Area
      Column() {
        if (this.showNumbers) {
          // Numbers Layout
          Column() {
            // Row 1: Numbers
            Row() {
              ForEach(['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'], (char: string) => {
                Button(char)
                  .fontSize(FONT_SIZE)
                  .fontColor('#FFFFFF')
                  .width('9.5%')
                  .height(50)
                  .backgroundColor(KEY_COLOR)
                  .borderRadius(KEY_RADIUS)
                  .margin({ left: 1, right: 1, top: 2, bottom: 2 })
                  .onClick(() => { this.insertText(char); })
              })
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)

            // Row 2: Symbols
            Row() {
              ForEach(['!', '@', '#', '$', '%', '^', '&', '*', '(', ')'], (char: string) => {
                Button(char)
                  .fontSize(FONT_SIZE)
                  .fontColor('#FFFFFF')
                  .width('9.5%')
                  .height(50)
                  .backgroundColor(KEY_COLOR)
                  .borderRadius(KEY_RADIUS)
                  .margin({ left: 1, right: 1, top: 2, bottom: 2 })
                  .onClick(() => { this.insertText(char); })
              })
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)

            // Row 3: More Symbols
            Row() {
              ForEach(['-', '/', ':', ';', '£', '€', '¥', '?', '"'], (char: string) => {
                Button(char)
                  .fontSize(FONT_SIZE)
                  .fontColor('#FFFFFF')
                  .width('9.5%')
                  .height(50)
                  .backgroundColor(KEY_COLOR)
                  .borderRadius(KEY_RADIUS)
                  .margin({ left: 1, right: 1, top: 2, bottom: 2 })
                  .onClick(() => { this.insertText(char); })
              })
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)

            // Row 4: Controls
            Row() {
              Button('ABC')
                .fontSize(FONT_SIZE)
                .fontColor('#FFFFFF')
                .width('20%')
                .height(50)
                .backgroundColor(SPECIAL_KEY_COLOR)
                .borderRadius(KEY_RADIUS)
                .margin({ left: 1, right: 1, top: 2, bottom: 2 })
                .onClick(() => { this.showNumbers = false })

              Button('Spacja')
                .fontSize(FONT_SIZE)
                .fontColor('#FFFFFF')
                .width('50%')
                .height(50)
                .backgroundColor('#6C6C6C')
                .borderRadius(KEY_RADIUS)
                .margin({ left: 1, right: 1, top: 2, bottom: 2 })
                .onClick(() => { this.insertText(' '); })

              Button('⌫')
                .fontSize(22)
                .fontColor('#FFFFFF')
                .width('20%')
                .height(50)
                .backgroundColor(SPECIAL_KEY_COLOR)
                .borderRadius(KEY_RADIUS)
                .margin({ left: 1, right: 1, top: 2, bottom: 2 })
                .onClick(() => this.deleteText())
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width('100%')
        } else {
          // Letters Layout
          Column() {
            // Row 1: Q W E R T Y U I O P
            Row() {
              ForEach(this.letterRow1, (displayChar: string) => {
                Button(displayChar)
                  .fontSize(FONT_SIZE)
                  .fontColor('#FFFFFF')
                  .width('9.5%')
                  .height(50)
                  .backgroundColor(KEY_COLOR)
                  .borderRadius(KEY_RADIUS)
                  .margin({ left: 1, right: 1, top: 2, bottom: 2 })
                  .onClick(() => { this.insertText(displayChar); })
              })
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)

            // Row 2: A S D F G H J K L
            Row() {
              Blank().width(5)
              Row() {
                ForEach(this.letterRow2, (displayChar: string) => {
                  Button(displayChar)
                    .fontSize(FONT_SIZE)
                    .fontColor('#FFFFFF')
                    .width('9.5%')
                    .height(50)
                    .backgroundColor(KEY_COLOR)
                    .borderRadius(KEY_RADIUS)
                    .margin({ left: 1, right: 1, top: 2, bottom: 2 })
                    .onClick(() => { this.insertText(displayChar); })
                })
              }
              .justifyContent(FlexAlign.SpaceBetween)
              .width('100%')
            }
            .width('100%')

            // Row 3: Shift Z X C V B N M Backspace
            Row() {
              Button(this.isUpperCase ? '⇩' : '⇧')
                .fontSize(22)
                .fontColor('#FFFFFF')
                .width('12%')
                .height(50)
                .backgroundColor(SPECIAL_KEY_COLOR)
                .borderRadius(KEY_RADIUS)
                .margin({ left: 1, right: 1, top: 2, bottom: 2 })
                .onClick(() => { this.isUpperCase = !this.isUpperCase })

              Row() {
                ForEach(this.letterRow3, (displayChar: string) => {
                  Button(displayChar)
                    .fontSize(FONT_SIZE)
                    .fontColor('#FFFFFF')
                    .width('9.5%')
                    .height(50)
                    .backgroundColor(KEY_COLOR)
                    .borderRadius(KEY_RADIUS)
                    .margin({ left: 1, right: 1, top: 2, bottom: 2 })
                    .onClick(() => { this.insertText(displayChar); })
                })
              }
              .justifyContent(FlexAlign.SpaceBetween)
              .width('70%')

              Button('⌫')
                .fontSize(22)
                .fontColor('#FFFFFF')
                .width('12%')
                .height(50)
                .backgroundColor(SPECIAL_KEY_COLOR)
                .borderRadius(KEY_RADIUS)
                .margin({ left: 1, right: 1, top: 2, bottom: 2 })
                .onClick(() => this.deleteText())
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
        }

        // Bottom Row (Common for both layouts)
        Row() {
          Button(this.symbolSwitchChar)
            .fontSize(FONT_SIZE)
            .fontColor('#FFFFFF')
            .width('15%')
            .height(50)
            .backgroundColor(SPECIAL_KEY_COLOR)
            .borderRadius(KEY_RADIUS)
            .margin({ left: 1, right: 1, top: 2, bottom: 2 })
            .onClick(() => { this.showNumbers = !this.showNumbers })

          Button(',')
            .fontSize(FONT_SIZE)
            .fontColor('#FFFFFF')
            .width('10%')
            .height(50)
            .backgroundColor(KEY_COLOR)
            .borderRadius(KEY_RADIUS)
            .margin({ left: 1, right: 1, top: 2, bottom: 2 })
            .onClick(() => { this.insertText(','); })

          Button('Spacja')
            .fontSize(FONT_SIZE)
            .fontColor('#FFFFFF')
            .width('40%')
            .height(50)
            .backgroundColor('#6C6C6C')
            .borderRadius(KEY_RADIUS)
            .margin({ left: 1, right: 1, top: 2, bottom: 2 })
            .onClick(() => { this.insertText(' '); })

          Button('.')
            .fontSize(FONT_SIZE)
            .fontColor('#FFFFFF')
            .width('10%')
            .height(50)
            .backgroundColor(KEY_COLOR)
            .borderRadius(KEY_RADIUS)
            .margin({ left: 1, right: 1, top: 2, bottom: 2 })
            .onClick(() => { this.insertText('.'); })

          Button('PL/EN')
            .fontSize(FONT_SIZE)
            .fontColor('#FFFFFF')
            .width('20%')
            .height(50)
            .backgroundColor(SPECIAL_KEY_COLOR)
            .borderRadius(KEY_RADIUS)
            .margin({ left: 1, right: 1, top: 2, bottom: 2 })
            .onClick(() => {
              this.currentLanguage = this.currentLanguage === 'PL' ? 'EN' : 'PL';
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('100%')
      .padding({ left: 4, right: 4, bottom: 4 })
    }
    .width('100%')
    .height(320)
    .backgroundColor(BACKGROUND_COLOR)
    .alignItems(HorizontalAlign.Center)
  }
}