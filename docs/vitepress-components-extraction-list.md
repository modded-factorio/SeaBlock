# VitePress Theme Components Extraction List

This document lists all VitePress theme components that need to be extracted for the browser bundle to support full VitePress functionality, including home layouts with hero sections and features.

## Currently Extracted Components

The following components are already extracted and working:

### Core Layout Components

- `VPContent.vue` - Main content wrapper
- `VPDoc.vue` - Documentation page layout
- `VPFooter.vue` - Site footer
- `VPLocalNav.vue` - Local navigation
- `VPNav.vue` - Main navigation
- `VPPage.vue` - Generic page layout
- `VPSidebar.vue` - Sidebar navigation
- `VPSkipLink.vue` - Skip to content link

### Other Files

- `NotFound.vue` - 404 page component
- `Layout.vue` - Main layout wrapper

## Missing Components for Home Layout Support

The following components are needed to support `layout: home` with hero sections and features:

### Home Layout Components

- `VPHome.vue` - Main home page layout
- `VPHomeHero.vue` - Hero section wrapper
- `VPHomeFeatures.vue` - Features section wrapper
- `VPHomeContent.vue` - Home page content wrapper
- `VPHomeSponsors.vue` - Sponsors section (optional)

### Hero Section Components

- `VPHero.vue` - Hero section component
- `VPButton.vue` - Action buttons in hero
- `VPImage.vue` - Hero image component

### Features Section Components

- `VPFeatures.vue` - Features grid container
- `VPFeature.vue` - Individual feature component
- `VPLink.vue` - Feature links

## Additional Components for Full Functionality

### Navigation Components

- `VPBackdrop.vue` - Mobile menu backdrop
- `VPNavBar.vue` - Navigation bar
- `VPNavBarAppearance.vue` - Dark/light mode toggle
- `VPNavBarExtra.vue` - Extra navigation items
- `VPNavBarHamburger.vue` - Mobile menu button
- `VPNavBarMenu.vue` - Navigation menu
- `VPNavBarMenuGroup.vue` - Menu group
- `VPNavBarMenuLink.vue` - Menu link
- `VPNavBarSearch.vue` - Search functionality
- `VPNavBarSearchButton.vue` - Search button
- `VPNavBarSocialLinks.vue` - Social media links
- `VPNavBarTitle.vue` - Site title
- `VPNavBarTranslations.vue` - Language switcher
- `VPNavScreen.vue` - Mobile navigation screen
- `VPNavScreenAppearance.vue` - Mobile appearance toggle
- `VPNavScreenMenu.vue` - Mobile menu
- `VPNavScreenMenuGroup.vue` - Mobile menu group
- `VPNavScreenMenuGroupLink.vue` - Mobile menu group link
- `VPNavScreenMenuGroupSection.vue` - Mobile menu group section
- `VPNavScreenMenuLink.vue` - Mobile menu link
- `VPNavScreenSocialLinks.vue` - Mobile social links
- `VPNavScreenTranslations.vue` - Mobile language switcher

### Sidebar Components

- `VPSidebarGroup.vue` - Sidebar group
- `VPSidebarItem.vue` - Sidebar item

### Documentation Components

- `VPDocAside.vue` - Documentation sidebar
- `VPDocAsideCarbonAds.vue` - Carbon ads in sidebar
- `VPDocAsideOutline.vue` - Table of contents
- `VPDocAsideSponsors.vue` - Sponsors in sidebar
- `VPDocFooter.vue` - Documentation footer
- `VPDocFooterLastUpdated.vue` - Last updated info
- `VPDocOutlineItem.vue` - TOC item

### Utility Components

- `VPBadge.vue` - Badge component
- `VPFlyout.vue` - Dropdown/flyout component
- `VPMenu.vue` - Menu component
- `VPMenuGroup.vue` - Menu group
- `VPMenuLink.vue` - Menu link
- `VPSwitch.vue` - Toggle switch
- `VPSwitchAppearance.vue` - Appearance toggle
- `VPSocialLinks.vue` - Social media links container
- `VPSocialLink.vue` - Individual social link

### Search Components

- `VPAlgoliaSearchBox.vue` - Algolia search
- `VPLocalSearchBox.vue` - Local search

### Local Navigation Components

- `VPLocalNavOutlineDropdown.vue` - Outline dropdown

### Team Page Components (Optional)

- `VPTeamPage.vue` - Team page layout
- `VPTeamPageSection.vue` - Team page section
- `VPTeamPageTitle.vue` - Team page title
- `VPTeamMembers.vue` - Team members container
- `VPTeamMembersItem.vue` - Individual team member

### Sponsors Components (Optional)

- `VPSponsors.vue` - Sponsors container
- `VPSponsorsGrid.vue` - Sponsors grid

### Ads Components (Optional)

- `VPCarbonAds.vue` - Carbon ads

## Icon Components

All icon components in the `icons/` subdirectory:

### Navigation Icons

- `VPIconArrowLeft.vue`
- `VPIconArrowRight.vue`
- `VPIconChevronDown.vue`
- `VPIconChevronLeft.vue`
- `VPIconChevronRight.vue`
- `VPIconChevronUp.vue`

### Text Alignment Icons

- `VPIconAlignJustify.vue`
- `VPIconAlignLeft.vue`
- `VPIconAlignRight.vue`

### Action Icons

- `VPIconEdit.vue`
- `VPIconHeart.vue`
- `VPIconLanguages.vue`
- `VPIconMinus.vue`
- `VPIconMinusSquare.vue`
- `VPIconPlus.vue`
- `VPIconPlusSquare.vue`

### UI Icons

