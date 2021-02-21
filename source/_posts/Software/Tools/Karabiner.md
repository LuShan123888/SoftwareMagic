---
title: Karabiner
categories:
- Software
- Tools
---
# Karabiner

## 配置

- `~/.config/karabiner/assets/complex_modifications/PunctuationConverter.json`

```json
{
  "title": "input Chinese punctuation convert to English",
  "rules": [
    {
      "description": "Simplity-Input Chinese punctuation convert to English",
      "manipulators": [
        {
          "conditions": [{"input_sources": [{"language": "zh-Hans"}],"type": "input_source_if"}],
          "type": "basic",
          "from": {
            "key_code": "comma",
            "modifiers": {"mandatory": ["left_shift"]}
          },
          "to": [
            {"key_code": "caps_lock"},
            {
              "key_code": "comma",
              "modifiers": ["left_shift"]
            },
            {"key_code": "caps_lock"}
          ]
        },
        {
          "conditions": [{"input_sources": [{"language": "zh-Hans"}],"type": "input_source_if"}],
          "type": "basic",
          "from": {
            "key_code": "comma",
            "modifiers": {"mandatory": ["right_shift"]}
          },
          "to": [
            {"key_code": "caps_lock"},
            {
              "key_code": "comma",
              "modifiers": ["right_shift"]
            },
            {"key_code": "caps_lock"}
          ]
        },
        {
          "conditions": [{"input_sources": [{"language": "zh-Hans"}],"type": "input_source_if"}],
          "type": "basic",
          "from": {
            "key_code": "period",
            "modifiers": {"mandatory": ["left_shift"]}
          },
          "to": [
            {"key_code": "caps_lock"},
            {
              "key_code": "period",
              "modifiers": ["left_shift"]
            },
            {"key_code": "caps_lock"}
          ]
        },
        {
          "conditions": [{"input_sources": [{"language": "zh-Hans"}],"type": "input_source_if"}],
          "type": "basic",
          "from": {
            "key_code": "period",
            "modifiers": {"mandatory": ["right_shift"]}
          },
          "to": [
            {"key_code": "caps_lock"},
            {
              "key_code": "period",
              "modifiers": ["right_shift"]
            },
            {"key_code": "caps_lock"}
          ]
        },
        {
          "conditions": [{"input_sources": [{"language": "zh-Hans"}],"type": "input_source_if"}],
          "type": "basic",
          "from": {
            "key_code": "semicolon",
            "modifiers": {"mandatory": ["left_shift"]}
          },
          "to": [
            {"key_code": "caps_lock"},
            {
              "key_code": "semicolon",
              "modifiers": ["left_shift"]
            },
            {"key_code": "caps_lock"}
          ]
        },
        {
          "conditions": [{"input_sources": [{"language": "zh-Hans"}],"type": "input_source_if"}],
          "type": "basic",
          "from": {
            "key_code": "semicolon",
            "modifiers": {"mandatory": ["right_shift"]}
          },
          "to": [
            {"key_code": "caps_lock"},
            {
              "key_code": "semicolon",
              "modifiers": ["right_shift"]
            },
            {"key_code": "caps_lock"}
          ]
        },
        {
          "conditions": [{"input_sources": [{"language": "zh-Hans"}],"type": "input_source_if"}],
          "type": "basic",
          "from": {
            "key_code": "quote"
          },
          "to": [
            {"key_code": "caps_lock"},
            {
              "key_code": "quote"
            },
            {"key_code": "caps_lock"}
          ]
        },
        {
          "conditions": [{"input_sources": [{"language": "zh-Hans"}],"type": "input_source_if"}],
          "type": "basic",
          "from": {
            "key_code": "quote",
            "modifiers": {"mandatory": ["right_shift"]}
          },
          "to": [
            {"key_code": "caps_lock"},
            {
              "key_code": "quote",
              "modifiers": ["right_shift"]
            },
            {"key_code": "caps_lock"}
          ]
        },
        {
          "conditions": [{"input_sources": [{"language": "zh-Hans"}],"type": "input_source_if"}],
          "type": "basic",
          "from": {
            "key_code": "quote",
            "modifiers": {"mandatory": ["left_shift"]}
          },
          "to": [
            {"key_code": "caps_lock"},
            {
              "key_code": "quote",
              "modifiers": ["left_shift"]
            },
            {"key_code": "caps_lock"}
          ]
        },
        {
          "conditions": [{"input_sources": [{"language": "zh-Hans"}],"type": "input_source_if"}],
          "type": "basic",
          "from": {
            "key_code": "open_bracket",
            "modifiers": {"mandatory": ["right_shift"]}
          },
          "to": [
            {"key_code": "caps_lock"},
            {
              "key_code": "open_bracket",
              "modifiers": ["right_shift"]
            },
            {"key_code": "caps_lock"}
          ]
        },
        {
          "conditions": [{"input_sources": [{"language": "zh-Hans"}],"type": "input_source_if"}],
          "type": "basic",
          "from": {
            "key_code": "open_bracket",
            "modifiers": {"mandatory": ["left_shift"]}
          },
          "to": [
            {"key_code": "caps_lock"},
            {
              "key_code": "open_bracket",
              "modifiers": ["left_shift"]
            },
            {"key_code": "caps_lock"}
          ]
        },
        {
          "conditions": [{"input_sources": [{"language": "zh-Hans"}],"type": "input_source_if"}],
          "type": "basic",
          "from": {
            "key_code": "close_bracket",
            "modifiers": {"mandatory": ["right_shift"]}
          },
          "to": [
            {"key_code": "caps_lock"},
            {
              "key_code": "close_bracket",
              "modifiers": ["right_shift"]
            },
            {"key_code": "caps_lock"}
          ]
        },
        {
          "conditions": [{"input_sources": [{"language": "zh-Hans"}],"type": "input_source_if"}],
          "type": "basic",
          "from": {
            "key_code": "close_bracket",
            "modifiers": {"mandatory": ["left_shift"]}
          },
          "to": [
            {"key_code": "caps_lock"},
            {
              "key_code": "close_bracket",
              "modifiers": ["left_shift"]
            },
            {"key_code": "caps_lock"}
          ]
        },
        {
          "conditions": [{"input_sources": [{"language": "zh-Hans"}],"type": "input_source_if"}],
          "type": "basic",
          "from": {
            "key_code": "backslash"
          },
          "to": [
            {"key_code": "caps_lock"},
            {
              "key_code": "backslash"
            },
            {"key_code": "caps_lock"}
          ]
        },
        {
          "conditions": [{"input_sources": [{"language": "zh-Hans"}],"type": "input_source_if"}],
          "type": "basic",
          "from": {
            "key_code": "hyphen",
            "modifiers": {"mandatory": ["left_shift"]}
          },
          "to": [
            {"key_code": "caps_lock"},
            {
              "key_code": "hyphen",
              "modifiers": ["left_shift"]
            },
            {"key_code": "caps_lock"}
          ]
        },
        {
          "conditions": [{"input_sources": [{"language": "zh-Hans"}],"type": "input_source_if"}],
          "type": "basic",
          "from": {
            "key_code": "hyphen",
            "modifiers": {"mandatory": ["right_shift"]}
          },
          "to": [
            {"key_code": "caps_lock"},
            {
              "key_code": "hyphen",
              "modifiers": ["right_shift"]
            },
            {"key_code": "caps_lock"}
          ]
        },
        {
          "conditions": [{"input_sources": [{"language": "zh-Hans"}],"type": "input_source_if"}],
          "type": "basic",
          "from": {
            "key_code": "6",
            "modifiers": {"mandatory": ["left_shift"]}
          },
          "to": [
            {"key_code": "caps_lock"},
            {
              "key_code": "6",
              "modifiers": ["left_shift"]
            },
            {"key_code": "caps_lock"}
          ]
        },
        {
          "conditions": [{"input_sources": [{"language": "zh-Hans"}],"type": "input_source_if"}],
          "type": "basic",
          "from": {
            "key_code": "6",
            "modifiers": {"mandatory": ["right_shift"]}
          },
          "to": [
            {"key_code": "caps_lock"},
            {
              "key_code": "6",
              "modifiers": ["right_shift"]
            },
            {"key_code": "caps_lock"}
          ]
        },
        {
          "conditions": [{"input_sources": [{"language": "zh-Hans"}],"type": "input_source_if"}],
          "type": "basic",
          "from": {
            "key_code": "grave_accent_and_tilde"
          },
          "to": [
            {"key_code": "caps_lock"},
            {
              "key_code": "grave_accent_and_tilde"
            },
            {"key_code": "caps_lock"}
          ]
        }
      ]
    }
  ]
}
```

