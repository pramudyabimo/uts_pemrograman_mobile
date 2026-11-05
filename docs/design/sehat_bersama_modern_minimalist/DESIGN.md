---
name: Sehat Bersama Modern Minimalist
colors:
  surface: '#f9f9ff'
  surface-dim: '#d3daef'
  surface-bright: '#f9f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f1f3ff'
  surface-container: '#e9edff'
  surface-container-high: '#e1e8fd'
  surface-container-highest: '#dce2f7'
  on-surface: '#141b2b'
  on-surface-variant: '#414754'
  inverse-surface: '#293040'
  inverse-on-surface: '#edf0ff'
  outline: '#727785'
  outline-variant: '#c1c6d6'
  surface-tint: '#005bc0'
  primary: '#005bbf'
  on-primary: '#ffffff'
  primary-container: '#1a73e8'
  on-primary-container: '#ffffff'
  inverse-primary: '#adc7ff'
  secondary: '#585f67'
  on-secondary: '#ffffff'
  secondary-container: '#dce3ec'
  on-secondary-container: '#5e656d'
  tertiary: '#9e4300'
  on-tertiary: '#ffffff'
  tertiary-container: '#c55500'
  on-tertiary-container: '#0e0200'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d8e2ff'
  primary-fixed-dim: '#adc7ff'
  on-primary-fixed: '#001a41'
  on-primary-fixed-variant: '#004493'
  secondary-fixed: '#dce3ec'
  secondary-fixed-dim: '#c0c7d0'
  on-secondary-fixed: '#151c23'
  on-secondary-fixed-variant: '#40484f'
  tertiary-fixed: '#ffdbcb'
  tertiary-fixed-dim: '#ffb691'
  on-tertiary-fixed: '#341100'
  on-tertiary-fixed-variant: '#783100'
  background: '#f9f9ff'
  on-background: '#141b2b'
  surface-variant: '#dce2f7'
  surface-pure: '#FFFFFF'
  surface-subtle: '#F9FAFB'
  surface-input: '#F3F4F6'
  border-subtle: '#E5E7EB'
  text-muted: '#6B7280'
  icon-placeholder: '#9CA3AF'
  status-success-bg: '#D1FAE5'
  status-success-text: '#059669'
  status-error-bg: '#FEE2E2'
  status-error-text: '#DC2626'
typography:
  headline-lg:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.5px
  headline-md:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 26px
    letterSpacing: -0.25px
  headline-sm:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '500'
    lineHeight: 24px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 21px
  body-sm:
    fontFamily: Inter
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
    letterSpacing: 0.2px
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1.25rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

This design system establishes a Modern Minimalist design language tailored for civic and community healthcare access. The design philosophy centers on high utility, legibility, and structural tranquility, recognizing that users interacting with public health services often require quick, stress-free access to critical facility data, routes, and emergency services.

The visual direction eliminates gratuitous decoration, reliance on heavy drop shadows, and visual noise. By leaning into generous whitespace, clean line containment, and a single high-clarity primary action color, the system evokes trust, precision, efficiency, and calm reassurance.

## Colors

The color palette operates on a strict functional hierarchy designed around maximum contrast and readability:

- **Primary Accent (`#1A73E8`):** Reserved exclusively for active touchpoints, primary call-to-action triggers, selected states, and navigational route overlays.
- **Secondary Tone (`#EFF6FF`):** A soft, low-chroma blue tint used to designate active chip filters and interactive pill highlights without overpowering the screen.
- **Neutral Foreground (`#111827`):** A refined charcoal-black that provides optimal contrast for headings and primary labels while mitigating ocular strain compared to pure `#000000`.
- **Muted Foreground (`#6B7280`):** Applied to operational details (operating hours, distances, secondary metadata, and icon strokes).
- **Backgrounds & Dividers:** The interface alternates between `#FFFFFF` for primary surfaces and `#F9FAFB` for sectional differentiation. Contours rely on `#E5E7EB` to ensure clean structural separation without requiring drop shadows.
- **Semantic Badges:** Soft pastel containers (`#D1FAE5` for open status/success, `#FEE2E2` for emergency/alert) paired with higher-contrast text values preserve calmness while communicating vital state changes immediately.

## Typography

Typographic scale is powered by Inter to ensure crisp metric clarity, high aperture readability, and neutral presentation across device densities. 

