# Raf Ustası Mini

Bilgisayarsız ilerlemek için hazırlanmış Godot 4.3 MVP oyun projesidir.

## Oyun

- Tür: Goods Sort / Raf Düzenleme Puzzle
- Platform: Android
- Motor: Godot 4.3
- İlk hedef: GitHub Actions ile test APK üretmek

## İçerik

- Ana menü
- Oyun ekranı
- 3 raflı ürün seçme mantığı
- 7 slot sistemi
- 3 aynı ürün eşleşince silme
- Slot dolarsa kaybetme
- Bölüm bitince otomatik sonraki bölüme geçme
- 20 örnek bölüm
- Basit coin sistemi

## Telefonda GitHub'a yükleme

1. GitHub reposunu aç.
2. `Add file > Upload files` seç.
3. Bu klasördeki tüm dosya ve klasörleri yükle.
4. Commit yap.
5. Üst menüden `Actions` sekmesine gir.
6. `Build Android APK` workflow'unu aç.
7. `Run workflow` de.
8. İşlem bitince `Artifacts` bölümünden `RafUstasiMini-debug-apk` dosyasını indir.

## Önemli

Bu ilk paket mağazaya doğrudan yayınlanacak final ürün değildir. Önce APK alıp telefonda çalıştığını doğrulamak içindir.
Play Store için sonraki aşamada kalıcı release keystore, AAB üretimi, gizlilik politikası, AdMob ve mağaza görselleri eklenmelidir.

## Sonraki geliştirme sırası

1. APK build doğrulama
2. UI görsel kalite artırma
3. Booster sistemi: Undo, Hint, Shuffle, Extra Slot
4. AdMob rewarded/interstitial reklam entegrasyonu
5. AAB release build workflow
6. Play Store sayfa metinleri ve görseller