- `~/.config/karabiner/assets/complex_modifications/VimArrow.json`

```json
{
  "title": "Map Left Option plus h/j/k/l to Arrows",
  "rules": [
    {
      "description": "Map Left Option plus h/j/k/l to Arrows",
      "manipulators": [
        {
          "type": "basic",
          "from": {
            "key_code": "h",
            "modifiers": {
              "mandatory": [
                "left_option"
              ],
              "optional": [
                "any"
              ]
            }
          },
          "to": [
            {
              "key_code": "left_arrow"
            }
          ]
        },
        {
          "type": "basic",
          "from": {
            "key_code": "j",
            "modifiers": {
              "mandatory": [
                "left_option"
              ],
              "optional": [
                "any"
              ]
            }
          },
          "to": [
            {
              "key_code": "down_arrow"
            }
          ]
        },
        {
          "type": "basic",
          "from": {
            "key_code": "k",
            "modifiers": {
              "mandatory": [
                "left_option"
              ],
              "optional": [
                "any"
              ]
            }
          },
          "to": [
            {
              "key_code": "up_arrow"
            }
          ]
        },
        {
          "type": "basic",
          "from": {
            "key_code": "l",
            "modifiers": {
              "mandatory": [
                "left_option"
              ],
              "optional": [
                "any"
              ]
            }
          },
          "to": [
            {
              "key_code": "right_arrow"
            }
          ]
        }
      ]
    }
  ]
}

```

