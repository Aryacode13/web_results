import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dashboard_page.dart';
import 'search_page.dart';
import 'terms_conditions_page.dart';
import 'race_results_page.dart';
import 'features_page.dart';
import 'contact_page.dart';
import 'faq_page.dart';

class PricingPage extends StatefulWidget {
  const PricingPage({super.key});

  @override
  State<PricingPage> createState() => _PricingPageState();
}

class _PricingPageState extends State<PricingPage> with TickerProviderStateMixin {
  String selectedMenuItem = 'Pricing';
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
                  image: AssetImage('pricing.jpg'),
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
                              'Pricing',
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
                                  // Pricing Packages Section
                                  _buildPricingPackages(isMobile),
                                  
                                  SizedBox(height: isMobile ? 30 : 40),
                                  
                                  // Customized Solution Section
                                  _buildCustomizedSolution(isMobile),
                                  
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
    } else if (item == 'Pricing') {
      // Already on Pricing page
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
          color: text == 'Pricing' ? Colors.blue : Colors.grey[700],
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
          color: text == 'Pricing' ? Colors.blue : Colors.grey[700],
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
        // Reset to Pricing when returning from Home
        setState(() {
          selectedMenuItem = 'Pricing';
        });
      });
    } else if (text == 'Race Results') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RaceResultsPage()),
      ).then((_) {
        // Reset to Pricing when returning from Race Results
        setState(() {
          selectedMenuItem = 'Pricing';
        });
      });
    } else if (text == 'T&C') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TermsConditionsPage(),
        ),
      ).then((_) {
        // Reset to Pricing when returning from T&C
        setState(() {
          selectedMenuItem = 'Pricing';
        });
      });
    } else if (text == 'Pricing') {
      // Already on Pricing page
      return;
    } else if (text == 'Features') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FeaturesPage()),
      ).then((_) {
        // Reset to Pricing when returning from Features
        setState(() {
          selectedMenuItem = 'Pricing';
        });
      });
    } else if (text == 'Contact') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ContactPage()),
      ).then((_) {
        // Reset to Pricing when returning from Contact
        setState(() {
          selectedMenuItem = 'Pricing';
        });
      });
    } else if (text == 'FAQ') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FAQPage()),
      ).then((_) {
        // Reset to Pricing when returning from FAQ
        setState(() {
          selectedMenuItem = 'Pricing';
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

  Widget _buildPricingPackages(bool isMobile) {
    return Column(
      children: [
        // Pricing Packages Grid
        isMobile ? _buildMobilePricingGrid() : _buildDesktopPricingGrid(),
      ],
    );
  }

  Widget _buildMobilePricingGrid() {
    return Column(
      children: [
        _buildPricingCard(
          isMobile: true,
          packageName: 'Basic',
          runnerCapacity: '500 runners',
          price: 'IDR 34.500.000',
          features: [
            'Race Timing System',
            'BIB + chip',
            'BIB check at racepack collection',
            'BIB check at finish line',
          ],
          isBestSeller: false,
        ),
        SizedBox(height: 16),
        _buildPricingCard(
          isMobile: true,
          packageName: 'Standard',
          runnerCapacity: '1000 runners',
          price: 'IDR 52.000.000',
          features: [
            'Race Timing System',
            'BIB + chip',
            'BIB check at racepack collection',
            'Additional check point',
            'BIB check at finish line',
          ],
          isBestSeller: false,
        ),
        SizedBox(height: 16),
        _buildPricingCard(
          isMobile: true,
          packageName: 'Pro',
          runnerCapacity: '1500 runners',
          price: 'IDR 69.500.000',
          features: [
            'Race Timing System',
            'BIB + chip',
            'BIB check at racepack collection',
            '2 Additional check point',
            'BIB check at finish line',
          ],
          isBestSeller: true,
        ),
        SizedBox(height: 16),
        _buildPricingCard(
          isMobile: true,
          packageName: 'Elite',
          runnerCapacity: '2000 runners',
          price: 'IDR 74.000.000',
          features: [
            'Race Timing System',
            'BIB + chip',
            'BIB check at racepack collection',
            '2 Additional check point',
            'BIB check at finish line',
          ],
          isBestSeller: false,
        ),
      ],
    );
  }

  Widget _buildDesktopPricingGrid() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildPricingCard(
            isMobile: false,
            packageName: 'Basic',
            runnerCapacity: '500 runners',
            price: 'IDR 34.500.000',
            features: [
              'Race Timing System',
              'BIB + chip',
              'BIB check at racepack collection',
              'BIB check at finish line',
            ],
            isBestSeller: false,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildPricingCard(
            isMobile: false,
            packageName: 'Standard',
            runnerCapacity: '1000 runners',
            price: 'IDR 52.000.000',
            features: [
              'Race Timing System',
              'BIB + chip',
              'BIB check at racepack collection',
              'Additional check point',
              'BIB check at finish line',
            ],
            isBestSeller: false,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildPricingCard(
            isMobile: false,
            packageName: 'Pro',
            runnerCapacity: '1500 runners',
            price: 'IDR 69.500.000',
            features: [
              'Race Timing System',
              'BIB + chip',
              'BIB check at racepack collection',
              '2 Additional check point',
              'BIB check at finish line',
            ],
            isBestSeller: true,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildPricingCard(
            isMobile: false,
            packageName: 'Elite',
            runnerCapacity: '2000 runners',
            price: 'IDR 74.000.000',
            features: [
              'Race Timing System',
              'BIB + chip',
              'BIB check at racepack collection',
              '2 Additional check point',
              'BIB check at finish line',
            ],
            isBestSeller: false,
          ),
        ),
      ],
    );
  }

  Widget _buildPricingCard({
    required bool isMobile,
    required String packageName,
    required String runnerCapacity,
    required String price,
    required List<String> features,
    required bool isBestSeller,
  }) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isBestSeller ? Colors.blue[400]! : Colors.grey[300]!,
          width: isBestSeller ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Best Seller Badge
          if (isBestSeller)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'BEST SELLER',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 10 : 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          
          if (isBestSeller) SizedBox(height: 12),
          
          // Package Name
          Text(
            packageName,
            style: TextStyle(
              fontSize: isMobile ? 24 : 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          
          SizedBox(height: 4),
          
          // Runner Capacity
          Text(
            '($runnerCapacity)',
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              color: Color(0xFF7B7575),
            ),
          ),
          
          SizedBox(height: isMobile ? 16 : 20),
          
          // Features List
          ...features.map((feature) => Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.blue[600],
                  size: isMobile ? 16 : 18,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    feature,
                    style: TextStyle(
                      fontSize: isMobile ? 13 : 14,
                      color: Color(0xFF7B7575),
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
          
          SizedBox(height: isMobile ? 20 : 24),
          
          // Price
          Text(
            price,
            style: TextStyle(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          
          SizedBox(height: isMobile ? 16 : 20),
          
          // Request Quote Button
          GestureDetector(
            onTap: _openWhatsApp,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 14),
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Request Quote',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomizedSolution(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Divider Line
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[300],
            margin: EdgeInsets.only(bottom: isMobile ? 20 : 24),
          ),
          
          // Heading
          Text(
            'Looking for a customized solution for your race?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          
          SizedBox(height: isMobile ? 12 : 16),
          
          // Sub-heading
          Text(
            'Contact us today to discuss your specific needs:',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              color: Color(0xFF7B7575),
            ),
          ),
          
          SizedBox(height: isMobile ? 20 : 24),
          
          // Request Quote Button
          GestureDetector(
            onTap: _openWhatsApp,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 32 : 40,
                vertical: isMobile ? 12 : 14,
              ),
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Request Quote',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
