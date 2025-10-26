import { InputMethodExtensionAbility } from '@kit.InputMethodKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

export default class InputMethodService extends InputMethodExtensionAbility {
  onCreate(want): void {
    hilog.info(0x0000, 'PolishKeyboard', 'Polish Keyboard Service Created');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'PolishKeyboard', 'Polish Keyboard Service Destroyed');
  }
}