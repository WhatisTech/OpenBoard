import InputMethodExtensionAbility from '@ohos.InputMethodExtensionAbility';
import hilog from '@ohos.hilog';
import Want from '@ohos.app.ability.Want';

export default class InputMethodService extends InputMethodExtensionAbility {
  onCreate(want: Want): void {
    hilog.info(0x0000, 'OpenBoard', 'OpenBoard Keyboard Service Created');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'OpenBoard', 'OpenBoard Keyboard Service Destroyed');
  }
}