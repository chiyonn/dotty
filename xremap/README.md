# xremap on **sway** — Quick Reference

Copy this into your project’s **README.md** to remember the exact steps that got xremap working under Wayland + sway.

---

## 1  Prerequisites

| Action                                                                       | Command / File                                                                               |
| ---------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| Add current user to **input** group                                          | `sudo usermod -aG input $USER` → **log out / log in**                                        |
| Load `uinput` kernel module                                                  | `sudo modprobe uinput`                                                                       |
| Create udev rule for `/dev/uinput`                                           | `/etc/udev/rules.d/99-uinput.rules` :<br>\`\`\`udev                                          |
| KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static\_node=uinput" |                                                                                              |
| \`\`\` then `sudo udevadm control --reload-rules && sudo udevadm trigger`    |                                                                                              |
| Confirm permissions                                                          | `ls -l /dev/uinput` → `crw-rw---- root input …`                                              |
| Ensure sway session                                                          | `echo $XDG_SESSION_TYPE` ⇒ `wayland`  and  `echo $XDG_CURRENT_DESKTOP` ⇒ `sway`              |
| Build/Install xremap **with wlroots feature**                                | `cargo install --force xremap --features wlroots` or distro package that already includes it |

---

## 2  User‑level systemd service

`~/.config/systemd/user/xremap.service`

```ini
[Unit]
Description=Launch xremap daemon (sway)
After=graphical-session.target
PartOf=graphical-session.target

[Service]
ExecStart=/usr/bin/xremap --watch %h/.config/xremap/config.yaml
Restart=always
RestartSec=2
Environment=RUST_LOG=debug

[Install]
WantedBy=graphical-session.target
```

Activate:

```bash
systemctl --user daemon-reload
systemctl --user enable --now xremap
```

---

## 3  Minimal **config.yaml** template

```yaml
modmap:
  - name: global
    remap:
      CapsLock: Esc

keymap:
  - name: arrows-on-super
    remap:
      Super-h: Left
      Super-j: Down
      Super-k: Up
      Super-l: Right
```

### Device‑specific remaps

* Use `xremap --list-devices` to copy the **exact** device name.
* `device.only` must be **an array**:

  ```yaml
  device: { only: ["AT Translated Set 2 keyboard"] }
  ```

---

## 4  Debugging checklist

1. **Real‑time logs**
   `journalctl --user -u xremap -f`
2. Manual run for verbose output
   `RUST_LOG=debug xremap ~/.config/xremap/config.yaml`
3. Look for these lines:

   * `Loaded config file …` – config parsed
   * `Applying modmap…`, `Applying keymap…` – rules active
4. While pressing keys you should see `send_event KEY_…` entries.
5. If no remap:

   * YAML syntax error ⇒ fix indent/colon spacing
   * `device.only` mismatch ⇒ verify exact device name list
   * sway config overriding the same keys (`xkb_options`, bindsym) ⇒ comment out or adjust.

---

## 5  Never‑forget key points ✅

* **Always** be in the `input` group **and** give `/dev/uinput` write permission.
* Build xremap with **wlroots** for sway compatibility – runtime `--sway` flag does **not** exist.
* Tie the service to `graphical-session.target`; otherwise it may start before Wayland is ready.
* Use `--watch` while tweaking: instant reload on config save.
* `device.only` → exact device name(s) **inside an array**.
* First test with a *global* simple remap (e.g., `CapsLock → Esc`) before complicated layouts.
* Confirm success by seeing `Applying keymap…` in logs **and** actual key behaviour change.

---

> ✨ With this crib sheet you can resurrect your xremap setup on any fresh sway install in minutes. Enjoy perfect keyboard control!


---
# memo
Running `xremap` as a daemon service

```bash
ln -sf path/to/xremap.service ~/.config/systemd/user/xremap.service
```


