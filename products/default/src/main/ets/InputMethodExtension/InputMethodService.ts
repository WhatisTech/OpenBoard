import InputMethodExtensionAbility from '@ohos.inputMethodExtensionAbility';
import InputMethod from '@ohos.inputMethod';
import hilog from '@ohos.hilog';

const TAG = '[PolishIME-Service]';
const DOMAIN_LOG = 0x0020;

export default class InputMethodService extends InputMethodExtensionAbility {
  private customInputPanel: any = null;

  onCreate() {
    hilog.info(DOMAIN_LOG, TAG, 'InputMethodService onCreate');
  }

  onDestroy() {
    hilog.info(DOMAIN_LOG, TAG, 'InputMethodService onDestroy');
  }

  onStartInputView(_info: InputMethod.InputAttribute): void {
    hilog.info(DOMAIN_LOG, TAG, 'onStartInputView called');

    if (this.customInputPanel) {
      (this.customInputPanel as any).showInputPanel(true);
      return;
    }

    let context = (this as any).getInputPanelUIContext();
    if (context) {
      this.customInputPanel = context;

      const keyboardLayoutPath = 'KeyboardLayout';
      (this.customInputPanel as any).loadContent(keyboardLayoutPath, (err: any) => {
        if (err.code === 0) {
          hilog.info(DOMAIN_LOG, TAG, 'KeyboardLayout loaded successfully.');

          let rootComponent = (this.customInputPanel as any).getComponentById('keyboardRoot');

          if (rootComponent) {
            (rootComponent as any).inputContext = (this as any).getInputMethodEngineContext();
          } else {
            hilog.error(DOMAIN_LOG, TAG, 'Failed to find keyboardRoot component.');
          }

          (this.customInputPanel as any).showInputPanel(true);
        } else {
          hilog.error(DOMAIN_LOG, TAG, `Failed to load KeyboardLayout. Error: ${err.message}`);
        }
      });
    } else {
      hilog.error(DOMAIN_LOG, TAG, 'Failed to get InputPanelUIContext.');
    }
  }

  onStopInputView(): void {
    (this.customInputPanel as any)?.showInputPanel(false);
  }

  onHideInput(): void {
    (this.customInputPanel as any)?.showInputPanel(false);
  }
}