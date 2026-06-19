---
name: Modern Ethos
colors:
  surface: '#f8f9fa'
  surface-dim: '#d9dadb'
  surface-bright: '#f8f9fa'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f4f5'
  surface-container: '#edeeef'
  surface-container-high: '#e7e8e9'
  surface-container-highest: '#e1e3e4'
  on-surface: '#191c1d'
  on-surface-variant: '#464555'
  inverse-surface: '#2e3132'
  inverse-on-surface: '#f0f1f2'
  outline: '#777587'
  outline-variant: '#c7c4d8'
  surface-tint: '#4c42e9'
  primary: '#493ee5'
  on-primary: '#ffffff'
  primary-container: '#635bff'
  on-primary-container: '#fefaff'
  inverse-primary: '#c3c0ff'
  secondary: '#5f5d69'
  on-secondary: '#ffffff'
  secondary-container: '#e4e0ef'
  on-secondary-container: '#65636f'
  tertiary: '#555b63'
  on-tertiary: '#ffffff'
  tertiary-container: '#6e747c'
  on-tertiary-container: '#fafaff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e2dfff'
  primary-fixed-dim: '#c3c0ff'
  on-primary-fixed: '#0f0069'
  on-primary-fixed-variant: '#321ed2'
  secondary-fixed: '#e4e0ef'
  secondary-fixed-dim: '#c8c5d3'
  on-secondary-fixed: '#1b1a25'
  on-secondary-fixed-variant: '#474551'
  tertiary-fixed: '#dde3ec'
  tertiary-fixed-dim: '#c1c7d0'
  on-tertiary-fixed: '#161c23'
  on-tertiary-fixed-variant: '#41474f'
  background: '#f8f9fa'
  on-background: '#191c1d'
  surface-variant: '#e1e3e4'
typography:
  headline-lg:
    fontFamily: Manrope
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Manrope
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Manrope
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Manrope
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-caps:
    fontFamily: Hanken Grotesk
    fontSize: 12px
    fontWeight: '700'
    lineHeight: 16px
    letterSpacing: 0.05em
  label-sm:
    fontFamily: Hanken Grotesk
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  container-padding: 1.5rem
  stack-gap: 1rem
  section-gap: 2.5rem
  gutter: 1rem
  inner-padding-sm: 0.75rem
  inner-padding-md: 1.25rem
---

## Brand & Style

The design system evolves the original prototype into a **Corporate / Modern** aesthetic that balances technical precision with high-end accessibility. It targets professionals who require clarity in data-dense environments while demanding the visual polish of a premium consumer app.

The UI evokes an emotional response of **composed efficiency**. We achieve this by moving away from basic Material components toward a bespoke, editorialized layout. The style relies on **refined minimalism**: high-quality typography, a restricted but sophisticated color palette, and a focus on content hierarchy over decorative elements. Whitespace is used aggressively to reduce cognitive load and provide a "breathable" interface.

## Colors

This design system uses a palette rooted in a modernized **Vibrant Lavender**. The primary color is a high-chroma purple that signifies action and focus. 

- **Primary (#635BFF):** Used for key actions, focus states, and brand identifiers.
- **Secondary (#F4F0FF):** A soft, desaturated lavender used for large background areas, subtle highlights, and light-mode card surfaces to provide a more sophisticated alternative to pure white.
- **Tertiary (#2D333A):** A deep charcoal for high-contrast text and structural elements.
- **Neutral (#F9FAFB):** Cool grays for borders, inactive states, and secondary text levels.

The color mode is strictly **light**, utilizing tonal shifts in the background to create natural separation between content blocks.

## Typography

We use **Manrope** as the primary typeface for its modern, geometric construction and exceptional readability. It provides a technical yet friendly tone. **Hanken Grotesk** is used for utility labels and captions to provide a sharp, functional contrast to the softer body text.

Large headlines utilize negative letter spacing to feel more "locked-in" and editorial. Body text is prioritized for legibility with generous line heights. Micro-labels are often presented in uppercase with tracked-out spacing to signify metadata clearly.

## Layout & Spacing

This design system employs a **fluid grid** optimized for mobile-first interaction. 

- **Safe Zones:** A standard 24px (1.5rem) horizontal margin is maintained on all mobile screens to prevent content from hitting the edges.
- **Vertical Rhythm:** Content follows an 8px base unit. Section spacing (40px) is significantly larger than component spacing (16px) to create clear visual clusters.
- **Card-Based Architecture:** Information is grouped into cards that span the full width of the safe-zone container.
- **Density:** We prefer a "Comfortable" density, allowing elements to breathe rather than cramming data.

## Elevation & Depth

Depth is achieved through **tonal layering** and **ambient shadows** rather than physical skeuomorphism.

- **Primary Layer:** The main background uses the Neutral (#F9FAFB) color.
- **Secondary Layer:** Cards and interactive containers use White (#FFFFFF).
- **Shadow Profile:** We use a "Soft-Focus" shadow: `0 8px 24px rgba(99, 91, 255, 0.08)`. This adds a slight primary-color tint to the shadow, making the interface feel cohesive and vibrant rather than muddy with gray shadows.
- **Interaction:** On press, elements lose their shadow and scale slightly (98%) to simulate physical depression.

## Shapes

The shape language is **Rounded**, moving away from the sharper, default look of the original prototype.

- Standard components (Inputs, Buttons) use a **0.5rem (8px)** radius.
- Larger containers and cards use a **1rem (16px)** radius to feel approachable.
- Icons and small badges use a fully circular (Pill) treatment to differentiate them from functional UI blocks.

## Components

### Buttons
- **Primary:** Solid Primary (#635BFF) fill with White text. No border.
- **Secondary:** Secondary (#F4F0FF) fill with Primary text.
- **Sizing:** Minimum height of 48px for touch targets.

### Input Fields
- **Modernized Style:** Unlike the underlined prototype, we use fully enclosed boxes with a 1px border (#E5E7EB). 
- **Focus State:** Border changes to Primary (#635BFF) with a 2px thickness and a subtle outer glow.
- **Labels:** Floating labels or top-aligned labels in `label-caps` typography.

### Cards
- **Structure:** White background, 16px corner radius, and the Soft-Focus shadow.
- **List Items:** Within cards, items are separated by a 1px hair-line (#F3F4F6) with 16px of vertical padding.

### Chips & Badges
- **Status:** Small, pill-shaped indicators with low-opacity Primary backgrounds and high-opacity Primary text.

### Floating Action Button (FAB)
- Elevated with a more pronounced shadow. Uses the Primary color and a 16px radius rather than a perfect circle to match the new shape language.