Scale discipline is maintained by constraining page titles to `headline-lg` (`24px` with `-0.5px` tracking), ensuring facility and hospital titles do not overwhelm modest screen dimensions. `body-md` (`14px` with an expanded `1.5` line height multiplier) serves as the default readable unit for descriptions, facility specs, and addresses. Small metadata, operating hours, and distance markers are mapped to `label-md` (`12px`) rendered in medium weight to preserve legibility under rapid glance conditions.

## Layout & Spacing

The layout model is optimized for mobile single-column ergonomics using strict 8pt base rhythms (4px, 8px, 16px, 24px, 32px):

- **Canvas Safe Margins:** Screens adhere to uniform horizontal gutters of `1.25rem` (`20px`) on standard smartphones, expanding to `1.5rem` (`24px`) on tablets or wider viewports.
- **Card and Item Stacks:** Repeated vertical items—such as clinic and hospital lists—maintain a consistent `space-md` (`16px`) separation.
- **Interior Component Rhythm:** Interactive cards utilize `space-md` (`16px`) internal padding to keep thumbnails, facility metadata, and badge markers uncluttered.
- **Section Spacing:** Major content blocks (e.g., category icon grids, nearby healthcare lists, and route panels) transition across `space-lg` (`24px`) to `space-xl` (`32px`) breaks, granting the user interface natural breathing room.

## Elevation & Depth

In line with Modern Minimalism, this design system avoids heavy, simulated drop shadows. Depth and visual hierarchy are instead created via two primary techniques:

1. **Flat Outline (Default):** Structural boundaries, cards, and modal panels are enclosed in razor-thin `1px solid #E5E7EB` borders over pure `#FFFFFF` or `#F9FAFB` backdrops with zero drop shadow.
2. **Subtle Ambient Depth (Overlay/Navigation Bar only):** For sticky navigation panels, map callouts, or critical floating bottom action sheets, elevation uses an ultra-faint ambient tint: `box-shadow: 0 4px 12px rgba(17, 24, 39, 0.04)`.
3. **Backdrop Layering:** System bottom-sheets, geofencing modals, and route cards lay directly on map viewports or off-white canvas surfaces, relying on pristine edges and contrast shifts rather than blurred elevation cones.

## Shapes

The design system incorporates a dual-geometry shape language:

- **Stadium / Pill Radii (`rounded-full` / `9999px`):** Utilized for all high-intent touchpoints including primary CTA buttons, quick-filter chips, and pill tabs. This creates approachable, finger-friendly hit targets.
- **Smooth Container Radii (`16px`):** Facility listing cards, search panels, sheet containers, and profile preview units utilize a uniform `16px` corner curvature, softening data displays while fitting seamlessly into the outline aesthetic.
- **Micro Radii (`8px` to `12px`):** Employed for service category icon boxes, badge labels (e.g., "Buka", "Tutup"), and contextual thumbnails.

## Components

### Buttons
- **Primary CTA:** Stadium pill geometry (`rounded-full`), solid background `#1A73E8`, label `#FFFFFF` in medium/semi-bold weight, height `48px`, zero shadow. 
- **Secondary / Filter Chips:** Stadium pill geometry, height `36px`, horizontal padding `16px`. Active state features background `#EFF6FF`, text `#1A73E8`, and no border. Inactive state features background `transparent`, border `1px solid #E5E7EB`, and text `#6B7280`.

### Facility Cards
- **Flat Outline Cards:** White `#FFFFFF` surface, `1px solid #E5E7EB` border, border-radius `16px`, internal padding `16px`. Left-aligned facility thumbnail (`72px × 72px` with `8px` corner radius) paired with facility name in `headline-sm`, metadata lines in `body-sm` (`#6B7280`), and inline status pill badges.
- **Hover/Tap State:** Visual feedback shifts background gently to `#F9FAFB` without shifting borders or applying shadows.

### Input Fields & Search Bars
- **Global Search:** Background `#F3F4F6`, border `none`, radius `12px` or pill, height `44px`. Leading search icon and placeholder rendered in `#9CA3AF`. No borders in resting state; subtle `#1A73E8` ring on focus.

### Service Category Badges
- **Icon Grid Items:** Square rounded-rect container (`48px × 48px`, radius `12px`) with light pastel or low-saturation tinted background, centering a vector line icon. Accompanied by a concise `label-md` beneath.

### Status Indicators
- **Operational Status:** Capsule badge (`px-2 py-0.5`, radius `6px`) displaying `#059669` text over `#D1FAE5` for open facilities, or `#DC2626` over `#FEE2E2` for emergency/closed notices.