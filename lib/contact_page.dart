import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dashboard_page.dart';
import 'search_page.dart';
import 'terms_conditions_page.dart';
import 'race_results_page.dart';
import 'pricing_page.dart';
import 'features_page.dart';
import 'faq_page.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> with TickerProviderStateMixin {
  String selectedMenuItem = 'Contact';
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
                              'Contact',
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
                                  // Contact Content
                                  _buildContactContent(isMobile),
                                  
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
    } else if (item == 'Contact') {
      // Already on Contact page
    } else if (item == 'FAQ') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FAQPage()),
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
          color: text == 'Contact' ? Colors.blue : Colors.grey[700],
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
          color: text == 'Contact' ? Colors.blue : Colors.grey[700],
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
        // Reset to Contact when returning from Home
        setState(() {
          selectedMenuItem = 'Contact';
        });
      });
    } else if (text == 'Race Results') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RaceResultsPage()),
      ).then((_) {
        // Reset to Contact when returning from Race Results
        setState(() {
          selectedMenuItem = 'Contact';
        });
      });
    } else if (text == 'Pricing') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PricingPage()),
      ).then((_) {
        // Reset to Contact when returning from Pricing
        setState(() {
          selectedMenuItem = 'Contact';
        });
      });
    } else if (text == 'Features') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FeaturesPage()),
      ).then((_) {
        // Reset to Contact when returning from Features
        setState(() {
          selectedMenuItem = 'Contact';
        });
      });
    } else if (text == 'T&C') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TermsConditionsPage(),
        ),
      ).then((_) {
        // Reset to Contact when returning from T&C
        setState(() {
          selectedMenuItem = 'Contact';
        });
      });
    } else if (text == 'Contact') {
      // Already on Contact page
      return;
    } else if (text == 'FAQ') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FAQPage()),
      ).then((_) {
        // Reset to Contact when returning from FAQ
        setState(() {
          selectedMenuItem = 'Contact';
        });
      });
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

  Widget _buildContactContent(bool isMobile) {
    return Column(
      children: [
        // Get in Touch Section
        _buildGetInTouchSection(isMobile),
        
        SizedBox(height: isMobile ? 30 : 40),
        
        // Contact Information Section
        _buildContactInfoSection(isMobile),
        
        SizedBox(height: isMobile ? 30 : 40),
        
        // Request Quote Section
        _buildRequestQuoteSection(isMobile),
      ],
    );
  }

  Widget _buildGetInTouchSection(bool isMobile) {
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
              Icons.contact_support,
              color: Colors.blue[700],
              size: isMobile ? 30 : 40,
            ),
          ),
          
          SizedBox(height: isMobile ? 20 : 24),
          
          // Title
          Text(
            'Get in Touch',
            style: TextStyle(
              fontSize: isMobile ? 24 : 32,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: isMobile ? 16 : 20),
          
          // Description
          Text(
            'We\'re here to help you make your race a success! Whether you have questions about our race timing system, need a customized solution, or want to discuss your event in detail, our team is ready to assist you.',
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

  Widget _buildContactInfoSection(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.blue[700],
                size: isMobile ? 20 : 24,
              ),
              SizedBox(width: 8),
              Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: isMobile ? 18 : 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          
          SizedBox(height: isMobile ? 20 : 24),
          
          // Contact Details
          _buildContactDetail(
            isMobile: isMobile,
            icon: Icons.phone,
            title: 'Phone',
            content: '+62-852-0411-5000',
            onTap: () {
              // You can add phone call functionality here
            },
          ),
          
          SizedBox(height: isMobile ? 16 : 20),
          
          _buildContactDetail(
            isMobile: isMobile,
            icon: Icons.email,
            title: 'Email',
            content: 'runmlgrun@gmail.com',
            onTap: () {
              // You can add email functionality here
            },
          ),
          
          SizedBox(height: isMobile ? 16 : 20),
          
          _buildContactDetail(
            isMobile: isMobile,
            icon: Icons.location_on,
            title: 'Office',
            content: 'Jl. Mandalika, Malang, Jawa Timur, Indonesia',
            onTap: null,
          ),
        ],
      ),
    );
  }

  Widget _buildContactDetail({
    required bool isMobile,
    required IconData icon,
    required String title,
    required String content,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
          boxShadow: onTap != null ? [
            BoxShadow(
              color: Colors.blue.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ] : null,
        ),
        child: Row(
          children: [
            Container(
              width: isMobile ? 40 : 48,
              height: isMobile ? 40 : 48,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                icon,
                color: Colors.blue[700],
                size: isMobile ? 18 : 22,
              ),
            ),
            
            SizedBox(width: isMobile ? 12 : 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      fontWeight: FontWeight.w500,
                      color: onTap != null ? Colors.blue[700] : Colors.grey[800],
                      decoration: onTap != null ? TextDecoration.underline : null,
                    ),
                  ),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildRequestQuoteSection(bool isMobile) {
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
          // Section Title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.request_quote,
                color: Colors.blue[700],
                size: isMobile ? 20 : 24,
              ),
              SizedBox(width: 8),
              Text(
                'Request a Quote',
                style: TextStyle(
                  fontSize: isMobile ? 18 : 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          
          SizedBox(height: isMobile ? 16 : 20),
          
          // Description
          Text(
            'Interested in our race timing services? Contact us for a personalized quote tailored to your event\'s needs.',
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
