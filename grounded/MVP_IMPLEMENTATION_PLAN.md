# Pact MVP Implementation Plan

> **For agentic workers:** Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Menerjemahkan `PRODUCT_BRIEF.md` menjadi roadmap implementasi MVP yang jelas, dengan milestone pertama fokus ke `coded UI` dan milestone kedua fokus ke `functionality`.

**Architecture:** App dibangun sebagai iOS app offline-first berbasis SwiftUI. Tahap awal hanya menyusun alur layar, komponen visual, dan navigasi dummy agar user flow terlihat utuh; setelah itu baru diisi data model, persistence, timer, break detection, notification, dan Live Activity.

**Tech Stack:** SwiftUI, SwiftData, ActivityKit, WidgetKit, UserNotifications, App Lifecycle / ScenePhase, Haptics

---

## Feature List MVP

### Core Features
- Onboarding yang menjelaskan konsep focus contract
- Create Focus Contract form
- Active Focus Session screen
- Live Activity untuk status sesi berjalan
- Break detection berbasis app lifecycle
- Local notification sebagai attention hook
- Consequence Replay screen saat user kembali
- Reflection Report screen setelah sesi selesai
- Local persistence untuk contract, session, dan break log

### Supporting Features
- Tone selector: `Supportive`, `Direct`, `Savage`
- Session timer dan status label
- Break duration tracking
- Summary per sesi: focus time, lost time, break count
- Haptic feedback pada momen penting

### Explicitly Out of Scope for MVP
- Login dan akun user
- Cloud sync
- Mac app
- AI chatbot
- Social / leaderboard / accountability teman
- Gamification yang kompleks
- Monitoring app tertentu di iPhone atau Mac

## Delivery Principles

- Milestone 1 harus menghasilkan flow UI yang terasa end-to-end walau masih pakai mock data.
- Milestone 2 baru menghubungkan semua layar ke state, persistence, dan lifecycle asli.
- Semua scope harus tetap jujur secara teknis: app mendeteksi `focus break`, bukan isi distraksinya.
- Prioritaskan loop utama: `create contract -> start focus -> break -> replay -> report`.

## Milestone 1: Coded UI

**Outcome:** Semua screen utama sudah terbangun, bisa dinavigasi, dan merepresentasikan user flow penuh dengan dummy data.

### Task 1: Foundation UI
- [x] Tentukan visual direction minimalis dan Apple-native untuk seluruh app.
- [x] Buat struktur navigasi utama aplikasi.
- [x] Definisikan reusable styles dasar: spacing, color roles, typography, button style, card style.
- [x] Siapkan preview/mock model agar setiap screen bisa dirender tanpa logic backend.

### Task 2: Onboarding Screen
- [x] Buat layar onboarding dengan copy singkat tentang “focus is a promise, not just a timer”.
- [x] Tambahkan CTA utama untuk masuk ke flow pembuatan contract.
- [x] Pastikan layout nyaman di iPhone portrait dan mudah discan.

### Task 3: Create Focus Contract Screen
- [x] Buat form UI untuk `task`, `duration`, `why it matters`, `consequence`, dan `tone`.
- [x] Tambahkan state visual untuk empty, filled, dan disabled CTA.
- [x] Susun hierarchy form agar field paling penting terlihat dulu.
- [x] Tambahkan preview tone secara visual agar user paham perbedaannya.

### Task 4: Active Focus Session Screen
- [x] Buat layar fokus aktif dengan timer besar, task title, short reason, dan status label.
- [x] Tambahkan area yang menunjukkan sesi sedang berjalan tanpa distraksi visual berlebih.
- [x] Siapkan variasi tampilan untuk `active`, `paused/break`, dan `completed`.

### Task 5: Break Alert and Consequence Replay UI
- [x] Rancang tampilan preview untuk notifikasi lokal: title + body singkat.
- [x] Buat Consequence Replay screen dengan `break duration`, `why it matters`, `consequence message`, dan CTA `Resume` / `End Session`.
- [x] Pastikan emotional intervention terasa personal, bukan generik.

### Task 6: Reflection Report Screen
- [x] Buat layar report dengan `focused time`, `lost time`, `break count`, dan session summary.
- [x] Tambahkan CTA `Start New Session`.
- [x] Pastikan layout cukup fleksibel untuk angka kecil maupun besar.

### Task 7: Live Activity UI Preparation
- [x] Definisikan tampilan ringkas untuk Live Activity: task summary, timer, status.
- [x] Pastikan informasi penting tetap terbaca dalam ruang yang sempit.
- [x] Siapkan placeholder/mock rendering agar desainnya tervalidasi sebelum logic dibuat.

### Task 8: End-to-End UI Flow
- [x] Hubungkan semua screen dengan navigasi dummy.
- [x] Pastikan demo flow lengkap berjalan: onboarding -> create contract -> active session -> break replay -> reflection report.
- [x] Review konsistensi copy, spacing, CTA labels, dan state antar layar.

## Milestone 2: Functionality

**Outcome:** UI yang sudah jadi mulai memakai data dan lifecycle nyata, sehingga loop utama produk berfungsi secara end-to-end di device.

### Task 1: Data Model and Persistence
- [x] Implementasikan model `FocusContract`, `FocusSession`, `FocusBreak`, `ToneType`, dan `SessionStatus`.
- [x] Simpan semuanya dengan SwiftData.
- [x] Definisikan relasi yang jelas antara contract, session, dan break log.

### Task 2: Contract Creation Logic
- [x] Hubungkan form contract ke model nyata.
- [x] Tambahkan validasi minimum agar user tidak bisa memulai sesi kosong.
- [x] Simpan contract baru sebelum sesi dimulai.

