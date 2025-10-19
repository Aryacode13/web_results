import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dashboard_page.dart';
import 'search_page.dart';
import 'terms_conditions_page.dart';
import 'pricing_page.dart';
import 'features_page.dart';
import 'contact_page.dart';
import 'faq_page.dart';
import 'happy_result_page.dart';

class RaceResultsPage extends StatefulWidget {
  const RaceResultsPage({super.key});

  @override
  State<RaceResultsPage> createState() => _RaceResultsPageState();
}

class _RaceResultsPageState extends State<RaceResultsPage> with TickerProviderStateMixin {
  String selectedMenuItem = 'Race Results';
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
            height: isMobile ? 400 : 500, // Increased height to cover header
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('tiga.jpg'),
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
                              'Race Results',
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
                                      // Title
                                      Center(
                                        child: Text(
                                          'Past Events',
                                          style: TextStyle(
                                            fontSize: isMobile ? 28 : 36,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[800],
                                          ),
                                        ),
                                      ),
                                      
                                      SizedBox(height: isMobile ? 16 : 24),
                                      
                                      // Subtitle
                                      Center(
                                        child: Text(
                                          'Click on any event to view race results',
                                          style: TextStyle(
                                            fontSize: isMobile ? 16 : 18,
                                            color: Color(0xFF7B7575),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      
                                      SizedBox(height: isMobile ? 30 : 40),
                                      
                                      // Event Cards
                                      _buildEventCard(
                                        isMobile: isMobile,
                                        eventName: 'Happy Run 2025',
                                        date: 'August 10, 2025',
                                        raceType: '5K Race',
                                        location: 'Bekasi, Jawa Barat',
                                        isClickable: true,
                                      ),
                                      
                                      SizedBox(height: isMobile ? 16 : 20),
                                      
                                      _buildEventCard(
                                        isMobile: isMobile,
                                        eventName: 'COMING SOON',
                                        date: '',
                                        raceType: '',
                                        location: '',
                                        isClickable: false,
                                      ),
                                      
                                      SizedBox(height: isMobile ? 16 : 20),
                                      
                                      _buildEventCard(
                                        isMobile: isMobile,
                                        eventName: 'COMING SOON',
                                        date: '',
                                        raceType: '',
                                        location: '',
                                        isClickable: false,
                                      ),
                                      
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
                builder: (context) => SearchPage(),
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
            _showMobileMenu();
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
                builder: (context) => SearchPage(),
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

  void _showMobileMenu() {
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
      // Already on Race Results page
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SearchPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$item page coming soon!'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
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

  Future<void> _openHappyResultInNewTab() async {
    try {
      // Get current URL and modify it to open Happy Result page
      final currentUrl = Uri.base.toString();
      final baseUrl = currentUrl.split('#')[0]; // Remove any hash fragments
      final happyResultUrl = '$baseUrl#/happy-result';
      
      final Uri url = Uri.parse(happyResultUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        // Fallback: try to open in same tab
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HappyResultPage()),
        );
      }
    } catch (e) {
      // Fallback: open in same tab if URL launch fails
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HappyResultPage()),
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
                    fontFamily: 'Lexend',
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

  Widget _buildDesktopFooter(BuildContext context) {
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
                  fontFamily: 'Lexend',
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
          color: text == 'Race Results' ? Colors.blue : Colors.grey[700],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _handleFooterLinkTap(String text) {
    if (text == 'Home') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    } else if (text == 'Race Results') {
      // Already on Race Results page
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
          color: text == 'Race Results' ? Colors.blue : Colors.grey[700],
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

  Widget _buildEventCard({
    required bool isMobile,
    required String eventName,
    required String date,
    required String raceType,
    required String location,
    required bool isClickable,
  }) {
    return GestureDetector(
        onTap: isClickable ? () {
          if (eventName == 'Happy Run 2025') {
            // Open Happy Result in new tab
            _openHappyResultInNewTab();
          } else {
            // TODO: Navigate to specific event results
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Event results for $eventName coming soon!'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } : null,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        decoration: BoxDecoration(
          color: isClickable ? Colors.white : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isClickable ? Colors.blue[200]! : Colors.grey[300]!,
            width: 1,
          ),
          boxShadow: isClickable ? [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ] : null,
        ),
        child: isClickable ? _buildClickableEventCard(isMobile, eventName, date, raceType, location) : _buildComingSoonCard(isMobile),
      ),
    );
  }

  Widget _buildClickableEventCard(bool isMobile, String eventName, String date, String raceType, String location) {
    return Row(
      children: [
        // Event Icon
        Container(
          width: isMobile ? 50 : 60,
          height: isMobile ? 50 : 60,
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(
            Icons.directions_run,
            color: Colors.blue[700],
            size: isMobile ? 24 : 28,
          ),
        ),
        
        SizedBox(width: isMobile ? 12 : 16),
        
        // Event Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Name
              Text(
                eventName,
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              
              SizedBox(height: isMobile ? 8 : 10),
              
              // Date
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: isMobile ? 14 : 16,
                    color: Color(0xFF7B7575),
                  ),
                  SizedBox(width: 6),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 14,
                      color: Color(0xFF7B7575),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 4),
              
              // Race Type
              Row(
                children: [
                  Icon(
                    Icons.flag,
                    size: isMobile ? 14 : 16,
                    color: Color(0xFF7B7575),
                  ),
                  SizedBox(width: 6),
                  Text(
                    raceType,
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 14,
                      color: Color(0xFF7B7575),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 4),
              
              // Location
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: isMobile ? 14 : 16,
                    color: Color(0xFF7B7575),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      location,
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        color: Color(0xFF7B7575),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Arrow Icon
        Icon(
          Icons.arrow_forward_ios,
          color: Colors.blue[600],
          size: isMobile ? 16 : 18,
        ),
      ],
    );
  }

  Widget _buildComingSoonCard(bool isMobile) {
    return Center(
      child: Text(
        'COMING SOON',
        style: TextStyle(
          fontSize: isMobile ? 16 : 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey[500],
        ),
      ),
    );
  }
}
