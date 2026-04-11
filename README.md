<img src="images/showUI_banner.png"/>

<br/>

> **iOS development, Shown - not told.**

ShowUI is an interactive learning app for iOS developers. Every concept has its own lesson. Every lesson has a live, tappable visual at the top. No slides. No passive reading. You tap, drag, toggle, and watch it happen in real time.

## Screenshots

<table>
  <tr>
    <td width="25%"><img src="images/collections.png" width="100%"/></td>
    <td width="25%"><img src="gifs/concurrency.gif" width="100%"/></td>
    <td width="25%"><img src="gifs/animation.gif" width="100%"/></td>
    <td width="25%"><img src="gifs/sfSymbol.gif" width="100%"/></td>
  </tr>
  <tr>
    <td width="25%"><img src="gifs/buttons.gif" width="100%"/></td>
    <td width="25%"><img src="gifs/blendMode.gif" width="100%"/></td>
    <td width="25%"><img src="gifs/masking.gif" width="100%"/></td>
    <td width="25%"><img src="gifs/keyboard.gif" width="100%"/></td>
  </tr>
</table>

## What's inside

57 lessons across 7 topics. Every one built to be felt, not just read.

| Topic | Lessons | Highlights |
|---|:---:|---|
| **Alerts & Popovers** | 8 | Alert, confirmationDialog, sheet, popover, fullScreenCover |
| **Animations** | 17 | Springs, keyframes, phase animator, scroll effects, TimelineView particles, GeometryEffect |
| **Animations Deep Dive** | 8 | Springs, timing, transitions, keyframes, phase animators and custom |
| **Blend Modes** | 7 | All 20 blend modes with live color picker and category breakdown |
| **Bottom Sheets** | 9 | Detents, drag indicators, background interaction and more |
| **Buttons** | 10 | Loading states, toggle patterns, menus, haptics, custom styles, hit testing |
| **Colors & Gradients** | 8 | Color system, gradients, materials, opacity and dynamic color |
| **Concurrency** | 8 | Race conditions you can trigger, actors with a lock animation, live task cancellation |
| **Controls Deep Dive** | 8 | Toggle, Picker, Slider, Stepper controls - styles, customisation and real-world patterns |
| **Forms & SettingsUI** | 8 | Form, Section, Picker, Toggle, Slider and validation patterns |
| **Gestures** | 8 | Tap, drag, pinch, rotate and composing complex interactions |
| **Grids** | 8 | LazyVGrid, LazyHGrid, Grid, columns, alignment and performance |
| **Geometry Reader** | 8 | Size-adaptive layouts, coordinate spaces, anchor preferences and proxies |
| **Images & AsyncImage** | 8 | Resizable, aspect ratio, clipping, filters and async loading |
| **Keyboard** | 6 | Every keyboard type, focus chaining, avoidance modes side by side |
| **List & ForEach** | 8 | Dynamic lists, swipe actions, edit mode, sections and performance |
| **Masking** | 9 | Clip shapes, gradient fade, inverted mask, animated reveal, path mask |
| **Navigation Stack** | 8 | Typed navigation, paths, deep linking, toolbars and split views |
| **ScrollView & Scroll APIs** | 8 | Scroll axes, offsets, paging, transitions, targets and scroll position |
| **SF Symbols** | 10 | Searchable browser with 300+ symbols, rendering modes, variable color, layer toggle |
| **Stacks & Spacer** | 8 | Layout fundamentals: HStack, VStack, ZStack, frame, alignment |
| **State & Binding** | 8 | How SwiftUI views own, share and react to data changes |
| **Shapes & Paths** | 8 | Built-in shapes, custom paths, stroke, fill, trim and animation |
| **Text & Typography** | 6 | Fonts, markdown formatting, trunction and advanced styling |
| **TextField Deep Dive** | 8 | Focus, formatting, validation, keyboard, secure fields and custom styles |
| **TabView & Tab Bars** | 8 | Tab navigation, paging, badges, customisation and sidebar on iPad |
| **ViewModifiers** | 8 | Custom modifiers, modifier order, conditional styling and reuse |

## Lesson Structure

```
┌─────────────────────────────────┐
│                                 │
│   Interactive visual            │  ← tap it, drag it, trigger it
│   (always at the top)           │
│                                 │
├─────────────────────────────────┤
│                                 │
│   Plain-language explanation    │  ← what's happening and why
│                                 │
├─────────────────────────────────┤
│                                 │
│   func path(in rect: CGRect)    │  ← the actual Swift, no boilerplate
│       → Path { ... }            │
│                                 │
└─────────────────────────────────┘
```

> Every lesson follows this structure. The visual comes first you form an intuition before you read the explanation. The code at the bottom is copy paste ready.


## Built for all levels

ShowUI isn't just for beginners. The Animations topic covers `KeyframeAnimator`, `GeometryEffect`, `TimelineView`, `DrawingGroup`, and `Transaction`. APIs that most experienced developers haven't fully explored. The SF Symbols topic has a full searchable browser and covers `variableValue:`, layered rendering modes, and custom symbol import.

If you already know SwiftUI, you'll still find something new.

## Contributing

Found a bug? Have a topic idea? Open an issue or submit a pull request. If you can write a SwiftUI view, you can add a lesson.

## License

This project is source available. See the LICENSE file for full details.