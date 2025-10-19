import '../../data/models/medicine_model.dart';
import '../../data/repositories/medicine_repository.dart';
import 'base_viewmodel.dart';

class MedicineViewModel extends BaseViewModel {
  final MedicineRepository _medicineRepository = MedicineRepository();
  
  List<MedicineModel> _medicines = [];
  List<MedicineModel> _searchResults = [];
  List<MedicineModel> _expiringMedicines = [];
  List<MedicineModel> _lowStockMedicines = [];
  MedicineModel? _selectedMedicine;
  
  // Pagination
  int _currentPage = 0;
  int _totalPages = 0;
  int _totalElements = 0;
  final int _pageSize = 10;
  
  // Getters
  List<MedicineModel> get medicines => _medicines;
  List<MedicineModel> get searchResults => _searchResults;
  List<MedicineModel> get expiringMedicines => _expiringMedicines;
  List<MedicineModel> get lowStockMedicines => _lowStockMedicines;
  MedicineModel? get selectedMedicine => _selectedMedicine;
  
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalElements => _totalElements;
  bool get hasNextPage => _currentPage < _totalPages - 1;
  bool get hasPreviousPage => _currentPage > 0;
  
  // Load all medicines
  Future<void> loadMedicines() async {
    try {
      setLoading();
      _medicines = await _medicineRepository.getAllMedicines();
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }
  
  // Load medicines with pagination
  Future<void> loadMedicinesPaginated({bool nextPage = false}) async {
    try {
      setLoading();
      
      if (nextPage && hasNextPage) {
        _currentPage++;
      } else if (!nextPage && hasPreviousPage) {
        _currentPage--;
      }
      
      final result = await _medicineRepository.getMedicinesPaginated(
        page: _currentPage,
        size: _pageSize,
      );
      
      _medicines = result['content'] as List<MedicineModel>;
      _totalElements = result['totalElements'];
      _totalPages = result['totalPages'];
      _currentPage = result['currentPage'];
      
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }
  
  // Search medicines
  Future<void> searchMedicines(String keyword) async {
    if (keyword.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    
    try {
      setLoading();
      _searchResults = await _medicineRepository.searchMedicines(keyword);
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }
  
  // Get medicine by ID
  Future<void> getMedicineById(int id) async {
    try {
      setLoading();
      _selectedMedicine = await _medicineRepository.getMedicineById(id);
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }
  
  // Create new medicine
  Future<bool> createMedicine(MedicineModel medicine) async {
    try {
      setLoading();
      final createdMedicine = await _medicineRepository.createMedicine(medicine);
      _medicines.insert(0, createdMedicine);
      setSuccess();
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    }
  }
  
  // Update medicine
  Future<bool> updateMedicine(int id, MedicineModel medicine) async {
    try {
      setLoading();
      final updatedMedicine = await _medicineRepository.updateMedicine(id, medicine);
      
      final index = _medicines.indexWhere((m) => m.id == id);
      if (index != -1) {
        _medicines[index] = updatedMedicine;
      }
      
      setSuccess();
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    }
  }
  
  // Delete medicine
  Future<bool> deleteMedicine(int id) async {
    try {
      setLoading();
      await _medicineRepository.deleteMedicine(id);
      _medicines.removeWhere((m) => m.id == id);
      setSuccess();
      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    }
  }
  
  // Load expiring medicines
  Future<void> loadExpiringMedicines({int daysBeforeExpiry = 30}) async {
    try {
      setLoading();
      _expiringMedicines = await _medicineRepository.getExpiringMedicines(
        daysBeforeExpiry: daysBeforeExpiry,
      );
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }
  
  // Load low stock medicines
  Future<void> loadLowStockMedicines() async {
    try {
      setLoading();
      _lowStockMedicines = await _medicineRepository.getLowStockMedicines();
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }
  
  // Clear search results
  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }
  
  // Clear selected medicine
  void clearSelectedMedicine() {
    _selectedMedicine = null;
    notifyListeners();
  }
}