### Task 3: Session Start and Timer Logic
- [x] Implementasikan aksi `Start Focus`.
- [x] Buat session baru dengan `startedAt`, `status`, dan target duration.
- [x] Jalankan timer/session state yang tetap akurat saat app berpindah lifecycle.

### Task 4: Break Detection
- [x] Gunakan `scenePhase` / app lifecycle untuk mendeteksi saat user keluar dari fokus aktif.
- [x] Catat `breakStartedAt` ketika sesi terinterupsi.
- [x] Saat user kembali, tutup break aktif dan hitung durasinya.

### Task 5: Local Notification
- [x] Minta izin notifikasi lokal.
- [x] Tentukan trigger notification ketika break dimulai atau setelah delay pendek yang terdefinisi.
- [x] Bangun generator copy notification berdasarkan `why it matters`, `consequence`, dan `tone`.

### Task 6: Consequence Replay Logic
- [x] Tampilkan Consequence Replay screen otomatis saat user kembali dari break.
- [x] Isi data real: break duration, reminder text, dan consequence line.
- [x] Implementasikan aksi `Resume Focus` dan `End Session`.

### Task 7: Session Summary Calculation
- [x] Hitung `totalFocusSeconds`, `totalBreakSeconds`, dan `breakCount`.
- [x] Pastikan kalkulasi aman untuk sesi yang berakhir normal maupun dihentikan manual.
- [x] Kirim data hasil kalkulasi ke Reflection Report screen.

### Task 8: Live Activity Integration
- [x] Sambungkan Active Focus Session ke ActivityKit.
- [x] Update timer, task summary, dan status selama sesi berjalan.
- [x] Hentikan Live Activity saat sesi selesai.

### Task 9: Haptics and Micro Feedback
- [x] Tambahkan haptic saat start focus, resume focus, dan end session.
- [x] Pastikan feedback terasa membantu, bukan mengganggu.

### Task 10: Offline Reliability and Recovery
- [x] Pastikan sesi tetap recoverable setelah app ditutup dan dibuka lagi.
- [x] Handle state yang belum selesai: active session, active break, atau completed session.
- [x] Verifikasi semua flow inti tetap berjalan tanpa internet.

## Milestone 3: Polish and QA

**Outcome:** MVP siap diuji secara serius dan lebih aman untuk didemokan.

### Task 1: Copy and Tone Review
- [x] Audit semua copy agar tetap personal, singkat, dan konsisten dengan tone yang dipilih.
- [x] Pastikan tone `Savage` tetap tegas tanpa terasa tidak pantas.

### Task 2: Edge Cases
- [x] Uji sesi yang selesai tepat waktu.
- [x] Uji user keluar-masuk app berulang kali.
- [x] Uji user mengakhiri sesi ketika sedang dalam break.
- [x] Uji state notifikasi ditolak user.

### Task 3: Visual and Interaction QA
- [x] Rapikan spacing, safe area, loading/state transitions, dan accessibility dasar.
- [x] Verifikasi seluruh screen tetap nyaman di berbagai ukuran iPhone.

### Task 4: Demo Readiness
- [x] Siapkan sample contract dan sample session untuk kebutuhan demo.
- [x] Pastikan loop utama bisa dipresentasikan kurang dari 2 menit.

## Next Phase Backlog

**Goal:** Menyiapkan transisi dari MVP yang stabil ke produk yang lebih siap diuji berulang dan dikembangkan tanpa regresi.

### Engineering Follow-Ups
- [ ] Tambahkan `Unit Tests` atau `UITests` untuk flow inti: start session, break detection, replay, end session, dan recovery.
- [ ] Pisahkan state-machine session ke layer yang lebih mudah dites tanpa harus bergantung penuh pada SwiftUI lifecycle.
- [ ] Tambahkan instrumentation ringan untuk debugging lifecycle dan notification state di build debug.

### Product Follow-Ups
- [ ] Tambahkan onboarding state agar user lama tidak selalu kembali ke layar onboarding.
- [ ] Pertimbangkan histori sesi sederhana agar reflection tidak hanya tersedia untuk sesi terakhir.
- [ ] Evaluasi apakah user perlu opsi edit contract saat sesi masih aktif atau tetap dikunci.

### Demo and Research Follow-Ups
- [ ] Siapkan skenario demo formal untuk tiga tone: `Supportive`, `Direct`, dan `Savage`.
- [ ] Jalankan validasi produk kecil untuk mengecek apakah replay benar-benar terasa personal dan cukup kuat mengintervensi.

## Recommended Execution Order

1. Selesaikan seluruh `Milestone 1: Coded UI` sampai flow dummy terasa utuh.
2. Masuk ke `Milestone 2: Functionality` dimulai dari data model, contract creation, dan timer/session state.
3. Lanjutkan ke break detection, notification, dan consequence replay karena ini adalah pembeda utama produk.
4. Tutup dengan reflection report, Live Activity, dan polish QA.

## Definition of Done per Milestone

### Milestone 1 Done If
- Semua screen utama sudah ada.
- Navigasi dummy end-to-end berjalan.
- Dummy content sudah cukup untuk demo produk.

### Milestone 2 Done If
- User bisa membuat contract nyata dan memulai sesi.
- Break bisa tercatat dan ditampilkan kembali sebagai consequence replay.
- Reflection report dan persistence berjalan di device.

### Milestone 3 Done If
- Flow inti stabil untuk diuji.
- Copy, edge case, dan presentasi visual sudah rapi.
- MVP siap dipakai untuk validasi produk lebih lanjut.
