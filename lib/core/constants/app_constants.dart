/// 全局视觉常量（对齐 `产品ui文档.md` 第二节视觉基准）。
class AppColors {
  // 背景
  static const int ivory = 0xFFFAF8F3; // 暖米白
  static const int cream = 0xFFF7F3EA; // 奶油
  // 木色
  static const int wood = 0xFFB98252; // 浅木色（主色）
  static const int woodLight = 0xFFD9A878;
  static const int woodDark = 0xFF8C5A33;
  // 文字
  static const int darkBrown = 0xFF292621;
  static const int gray = 0xFF817A70;
  // 强调
  static const int red = 0xFFB84A3A; // 红印章

  AppColors._();
}

/// 菜谱分类（菜谱库筛选 / 新建编辑表单共用，保持一致）。
const List<String> kRecipeCategories = [
  '川菜',
  '家常菜',
  '下饭菜',
  '快手菜',
  '早餐',
  '汤羹',
  '甜品',
  '素菜',
  '肉菜',
];

/// 菜谱口味（新建编辑表单可选项）。
const List<String> kRecipeFlavors = [
  '五香', '卤香', '咖喱', '咸甜', '咸辣', '咸香', '咸鲜', '嫩', '孜然',
  '干香', '微辣', '清润', '清淡', '清爽', '清甜', '清鲜', '烟香', '甜',
  '甜咸', '糊辣', '糊辣荔枝口', '红油', '荔枝口', '葱香', '蒜香', '蜜汁',
  '酥脆', '酱香', '酸甜', '酸甜微辣', '酸辣', '香辣', '鲜', '鲜香', '麻辣',
];
