import { ResponsiveLayout } from './ResponsiveLayout';

/**
 * ResponsiveIndex is the entry of the responsive layout pages.
 */
@Entry
@Component
struct ResponsiveIndex {
  build() {
    Column() {
      ResponsiveLayout()
    }
  }
}