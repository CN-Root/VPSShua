
# 🌀 VPSShua | Simulate VPS Downlink Traffic | VPS Traffic Disappears

**Introduction:**  
VPSShua is a powerful tool designed to simulate VPS downlink traffic. With a stable core, flexible configuration, and interactive menu, it is perfect for bandwidth testing, network performance validation, and traffic simulation.

**One-line Installation:**  
```bash
bash <(curl -Ls https://raw.githubusercontent.com/CN-Root/VPSShua/main/install.sh)
```

---

**✨ Features:**
- ✅ Domestic/Overseas Resource Selection: Built-in high-quality static resource links with original filenames.
- ✅ Custom Traffic Limit: Set a maximum usage limit in GB; auto-stop upon reaching the cap.
- ✅ Adjustable Thread Count: Configure concurrent threads to control load pressure.
- ✅ Real-time Stats: View used traffic, request count, and runtime dynamically.
- ✅ Comprehensive Settings Menu: Includes install, update, and auto-start settings.
- ✅ Graceful Interrupt & Cleanup: Ctrl+C to stop tasks and clean temporary files.

---

**🚀 Use Cases:**
- VPS bandwidth saturation testing
- Sudden traffic simulation
- Network resource response testing
- Educational or research purposes

---

**⚠️ Note:**
- For educational and research use only. Users are solely responsible for any consequences of misuse.

---

**🧠 Technical Highlights:**
- `curl` for downloading with retry and error handling
- Multi-threaded execution via Bash arrays and subprocesses
- `awk` and `bc` for precise traffic calculation
- Clean structure for easy customization

---

**📦 Bonus:**
- Donation wallet address included at the end of the script to support development.
