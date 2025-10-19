import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dashboard_page.dart';
import 'search_page.dart';
import 'terms_conditions_page.dart';
import 'race_results_page.dart';
import 'pricing_page.dart';
import 'features_page.dart';
import 'contact_page.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> with TickerProviderStateMixin {
  String selectedMenuItem = 'FAQ';
  late ScrollController _scrollController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool isMobileMenuOpen = false;

  final List<String> menuItems = [
    'Home',
    'Race Results',
    'Pricing',
    'Features',
    'Contact',
    'FAQ',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final scrollOffset = _scrollController.offset;
      if (scrollOffset > 50) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image - Full to top with shadow
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: isMobile ? 400 : 500,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('features.jpg'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 40,
                    offset: Offset(0, 20),
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
          ),
          
          // Black transparent overlay for highlight
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: isMobile ? 400 : 500,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
          
          // Main Content
          Column(
            children: [
              // Header with fade animation
              Container(
                height: isMobile ? 70 : 80,
                child: Stack(
                  children: [
                    // Animated background
                    AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return Container(
                          height: isMobile ? 70 : 80,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(_fadeAnimation.value),
                            boxShadow: _fadeAnimation.value > 0 ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ] : null,
                          ),
                        );
                      },
                    ),
                    // Header content (selalu terlihat)
                    Container(
                      height: isMobile ? 70 : 80,
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 10 : 20,
                      ),
                      child: isMobile ? _buildMobileHeader() : _buildDesktopHeader(),
                    ),
                  ],
                ),
              ),
              
              // Main Content Area with Scrollable Background
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      // Hero Section with Text Overlay
                      Container(
                        width: double.infinity,
                        height: isMobile ? 300 : 400,
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 20 : 40,
                              vertical: isMobile ? 20 : 30,
                            ),
                            child: Text(
                              'FAQ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isMobile ? 28 : 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // Additional content area (white background)
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        child: Column(
                          children: [
                            // Content with padding
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 20 : 40,
                                vertical: isMobile ? 30 : 50,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // FAQ Content
                                  _buildFAQContent(isMobile),
                                  
                                  const SizedBox(height: 30),
                                ],
                              ),
                            ),
                            
                            // Footer - Full width outside padding
                            Container(
                              width: double.infinity,
                              color: Colors.grey[200],
                              padding: EdgeInsets.symmetric(
                                vertical: isMobile ? 16 : 20,
                                horizontal: isMobile ? 16 : 20,
                              ),
                              child: isMobile ? _buildMobileFooter(context) : _buildDesktopFooter(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileHeader() {
    return Row(
      children: [
        // Logo
        Container(
          height: 150, // Diperbesar sama dengan desktop
          width: 150,  // Diperbesar sama dengan desktop
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'lariterus_logo-removebg-preview.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.white,
                  child: const Icon(
                    Icons.image,
                    color: Colors.grey,
                    size: 80, // Diperbesar sesuai dengan logo
                  ),
                );
              },
            ),
          ),
        ),
        
        const Spacer(),
        
        // Search Icon
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchPage(),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.search,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        
        const SizedBox(width: 10),
        
        // Mobile Menu Button (Hamburger)
        GestureDetector(
          onTap: () {
            _showMobileMenu(context);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.menu,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopHeader() {
    return Row(
      children: [
        // Logo
        Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'lariterus_logo-removebg-preview.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.white,
                  child: const Icon(
                    Icons.image,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
        ),
        
        Spacer(),
        
        // Navigation Menu
        Row(
          children: menuItems.map((item) {
            return Padding(
              padding: const EdgeInsets.only(right: 30),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedMenuItem = item;
                  });
                  _handleNavigation(item);
                },
                child: Text(
                  item,
                  style: TextStyle(
                    color: selectedMenuItem == item
                        ? Colors.white
                        : Colors.white70,
                    fontSize: 16,
                    fontWeight: selectedMenuItem == item
                        ? FontWeight.bold
                        : FontWeight.normal,
                    decoration: selectedMenuItem == item
                        ? TextDecoration.underline
                        : null,
                    decorationColor: Colors.white,
                    decorationThickness: 2,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        
        SizedBox(width: 20),
        
        // Search Icon
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchPage()),
            );
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.search,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Menu title
                const Text(
                  'Navigation Menu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Menu items
                ...menuItems.map((item) {
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: ListTile(
                      leading: Icon(
                        _getMenuIcon(item),
                        color: selectedMenuItem == item ? Colors.blue : Colors.grey[600],
                      ),
                      title: Text(
                        item,
                        style: TextStyle(
                          color: selectedMenuItem == item ? Colors.blue : Colors.grey[800],
                          fontWeight: selectedMenuItem == item ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: selectedMenuItem == item
                          ? const Icon(Icons.check, color: Colors.blue)
                          : null,
                      onTap: () {
                        setState(() {
                          selectedMenuItem = item;
                        });
                        Navigator.pop(context);
                        _handleNavigation(item);
                      },
                    ),
                  );
                }).toList(),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleNavigation(String item) {
    if (item == 'Home') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    } else if (item == 'Race Results') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RaceResultsPage()),
      );
    } else if (item == 'Pricing') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PricingPage()),
      );
    } else if (item == 'Features') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FeaturesPage()),
      );
    } else if (item == 'Contact') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ContactPage()),
      );
    } else if (item == 'T&C') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TermsConditionsPage()),
      );
    } else if (item == 'Search') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SearchPage()),
      );
    } else if (item == 'FAQ') {
      // Already on FAQ page
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$item page coming soon!'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  IconData _getMenuIcon(String item) {
    switch (item) {
      case 'Home':
        return Icons.home;
      case 'Race Results':
        return Icons.emoji_events;
      case 'Pricing':
        return Icons.attach_money;
      case 'Features':
        return Icons.star;
      case 'Contact':
        return Icons.contact_mail;
      case 'FAQ':
        return Icons.help;
      default:
        return Icons.circle;
    }
  }

  void _openWhatsApp() async {
    final url = 'https://api.whatsapp.com/send/?phone=6285708700863&text=Halo%2C%0A%0ASaya+tertarik+untuk+mengetahui+lebih+lanjut+tentang+solusi+pencatatan+waktu+balap+berbasis+RFID+yang+Anda+tawarkan.+Bisakah+Anda+memberikan+informasi+lebih+lanjut+mengenai+layanan+dan+paket+harga+yang+tersedia%3F&type=phone_number&app_absent=0';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open WhatsApp'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildMobileFooter(BuildContext context) {
    return Container(
      color: Colors.grey[200], // Tetap menggunakan warna abu-abu muda
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Navigation Links
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildMobileFooterLink(context, 'Home'),
              _buildMobileFooterSeparator(),
              _buildMobileFooterLink(context, 'Race Results'),
              _buildMobileFooterSeparator(),
              _buildMobileFooterLink(context, 'Pricing'),
              _buildMobileFooterSeparator(),
              _buildMobileFooterLink(context, 'Features'),
              _buildMobileFooterSeparator(),
              _buildMobileFooterLink(context, 'T&C'),
              _buildMobileFooterSeparator(),
              _buildMobileFooterLink(context, 'Contact'),
              _buildMobileFooterSeparator(),
              _buildMobileFooterLink(context, 'FAQ'),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // WhatsApp Link
          GestureDetector(
            onTap: _openWhatsApp,
            child: Text(
              'Request Quote (via WhatsApp)',
              style: TextStyle(
                color: Colors.grey[700], // Menggunakan warna abu-abu gelap
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Email Address
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.email,
                color: Colors.grey[700], // Menggunakan warna abu-abu gelap
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'runmlgrun@gmail.com',
                style: TextStyle(
                  color: Colors.grey[700], // Menggunakan warna abu-abu gelap
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Navigation Links
        Row(
          children: [
            _buildFooterLink(context, 'Home'),
            _buildFooterSeparator(),
            _buildFooterLink(context, 'Race Results'),
            _buildFooterSeparator(),
            _buildFooterLink(context, 'Pricing'),
            _buildFooterSeparator(),
            _buildFooterLink(context, 'Features'),
            _buildFooterSeparator(),
            _buildFooterLink(context, 'T&C'),
            _buildFooterSeparator(),
            _buildFooterLink(context, 'Contact'),
            _buildFooterSeparator(),
            _buildFooterLink(context, 'FAQ'),
          ],
        ),
        
        // WhatsApp Link (Center)
        GestureDetector(
          onTap: _openWhatsApp,
          child: Text(
            'Request Quote (via WhatsApp)',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        
        // Email Address (Right)
        Row(
          children: [
            Icon(
              Icons.email,
              color: Colors.grey[700],
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'runmlgrun@gmail.com',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileFooterLink(BuildContext context, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMenuItem = text;
        });
        _handleFooterLinkTap(context, text);
      },
      child: Text(
        text,
        style: TextStyle(
          color: text == 'FAQ' ? Colors.blue : Colors.grey[700],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFooterLink(BuildContext context, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMenuItem = text;
        });
        _handleFooterLinkTap(context, text);
      },
      child: Text(
        text,
        style: TextStyle(
          color: text == 'FAQ' ? Colors.blue : Colors.grey[700],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _handleFooterLinkTap(BuildContext context, String text) {
    if (text == 'Home') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      ).then((_) {
        // Reset to FAQ when returning from Home
        setState(() {
          selectedMenuItem = 'FAQ';
        });
      });
    } else if (text == 'Race Results') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RaceResultsPage()),
      ).then((_) {
        // Reset to FAQ when returning from Race Results
        setState(() {
          selectedMenuItem = 'FAQ';
        });
      });
    } else if (text == 'Pricing') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PricingPage()),
      ).then((_) {
        // Reset to FAQ when returning from Pricing
        setState(() {
          selectedMenuItem = 'FAQ';
        });
      });
    } else if (text == 'Features') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FeaturesPage()),
      ).then((_) {
        // Reset to FAQ when returning from Features
        setState(() {
          selectedMenuItem = 'FAQ';
        });
      });
    } else if (text == 'Contact') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ContactPage()),
      ).then((_) {
        // Reset to FAQ when returning from Contact
        setState(() {
          selectedMenuItem = 'FAQ';
        });
      });
    } else if (text == 'T&C') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TermsConditionsPage(),
        ),
      ).then((_) {
        // Reset to FAQ when returning from T&C
        setState(() {
          selectedMenuItem = 'FAQ';
        });
      });
    } else if (text == 'FAQ') {
      // Already on FAQ page
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$text page coming soon!'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Widget _buildMobileFooterSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        '|',
        style: TextStyle(
          color: Colors.grey[500], // Menggunakan warna abu-abu medium
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildFooterSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        '|',
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildFAQContent(bool isMobile) {
    return Column(
      children: [
        // Introduction Section
        _buildIntroductionSection(isMobile),
        
        SizedBox(height: isMobile ? 30 : 40),
        
        // FAQ Items
        _buildFAQItems(isMobile),
        
        SizedBox(height: isMobile ? 30 : 40),
        
        // Contact Section
        _buildContactSection(isMobile),
      ],
    );
  }

  Widget _buildIntroductionSection(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon
          Container(
            width: isMobile ? 60 : 80,
            height: isMobile ? 60 : 80,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.help_outline,
              color: Colors.blue[700],
              size: isMobile ? 30 : 40,
            ),
          ),
          
          SizedBox(height: isMobile ? 20 : 24),
          
          // Title
          Text(
            'Frequently Asked Questions (FAQ)',
            style: TextStyle(
              fontSize: isMobile ? 20 : 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: isMobile ? 16 : 20),
          
          // Description
          Text(
            'We understand that planning a race event comes with many questions. Below are some of the most common inquiries about our race timing system and services. If you don\'t find the answer you\'re looking for, feel free to reach out!',
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              color: Color(0xFF7B7575),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItems(bool isMobile) {
    final faqItems = [
      {
        'question': 'What types of races can your timing system be used for?',
        'answer': 'Our race timing system is highly versatile and can be used for various events, including marathons, triathlons, cycling races, obstacle courses, and fun runs. No matter the scale or type of race, our system is designed to deliver precise results.',
      },
      {
        'question': 'How does the RFID timing system work?',
        'answer': 'Each participant is assigned a BIB with an embedded RFID chip. As runners pass timing checkpoints and the finish line, the chip communicates with our antennas to record their time accurately. This ensures real-time results and precise tracking.',
      },
      {
        'question': 'How accurate is your timing system?',
        'answer': 'Our RFID-based timing system is designed for high accuracy, typically within seconds. We use multiple checkpoints and advanced equipment to ensure every split and finish time is captured accurately.',
      },
      {
        'question': 'Can I customize the number of checkpoints?',
        'answer': 'Yes! We offer the flexibility to add as many checkpoints as needed to match your race course. Whether you need basic start/finish tracking or multiple splits, our system can be customized to your event\'s layout.',
      },
      {
        'question': 'How do participants view their results?',
        'answer': 'Participants can view their results in real-time through our online platform after crossing the start or checkpoints.',
      },
      {
        'question': 'How many participants can your system handle?',
        'answer': 'Our system is scalable, capable of handling small races with hundreds participants to large events with thousands of runners. We have different packages designed to accommodate events of all sizes.',
      },
      {
        'question': 'Do you offer support during the race?',
        'answer': 'Yes, we provide full technical support during your event. Our team will assist with setup, monitor the system throughout the race, and ensure that all results are accurately recorded and reported.',
      },
      {
        'question': 'How far in advance should I book your race timing services?',
        'answer': 'We recommend booking as early as possible to secure your event date. Ideally, contact us at least 1-2 months before your race to ensure availability and adequate preparation time.',
      },
      {
        'question': 'Can I get a customized quote for my event?',
        'answer': 'Absolutely! We provide tailored quotes based on the specifics of your event, including the number of participants, checkpoints, and additional services required.',
      },
      {
        'question': 'What regions do you serve?',
        'answer': 'While we are headquartered in Indonesia, our race timing services are available across Southeast Asia and Australia. We are fully equipped to support events throughout these regions, ensuring accurate and reliable timing for races of any size.',
      },
    ];

    return Column(
      children: faqItems.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return Padding(
          padding: EdgeInsets.only(bottom: isMobile ? 16 : 20),
          child: _buildFAQItem(
            isMobile: isMobile,
            number: index + 1,
            question: item['question']!,
            answer: item['answer']!,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFAQItem({
    required bool isMobile,
    required int number,
    required String question,
    required String answer,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Number and Question
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Number Badge
              Container(
                width: isMobile ? 28 : 32,
                height: isMobile ? 28 : 32,
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    '$number',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 12 : 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: isMobile ? 12 : 16),
              
              // Question Text
              Expanded(
                child: Text(
                  question,
                  style: TextStyle(
                    fontSize: isMobile ? 15 : 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: isMobile ? 12 : 16),
          
          // Answer
          Padding(
            padding: EdgeInsets.only(left: isMobile ? 40 : 48),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: isMobile ? 13 : 15,
                color: Color(0xFF7B7575),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue[50]!,
            Colors.blue[100]!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue[200]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Icon
          Container(
            width: isMobile ? 50 : 60,
            height: isMobile ? 50 : 60,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              Icons.chat,
              color: Colors.blue[700],
              size: isMobile ? 24 : 28,
            ),
          ),
          
          SizedBox(height: isMobile ? 16 : 20),
          
          // Title
          Text(
            'Still have questions?',
            style: TextStyle(
              fontSize: isMobile ? 18 : 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: isMobile ? 8 : 12),
          
          // Description
          Text(
            'Don\'t hesitate to contact us, and we\'ll be happy to assist you!',
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              color: Color(0xFF7B7575),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: isMobile ? 24 : 32),
          
          // Request Quote Button
          Container(
            width: double.infinity,
            height: isMobile ? 50 : 56,
            child: ElevatedButton(
              onPressed: _openWhatsApp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: Colors.blue.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat,
                    size: isMobile ? 20 : 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Request Quote',
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
