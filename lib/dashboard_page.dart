import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'search_page.dart';
import 'terms_conditions_page.dart';
import 'race_results_page.dart';
import 'pricing_page.dart';
import 'features_page.dart';
import 'contact_page.dart';
import 'faq_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with TickerProviderStateMixin {
  String selectedMenuItem = 'Home';
  bool isMobileMenuOpen = false;
  late ScrollController _scrollController;
  late AnimationController _headerAnimationController;
  late Animation<double> _headerOpacityAnimation;

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
    _scrollController.addListener(_onScroll);
    
    // Initialize animation controller
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    // Initialize opacity animation
    _headerOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeInOut,
    ));
  }


  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _headerAnimationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final scrollOffset = _scrollController.offset;
    // Fade in saat scroll: transparan di atas (0), muncul saat scroll (80px)
    final targetOpacity = (scrollOffset.clamp(0, 80)) / 80;
    
    // Animate to target opacity
    _headerAnimationController.animateTo(targetOpacity);
  }

  Future<void> _openWhatsApp() async {
    const whatsappUrl = 'https://api.whatsapp.com/send/?phone=6285708700863&text=Halo%2C%0A%0ASaya+tertarik+untuk+mengetahui+lebih+lanjut+tentang+solusi+pencatatan+waktu+balap+berbasis+RFID+yang+Anda+tawarkan.+Bisakah+Anda+memberikan+informasi+lebih+lanjut+mengenai+layanan+dan+paket+harga+yang+tersedia%3F&type=phone_number&app_absent=0';
    
    try {
      final Uri url = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat membuka WhatsApp'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan saat membuka WhatsApp'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image - Full to top with shadow
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: isMobile ? 400 : 500, // Increased height to cover header
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('backgroundlari.jpg'),
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
              // Header with transparent background and smooth fade effect
              AnimatedBuilder(
                animation: _headerOpacityAnimation,
                builder: (context, child) {
                  return Container(
                    height: isMobile ? 70 : 80,
                    child: Stack(
                      children: [
                        // Background dengan smooth fade effect
                        Container(
                          height: isMobile ? 70 : 80,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(_headerOpacityAnimation.value),
                          ),
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
                  );
                },
              ),
              
              // Main Content Area with Scrollable Background
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      // Hero Section with Text Overlay (no background image here)
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
                              'Race Timing Solution',
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
                           children: [
                           Text(
                             'Hi, race directors!',
                             textAlign: TextAlign.center,
                             style: TextStyle(
                               fontSize: isMobile ? 20 : 24,
                               fontWeight: FontWeight.bold,
                               color: Color(0xFF7B7575),
                             ),
                           ),
                           SizedBox(height: isMobile ? 16 : 24),
                           Text(
                             'Looking for a seamless and accurate race timing solution? Our RFID technology guarantees precise tracking for every participant, giving you one less thing to worry about on race day!',
                             textAlign: TextAlign.center,
                             style: TextStyle(
                               fontSize: isMobile ? 14 : 16,
                               color: Color(0xFF7B7575),
                               height: 1.5,
                             ),
                           ),
                           SizedBox(height: isMobile ? 16 : 24),
                           Text(
                             'Learn more about our offerings through the links below:',
                             textAlign: TextAlign.center,
                             style: TextStyle(
                               fontSize: isMobile ? 14 : 16,
                               color: Color(0xFF7B7575),
                             ),
                           ),
                           SizedBox(height: isMobile ? 15 : 20),
                           
                           // Service Links
                           Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               _buildServiceLink('PRICING'),
                               SizedBox(width: isMobile ? 20 : 30),
                               _buildServiceLink('FEATURES'),
                               SizedBox(width: isMobile ? 20 : 30),
                               _buildServiceLink('FAQ'),
                             ],
                           ),
                           SizedBox(height: isMobile ? 20 : 30),
                           
                          // Request Quote Button
                          ElevatedButton(
                            onPressed: _openWhatsApp,
                             style: ElevatedButton.styleFrom(
                               backgroundColor: Colors.black,
                               foregroundColor: Colors.white,
                               padding: EdgeInsets.symmetric(
                                 horizontal: isMobile ? 30 : 40,
                                 vertical: isMobile ? 12 : 16,
                               ),
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(8),
                               ),
                             ),
                             child: Text(
                               'Request Quote',
                               style: TextStyle(
                                 fontSize: isMobile ? 14 : 16,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                           ),
                           SizedBox(height: isMobile ? 30 : 40),
                           
                           // Sports Sections
                           isMobile ? _buildMobileSportsSections(isMobile) : _buildDesktopSportsSections(isMobile),
                           
                           // Add some bottom padding to prevent overflow
                           SizedBox(height: isMobile ? 20 : 30),
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
                         child: isMobile ? _buildMobileFooter() : _buildDesktopFooter(),
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
        
        const Spacer(),
        
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
        
        const SizedBox(width: 20),
        
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
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileFooter() {
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
              _buildMobileFooterLink('Home'),
              _buildMobileFooterSeparator(),
              _buildMobileFooterLink('Race Results'),
              _buildMobileFooterSeparator(),
              _buildMobileFooterLink('Pricing'),
              _buildMobileFooterSeparator(),
              _buildMobileFooterLink('Features'),
              _buildMobileFooterSeparator(),
              _buildMobileFooterLink('T&C'),
              _buildMobileFooterSeparator(),
              _buildMobileFooterLink('Contact'),
              _buildMobileFooterSeparator(),
              _buildMobileFooterLink('FAQ'),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // WhatsApp Link
          GestureDetector(
            onTap: _openWhatsApp,
          child: Text(
            'Request Quote (via WhatsApp)',
            style: TextStyle(
              fontFamily: 'Lexend',
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
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening email...'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: Text(
                  'runmlgrun@gmail.com',
                  style: TextStyle(
                    color: Colors.grey[700], // Menggunakan warna abu-abu gelap
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopFooter() {
    return Row(
      children: [
        // Left: Navigation links
        Row(
          children: [
            _buildFooterLink('Home'),
            _buildFooterSeparator(),
            _buildFooterLink('Race Results'),
            _buildFooterSeparator(),
            _buildFooterLink('Pricing'),
            _buildFooterSeparator(),
            _buildFooterLink('Features'),
            _buildFooterSeparator(),
            _buildFooterLink('T&C'),
            _buildFooterSeparator(),
            _buildFooterLink('Contact'),
            _buildFooterSeparator(),
            _buildFooterLink('FAQ'),
          ],
        ),
        
        const Spacer(),
        
        // Center: WhatsApp Link
        GestureDetector(
          onTap: _openWhatsApp,
          child: Text(
            'Request Quote (via WhatsApp)',
            style: TextStyle(
              fontFamily: 'Lexend',
              color: Colors.grey[700],
              fontSize: 14,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        
        const Spacer(),
        
        // Right: Email Address
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.email,
              color: Colors.grey[700],
              size: 16,
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening email...'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: Text(
                'runmlgrun@gmail.com',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooterLink(String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMenuItem = text;
        });
        _handleFooterLinkTap(text);
      },
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Lexend',
          color: Colors.grey[700],
          fontSize: 14,
          fontWeight: FontWeight.w500,
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
          fontFamily: 'Lexend',
          color: Colors.grey[500],
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildMobileFooterLink(String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMenuItem = text;
        });
        _handleFooterLinkTap(text);
      },
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Lexend',
          color: Colors.grey[700], // Menggunakan warna abu-abu gelap
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMobileFooterSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        '|',
        style: TextStyle(
          fontFamily: 'Lexend',
          color: Colors.grey[500], // Menggunakan warna abu-abu medium
          fontSize: 14,
        ),
      ),
    );
  }

  void _handleFooterLinkTap(String text) {
    if (text == 'Home') {
      // Already on Home page - reset selectedMenuItem to Home
      setState(() {
        selectedMenuItem = 'Home';
      });
    } else if (text == 'Race Results') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RaceResultsPage()),
      );
    } else if (text == 'Pricing') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PricingPage()),
      );
    } else if (text == 'Features') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FeaturesPage()),
      );
    } else if (text == 'Contact') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ContactPage()),
      );
    } else if (text == 'FAQ') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FAQPage()),
      );
    } else if (text == 'T&C') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const TermsConditionsPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$text page coming soon!'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
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
      // Already on Home page - reset selectedMenuItem to Home
      setState(() {
        selectedMenuItem = 'Home';
      });
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
    } else if (item == 'FAQ') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FAQPage()),
      );
    } else if (item == 'T&C') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TermsConditionsPage()),
      );
    } else if (item == 'Search') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SearchPage()),
      ).then((_) {
        // Reset to Home when returning from Search
        setState(() {
          selectedMenuItem = 'Home';
        });
      });
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

  Widget _buildServiceLink(String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMenuItem = text;
        });
        _handleFooterLinkTap(text);
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF7B7575),
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildDesktopSportsSections(bool isMobile) {
    return Row(
      children: [
        Expanded(child: _buildSportSection('Running', 'lari.jpg', isMobile)),
        SizedBox(width: 20),
        Expanded(child: _buildSportSection('Cycling', 'sepeda.jpg', isMobile)),
        SizedBox(width: 20),
        Expanded(child: _buildSportSection('Triathlon', 'triathlon.jpg', isMobile)),
      ],
    );
  }

  Widget _buildMobileSportsSections(bool isMobile) {
    return Column(
      children: [
        _buildSportSection('Running', 'lari.jpg', isMobile),
        SizedBox(height: 20),
        _buildSportSection('Cycling', 'sepeda.jpg', isMobile),
        SizedBox(height: 20),
        _buildSportSection('Triathlon', 'triathlon.jpg', isMobile),
      ],
    );
  }

  Widget _buildSportSection(String title, String imagePath, bool isMobile) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7B7575),
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: isMobile ? 150 : 180,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}