- `VPIconMoon.vue`
- `VPIconSun.vue`
- `VPIconMoreHorizontal.vue`

## Priority Levels

### Critical (Required for Home Layout)

1. `VPHome.vue`
2. `VPHomeHero.vue`
3. `VPHomeFeatures.vue`
4. `VPHomeContent.vue`
5. `VPHero.vue`
6. `VPButton.vue`
7. `VPImage.vue`
8. `VPFeatures.vue`
9. `VPFeature.vue`
10. `VPLink.vue`

### Important (Required for Full Navigation)

1. `VPBackdrop.vue`
2. `VPNavBar.vue`
3. `VPNavBarHamburger.vue`
4. `VPNavBarMenu.vue`
5. `VPNavBarMenuGroup.vue`
6. `VPNavBarMenuLink.vue`
7. `VPNavBarTitle.vue`
8. `VPNavScreen.vue`
9. `VPNavScreenMenu.vue`
10. `VPNavScreenMenuGroup.vue`
11. `VPNavScreenMenuLink.vue`

### Useful (Enhanced Functionality)

1. `VPSidebarGroup.vue`
2. `VPSidebarItem.vue`
3. `VPDocAside.vue`
4. `VPDocAsideOutline.vue`
5. `VPDocOutlineItem.vue`
6. `VPDocFooter.vue`
7. `VPSwitchAppearance.vue`
8. `VPSocialLinks.vue`
9. `VPSocialLink.vue`

### Optional (Nice to Have)

1. All remaining components for full VitePress feature parity

## Extraction Script Commands

### Critical Components (Home Layout)

```bash
# Home layout components
cp node_modules/vitepress/dist/client/theme-default/components/VPHome.vue src/browser-bundle/vitepress-theme/client/theme-default/components/
cp node_modules/vitepress/dist/client/theme-default/components/VPHomeHero.vue src/browser-bundle/vitepress-theme/client/theme-default/components/
cp node_modules/vitepress/dist/client/theme-default/components/VPHomeFeatures.vue src/browser-bundle/vitepress-theme/client/theme-default/components/
cp node_modules/vitepress/dist/client/theme-default/components/VPHomeContent.vue src/browser-bundle/vitepress-theme/client/theme-default/components/

# Hero section components
cp node_modules/vitepress/dist/client/theme-default/components/VPHero.vue src/browser-bundle/vitepress-theme/client/theme-default/components/
cp node_modules/vitepress/dist/client/theme-default/components/VPButton.vue src/browser-bundle/vitepress-theme/client/theme-default/components/
cp node_modules/vitepress/dist/client/theme-default/components/VPImage.vue src/browser-bundle/vitepress-theme/client/theme-default/components/

# Features section components
cp node_modules/vitepress/dist/client/theme-default/components/VPFeatures.vue src/browser-bundle/vitepress-theme/client/theme-default/components/
cp node_modules/vitepress/dist/client/theme-default/components/VPFeature.vue src/browser-bundle/vitepress-theme/client/theme-default/components/
cp node_modules/vitepress/dist/client/theme-default/components/VPLink.vue src/browser-bundle/vitepress-theme/client/theme-default/components/
```

### Important Components (Navigation)

```bash
# Navigation components
cp node_modules/vitepress/dist/client/theme-default/components/VPBackdrop.vue src/browser-bundle/vitepress-theme/client/theme-default/components/
cp node_modules/vitepress/dist/client/theme-default/components/VPNavBar.vue src/browser-bundle/vitepress-theme/client/theme-default/components/
cp node_modules/vitepress/dist/client/theme-default/components/VPNavBarHamburger.vue src/browser-bundle/vitepress-theme/client/theme-default/components/
cp node_modules/vitepress/dist/client/theme-default/components/VPNavBarMenu.vue src/browser-bundle/vitepress-theme/client/theme-default/components/
cp node_modules/vitepress/dist/client/theme-default/components/VPNavBarMenuGroup.vue src/browser-bundle/vitepress-theme/client/theme-default/components/
cp node_modules/vitepress/dist/client/theme-default/components/VPNavBarMenuLink.vue src/browser-bundle/vitepress-theme/client/theme-default/components/
cp node_modules/vitepress/dist/client/theme-default/components/VPNavBarTitle.vue src/browser-bundle/vitepress-theme/client/theme-default/components/
cp node_modules/vitepress/dist/client/theme-default/components/VPNavScreen.vue src/browser-bundle/vitepress-theme/client/theme-default/components/
cp node_modules/vitepress/dist/client/theme-default/components/VPNavScreenMenu.vue src/browser-bundle/vitepress-theme/client/theme-default/components/
cp node_modules/vitepress/dist/client/theme-default/components/VPNavScreenMenuGroup.vue src/browser-bundle/vitepress-theme/client/theme-default/components/
cp node_modules/vitepress/dist/client/theme-default/components/VPNavScreenMenuLink.vue src/browser-bundle/vitepress-theme/client/theme-default/components/
```

### All Components (Complete Extraction)

```bash
# Extract all components at once
cp -r node_modules/vitepress/dist/client/theme-default/components/* src/browser-bundle/vitepress-theme/client/theme-default/components/
```

## Notes

1. **Dependencies**: Some components may have dependencies on others. Extract in the order listed above to avoid import errors.

2. **Icons**: The icon components are in a subdirectory and may need special handling in the extraction script.

3. **Testing**: After extraction, test the home layout functionality to ensure all components work together.

4. **Bundle Size**: Consider the impact on bundle size when extracting all components vs. just the critical ones.

5. **Maintenance**: This list should be updated when VitePress releases new components or changes existing ones.
