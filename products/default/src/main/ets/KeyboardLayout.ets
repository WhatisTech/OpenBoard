import { InputMethodExtensionContext } from '@ohos.inputMethodExtensionContext';

// Define the keys available for long-press diacritics
const POLISH_DIACRITICS: Record<string, string[]> = {
  'a': ['ą', 'ä', 'á'],
  'c': ['ć'],
  'e': ['ę'],
  'l': ['ł'],
  'n': ['ń'],
  'o': ['ó', 'ö', 'ő'],
  's': ['ś'],
  'z': ['ź', 'ż']
};

// Define the QWERTY key rows
const QWERTY_LAYOUT: string[][] = [
  ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
  ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
];

/**
 * The declarative UI component for the soft keyboard.
 */
@Component
export default struct KeyboardLayout {
  // Context passed from the service, used to send text to the input field
  @State inputContext: InputMethodExtensionContext = {} as InputMethodExtensionContext;

  // State to manage the Shift key toggle
  @State isShiftActive: boolean = false;

  // State to manage the key that is currently long-pressed (for pop-up selection)
  @State longPressKey: string = '';

  // --- UI Builders ---

  // Builder for a single Key Button
  @Builder KeyButton(char: string, weight: number = 1) {
    Button(this.getKeyDisplay(char))
      .backgroundColor(Color.White)
      .fontColor(Color.Black)
      .fontSize(18)
      .height(50)
      .layoutWeight(weight)
      .borderRadius(8)
      .margin({ horizontal: 2, vertical: 4 })
      .onClick(() => this.handleKeyTap(char))
      .onLongPress(() => this.showLongPressOptions(char))
  }

  // Builder for the entire keyboard row
  @Builder KeyboardRow(row: string[]) {
    Row() {
      ForEach(row, (char: string) => {
        this.KeyButton(char, 1)
      })
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
  }

  // --- Logic Functions ---

  getKeyDisplay(char: string): string {
    let display = char;
    if (this.isShiftActive) {
      // Handle special Polish characters when shift is active
      switch (char) {
        case 'a': display = 'Ą'; break;
        case 'c': display = 'Ć'; break;
        case 'e': display = 'Ę'; break;
        case 'l': display = 'Ł'; break;
        case 'n': display = 'Ń'; break;
        case 'o': display = 'Ó'; break;
        case 's': display = 'Ś'; break;
        case 'z': display = 'Ż'; break;
        default: display = char.toUpperCase(); break;
      }
    } else {
      // Handle lowercase Polish characters
      switch (char) {
        case 'a': display = 'ą'; break;
        case 'c': display = 'ć'; break;
        case 'e': display = 'ę'; break;
        case 'l': display = 'ł'; break;
        case 'n': display = 'ń'; break;
        case 'o': display = 'ó'; break;
        case 's': display = 'ś'; break;
        case 'z': display = 'ż'; break;
        default: display = char.toLowerCase(); break;
      }
    }
    return display;
  }

  handleKeyTap(char: string): void {
    let outputChar = this.getKeyDisplay(char);

    // Send the character to the active text field
    this.inputContext.insertText(outputChar);

    // If Shift was active, turn it off after one key press (standard mobile behavior)
    if (this.isShiftActive) {
      this.isShiftActive = false;
    }
  }

  showLongPressOptions(baseChar: string): void {
    if (POLISH_DIACRITICS[baseChar]) {
      this.longPressKey = baseChar;
      // In a real application, you would show a custom dialog or a pop-up here
      // For this example, we log and can manually implement a selection UI.
      console.log(`Long press on ${baseChar}. Options: ${POLISH_DIACRITICS[baseChar].join(', ')}`);

      // Let's implement a simple automatic insertion of the primary diacritic
      let primaryDiacritic = POLISH_DIACRITICS[baseChar][0];
      if (this.isShiftActive) {
        primaryDiacritic = primaryDiacritic.toUpperCase();
      }
      this.inputContext.insertText(primaryDiacritic);
      this.longPressKey = ''; // Clear selection state
    }
  }

  // --- Keyboard UI Structure ---
  build() {
    Column() {
      // Candidates View Placeholder (for auto-correction/prediction)
      Row() {
        Text('Słownik polski: [Suggest] [AutoCorrect]')
          .fontSize(14)
          .fontColor(Color.Gray)
          .padding({ left: 15, right: 15, top: 10, bottom: 5 })
          .textAlign(TextAlign.Center)
          .flexGrow(1)
      }
      .width('100%')
      .backgroundColor(0xF0F0F0)

      Column() {
        // Top QWERTY Rows
        this.KeyboardRow(QWERTY_LAYOUT[0])
        this.KeyboardRow(QWERTY_LAYOUT[1])

        // Third Row (Shift, ZXC..., Backspace)
        Row() {
          // 1. Shift Key
          Button(this.isShiftActive ? '⇧' : '⇧')
            .backgroundColor(this.isShiftActive ? Color.Blue : Color.Gray)
            .fontColor(Color.White)
            .height(50).borderRadius(8).margin({ horizontal: 2 })
            .layoutWeight(1.5)
            .onClick(() => this.isShiftActive = !this.isShiftActive)

          // 2. Z X C V B N M
          ForEach(['z', 'x', 'c', 'v', 'b', 'n', 'm'], (char: string) => {
            this.KeyButton(char, 1)
          })

          // 3. Backspace Key
          Button('⌫')
            .backgroundColor(Color.Gray)
            .fontColor(Color.White)
            .height(50).borderRadius(8).margin({ horizontal: 2 })
            .layoutWeight(1.5)
            .onClick(() => this.inputContext.deleteBackward(1))

        }
        .justifyContent(FlexAlign.Center)
        .width('100%')

        // Bottom Row (123, Space, Language, Enter)
        Row() {
          // 1. Symbol/Number Key
          Button('?123')
            .backgroundColor(Color.Gray).fontColor(Color.White)
            .height(50).borderRadius(8).margin({ horizontal: 2 })
            .layoutWeight(2)
            .onClick(() => console.log('Switch to symbol layout'))

          // 2. Space Bar
          Button('Spacja')
            .backgroundColor(Color.White).fontColor(Color.Black)
            .height(50).borderRadius(8).margin({ horizontal: 2 })
            .layoutWeight(5)
            .onClick(() => this.inputContext.insertText(' '))

          // 3. Language Switch/Globe
          Button('🌐')
            .backgroundColor(Color.Gray).fontColor(Color.White)
            .height(50).borderRadius(8).margin({ horizontal: 2 })
            .layoutWeight(1.5)
            // In a real OpenHarmony app, you would use an InputMethod API call to request a subtype switch here
            .onClick(() => console.log('Triggered system language switch'))

          // 4. Enter Key
          Button('↵')
            .backgroundColor(Color.Blue).fontColor(Color.White)
            .height(50).borderRadius(8).margin({ horizontal: 2 })
            .layoutWeight(2)
            // Sending a key event with the "Enter" code (22) to the app
            .onClick(() => this.inputContext.sendKeyboardEvent(22))

        }
        .justifyContent(FlexAlign.Center)
        .padding({ bottom: 10, top: 5 })
        .width('100%')

      }
      .backgroundColor(0xDDDDDD)
    }
    .width('100%')
  }
}
