-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 15, 2026 at 08:55 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `assessai`
--

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `dosen_id` int(11) NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`id`, `name`, `dosen_id`, `created_at`) VALUES
(1, 'TRPL 3 B - Capstone Project', 1, '2026-07-03 02:47:07.479'),
(2, 'TRPL 3 B - Topik Khusus', 1, '2026-07-11 14:47:52.755');

-- --------------------------------------------------------

--
-- Table structure for table `emotion_results`
--

CREATE TABLE `emotion_results` (
  `id` int(11) NOT NULL,
  `evaluation_id` int(11) NOT NULL,
  `emotion_label` varchar(50) NOT NULL,
  `confidence_score` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `emotion_results`
--

INSERT INTO `emotion_results` (`id`, `evaluation_id`, `emotion_label`, `confidence_score`) VALUES
(1, 1, 'neutral', 0.1322000026702881),
(2, 1, 'happy', 0.03260000050067902),
(3, 1, 'surprise', 0.03189999982714653),
(4, 1, 'disgust', 0.3375999927520752),
(5, 1, 'disappointed', 0.4657000005245209),
(6, 2, 'neutral', 0.3682000041007996),
(7, 2, 'happy', 0.04850000143051147),
(8, 2, 'surprise', 0.09929999709129333),
(9, 2, 'disgust', 0.1404999941587448),
(10, 2, 'disappointed', 0.3434000015258789),
(11, 3, 'neutral', 0.3682000041007996),
(12, 3, 'happy', 0.04850000143051147),
(13, 3, 'surprise', 0.09929999709129333),
(14, 3, 'disgust', 0.1404999941587448),
(15, 3, 'disappointed', 0.3434000015258789),
(16, 4, 'neutral', 0.3682000041007996),
(17, 4, 'happy', 0.04850000143051147),
(18, 4, 'surprise', 0.09929999709129333),
(19, 4, 'disgust', 0.1404999941587448),
(20, 4, 'disappointed', 0.3434000015258789),
(21, 5, 'neutral', 0.1322000026702881),
(22, 5, 'happy', 0.03260000050067902),
(23, 5, 'surprise', 0.03189999982714653),
(24, 5, 'disgust', 0.3375999927520752),
(25, 5, 'disappointed', 0.4657000005245209),
(26, 6, 'neutral', 0.7028999924659729),
(27, 6, 'happy', 0.1386999934911728),
(28, 6, 'surprise', 0.0115999998524785),
(29, 6, 'disgust', 0.007499999832361937),
(30, 6, 'disappointed', 0.1392000019550323),
(31, 7, 'neutral', 0.3289999961853027),
(32, 7, 'happy', 0.1168000027537346),
(33, 7, 'surprise', 0.05669999867677689),
(34, 7, 'disgust', 0.2220000028610229),
(35, 7, 'disappointed', 0.2755999863147736),
(36, 8, 'neutral', 0.4695999920368195),
(37, 8, 'happy', 0.1955000013113022),
(38, 8, 'surprise', 0.08420000225305557),
(39, 8, 'disgust', 0.120899997651577),
(40, 8, 'disappointed', 0.1297000050544739);

-- --------------------------------------------------------

--
-- Table structure for table `evaluations`
--

CREATE TABLE `evaluations` (
  `id` int(11) NOT NULL,
  `presentation_id` int(11) NOT NULL,
  `overall_score` double NOT NULL,
  `articulation_score` double NOT NULL,
  `intonation_score` double NOT NULL,
  `transcription` longtext DEFAULT NULL,
  `feedback` text DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `evaluations`
--

INSERT INTO `evaluations` (`id`, `presentation_id`, `overall_score`, `articulation_score`, `intonation_score`, `transcription`, `feedback`, `created_at`) VALUES
(1, 6, 38.56, 41.57, 63.45, '', '• Terdeteksi ekspresi kurang semangat. Tingkatkan kepercayaan diri dan antusiasme Anda.\n• Perbaiki kejelasan pengucapan kata. Latih bicara lebih perlahan dan jelas.\n• Variasi intonasi cukup baik. Tingkatkan penekanan pada poin-poin penting.\n• Kurangi penggunaan kata pengisi (seperti \'eh\', \'um\', \'anu\') untuk kesan lebih profesional.\n• Perbanyak latihan presentasi, fokus pada ekspresi suara, kejelasan, dan variasi intonasi.', '2026-06-17 03:32:27.541'),
(2, 7, 56.55, 44.29, 77.57, 'Hau semanya selama yang harus terlebih berkatuk melingsamaku. Jangan di video kali ini aku bakal kestalku, scendri, membuka seminar prokosa atau membuka sedang split si terbaru 2-2. Jadi kali misalnya kan cara ini ini cara yang simpel banget yang bisa kalian. Plaakukkan ketika kalian mau seminar prokosa beberapa hari kemudian. Selasuk banget sepap video yang lupa untuk like video ini subscribe channel ini adalah pasal Instagram aku jika Lisa. Selau dengan selama jika masuk ke videonya bagaimana kali hard penbuka seminar prokosaal script si 2-2. Untuk mengawalis identifri si pertama sekali kita harus mengucapkan selam. Kalau misalnya muslin kamu bisa usakan selam seperti ini. Asal-alikum orang-orang untuk usakan berikutnya. Ketama-tama mari kita bersyukur pada awas bahan-hwala. Ketama-tama akan dikentasihatan kesempatan si inga kita dapat berkumpul bersama-sama. Di sini, telah macaras sebin art prokosa. Selama dan selam tahu pokul kita hari akan kepada awasul lo selalu lo hukuk hari hiku selam. Yenshawal dengan selalu yang selalu di temkan kita semuanya pertentifat. Nah kalau misalnya kamu mau muslin kamu bisa usakan selesuai dengan agam-adam keperceberan musimasi misalnya. Halo selamat pagi selesunya terlalu untuk kita semua. Darap darap darap darap darap darap. Inga, usakan selam sesuai dengan agam-adam keperceberan musimasi. Yang kedua, menyapa dosen pengguji dan pembiin bi, seantungnya gimana sih? Seantungnya kayak gini nih, yang keperhormat bahap darap darap darap di nasution NSG selaku pemguji pertama. Yang keperhormat ibu-uati MPD selaku pembiin bi-mutanah dan yang keperhormat bahap, muhama-tahanafi MPD selaku pemguji agam. Dan yang saya bendakan seluruh audi-ns yang hadir pada sidang-scripsi hari ini. Nah, soalnya ada hakik-kamalkan diri muh siapa diri muh dari jurosamana angkatan berapa. Perkenalkan diri yang simpel aja, cempulai kayak di sini, baiklah perkenalkan sejanis-seharhap saya dari jurosan bahasa inginis angkatan tahun 2020. Nah, soalnya adalah kasih tau judo-scripsi muh, centuhnya kayak gini nih. Baitlah saya akan mempresentasikan hasil-scripsi saya yang berjudul, seterlaku di koperakis dalam pembedaran bahasa inginis di sekolah menengah pertama di sematra utara. Nah, soalnya itu, kamu sampaikan point point penting, skripsi muh, point point penting ni-salahnya begini. Baitlah sebenarnya saya akan mempikkan point point penting di sini, yang pertama adalah pendeluhan di mana saya akan melakar belakang, saya mengambil juro-scripsi tersebut yang kedua adalah sejanpus takah dilanjutkan dengan metodologi. Ya itu metodnya yang saya ambil, atau cara cara yang saya vahukan dalam pengambilan juro-kersubu, lalu soalnya adalah hasil pembedahan saya dan rakyat di tutup dengan kesimpulan. Nah, itu dia kali matpengbuka seminal proposal yang bisa kamu lahukan, simpel aja, tapi ingat itu berurutan yang bisa kalian. Iku di ketika kalian musimna proposal, beberapa hal lagi. Ingat, jangan selalu dalam pengucapan mama, dosen pemujin, dan jangan salah dalam pengucapan mama, dosen pembimbing. Penguujit dan pembimbing beda. Ingat, jangan sampai salah mama, dan jangan sampai salah jabatannya. Karena ini berpunga rubangat dalam presentasim. Nah, yang terlalu keadawakan memenampaikan berimakasi kepada seluruh audience kepada pemujin dan kepada pembimbingmu yang telah membelan tumu. Soalnya ini telah menyelisakan, proposal, sekriti. Oke aku akan kasih cintu-kainyak pemukaan yang mulai dari awal sampai di kesimpulan. Seperti ini yang bisa kamu ikut di. Asal mahal kemaram gue ngelogrokato, soalnya pahil disemualnya. Protong matamah matamah, maksud kita bersyukur pada Allah yang telah membregang kesihatan, kesempatkan kebertargetasin kita ada untuk keperperbesang sama disini. Soalnya dan samtelalku kita hari akan kepada lo seluruh lo seluruh lo, makanya yang salah, yang ingat kita akan mendapatkan sempat di dia, umil akhir nanti. Yang terhormat, bahwa, dokkor, Darwin, nasution, M.S.G.S.S.Laku pemujir pertama, yang terhormat ikut wati empe S.Laku pembingbingmu pertama, dan yang terhormat bahwa, hanafina, sution, selaku pemujir agama. Dan yang saya bangga kakau diensi yang telah hadir pada hari ini. Baitu seluruhnya saya akan menenternalkan diri saya dihanis-ralahat, dari Juruh San Bahasa Indis, angkatan 2,000 belas. Baitu seluruh saya akan mempresentasi kansikri-saya yang berjuduh, strategi, koparatif, punggajaran bahasa Indis pada tingkat segala-mana pertama, di kawasan sumat-raha. Baitu apa yang penting disini yang bakau saya sampai ke nampak-ampak-ampak-ampak-ampak-ampak-ampak-ampak-ampak-ampak-ampak-ampak ada pun dahuluan di mana saya akan menjilaskan pelat-barbillakan, saya mengambil Juruh Scripsi Tersebut, yang kedua adalah kecian pusat-kalalu diikuti dengan metodologi, itu cara yang saya lakukan, atau kecian saya lakukan dalam pengambilan Juruh Scripsi Tersebut, dan selanjutnya adalah hasil kembal-hasil dan terakhir adalah kesimpulan. Nah itu dia kali maksudnya membuka, semina proposal yang bisa kalian diikuti ketika kalian mau semu-pro atau semina, proposal. Asak-alaha seperti itu, kamu langsung aja mulai kasih tahu bahan Scripsi mau, misalnya kamu mau menggunakan por poin, yang kamu tinggal. Jelaskan aja apa yang di por poinmu, alus selain itu jelupa ucapkan terima kasih. Makasinya Scripsi, baiklah seken presumpasi dari saya mengenai, segera tegi, koperapi ke dalam membederan bahasa In-Ris di linkat sepulah menangpatan malik ke awasan sumat-rah utara. Terima kasih kepada apa, ini ini ini ini kamu ketesebut kenyantah dia, lemakasi kopadai ibu-kawatin ini ini, lemakasi perbaikan. Terima kasih kopadai, udah yang seapas dengan apa-apa hati-hati-hati. baiklah saya itu tuh dengan lo bilang itu ikut-hikut-hikut-hikut, walaupun selema-laku, walaupun sehingga penilayah. baiklah itu dia pembuka semina proposal yang pembuka, sisi dan Scripsi yang bisa kamu ikutin yang bisa kamu chuntuhin, ketika kamu mau semina proposal, semoga saya memenperbaik dan ingat kejangan-guguk dan jangan sampai salah. dan rahasiannya adalah jangan sampai salah menyebutkan mama-dosen pemujir, lesempen bibing, jangan sampai salah. dan jabatannya juga kamu harus cerita-uluk, jangan sampai salah. ingat ini berpengaruh dalam presempasimu, dalam ni-lai presempasimu. So itu aja bisa aku sampai kan, mengenai kip, dan kip, membuka, si dan Scripsi, kau video ini membantu kalian jangan lupa like, komen dibawa-kasi aku saran dan jangan lupa pelin Instagram, pembuka yang istra, so. So, thank you, super nice, stay healthy, let\'s go see this. Bye bye.', '• Ekspresi suara Anda cukup netral. Cobalah untuk lebih antusias dan berenergi dalam penyampaian.\n• Perbaiki kejelasan pengucapan kata. Latih bicara lebih perlahan dan jelas.\n• Variasi intonasi cukup baik. Tingkatkan penekanan pada poin-poin penting.\n• Kurangi penggunaan kata pengisi (seperti \'eh\', \'um\', \'anu\') untuk kesan lebih profesional.\n• Perbanyak latihan presentasi, fokus pada ekspresi suara, kejelasan, dan variasi intonasi.', '2026-06-17 04:16:53.644'),
(3, 8, 56.62, 44.29, 77.57, 'Hau semuanya selama yang harus terlebih berkatuk meling semaku. Jangan di video kali ini aku bahkan kestalku. Sengen-kestalku, membuka seminar-proposar atau membuka sedang splitsi terbaru 2-2. Jadi kali misalnya kan cara ini ini cara yang simpel banget ambisa kalian. Laku kan kepisak kalian mau seminar-proposar atau berapa hari kemudian. Selasuk rumah sepapilnya jangan lupa untuk like video ini. Subscribe channel ini adalah pasal Instagram aku jika disal. Selau dengan selalai jika masuk ke videonya bagi mana kali-hart pengguka seminar-proposar, Scripsi 2-2-2. Kentuk mengawalis identifripsi pertama sekali kita harus mengucapkan selam. Kalau misalnya muslin kamu bisa usakan selam seperti ini. Assalamualaikum warahmatullahi wabarakatuh, atau matamam hari kita bersyukur pada awalis selamah nama tanggalah yang tolong memdikkan keceatan kesempatan singak kita dapat berkumpul bersamat. Di sini, telah macar-asami nartroposar. Selalai jika disalam, terlalu pahunak kita hari akan kepadir selalu lohuh hari hiva selam. Yenshallah dengan selalu yang selalu ditakuntanku kita semuanya pertentu. Nah kalau misalnya kamu mau muslin kamu bisa usakan selalu lain dengan agam-adam keperceber yang muslin. Yang terlalu saya mengasimasi misalnya kalau selamah pagi selam saya terlalu untuk kita semuanya. Darab darab darab darab darab. Ini, usakan selam sesuai dengan agam-adam keperceber yang muslin. Yang kedua, menyapa dosen pengguji dan pembingbing, coantuhnya gimana sih? Cetanya kayak gini nih, yang terhormat berapa dokter dari nasu tion, NSG selaku pemguji pertama. Yang terhormat ibu-uati MPD selaku pembingbing utama, dan yang terhormat berapa muhamat hanafi MPD selaku pemguji agam. Dan yang saya bendakan seluruh audi yang hadir pada sidang-scripsi hari ini. Nah, soalnya ada hukuk kemalkan dirimu siapa dirimu dari jurosamana angkatan berapa. Perkenalkan dirimu yang simpel aja, cempulanya kayak di sini, baiklah, terkenalkan sejanis-seharhap saya dari jurosan bahasa inginis angkatan tahun 2020. Nah, selanjutnya adalah kasih tau judo-scripsi mu. Centuknya kayak gini nih, baiklah saya akan mempresentasikan hasil-scripsi saya yang berjudul sejuruh, start-kid koprakis dalam pembeda-jaran bahasa inginis di sekolah menengah pertama di sematra utara. Nah, soklaya itu, kamu sampaikan point point penting, skripsi mu. Point point ni-salnya begini. Baiklah, sebenarnya saya akan mempresentasikan point penting di sini, yang pertama adalah pendeluhan di mana saya akan melakukan belakang, saya mengambil juros, skripsi tersebut. Yang kedua ada sejanbus takah dilanjutkan dengan metodologi. Ya itu metodia yang saya ambil, atau cara cara yang saya vahu kan dan pengambilan judulkan sebuah, langsung yang adalah hasil pembeda-hasil dan berakhir di tutup dengan kesimpulan. Nah, itu dia kali matpengbuka seminal propossal yang bisa kamu lahukan. Simpul aja, pahin-nya itu berurutan yang bisa kalian. Iku di ketika kalian mau seminal propossal, beberapa hal lagi. Ingat, jangan selanjutnya, dan pengujapan mama, dosen pemujin dan jangan selanjutnya, dan pengujapan mama, dosen pembing. Pengujit dan pembing, beda. Ingat, jangan selanjutnya, dan jangan selanjutnya, dan jangan selanjutnya, karena ini berpunga-bungat dalam presentasim. Nah, yang terakhir adalah kamu menampaikan berimakasi, kepadah seluruh, audian, sekopada pemujit, dan kepadah pembingbimmu. Yang telah membelan-belan semua. Sama-sama ini telah menelusaikan, propossal, skripsi. Oke aku akan kasih cintu-kali, nappu, bukan yang mulai dari awal sampai di semua. Seperti ini yang bisa kamu ikutin. Assalamualaikum roku logsu selama-issa neceskelicema. Pet終ika waktu mana jadi mengat Masakar Pusikur gitu ya apa dalam menjadi kesehatan. Sepertikan pemengeritanya advertise juga yang bisaUNGrisin nih alana saya terlaluертatnya ga College di Kamajibirdir. Yang menem 반� Türkiye SANA, loh peppersungえる caliber seluruh yang mengatakan taalisenin di Kamajibirdir Lamaksa. Kumpur dia satu kh Batman upstream dia lagi dari hana final setiwon selaku pemujir agama. Dan yang saya bangga kak audian sientuh hari pada hari ini. Baita sebelumnya saya akan menonton akan diri saya dihani seharahat dari Jerusalem bahasa Indis angkatan dua riku stabilan belas. Baita lah saya akan mempresentasi konsikri saya yang berjuduh, strategi, koparatif, umblejangan bahasa Indis pada tingkat sekola menemang pertama di kawasan sumat-tara. Baita kawain-kawain penting disini yang bakau saya sampai ke nampak-mada di mana saya akan menjilaskan pelat-pelat-pelat, saya mengambil Jerusalem-scripsi tersebut. Yang kedua adalah kacian pusat-kalalu diikuti dengan metodologi, itu cara yang saya lakukan, atau kacian yang saya lakukan, dalam pengambilan Jerusalem-scripsi tersebut. Dan selanjutnya adalah khasil kembal-hasaan dan terakhir adalah kesimpulan. Nah itu dia kali makupan buka, semina proposal yang bisa kali yang diikuti, katika kalian mau semuatu atau semina, proposan. Asap lah, seperti itu, kamu amson aja mulai kasih tahu bahan, secripsi mau, misalnya kamu mau menggunakan por poin, yang kamu tinggal. Jelaskan aja apa yang di por poinmu, alus telah itu jelupa ucapkan terimakasinya. Makasinya seperti ini. Baita lagi, saya ngemasih dari saya, mengenai, terat-gih, koperapi kembali-garang bahasa ingris di tingkat sepulah menang-ang pertama di kawasan sumat-tara. Terimakasi kepada apa, ini ini ini ini kamu ketesebut kenyantadi ya, terimakasi kepada ibu-gakinya ini, terimakasi kepada apa-apa ada di sini. Terimakasi kepada audi yang apa-siga apa-apa, hati-hania. Baita saya itu tuh dengan lo bilang itu, kauh di daya, wasalam malai, kauh, kauh, lo-kauh di ua barokah tuh. Nah, so say, tinggal penilayah. Baita lagi, itu dia pembuka seminar proposal ya, pembuka, sedang secripsi yang bisa kamu ikuti, yang bisa kamu cuntohin, katika kamu mau seminar proposal. Semoga saya menemain terbaik, dan ingat jangan gue gue, dan jangan sampai salah. Dan rahasiannya adalah jangan sampai salah menyebutkan mama lo-sen pemujir, lo-sen pembing, ya jangan sampai salah. Dan jabatannya juga, kamu harus cerita gue turu, jangan sampai salah. Ingat ini berpengaruh dalam presempasimu, dalam nih layai presempasimu. So itu aja bisa aku sampai kan, mengenai, kip, dan krik, membuka sedang seksi, kalau video ini membantu kalian jangan lupa like, komen di bawah, kasi aku saran, dan jangan lupa pelin Instagram, pembuka, so, so, thank you, super nice, stay healthy, aspa sedih, bye bye.', '• Ekspresi suara Anda cukup netral. Cobalah untuk lebih antusias dan berenergi dalam penyampaian.\n• Perbaiki kejelasan pengucapan kata. Latih bicara lebih perlahan dan jelas.\n• Variasi intonasi cukup baik. Tingkatkan penekanan pada poin-poin penting.\n• Kurangi penggunaan kata pengisi (seperti \'eh\', \'um\', \'oo\') untuk kesan lebih profesional.\n• Perbanyak latihan presentasi, fokus pada ekspresi suara, kejelasan, dan variasi intonasi.', '2026-06-24 02:39:21.794'),
(4, 9, 56.54, 44.29, 77.57, 'Halo semuanya, selamat malam terlalu berkata, kembali di sama aku. Jangan di video kali ini, aku bakal ke stel 5 dan 3 membuka seminar prokosal atau membuka sidang skripsi terbaru 2022. Jadi kalian bisa lakukan cara ini, ini cara yang simple, banget yang bisa kalian lakukan ketika kalian mau seminar prokosal beberapa hari kemudian. Susah sebelum asak video, jangan lupa untuk like video ini, subscribe channel ini dan lupa follow instagram aku jahat isra. Saat kita langsung aja masuk ke video-nya, bagaimana kalimat pangguka seminar prokosal skripsi 2022. Untuk ngawali sidang skripsi pertama sekali kita harus mengucapkan salam. Kalau misalnya muslim kamu bisa ucapkan salam seperti ini. Assalamualaikum warahmatullahi wabarakatuh. Kalo misalnya kamu non-muslim kamu bisa ucapkan sesuai dengan agama dan kepercayaanmu masih masih misalnya. Halo selamat lagi, selamat malam semuanya untuk kita semua. Ini yang saya mencari dengan agama dan kepercayaanmu masih masih. Yang kedua, menyapak dosan pengujik dan pembimbing. Contohnya gimana sih? Contohnya kayak gini nih. Yang terhormat dapat doktor darwin nasu di sini. Yang terhormat, menurutnya di sini. Yang terhormat, dapat doktor darwin nasu di sini. Yang terhormat, ibu uati MPD, selaku pembimbing utama. Yang terhormat, dapat mengharmat Hanavi MPD, selaku pemujik agama. Dan yang saya banggakan seluruh audien yang hadir pada sidang skripsi hari ini. Nah, selanjutnya adalah perkenalkan dirimu siapa dirimu dari juru samana angkatan berapa. Perkenalkan dirim simpel aja, contohnya kayak gini nih. Baiklah, perkenalkan sejenis terakhak saya dari juru sam bahasa Inggris angkatan tahun 19. Nah, selanjutnya adalah kasih tahun judol skripsi mu. Contohnya kayak gini nih. Baiklah, saya akan mempercentasikan hasil skripsi saya yang berjudul, strake di koperakis dalam pembelajaran bahasa Inggris di sekolah menengah pertama di sumat rah utara. Nah, setelah itu, kamu sampaikan point-point penting skripsi mu. Poin-point penting misalnya kayak gini nih. Baiklah, sebenarnya saya akan menyangpai point-point penting di sini yang pertama adalah pendahuluhan di mana saya akan menggelaskan lata belakang saya mengambil judol skripsi tersebut yang kedua adalah kajian pustaka di lanjutkan dengan metodologi. Ia itu metode yang saya ambil atau cara-cara yang saya lakukan dalam pengambilan judol tersebut. Terus, wajahnya adalah hasil pembelajaran dan terakhir ditutup dengan kesimpulan. Nah, itu dia kelimat pembuka seminal proposal yang bisa kamu lakukan. Simpel aja, tapi ingat itu berurutan yang bisa kalian ikutnya ketika kalian mau seminat proposal beberapa hari lagi. Ingat, jangan salah dan pengucapan mama, dosen penguci dan jangan salah dan pengucapan mama, dosen pembing-bing. Penguci dan pembing-bing, beda. Ingat, jangan salah nama dan jangan salah jabatannya. Karena ini berpengaruh banget dalam prestentasim. Nah, yang terakhir adalah kamu menyampaikan terima kasih kepada seluruh audian, kepada penguci dan kepada pembing-bing. Yang telah membelantungmu sampai saat ini telah menyalisaikan proposal skripsi. Oke, aku bakal kasih contoh kali napembukannya mulai dari awal sampai di kesimpulan. Seperti ini yang bisa kamu ikutin. Assalamualaikum warahmatullahi wabarakatuh, selamat pagi semuanya. Terutama-tama, mademah kita berusia kurup pada Allah yang telah membuat kesihatan kesempatan kekakitasi. Yang kita dapat berkumpul bersama-sama di sini. Salah dan sampe lupa, kita dia akan kepada Rasulullah, Salahullah, Kemalian iwasala. Yang yang siapa kita akan mendapatkan chefat di dia, umumnya akhir nanti. Anil mereka. Yang terakhir mat, bapak doktor darwin. Nah, Suti On, MSG selaku pemuci pertama. Yang terakhir mat, ibu kuatin MP selaku pembing-bing, kutama. Dan yang terhormat, bapak Hana Fina Suti On selaku pemuci agama. Dan yang saya banggakan audian simpel hadir pada hari ini. Bai Klas sebumbu, saya akan mempertenalkan diri Sejianis Rara Hat dari juru sen bahasa Inggris angkatan 2019. Bai Klas saya akan memprisentasikan skripsi saya yang berjudul, strategi, operatif, pembelajaran bahasa Inggris pada tingkat sekolah menengah pertama di kawasan sumatra utara. Bai Klas poin-poin penting di sini yang bakal saya sampaikan yang pertama dalam pendahuluan, dimana saya akan menjelaskan pelatar belakang saya mengambil judul skripsi tersebut. Yang kedua adalah kajian pustaka, lalu diikuti dengan metodologi, itu cara yang saya lakukan, atau teknik yang saya lakukan dalam pengambilan judul skripsi tersebut. Dan suangkinnya adalah hasil pembelajaran, dan terakhir adalah kesimpulan. Nah, itu dia, kalian maupun buka, semina proposa yang bisa kalian ikutin ketika kalian mau semu-pro atau seminan proposa. Asetlah, seperti itu, kamu langsung aja mulai kasih tau bahan skripsi mau misalnya kamu menggunakan porpoin ya kamu tingkat. Jelas kan aja apa yang di porpoinmu, lalu selain itu jalupa ucapkan terima kasih. Makasinya seperti ini. Bai Klas segin presentasi dari saya mengenai strategi, operatif, dalam pembelajaran bahasa Inggris di tingkat sekolah menengah pertama di kawasan sumatra utara. Terima kasih kepada Bapak. Bapak, ini kamu kesemputkan yang tadi ya, terima kasih kepada ibu, buatin ini ini terima kasih kepada Bapak. Dan terima kasih kepada Audi yang segera perhatiannya. Bapak Klas, saya tuh dengan wabilahi topik wanita ya, walaupun saya mau lagu, warah matu-lohi, warah berokat. Nah, sosai, tinggal penilai ya. Bapak Klas itu dia pembuka seminan proposa ya, pembuka sidang skripsi, yang bisa kamu ikutin, yang bisa kamu contohin ketika kamu mau seminan proposa. Semoga saya mau terbaik dan inget, jangan gugup dan jangan sampai salah. Dan rahasiannya adalah jangan sampai salah menyebutkan nama doosen penguji, doosen pembimbing, ya, jangan sampai salah. Dan jabatannya juga kamu harus cari tahu-betul, jangan sampai salah. Ingat, ini berpengaruh dalam pressempasinmu, dalam nilai pressempasinmu. So itu saja yang bisa aku sampai kan mengenai krips dan trick, membuka sidang skripsi. Kau video ini membantu kalian jangan lupa like, komendibawa kasih aku saran dan jangan lupa polis Instagram aku di Instagram isra. So, so thank you so good bye stay healthy, lusk, positive, bye bye.', '• Ekspresi suara Anda cukup netral. Cobalah untuk lebih antusias dan berenergi dalam penyampaian.\n• Perbaiki kejelasan pengucapan kata. Latih bicara lebih perlahan dan jelas.\n• Variasi intonasi cukup baik. Tingkatkan penekanan pada poin-poin penting.\n• Kurangi penggunaan kata pengisi (seperti \'eh\', \'um\', \'oo\') untuk kesan lebih profesional.\n• Perbanyak latihan presentasi, fokus pada ekspresi suara, kejelasan, dan variasi intonasi.', '2026-07-03 02:52:28.542'),
(5, 10, 38.74, 41.57, 63.45, 'Terhormat, Ibu Nyoman Terisna Heroati, SA AkMPD, Selaku Dosen Pembing-Bing Putama, yang terhormat bahwa Dr. Ibu tuh kejadian mika SA AkMPD, Selaku Dosen Pembing-Bing Penamping, yang terhormat bahwa Ibu tuh julian untuk SA AkMPD, Selaku Dosen Pemlaah. Padahal kesenfatan ini, saya akan mempresentasikan kroposal saya dengan judul pengaruh pengunangan software akutansi, efektivitas pengunangan dana BPUM dan Yumen Kapital terhadap kinerja usaha mikro, study pada usaha mikro penerima dana BPUM di kecamatan buli lenget. Namun sebelum lanjut, Ijen kasaya memperkenalkan diri terlebih dahulu, perkenalkan namas saya komang triudia malini, name 17-17-15-15-31 dari Prodi SA Akutansi. Ada pun kokok bahasan dalam presentasi ini, yaitu pendahuluan, kajian teori dan metodologi pendalitian, langsung saja pada bagian pendahuluan, pendaliti dalam menulis proposal ini dilatar belakangin oleh berbagai masalah yaitu, saat ini Indonesia sedang menghadapi pandemi COVID-19. Pandemi COVID-19 memberikan dampak di segala aspect kehidupan salah satunya sektor perekonomian. Penunjuk perekonomian terbesar di Indonesia, di dominasi dengan keberadaan EMKM. Dalam pakelasifikasi yang UMKM, usaha mikro adalah usaha yang paling banyak ada di kaput kuatkan buli lenget, diapalnya. Namun, karena sekarang adanya pandemi, kinerja usaha mikro mengalami penurunan. Beda sakan datosurfe yang dilakukan oleh LEPI tahun 2020, menunjukkan bahwa selama pandemi, 90.4,69 persen usaha mikro mengalami penurunan kinerja. Phenomena pandemi COVID-19 di era revolusi 4.0, mengharuskan segala jenis usaha tak terkecuali UMKM, ini menggunakan teknologi dalam menjalankan usahaannya. Namun isunya hanya sebagai UMKM yang menggunakan teknologi dan sebagiannya lagi, masih belum, ini berdasarkan wawancara yang dilakukan oleh penaliti. Akibat pandemi COVID-19, pemerintah mengharuskan memberikan banduan langsung tunai atau BLT UMKM atau disebut dengan BPUM. BPUM adalah banduan bagi pelaku usaha mikro sebesar 2,4 juta rupiah per pelaku usaha mikro yang tak kenal ada ampak pandemi COVID-19. Terdapat 1960 usaha mikro yang menerima BPUM di kecamatan dulu, melalui banduan ini diharapkan pelaku usaha mikro tidak lagi mengalami kesulitan model pada saat pandemi. Namun kenyataannya, penelologan dan ABPUM masih kurang efektif dan belum cepat sasaran, karena sebagian pelakini usaha mikro menggunakan banduan ini untuk keperluan sehari-harinya, tidak untuk keperluan usahaannya. Pemasal langsungnya, itu UMKM yang berkualitas. UMKM kapital masih jarang diperhatikan apalagi oleh pelaku usaha mikro karena keberadaannya tidak terjuad. Atau setiap itu, peneriti mengambil judul, pengaruh penggunaan sofuer akutasi, efektifitas penggunaan dan ABPUM dan UMKM kapital terhadap kinerja usaha mikro, studi pada usaha mikro penerima dan ABPUM di kecamatan bulet-lep. Tidak tipekasih masalah pada penelchan ini adalah pandemi COVID-19 ini menurutkan perekonongnya nasional Indonesia. Kemudian, jaman revolusi pati TN, ini sudah dirasakan oleh masyarakat Indonesia, namun hanya sebagian UMKM yang sudah menggunakan teknologi. Kemudian, dari tahun 2015 hingga 2018, serdata 1,7 juta UMKM, itu mengalami kebangkursan, karena tidak mempuber sayang. Kemudian pelaku usaha mikro, di desak untuk terbiasa menggunakan teknologi. Kemudian, efektifitas penggunaan dan ABPUM masih kurang, efektifkan belum terpaksa-sarang dan yang terakhir, yang mengkapital masih sangat jarang diperhatikan bagi pelaku usaha mikro. Peneliti juga melakukan tembatasan terhadap variable-variable penelpiat, yang itu penggunaan sofuer akutasi, efektifitas penggunaan dan ABPUM, UMKM, dan teknologi usaha mikro. Peneliti juga membuat remusah masalah, iaitu apakah penggunaan sofuer akutasi berpengaruh terhadap kinajau saham mikro, apakah efektifitas penggunaan dan ABPUM berpengaruh terhadap kinajau saham mikro, apakah human capital berpengaruh terhadap kinajau saham mikro, apakah penggunaan sofuer akutasi, efektifitas penggunaan dan ABPUM dan UMKM berpengaruh secara simulsan terhadap kinajau saham mikro. Berdasarkan usaha masalah yang sudah saya papan kanta di, tujuan penelitian ini adalah untuk mengatahui pengaruh penggunaan sofuer akutasi terhadap kinajau saham mikro, untuk mengatahui pengaruh efektifitas penggunaan dan ABPUM terhadap kinajau saham mikro, untuk mengatahui pengaruh human capital terhadap kinajau saham mikro, dan untuk mengatahui penggunaan sofuer akutasi, efektifitas penggunaan dan ABPUM dan UMKM dan UMKM capital secara simul terhadap kinajau saham mikro. Ada pun manfaat yang diharapkan dalam penelitian ini, ada 2, itu manfaat teoritis dan memfaat praktis. Untuk manfaat teoritisnya, itu sebagai rekrensi dan pertimbangan literatur dan untuk manfaat praktisnya, bagi penutis sebagai kesempatan untuk menerapkan pengetahuan penulis, bagi usaha mikro untuk meningkatkan kinajanya, kemudian untuk undiksa sebagai rekrensi untuk penitian selanjutnya. Bagian kedua, kajian teori. Grand Theorian digunakan dalam penelitian ini adalah teori RBT atau Resort, Beset Theoris atau Theoris Sumerdaya, yang menjalaskan bahwa apabila suatu perusahaan mempunyai kelebihan kompetitip maka perusahaan tersebut bampung mendatangkan ilai tambah, bunam meningkatkan tinajau perusahaan, yasrauan 2020. Keungulan kompetitip ini dapat berupa aset berujut dan aset tidak berujut. Sekon dari teori untuk penyiasat ini, iaitu ada usaha mikro, kinajau usaha mikro, pengenangan soverek akutansi, efektifitas pengenangan dana BPOM dan human capital. Kajian hasil penelitian yang berkaitan dalam penyiasat ini ada dari yasrauan 2020. Effektifitas pengenangan dana kor dan inklektor capital berpengaruh terhadap kinajau MKM. Menurut promenik 2020, BLT berpengaruh terhadap ke langsungan hidup masyarakat pada lalang. Daya ketiga dari pasar ribu 2019, perangkat dunia akutansi berpengaruh terhadap kinajau MKM, kemudian dari sayfudin 2018, soverek akutansi berpengaruh terhadap kinajau perangkat besar, kemudian dari zuliati decak K217, human capital berpengaruh terhadap kinajau MKM, kemudian dari Wahiunitau 2016, yang itu perangkat dunia akutansi tidak berpengaruh terhadap kinajau perusahaan dan sarit tahun 2012 perangkat dunia akutansi berpengaruh terhadap kinajau MKM. Kemudian, untuk perangkat berpikirnya dapat dilihat dislike bahwa X1, X2 dan X3 berpengaruh secara persial terhadap Y, X1, X2 dan X3 berpengaruh secara simultan terhadap Y. Nah dari kerangka berpikir tadi penulis dapat membuat hipotesist, yang itu H1, penggunaan soverek akutansi berpengaruh positive dan signifikan terhadap kinajau selamikro. Hadua, efektivitas penggunaan dana BPUM berpengaruh positive dan signifikan terhadap kinajau selamikro. Had 3, human capital berpengaruh positive dan signifikan terhadap kinajau selamikro. Dan yang terakhir, hampat, penggunaan soverek akutansi, efektivitas penggunaan dana BPUM dan human capital berpengaruh secara simultan terhadap kinajau selamikro. Selainjutnya, bagian yang ketiga, itu metode logi penelitian. Untuk tempat dan waktu penelitian adalah di kecamatan bulereng, nulai bulan januari hingga Juli 2021. Untuk jenis dan sumber data yang digunakan, iaitu jenis data quantitatif dengan sumber data primer dan juga sekunder. Penulis juga membuat rencangan penercian yang dapat dilihat di slide bahwa judul, itu dilatar belakangi oleh berbagai masalah, hingga dibuatkan rumusan masalah, tujuan dan mampat yang diharapkan. Tidak lupa untuk didukong dengan kajian teori dan dibuatkan metode penelitian berupa uji, kualitas data, uji asumsi klasi dan uji si protestif. Barulah dapat hasil pembahasan dan juga hasil penelitian nantraher dapat ditarek kesimpulan. Selanjutnya, dalam penelitian ini yang menjadi populasi adalah usaha mikro yang menerima dana BPUM di kecamatan bulereng yang terdata di bang BRI kancas hingga raja yang berjumlah 6,970 usaha mikro. Pendantuan sempil ini menggunakan perposev sampling dengan berbagai kriteria, yang pertama, respondent yang terdata sebagai pelaku usaha mikro di kecamatan bulereng. Respondent yang menerima BPUM di kecamatan bulereng dan terakhir respondent yang melakukan pembukuan menggunakan sofer akutansi di kecamatan bulereng. Untuk menentukan jumlah sempilnya menggunakan rumus lock pin sehingga di daftar sempil sebanyak 9,970 respondent. Untuk metode pengumpulan datanya menggunakan kushionet dengan sekalap pengukuran sekalap 5 puen. Untuk intrumend penelitiannya, indikatan untuk varia balkiner jauh usaha mikro terdiri dari pertumbuhan penjualan, pertumbuhan moda, pertumbuhan trinaga kerja, pertumbuhan pasad dan pemasaran dan pertumbuhan laba. Indikator untuk varia balkiner penggunaan sofer akutansi terdiri dari kualitas sofer akutansi, kualitas informasi, kepuasan penggunaan dan dampak penggunaan. Indikator untuk varia balk efektivitas penggunaan dan BPUM terdiri dari sebagai modal usaha untuk membeli bahan baku mendambah periasi produk dan memperluas kapasitas usaha. Yang terakhir, indikator untuk varia balkiner penggunaan terdiri dari pengetahuan, ketrampilan dan kemampuan. Terakhir untuk teknik analisis data menggunakan 3 uji itu uji kualitas data, uji asum si klasi dan uji hipotesis. Uji kualitas data terdiri dari uji validitas dan reali bilitas, uji asum si klasi terdiri dari uji normalitas, hetero-kadastisitas dan multi-colinionitas. Dayang uji hipotesis terdiri dari analisis rekrecil linear berganda, uji p, uji f dan uji kualifesian determinasi. Baik, itu saja yang bisa saya papakan, Mohon Maap apabila ada salah kata, akhir kata saya ucapkan terima kasih dan para mesanti. Om, Sanci, Sanci, Sanci, Sanci, O.', '• Terdeteksi ekspresi kurang semangat. Tingkatkan kepercayaan diri dan antusiasme Anda.\n• Perbaiki kejelasan pengucapan kata. Latih bicara lebih perlahan dan jelas.\n• Variasi intonasi cukup baik. Tingkatkan penekanan pada poin-poin penting.\n• Kurangi penggunaan kata pengisi (seperti \'eh\', \'um\', \'oo\') untuk kesan lebih profesional.\n• Perbanyak latihan presentasi, fokus pada ekspresi suara, kejelasan, dan variasi intonasi.', '2026-07-03 03:15:57.895'),
(6, 11, 59.35, 44.29, 77.57, 'Halo semuanya, selamat malam terlalu berkata, kembali di sama aku. Jangan di video kali ini, aku bakal ke stel 5 dan 3 membuka seminar prokosal atau membuka sidang skripsi terbaru 2022. Jadi kalian bisa lakukan cara ini, ini cara yang simple, banget yang bisa kalian lakukan ketika kalian mau seminar prokosal beberapa hari kemudian. Susah sebelum asak video, jangan lupa untuk like video ini, subscribe channel ini dan lupa follow instagram aku jahat isra. Saat kita langsung aja masuk ke video-nya, bagaimana kalimat pangguka seminar prokosal skripsi 2022. Untuk ngawali sidang skripsi pertama sekali kita harus mengucapkan salam. Kalau misalnya muslim kamu bisa ucapkan salam seperti ini. Assalamualaikum warahmatullahi wabarakatuh. Kalo misalnya kamu non-muslim kamu bisa ucapkan sesuai dengan agama dan kepercayaanmu masih masih misalnya. Halo selamat lagi, selamat malam semuanya untuk kita semua. Ini yang saya mencari dengan agama dan kepercayaanmu masih masih. Yang kedua, menyapak dosan pengujik dan pembimbing. Contohnya gimana sih? Contohnya kayak gini nih. Yang terhormat dapat doktor darwin nasu di sini. Yang terhormat, menurutnya di sini. Yang terhormat, dapat doktor darwin nasu di sini. Yang terhormat, ibu uati MPD, selaku pembimbing utama. Yang terhormat, dapat mengharmat Hanavi MPD, selaku pemujik agama. Dan yang saya banggakan seluruh audien yang hadir pada sidang skripsi hari ini. Nah, selanjutnya adalah perkenalkan dirimu siapa dirimu dari juru samana angkatan berapa. Perkenalkan dirim simpel aja, contohnya kayak gini nih. Baiklah, perkenalkan sejenis terakhak saya dari juru sam bahasa Inggris angkatan tahun 19. Nah, selanjutnya adalah kasih tahun judol skripsi mu. Contohnya kayak gini nih. Baiklah, saya akan mempercentasikan hasil skripsi saya yang berjudul, strake di koperakis dalam pembelajaran bahasa Inggris di sekolah menengah pertama di sumat rah utara. Nah, setelah itu, kamu sampaikan point-point penting skripsi mu. Poin-point penting misalnya kayak gini nih. Baiklah, sebenarnya saya akan menyangpai point-point penting di sini yang pertama adalah pendahuluhan di mana saya akan menggelaskan lata belakang saya mengambil judol skripsi tersebut yang kedua adalah kajian pustaka di lanjutkan dengan metodologi. Ia itu metode yang saya ambil atau cara-cara yang saya lakukan dalam pengambilan judol tersebut. Terus, wajahnya adalah hasil pembelajaran dan terakhir ditutup dengan kesimpulan. Nah, itu dia kelimat pembuka seminal proposal yang bisa kamu lakukan. Simpel aja, tapi ingat itu berurutan yang bisa kalian ikutnya ketika kalian mau seminat proposal beberapa hari lagi. Ingat, jangan salah dan pengucapan mama, dosen penguci dan jangan salah dan pengucapan mama, dosen pembing-bing. Penguci dan pembing-bing, beda. Ingat, jangan salah nama dan jangan salah jabatannya. Karena ini berpengaruh banget dalam prestentasim. Nah, yang terakhir adalah kamu menyampaikan terima kasih kepada seluruh audian, kepada penguci dan kepada pembing-bing. Yang telah membelantungmu sampai saat ini telah menyalisaikan proposal skripsi. Oke, aku bakal kasih contoh kali napembukannya mulai dari awal sampai di kesimpulan. Seperti ini yang bisa kamu ikutin. Assalamualaikum warahmatullahi wabarakatuh, selamat pagi semuanya. Terutama-tama, mademah kita berusia kurup pada Allah yang telah membuat kesihatan kesempatan kekakitasi. Yang kita dapat berkumpul bersama-sama di sini. Salah dan sampe lupa, kita dia akan kepada Rasulullah, Salahullah, Kemalian iwasala. Yang yang siapa kita akan mendapatkan chefat di dia, umumnya akhir nanti. Anil mereka. Yang terakhir mat, bapak doktor darwin. Nah, Suti On, MSG selaku pemuci pertama. Yang terakhir mat, ibu kuatin MP selaku pembing-bing, kutama. Dan yang terhormat, bapak Hana Fina Suti On selaku pemuci agama. Dan yang saya banggakan audian simpel hadir pada hari ini. Bai Klas sebumbu, saya akan mempertenalkan diri Sejianis Rara Hat dari juru sen bahasa Inggris angkatan 2019. Bai Klas saya akan memprisentasikan skripsi saya yang berjudul, strategi, operatif, pembelajaran bahasa Inggris pada tingkat sekolah menengah pertama di kawasan sumatra utara. Bai Klas poin-poin penting di sini yang bakal saya sampaikan yang pertama dalam pendahuluan, dimana saya akan menjelaskan pelatar belakang saya mengambil judul skripsi tersebut. Yang kedua adalah kajian pustaka, lalu diikuti dengan metodologi, itu cara yang saya lakukan, atau teknik yang saya lakukan dalam pengambilan judul skripsi tersebut. Dan suangkinnya adalah hasil pembelajaran, dan terakhir adalah kesimpulan. Nah, itu dia, kalian maupun buka, semina proposa yang bisa kalian ikutin ketika kalian mau semu-pro atau seminan proposa. Asetlah, seperti itu, kamu langsung aja mulai kasih tau bahan skripsi mau misalnya kamu menggunakan porpoin ya kamu tingkat. Jelas kan aja apa yang di porpoinmu, lalu selain itu jalupa ucapkan terima kasih. Makasinya seperti ini. Bai Klas segin presentasi dari saya mengenai strategi, operatif, dalam pembelajaran bahasa Inggris di tingkat sekolah menengah pertama di kawasan sumatra utara. Terima kasih kepada Bapak. Bapak, ini kamu kesemputkan yang tadi ya, terima kasih kepada ibu, buatin ini ini terima kasih kepada Bapak. Dan terima kasih kepada Audi yang segera perhatiannya. Bapak Klas, saya tuh dengan wabilahi topik wanita ya, walaupun saya mau lagu, warah matu-lohi, warah berokat. Nah, sosai, tinggal penilai ya. Bapak Klas itu dia pembuka seminan proposa ya, pembuka sidang skripsi, yang bisa kamu ikutin, yang bisa kamu contohin ketika kamu mau seminan proposa. Semoga saya mau terbaik dan inget, jangan gugup dan jangan sampai salah. Dan rahasiannya adalah jangan sampai salah menyebutkan nama doosen penguji, doosen pembimbing, ya, jangan sampai salah. Dan jabatannya juga kamu harus cari tahu-betul, jangan sampai salah. Ingat, ini berpengaruh dalam pressempasinmu, dalam nilai pressempasinmu. So itu saja yang bisa aku sampai kan mengenai krips dan trick, membuka sidang skripsi. Kau video ini membantu kalian jangan lupa like, komendibawa kasih aku saran dan jangan lupa polis Instagram aku di Instagram isra. So, so thank you so good bye stay healthy, lusk, positive, bye bye.', '• Ekspresi suara Anda cukup netral. Cobalah untuk lebih antusias dan berenergi dalam penyampaian.\n• Perbaiki kejelasan pengucapan kata. Latih bicara lebih perlahan dan jelas.\n• Variasi intonasi cukup baik. Tingkatkan penekanan pada poin-poin penting.\n• Kurangi penggunaan kata pengisi (seperti \'eh\', \'um\', \'oo\') untuk kesan lebih profesional.\n• Perbanyak latihan presentasi, fokus pada ekspresi suara, kejelasan, dan variasi intonasi.', '2026-07-11 15:16:32.912'),
(7, 12, 56.21, 44.29, 77.57, 'Halo semuanya, selamat malam terlalu berkata, kembali di sama aku. Jangan di video kali ini, aku bakal ke stel 5 dan 3 membuka seminar prokosal atau membuka sidang skripsi terbaru 2022. Jadi kalian bisa lakukan cara ini, ini cara yang simple, banget yang bisa kalian lakukan ketika kalian mau seminar prokosal beberapa hari kemudian. Susah sebelum asak video, jangan lupa untuk like video ini, subscribe channel ini dan lupa follow instagram aku jahat isra. Saat kita langsung aja masuk ke video-nya, bagaimana kalimat pangguka seminar prokosal skripsi 2022. Untuk ngawali sidang skripsi pertama sekali kita harus mengucapkan salam. Kalau misalnya muslim kamu bisa ucapkan salam seperti ini. Assalamualaikum warahmatullahi wabarakatuh. Kalo misalnya kamu non-muslim kamu bisa ucapkan sesuai dengan agama dan kepercayaanmu masih masih misalnya. Halo selamat lagi, selamat malam semuanya untuk kita semua. Ini yang saya mencari dengan agama dan kepercayaanmu masih masih. Yang kedua, menyapak dosan pengujik dan pembimbing. Contohnya gimana sih? Contohnya kayak gini nih. Yang terhormat dapat doktor darwin nasu di sini. Yang terhormat, menurutnya di sini. Yang terhormat, dapat doktor darwin nasu di sini. Yang terhormat, ibu uati MPD, selaku pembimbing utama. Yang terhormat, dapat mengharmat Hanavi MPD, selaku pemujik agama. Dan yang saya banggakan seluruh audien yang hadir pada sidang skripsi hari ini. Nah, selanjutnya adalah perkenalkan dirimu siapa dirimu dari juru samana angkatan berapa. Perkenalkan dirim simpel aja, contohnya kayak gini nih. Baiklah, perkenalkan sejenis terakhak saya dari juru sam bahasa Inggris angkatan tahun 19. Nah, selanjutnya adalah kasih tahun judol skripsi mu. Contohnya kayak gini nih. Baiklah, saya akan mempercentasikan hasil skripsi saya yang berjudul, strake di koperakis dalam pembelajaran bahasa Inggris di sekolah menengah pertama di sumat rah utara. Nah, setelah itu, kamu sampaikan point-point penting skripsi mu. Poin-point penting misalnya kayak gini nih. Baiklah, sebenarnya saya akan menyangpai point-point penting di sini yang pertama adalah pendahuluhan di mana saya akan menggelaskan lata belakang saya mengambil judol skripsi tersebut yang kedua adalah kajian pustaka di lanjutkan dengan metodologi. Ia itu metode yang saya ambil atau cara-cara yang saya lakukan dalam pengambilan judol tersebut. Terus, wajahnya adalah hasil pembelajaran dan terakhir ditutup dengan kesimpulan. Nah, itu dia kelimat pembuka seminal proposal yang bisa kamu lakukan. Simpel aja, tapi ingat itu berurutan yang bisa kalian ikutnya ketika kalian mau seminat proposal beberapa hari lagi. Ingat, jangan salah dan pengucapan mama, dosen penguci dan jangan salah dan pengucapan mama, dosen pembing-bing. Penguci dan pembing-bing, beda. Ingat, jangan salah nama dan jangan salah jabatannya. Karena ini berpengaruh banget dalam prestentasim. Nah, yang terakhir adalah kamu menyampaikan terima kasih kepada seluruh audian, kepada penguci dan kepada pembing-bing. Yang telah membelantungmu sampai saat ini telah menyalisaikan proposal skripsi. Oke, aku bakal kasih contoh kali napembukannya mulai dari awal sampai di kesimpulan. Seperti ini yang bisa kamu ikutin. Assalamualaikum warahmatullahi wabarakatuh, selamat pagi semuanya. Terutama-tama, mademah kita berusia kurup pada Allah yang telah membuat kesihatan kesempatan kekakitasi. Yang kita dapat berkumpul bersama-sama di sini. Salah dan sampe lupa, kita dia akan kepada Rasulullah, Salahullah, Kemalian iwasala. Yang yang siapa kita akan mendapatkan chefat di dia, umumnya akhir nanti. Anil mereka. Yang terakhir mat, bapak doktor darwin. Nah, Suti On, MSG selaku pemuci pertama. Yang terakhir mat, ibu kuatin MP selaku pembing-bing, kutama. Dan yang terhormat, bapak Hana Fina Suti On selaku pemuci agama. Dan yang saya banggakan audian simpel hadir pada hari ini. Bai Klas sebumbu, saya akan mempertenalkan diri Sejianis Rara Hat dari juru sen bahasa Inggris angkatan 2019. Bai Klas saya akan memprisentasikan skripsi saya yang berjudul, strategi, operatif, pembelajaran bahasa Inggris pada tingkat sekolah menengah pertama di kawasan sumatra utara. Bai Klas poin-poin penting di sini yang bakal saya sampaikan yang pertama dalam pendahuluan, dimana saya akan menjelaskan pelatar belakang saya mengambil judul skripsi tersebut. Yang kedua adalah kajian pustaka, lalu diikuti dengan metodologi, itu cara yang saya lakukan, atau teknik yang saya lakukan dalam pengambilan judul skripsi tersebut. Dan suangkinnya adalah hasil pembelajaran, dan terakhir adalah kesimpulan. Nah, itu dia, kalian maupun buka, semina proposa yang bisa kalian ikutin ketika kalian mau semu-pro atau seminan proposa. Asetlah, seperti itu, kamu langsung aja mulai kasih tau bahan skripsi mau misalnya kamu menggunakan porpoin ya kamu tingkat. Jelas kan aja apa yang di porpoinmu, lalu selain itu jalupa ucapkan terima kasih. Makasinya seperti ini. Bai Klas segin presentasi dari saya mengenai strategi, operatif, dalam pembelajaran bahasa Inggris di tingkat sekolah menengah pertama di kawasan sumatra utara. Terima kasih kepada Bapak. Bapak, ini kamu kesemputkan yang tadi ya, terima kasih kepada ibu, buatin ini ini terima kasih kepada Bapak. Dan terima kasih kepada Audi yang segera perhatiannya. Bapak Klas, saya tuh dengan wabilahi topik wanita ya, walaupun saya mau lagu, warah matu-lohi, warah berokat. Nah, sosai, tinggal penilai ya. Bapak Klas itu dia pembuka seminan proposa ya, pembuka sidang skripsi, yang bisa kamu ikutin, yang bisa kamu contohin ketika kamu mau seminan proposa. Semoga saya mau terbaik dan inget, jangan gugup dan jangan sampai salah. Dan rahasiannya adalah jangan sampai salah menyebutkan nama doosen penguji, doosen pembimbing, ya, jangan sampai salah. Dan jabatannya juga kamu harus cari tahu-betul, jangan sampai salah. Ingat, ini berpengaruh dalam pressempasinmu, dalam nilai pressempasinmu. So itu saja yang bisa aku sampai kan mengenai krips dan trick, membuka sidang skripsi. Kau video ini membantu kalian jangan lupa like, komendibawa kasih aku saran dan jangan lupa polis Instagram aku di Instagram isra. So, so thank you so good bye stay healthy, lusk, positive, bye bye.', '• Ekspresi suara Anda cukup netral. Cobalah untuk lebih antusias dan berenergi dalam penyampaian.\n• Perbaiki kejelasan pengucapan kata. Latih bicara lebih perlahan dan jelas.\n• Variasi intonasi cukup baik. Tingkatkan penekanan pada poin-poin penting.\n• Kurangi penggunaan kata pengisi (seperti \'eh\', \'um\', \'oo\') untuk kesan lebih profesional.\n• Perbanyak latihan presentasi, fokus pada ekspresi suara, kejelasan, dan variasi intonasi.', '2026-07-11 16:11:35.473');
INSERT INTO `evaluations` (`id`, `presentation_id`, `overall_score`, `articulation_score`, `intonation_score`, `transcription`, `feedback`, `created_at`) VALUES
(8, 13, 57.39, 44.29, 77.57, 'Halo semuanya, selamat malam terlalu berkata, kembali di sama aku. Jangan di video kali ini, aku bakal ke stel 5 dan 3 membuka seminar prokosal atau membuka sidang skripsi terbaru 2022. Jadi kalian bisa lakukan cara ini, ini cara yang simple, banget yang bisa kalian lakukan ketika kalian mau seminar prokosal beberapa hari kemudian. Susah sebelum asak video, jangan lupa untuk like video ini, subscribe channel ini dan lupa follow instagram aku jahat isra. Saat kita langsung aja masuk ke video-nya, bagaimana kalimat pangguka seminar prokosal skripsi 2022. Untuk ngawali sidang skripsi pertama sekali kita harus mengucapkan salam. Kalau misalnya muslim kamu bisa ucapkan salam seperti ini. Assalamualaikum warahmatullahi wabarakatuh. Kalo misalnya kamu non-muslim kamu bisa ucapkan sesuai dengan agama dan kepercayaanmu masih masih misalnya. Halo selamat lagi, selamat malam semuanya untuk kita semua. Ini yang saya mencari dengan agama dan kepercayaanmu masih masih. Yang kedua, menyapak dosan pengujik dan pembimbing. Contohnya gimana sih? Contohnya kayak gini nih. Yang terhormat dapat doktor darwin nasu di sini. Yang terhormat, menurutnya di sini. Yang terhormat, dapat doktor darwin nasu di sini. Yang terhormat, ibu uati MPD, selaku pembimbing utama. Yang terhormat, dapat mengharmat Hanavi MPD, selaku pemujik agama. Dan yang saya banggakan seluruh audien yang hadir pada sidang skripsi hari ini. Nah, selanjutnya adalah perkenalkan dirimu siapa dirimu dari juru samana angkatan berapa. Perkenalkan dirim simpel aja, contohnya kayak gini nih. Baiklah, perkenalkan sejenis terakhak saya dari juru sam bahasa Inggris angkatan tahun 19. Nah, selanjutnya adalah kasih tahun judol skripsi mu. Contohnya kayak gini nih. Baiklah, saya akan mempercentasikan hasil skripsi saya yang berjudul, strake di koperakis dalam pembelajaran bahasa Inggris di sekolah menengah pertama di sumat rah utara. Nah, setelah itu, kamu sampaikan point-point penting skripsi mu. Poin-point penting misalnya kayak gini nih. Baiklah, sebenarnya saya akan menyangpai point-point penting di sini yang pertama adalah pendahuluhan di mana saya akan menggelaskan lata belakang saya mengambil judol skripsi tersebut yang kedua adalah kajian pustaka di lanjutkan dengan metodologi. Ia itu metode yang saya ambil atau cara-cara yang saya lakukan dalam pengambilan judol tersebut. Terus, wajahnya adalah hasil pembelajaran dan terakhir ditutup dengan kesimpulan. Nah, itu dia kelimat pembuka seminal proposal yang bisa kamu lakukan. Simpel aja, tapi ingat itu berurutan yang bisa kalian ikutnya ketika kalian mau seminat proposal beberapa hari lagi. Ingat, jangan salah dan pengucapan mama, dosen penguci dan jangan salah dan pengucapan mama, dosen pembing-bing. Penguci dan pembing-bing, beda. Ingat, jangan salah nama dan jangan salah jabatannya. Karena ini berpengaruh banget dalam prestentasim. Nah, yang terakhir adalah kamu menyampaikan terima kasih kepada seluruh audian, kepada penguci dan kepada pembing-bing. Yang telah membelantungmu sampai saat ini telah menyalisaikan proposal skripsi. Oke, aku bakal kasih contoh kali napembukannya mulai dari awal sampai di kesimpulan. Seperti ini yang bisa kamu ikutin. Assalamualaikum warahmatullahi wabarakatuh, selamat pagi semuanya. Terutama-tama, mademah kita berusia kurup pada Allah yang telah membuat kesihatan kesempatan kekakitasi. Yang kita dapat berkumpul bersama-sama di sini. Salah dan sampe lupa, kita dia akan kepada Rasulullah, Salahullah, Kemalian iwasala. Yang yang siapa kita akan mendapatkan chefat di dia, umumnya akhir nanti. Anil mereka. Yang terakhir mat, bapak doktor darwin. Nah, Suti On, MSG selaku pemuci pertama. Yang terakhir mat, ibu kuatin MP selaku pembing-bing, kutama. Dan yang terhormat, bapak Hana Fina Suti On selaku pemuci agama. Dan yang saya banggakan audian simpel hadir pada hari ini. Bai Klas sebumbu, saya akan mempertenalkan diri Sejianis Rara Hat dari juru sen bahasa Inggris angkatan 2019. Bai Klas saya akan memprisentasikan skripsi saya yang berjudul, strategi, operatif, pembelajaran bahasa Inggris pada tingkat sekolah menengah pertama di kawasan sumatra utara. Bai Klas poin-poin penting di sini yang bakal saya sampaikan yang pertama dalam pendahuluan, dimana saya akan menjelaskan pelatar belakang saya mengambil judul skripsi tersebut. Yang kedua adalah kajian pustaka, lalu diikuti dengan metodologi, itu cara yang saya lakukan, atau teknik yang saya lakukan dalam pengambilan judul skripsi tersebut. Dan suangkinnya adalah hasil pembelajaran, dan terakhir adalah kesimpulan. Nah, itu dia, kalian maupun buka, semina proposa yang bisa kalian ikutin ketika kalian mau semu-pro atau seminan proposa. Asetlah, seperti itu, kamu langsung aja mulai kasih tau bahan skripsi mau misalnya kamu menggunakan porpoin ya kamu tingkat. Jelas kan aja apa yang di porpoinmu, lalu selain itu jalupa ucapkan terima kasih. Makasinya seperti ini. Bai Klas segin presentasi dari saya mengenai strategi, operatif, dalam pembelajaran bahasa Inggris di tingkat sekolah menengah pertama di kawasan sumatra utara. Terima kasih kepada Bapak. Bapak, ini kamu kesemputkan yang tadi ya, terima kasih kepada ibu, buatin ini ini terima kasih kepada Bapak. Dan terima kasih kepada Audi yang segera perhatiannya. Bapak Klas, saya tuh dengan wabilahi topik wanita ya, walaupun saya mau lagu, warah matu-lohi, warah berokat. Nah, sosai, tinggal penilai ya. Bapak Klas itu dia pembuka seminan proposa ya, pembuka sidang skripsi, yang bisa kamu ikutin, yang bisa kamu contohin ketika kamu mau seminan proposa. Semoga saya mau terbaik dan inget, jangan gugup dan jangan sampai salah. Dan rahasiannya adalah jangan sampai salah menyebutkan nama doosen penguji, doosen pembimbing, ya, jangan sampai salah. Dan jabatannya juga kamu harus cari tahu-betul, jangan sampai salah. Ingat, ini berpengaruh dalam pressempasinmu, dalam nilai pressempasinmu. So itu saja yang bisa aku sampai kan mengenai krips dan trick, membuka sidang skripsi. Kau video ini membantu kalian jangan lupa like, komendibawa kasih aku saran dan jangan lupa polis Instagram aku di Instagram isra. So, so thank you so good bye stay healthy, lusk, positive, bye bye.', '• Ekspresi suara Anda cukup netral. Cobalah untuk lebih antusias dan berenergi dalam penyampaian.\n• Perbaiki kejelasan pengucapan kata. Latih bicara lebih perlahan dan jelas.\n• Variasi intonasi cukup baik. Tingkatkan penekanan pada poin-poin penting.\n• Kurangi penggunaan kata pengisi (seperti \'eh\', \'um\', \'oo\') untuk kesan lebih profesional.\n• Perbanyak latihan presentasi, fokus pada ekspresi suara, kejelasan, dan variasi intonasi.', '2026-07-14 13:32:43.968'),
(9, 16, 0, 0, 0, '', '[ERROR] Analisis gagal: ', '2026-07-15 03:42:03.963');

-- --------------------------------------------------------

--
-- Table structure for table `presentations`
--

CREATE TABLE `presentations` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `file_path` varchar(500) NOT NULL,
  `duration` int(11) DEFAULT NULL,
  `uploaded_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `course_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `presentations`
--

INSERT INTO `presentations` (`id`, `user_id`, `title`, `file_path`, `duration`, `uploaded_at`, `course_id`) VALUES
(1, 3, 'Latihan Presentasi', 'uploads\\audio-1781663739498-177154677.mp3', NULL, '2026-06-17 02:35:39.580', NULL),
(2, 3, 'Latihan Presentasi', 'uploads\\audio-1781664351975-623758906.mp3', NULL, '2026-06-17 02:45:52.043', NULL),
(3, 3, 'Latihan Presentasi', 'uploads\\audio-1781664951729-613938139.mp3', NULL, '2026-06-17 02:55:51.788', NULL),
(4, 3, 'Latihan Presentasi', 'uploads\\audio-1781665205763-64284811.mp3', NULL, '2026-06-17 03:00:05.861', NULL),
(5, 3, 'Latihan Presentasi', 'uploads\\audio-1781665631100-746773520.mp3', NULL, '2026-06-17 03:07:11.204', NULL),
(6, 3, 'Latihan Presentasi', 'uploads\\audio-1781666941026-225971545.mp3', 687, '2026-06-17 03:29:01.089', NULL),
(7, 3, 'Latihan Presentasi 2', 'uploads\\audio-1781669632004-416760204.mp3', 410, '2026-06-17 04:13:52.042', NULL),
(8, 4, 'Latihan Presentasi', 'uploads\\audio-1782268574530-884633596.mp3', 410, '2026-06-24 02:36:14.625', NULL),
(9, 3, 'Latihan Presentasi 3', 'uploads\\audio-1783046921332-553986295.mp3', 410, '2026-07-03 02:48:41.407', 1),
(10, 4, 'Latihan Presentasi 123', 'uploads\\audio-1783048186041-439985043.mp3', 687, '2026-07-03 03:09:46.226', 1),
(11, 3, 'Presentasi UTS', 'uploads\\audio-1783782792407-940076224.mp3', 410, '2026-07-11 15:13:12.569', 2),
(12, 3, 'Latihan Presentasi 456', 'uploads\\audio-1783786068037-193403543.mp3', 410, '2026-07-11 16:07:48.067', 2),
(13, 3, 'Presentasi UAS', 'uploads\\audio-1784035742620-149908380.mp3', 410, '2026-07-14 13:29:02.697', 1),
(16, 3, 'Pengujian Presentasi', 'uploads\\audio-1784086923653-531405973.mp3', NULL, '2026-07-15 03:42:03.678', 1);

-- --------------------------------------------------------

--
-- Table structure for table `rubrics`
--

CREATE TABLE `rubrics` (
  `id` int(11) NOT NULL,
  `criteria_name` varchar(255) NOT NULL,
  `weight` double NOT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `rubrics`
--

INSERT INTO `rubrics` (`id`, `criteria_name`, `weight`, `description`) VALUES
(1, 'Ekspresi Emosi', 40, 'Penilaian berdasarkan klasifikasi emosi menggunakan model CNN-LSTM (neutral, happy, surprise, disgust, disappointed)'),
(2, 'Artikulasi', 30, 'Kejelasan pengucapan kata dan konsistensi energi suara'),
(3, 'Intonasi', 20, 'Variasi nada suara dan penekanan kata kunci'),
(4, 'Konten & Sentimen', 10, 'Analisis sentimen teks transkripsi - pilihan kata profesional');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('dosen','mahasiswa') NOT NULL DEFAULT 'mahasiswa',
  `nim_nip` varchar(20) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL,
  `avatar_url` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `nim_nip`, `created_at`, `updated_at`, `avatar_url`) VALUES
(1, 'Dr. Dosen Penguji', 'dosen@gmail.com', '$2b$12$oaqZJs97osorpiGqb5TObup6BrQwnEaiA7zyDUrDyWWqbNSCxNzl.', 'dosen', '198501012010011001', '2026-06-10 03:32:36.838', '2026-07-11 11:39:33.345', '/uploads/avatars/avatar-1783769968184-179292488.png'),
(2, 'Budi Santoso', 'budi@student.ac.id', '$2b$12$tYfKC592tLOUkBoZl8qh6On2AnPKWwLwLAU0a7z3NlLVRrv3bDcFi', 'mahasiswa', '2021001001', '2026-06-10 03:43:09.776', '2026-06-10 03:43:09.776', NULL),
(3, 'aulia al khairi', 'khairi@gmail.com', '$2b$12$IVaKcSzO/QRKWS65t5jvJenBzYHEv9FrIn22QWGk355OZdKNh/1km', 'mahasiswa', '2311082008', '2026-06-11 07:42:31.283', '2026-07-11 15:25:33.090', '/uploads/avatars/avatar-1783783533085-253200128.jpg'),
(4, 'aulia', 'aulia@gmail.com', '$2b$12$Pb48oAW2ZrtN00tKEIoly.Ie5DLWN52i2AOzdb0aGbu8/nVlRaNYe', 'mahasiswa', '23134234', '2026-06-24 02:35:43.543', '2026-06-24 02:35:43.543', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `_prisma_migrations`
--

CREATE TABLE `_prisma_migrations` (
  `id` varchar(36) NOT NULL,
  `checksum` varchar(64) NOT NULL,
  `finished_at` datetime(3) DEFAULT NULL,
  `migration_name` varchar(255) NOT NULL,
  `logs` text DEFAULT NULL,
  `rolled_back_at` datetime(3) DEFAULT NULL,
  `started_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `applied_steps_count` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `_prisma_migrations`
--

INSERT INTO `_prisma_migrations` (`id`, `checksum`, `finished_at`, `migration_name`, `logs`, `rolled_back_at`, `started_at`, `applied_steps_count`) VALUES
('34f42500-500c-4977-ac13-484cb5d5d03a', 'bc7bce0bbc0309d3f598340870d8ee1b147d70f40d2eb5e776409d9a5bde4a72', '2026-06-10 03:32:20.037', '20260610033219_init_assessai_schema', NULL, NULL, '2026-06-10 03:32:19.961', 1),
('a89b5068-b878-42e0-86b9-aca698447597', '9f50d6d6ccf9e1c08450f7aee243d9afd12c1fcf1e6e3ef5f849713ee4465b54', '2026-07-03 02:40:19.882', '20260703024019_add_course_avatar', NULL, NULL, '2026-07-03 02:40:19.823', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `courses_dosen_id_fkey` (`dosen_id`);

--
-- Indexes for table `emotion_results`
--
ALTER TABLE `emotion_results`
  ADD PRIMARY KEY (`id`),
  ADD KEY `emotion_results_evaluation_id_fkey` (`evaluation_id`);

--
-- Indexes for table `evaluations`
--
ALTER TABLE `evaluations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `evaluations_presentation_id_key` (`presentation_id`);

--
-- Indexes for table `presentations`
--
ALTER TABLE `presentations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `presentations_user_id_fkey` (`user_id`),
  ADD KEY `presentations_course_id_fkey` (`course_id`);

--
-- Indexes for table `rubrics`
--
ALTER TABLE `rubrics`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_key` (`email`);

--
-- Indexes for table `_prisma_migrations`
--
ALTER TABLE `_prisma_migrations`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `emotion_results`
--
ALTER TABLE `emotion_results`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `evaluations`
--
ALTER TABLE `evaluations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `presentations`
--
ALTER TABLE `presentations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `rubrics`
--
ALTER TABLE `rubrics`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `courses`
--
ALTER TABLE `courses`
  ADD CONSTRAINT `courses_dosen_id_fkey` FOREIGN KEY (`dosen_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `emotion_results`
--
ALTER TABLE `emotion_results`
  ADD CONSTRAINT `emotion_results_evaluation_id_fkey` FOREIGN KEY (`evaluation_id`) REFERENCES `evaluations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `evaluations`
--
ALTER TABLE `evaluations`
  ADD CONSTRAINT `evaluations_presentation_id_fkey` FOREIGN KEY (`presentation_id`) REFERENCES `presentations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `presentations`
--
ALTER TABLE `presentations`
  ADD CONSTRAINT `presentations_course_id_fkey` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `presentations_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
