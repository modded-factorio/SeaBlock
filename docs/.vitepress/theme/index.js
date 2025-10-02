import DefaultTheme from 'vitepress/theme'

import Tooltip from '../components/Tooltip.vue'
import SpriteIcon from '../components/SpriteIcon.vue'
import AnimatedSprite from '../components/AnimatedSprite.vue'
import Building from '../components/Building.vue'
import Factoriopedia from '../components/Factoriopedia.vue'

import Layout from './Layout.vue'
import './custom.css'
import './editor-styles.css'

export default {
  extends: DefaultTheme,
  Layout,
  enhanceApp({ app }) {
    // Register global components
    app.component('Tooltip', Tooltip)
    app.component('SpriteIcon', SpriteIcon)
    app.component('AnimatedSprite', AnimatedSprite)
    app.component('Building', Building)
    app.component('Factoriopedia', Factoriopedia)
  }
}
