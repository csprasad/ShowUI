<img src="images/showUI_banner.png"/>

# ShowUI

**ShowUI** is an iOS app for developers who learn by doing. Every concept gets its own interactive lesson — not a static explanation, but a live visual you can tap, trigger, and watch unfold.

## Screenshots(gifs)

<table>
  <tr>
    <td width="25%"><img src="images/collections.png" width="100%"/></td>
    <td width="25%"><img src="gifs/concurrency.gif" width="100%"/></td>
    <td width="25%"><img src="gifs/keyboard.gif" width="100%"/></td>
    <td width="25%"><img src="gifs/blendMode.gif" width="100%"/></td>
  </tr>
  <tr>
    <td width="25%"><img src="gifs/masking.gif" width="100%"/></td>
  </tr>
</table>

## What's inside

ShowUI covers iOS and Swift concepts across UI, concurrency, input, and visual effects. Each topic is broken into focused lessons with an interactive visual at the top and a plain-language explanation below.

| Topic | What you'll learn |
|---|---|
| **Concurrency** | Sequential vs concurrent execution, race conditions, actors, async let, task groups, cancellation, Sendable |
| **Keyboard** | All keyboard types, focus management, avoidance, input validation, toolbar, return key |
| **Buttons** | Default styles, custom styles, roles, loading states |
| **Blend Modes** | Every compositing mode shown side by side with live controls |
| **Masking** | Clip shapes, masks, reveal animations |
| **Bottom Sheets** | Detents, drag indicators, custom presentations |

More topics added regularly.

## How it works
Every lesson follows the same structure:

- **Visual first**: an animated, interactive demo you can control
- **Explanation below**: plain-language breakdown of what's happening and why
- **Code at the bottom**: the actual Swift you'd write, no boilerplate

The architecture is protocol-driven. Adding a new topic means creating one folder and one registration line. Nothing else changes.

## Contributing

Found a bug or want to add a topic? Open an issue or submit a pull request. New topics follow the existing pattern — each lesson needs a visual view, an explanation view, and a registration entry in `TopicRegistry`.

For questions, suggestions, or feature requests, open an issue or reach out directly.

## License

This project is licensed under the Apache License 2.0.
