import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'terms_conditions_page.dart';
import 'race_results_page.dart';
import 'pricing_page.dart';
import 'features_page.dart';
import 'contact_page.dart';
import 'faq_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Map<String, dynamic>> _searchResults = [];
  String selectedMenuItem = 'Search';
  bool isMobileMenuOpen = false;

  final List<String> menuItems = [
    'Home',
    'Race Results',
    'Pricing',
    'Features',
    'Contact',
    'FAQ',
  ];

  // Comprehensive search data from all pages
  final List<Map<String, dynamic>> _searchData = [
    // Home Page Content
    {'title': 'Race Timing Solution', 'description': 'RFID technology for precise race timing', 'page': 'Home', 'category': 'Service'},
    {'title': 'Running', 'description': 'Running race timing services', 'page': 'Home', 'category': 'Sport'},
    {'title': 'Cycling', 'description': 'Cycling race timing services', 'page': 'Home', 'category': 'Sport'},
    {'title': 'Triathlon', 'description': 'Triathlon race timing services', 'page': 'Home', 'category': 'Sport'},
    {'title': 'Request Quote', 'description': 'Get pricing information for race timing', 'page': 'Home', 'category': 'Action'},
    
    // Race Results Content
    {'title': 'Happy Run 2025', 'description': 'Race results for Happy Run 2025 event', 'page': 'Race Results', 'category': 'Event'},
    {'title': 'Past Events', 'description': 'View results from previous race events', 'page': 'Race Results', 'category': 'Event'},
    {'title': 'Race Results', 'description': 'Complete race timing results and rankings', 'page': 'Race Results', 'category': 'Service'},
    
    // Pricing Content
    {'title': 'Basic Package', 'description': 'Essential race timing package for small events', 'page': 'Pricing', 'category': 'Package'},
    {'title': 'Standard Package', 'description': 'Standard race timing package with more features', 'page': 'Pricing', 'category': 'Package'},
    {'title': 'Pro Package', 'description': 'Professional race timing package - Best Seller', 'page': 'Pricing', 'category': 'Package'},
    {'title': 'Elite Package', 'description': 'Premium race timing package for large events', 'page': 'Pricing', 'category': 'Package'},
    {'title': 'Customized Solution', 'description': 'Tailored race timing solution for your specific needs', 'page': 'Pricing', 'category': 'Service'},
    
    // Features Content
    {'title': 'RFID Technology', 'description': 'Advanced RFID chip timing system', 'page': 'Features', 'category': 'Technology'},
    {'title': 'Real-time Results', 'description': 'Live race results and timing updates', 'page': 'Features', 'category': 'Feature'},
    {'title': 'Multiple Checkpoints', 'description': 'Support for multiple timing checkpoints', 'page': 'Features', 'category': 'Feature'},
    {'title': 'Online Platform', 'description': 'Web-based results and participant management', 'page': 'Features', 'category': 'Platform'},
    {'title': 'Certificate Generation', 'description': 'Automatic certificate generation for participants', 'page': 'Features', 'category': 'Feature'},
    {'title': 'Data Export', 'description': 'Export race data in various formats', 'page': 'Features', 'category': 'Feature'},
    {'title': 'Technical Support', 'description': '24/7 technical support during events', 'page': 'Features', 'category': 'Support'},
    {'title': 'Scalable System', 'description': 'System that scales from small to large events', 'page': 'Features', 'category': 'Feature'},
    
    // Contact Content
    {'title': 'Contact Information', 'description': 'Get in touch with our race timing experts', 'page': 'Contact', 'category': 'Contact'},
    {'title': 'Phone Support', 'description': 'Call us for immediate assistance', 'page': 'Contact', 'category': 'Contact'},
    {'title': 'Email Support', 'description': 'Send us an email for detailed inquiries', 'page': 'Contact', 'category': 'Contact'},
    {'title': 'Office Location', 'description': 'Visit our office for in-person consultation', 'page': 'Contact', 'category': 'Contact'},
    {'title': 'WhatsApp Support', 'description': 'Quick support via WhatsApp messaging', 'page': 'Contact', 'category': 'Contact'},
    
    // FAQ Content
    {'title': 'Race Types', 'description': 'What types of races can your system handle?', 'page': 'FAQ', 'category': 'Question'},
    {'title': 'RFID System', 'description': 'How does the RFID timing system work?', 'page': 'FAQ', 'category': 'Question'},
    {'title': 'Accuracy', 'description': 'How accurate is your timing system?', 'page': 'FAQ', 'category': 'Question'},
    {'title': 'Checkpoints', 'description': 'Can I customize the number of checkpoints?', 'page': 'FAQ', 'category': 'Question'},
    {'title': 'Results Viewing', 'description': 'How do participants view their results?', 'page': 'FAQ', 'category': 'Question'},
    {'title': 'Participant Capacity', 'description': 'How many participants can your system handle?', 'page': 'FAQ', 'category': 'Question'},
    {'title': 'Event Support', 'description': 'Do you offer support during the race?', 'page': 'FAQ', 'category': 'Question'},
    {'title': 'Booking Timeline', 'description': 'How far in advance should I book?', 'page': 'FAQ', 'category': 'Question'},
    {'title': 'Custom Quote', 'description': 'Can I get a customized quote?', 'page': 'FAQ', 'category': 'Question'},
    {'title': 'Service Regions', 'description': 'What regions do you serve?', 'page': 'FAQ', 'category': 'Question'},
    
    // Terms & Conditions
    {'title': 'Terms and Conditions', 'description': 'Legal terms and conditions for our services', 'page': 'T&C', 'category': 'Legal'},
    {'title': 'Service Agreement', 'description': 'Terms of service for race timing', 'page': 'T&C', 'category': 'Legal'},
    {'title': 'Privacy Policy', 'description': 'How we handle participant data', 'page': 'T&C', 'category': 'Legal'},
    
    // General Terms
    {'title': 'Marathon', 'description': 'Full marathon race timing services', 'page': 'General', 'category': 'Race Type'},
    {'title': 'Half Marathon', 'description': 'Half marathon race timing services', 'page': 'General', 'category': 'Race Type'},
    {'title': '5K Race', 'description': '5K race timing services', 'page': 'General', 'category': 'Race Type'},
    {'title': '10K Race', 'description': '10K race timing services', 'page': 'General', 'category': 'Race Type'},
    {'title': 'Fun Run', 'description': 'Fun run and charity race timing', 'page': 'General', 'category': 'Race Type'},
    {'title': 'Obstacle Course', 'description': 'Obstacle course race timing', 'page': 'General', 'category': 'Race Type'},
    {'title': 'Indonesia', 'description': 'Race timing services in Indonesia', 'page': 'General', 'category': 'Location'},
    {'title': 'Southeast Asia', 'description': 'Race timing services across Southeast Asia', 'page': 'General', 'category': 'Location'},
    {'title': 'Australia', 'description': 'Race timing services in Australia', 'page': 'General', 'category': 'Location'},
  ];

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = _searchData
            .where((item) => 
                item['title'].toLowerCase().contains(query.toLowerCase()) ||
                item['description'].toLowerCase().contains(query.toLowerCase()) ||
                item['page'].toLowerCase().contains(query.toLowerCase()) ||
                item['category'].toLowerCase().contains(query.toLowerCase())
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Blue Header (responsive)
          Container(
            height: isMobile ? 70 : 80,
            decoration: const BoxDecoration(
              color: Colors.blue,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 10 : 20,
              ),
              child: isMobile ? _buildMobileHeader() : _buildDesktopHeader(),
            ),
          ),
          
          // Search Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Title
                  Text(
                    'Search',
                    style: TextStyle(
                      fontSize: isMobile ? 24 : 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: isMobile ? 16 : 20),
                  
                  // Search Input
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _performSearch,
                      decoration: InputDecoration(
                        hintText: isMobile 
                            ? 'Search...' 
                            : 'Search for races...',
                        prefixIcon: Icon(Icons.search, color: Colors.blue),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: isMobile ? 12 : 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Search Results
                  if (_searchQuery.isNotEmpty) ...[
                    Text(
                      'Search Results for "$_searchQuery"',
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: isMobile ? 12 : 16),
                  ],
                  
                  // Results List
                  Expanded(
                    child: _searchResults.isEmpty && _searchQuery.isNotEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No results found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : _searchResults.isEmpty
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Start typing to search...',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: _searchResults.length,
                                itemBuilder: (context, index) {
                                  final result = _searchResults[index];
                                  return GestureDetector(
                                    onTap: () => _navigateToPage(result['page']),
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: isMobile ? 6 : 8),
                                      padding: EdgeInsets.all(isMobile ? 12 : 16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey[300]!),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                _getCategoryIcon(result['category']),
                                                color: Colors.blue,
                                                size: isMobile ? 18 : 20,
                                              ),
                                              SizedBox(width: isMobile ? 8 : 12),
                                              Expanded(
                                                child: Text(
                                                  result['title'],
                                                  style: TextStyle(
                                                    fontSize: isMobile ? 14 : 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue[800],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: isMobile ? 6 : 8,
                                                  vertical: isMobile ? 2 : 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: _getCategoryColor(result['category']),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  result['category'],
                                                  style: TextStyle(
                                                    fontSize: isMobile ? 10 : 12,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: isMobile ? 4 : 6),
                                          Text(
                                            result['description'],
                                            style: TextStyle(
                                              fontSize: isMobile ? 12 : 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          SizedBox(height: isMobile ? 4 : 6),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.public,
                                                size: isMobile ? 12 : 14,
                                                color: Colors.grey[500],
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                'Page: ${result['page']}',
                                                style: TextStyle(
                                                  fontSize: isMobile ? 11 : 12,
                                                  color: Colors.grey[500],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Spacer(),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.grey,
                                                size: isMobile ? 12 : 14,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
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

  Widget _buildMobileHeader() {
    return Row(
      children: [
        // Logo
        Container(
          height: 150, // Sama untuk mobile dan desktop
          width: 150,  // Sama untuk mobile dan desktop
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
                    size: 80, // Sama untuk mobile dan desktop
                  ),
                );
              },
            ),
          ),
        ),
        
        const Spacer(),
        
        // Hamburger Menu
        GestureDetector(
          onTap: () {
            setState(() {
              isMobileMenuOpen = !isMobileMenuOpen;
            });
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
              size: 24,
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
          height: 150, // Sama untuk mobile dan desktop
          width: 150,  // Sama untuk mobile dan desktop
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
                    size: 80, // Sama untuk mobile dan desktop
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
            // Already on search page
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
      ],
    );
  }

  void _showMobileMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                return ListTile(
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
                  onTap: () {
                    setState(() {
                      selectedMenuItem = item;
                      isMobileMenuOpen = false;
                    });
                    Navigator.pop(context);
                    _handleNavigation(item);
                  },
                );
              }).toList(),
            ],
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
    } else if (item == 'FAQ') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FAQPage()),
      );
    } else if (item == 'T&C') {
      // Navigate to T&C page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const TermsConditionsPage(),
        ),
      );
    } else if (item == 'Search') {
      // Already on Search page
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

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Service':
        return Icons.build;
      case 'Sport':
        return Icons.sports;
      case 'Action':
        return Icons.touch_app;
      case 'Event':
        return Icons.event;
      case 'Package':
        return Icons.inventory;
      case 'Technology':
        return Icons.engineering;
      case 'Feature':
        return Icons.star;
      case 'Platform':
        return Icons.web;
      case 'Support':
        return Icons.support_agent;
      case 'Contact':
        return Icons.contact_phone;
      case 'Question':
        return Icons.help_outline;
      case 'Legal':
        return Icons.gavel;
      case 'Race Type':
        return Icons.directions_run;
      case 'Location':
        return Icons.location_on;
      default:
        return Icons.search;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Service':
        return Colors.blue;
      case 'Sport':
        return Colors.green;
      case 'Action':
        return Colors.orange;
      case 'Event':
        return Colors.purple;
      case 'Package':
        return Colors.red;
      case 'Technology':
        return Colors.teal;
      case 'Feature':
        return Colors.indigo;
      case 'Platform':
        return Colors.cyan;
      case 'Support':
        return Colors.amber;
      case 'Contact':
        return Colors.pink;
      case 'Question':
        return Colors.lime;
      case 'Legal':
        return Colors.brown;
      case 'Race Type':
        return Colors.deepOrange;
      case 'Location':
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }

  void _navigateToPage(String page) {
    if (page == 'Home') {
      Navigator.pop(context); // Go back to dashboard
    } else if (page == 'Race Results') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RaceResultsPage()),
      );
    } else if (page == 'Pricing') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PricingPage()),
      );
    } else if (page == 'Features') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FeaturesPage()),
      );
    } else if (page == 'Contact') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ContactPage()),
      );
    } else if (page == 'FAQ') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FAQPage()),
      );
    } else if (page == 'T&C') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TermsConditionsPage()),
      );
    } else {
      // For General or other pages, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('This content is available across multiple pages. Try searching for specific features.'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
