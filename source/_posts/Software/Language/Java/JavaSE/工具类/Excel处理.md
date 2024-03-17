---
title: Java Excel处理
categories:
- Software
- Language
- Java
- JavaSE
- 工具类
---
# Java Excel处理

## Apache POI

- Apache POI是Apache软件基金会的开放源码函式库,POI提供API给Java程序对Microsoft Office格式档案读和写的功能
- 结构:
    - HSSF － 提供读写Microsoft Excel格式档案的功能(Excel 2003 版本)
    - XSSF － 提供读写Microsoft Excel OOXML格式档案的功能(Excel 2007 版本)
    - HWPF － 提供读写Microsoft Word格式档案的功能
    - HSLF － 提供读写Microsoft PowerPoint格式档案的功能
    - HDGF － 提供读写Microsoft Visio格式档案的功能

### pom.xml

```xml
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi-ooxml</artifactId>
    <version>3.17</version>
</dependency>
```

- 日期格式化工具

```xml
<dependency>
    <groupId>joda-time</groupId>
    <artifactId>joda-time</artifactId>
    <version>2.10.1</version>
</dependency>
```

### HSSF

- 提供读写Microsoft Excel格式档案的功能(Excel 2003 版本)
- **缺点**:最多只能处理 65536 行，否则会抛出异常
- **优点**:过程中写入缓存，不操作磁盘，最后一次性写入磁盘，速度快

#### Write

```java
public class Test {

    public void ExcelTest() throws IOException {
        String PATH = "/Users/cian/Downloads";
        // 创建工作薄
        HSSFWorkbook workbook = new HSSFWorkbook();
        // 创建工作表
        HSSFSheet sheet = workbook.createSheet("HSSFWriteTest");

        // 创建第一行
        Row row1 = sheet.createRow(0);
        // 创建单元格(1,1)
        Cell cell11 = row1.createCell(0);
        cell11.setCellValue("(1,1)");
        // 创建单元格(1,2)
        Cell cell12 = row1.createCell(1);
        cell12.setCellValue(1.2);

        // 创建第二行
        Row row2 = sheet.createRow(1);
        // 创建单元格(2,1)
        Cell cell21 = row2.createCell(0);
        cell21.setCellValue("(2,1)");
        // 创建单元格(2,2)
        Cell cell22 = row2.createCell(1);
        cell22.setCellValue(2.2);

        // 生成一张表,03版本的使用xls结尾
        FileOutputStream fileOutputStream = new FileOutputStream(PATH + "/HSSFWriteTest.xls");
        workbook.write(fileOutputStream);
        // 关闭流
        fileOutputStream.close();
    }

}
```

#### Read

##### 基本读取

```java
public class Test {

    public void ExcelTest() throws IOException {
        String PATH = "/Users/cian/Downloads";
        // 获取文件流
        FileInputStream fileInputStream = new FileInputStream(PATH + "/HSSFWriteTest.xlsx");
        // 根据文件创建一个工作簿对象
        HSSFWorkbook workbook = new HSSFWorkbook(fileInputStream);
        // 得到表
        HSSFSheet sheet = workbook.getSheetAt(0);
        // 得到第一行
        Row row = sheet.getRow(0);
        // 得到第一列
        Cell cell = row.getCell(0);
        System.out.println(cell.getNumericCellValue());
        // 得到第二列
        Cell cell1 = row.getCell(1);
        System.out.println(cell1.getNumericCellValue());
        // 关闭文件流
        fileInputStream.close();
    }

}
```

##### 根据数据类型遍历读取

```java
public class Test {

    public void ExcelTest() throws IOException {
        String PATH = "/Users/cian/Downloads";
        // 获取文件流
        FileInputStream fileInputStream = new FileInputStream(PATH + "/HSSFWriteTest.xls");
        // 根据文件创建一个工作簿对象
        Workbook workbook = new HSSFWorkbook(fileInputStream);
        // 获得该工作簿的第一个工作表
        Sheet sheet = workbook.getSheetAt(0);
        // 获取标题内容
        Row rowTitle = sheet.getRow(0);
        if (rowTitle != null) {
            // 获取列的数量
            int rowCount = rowTitle.getPhysicalNumberOfCells();
            for (int cellNum = 0; cellNum < rowCount; cellNum++) {
                Cell cell = rowTitle.getCell(cellNum);
                if (cell != null) {
                    String cellValue = cell.getStringCellValue();
                    System.out.print(cellValue + " | ");
                }
            }
            System.out.println();
        }

        // 遍历行
        int rowCount = sheet.getPhysicalNumberOfRows();
        for (int rowNum = 1; rowNum < rowCount; rowNum++) {
            Row rowData = sheet.getRow(rowNum);
            if (rowData != null) {
                // 遍历列
                int cellCount = rowData.getPhysicalNumberOfCells();
                for (int cellNum = 0; cellNum < cellCount; cellNum++) {
                    System.out.print("(" + (rowNum + 1) + "," + (cellNum + 1) + ")");

                    Cell cell = rowData.getCell(cellNum);
                    // 匹配列的数据类型
                    if (cell != null) {
                        CellType cellTypeEnum = cell.getCellTypeEnum();
                        String cellValue = "";
                        switch (cellTypeEnum) {
                            case STRING: // 字符串
                                System.out.print("[String]: ");
                                cellValue = cell.getStringCellValue();
                                break;
                            case BOOLEAN: // 布尔
                                System.out.print("[BOOLEAN]: ");
                                cellValue = String.valueOf(cell.getBooleanCellValue());
                                break;
                            case _NONE: // 空
                                System.out.print("[NONE]: ");
                                break;
                            case NUMERIC: // 数字
                                System.out.print("[NUMERIC]: ");
                                // 日期
                                if (HSSFDateUtil.isCellDateFormatted(cell)) {
                                    System.out.print("[数字转换为DATE]: ");
                                    Date date = cell.getDateCellValue();
                                    cellValue = new DateTime(date).toString();
                                } else {
                                    // 不是日期格式，防止数字过长
                                    System.out.print("[数字转换为字符串输出]: ");
                                    cell.setCellType(CellType.STRING);
                                    cellValue = cell.toString();
                                }
                                break;
                            case ERROR:
                                System.out.print("[ERROR]");
                                break;
                        }
                        System.out.println(cellValue);
                    }
                }
            }
        }
        fileInputStream.close();
    }

}
```

##### 读取公式

```java
public class Test {

    public void ExcelTest() throws IOException {
        String PATH = "/Users/cian/Downloads";
        // 获取文件流
        FileInputStream fileInputStream = new FileInputStream(PATH + "/HSSFWriteTest.xls");
        // 根据文件创建一个工作簿对象
        Workbook workbook = new HSSFWorkbook(fileInputStream);
        // 获得该工作簿的第一个工作表
        Sheet sheet = workbook.getSheetAt(0);

        Row row = sheet.getRow(3);
        Cell cell = row.getCell(0);

        // 拿到计算公式
        FormulaEvaluator formulaEvaluator = new HSSFFormulaEvaluator((HSSFWorkbook) workbook);

        // 输出单元格的内容
        CellType cellTypeEnum = cell.getCellTypeEnum();
        if (cellTypeEnum == CellType.FORMULA) {
            // 打印公式
            System.out.println(cell.getCellFormula());
            // 计算公式
            CellValue evaluate = formulaEvaluator.evaluate(cell);
            String cellValue = evaluate.formatAsString();
            System.out.println(cellValue);
        }
    }

}
```

### XSSF

- 提供读写Microsoft Excel OOXML格式档案的功能(Excel 2007 版本)
- **缺点**:写数据时速度非常慢，非常耗内存，也会发生内存溢出，如 100 万条数据
- **优点**:可以写较大的数据量，如 20 万条

#### Write

```java
public class Test {

    public void ExcelTest() throws IOException {
        String PATH = "/Users/cian/Downloads";
        // 开始时间
        long begin = System.currentTimeMillis();
        // 创建工作薄
        XSSFWorkbook workbook = new XSSFWorkbook();
        // 创建表
        XSSFSheet sheet = workbook.createSheet();
        // 写入数据
        for (int rowNum = 0; rowNum < 65537; rowNum++) {
            Row row = sheet.createRow(rowNum);
            for (int cellNum = 0; cellNum < 10; cellNum++) {
                Cell cell = row.createCell(cellNum);
                cell.setCellValue(cellNum);
            }
        }
        FileOutputStream fileOutputStream = new FileOutputStream(PATH + "/XSSFWriteTest.xlsx");
        workbook.write(fileOutputStream);
        fileOutputStream.close();
        // 结束时间
        long end = System.currentTimeMillis();
        // 输出所用的时间
        System.out.println((double) (end - begin) / 1000);
    }
}
```

#### Read

```java
public class Test {

    public void ExcelTest() throws IOException {
        String PATH = "/Users/cian/Downloads";
        // 获取文件流
        FileInputStream fileInputStream = new FileInputStream(PATH + "/XSSFWriteTest.xlsx");
        // 根据文件创建一个工作簿对象
        XSSFWorkbook workbook = new XSSFWorkbook(fileInputStream);
        // 得到表
        XSSFSheet sheet = workbook.getSheetAt(0);
        // 得到第一行
        Row row = sheet.getRow(0);
        // 得到第一列
        Cell cell = row.getCell(0);
        System.out.println(cell.getNumericCellValue());
        // 得到第二列
        Cell cell1 = row.getCell(1);
        System.out.println(cell1.getNumericCellValue());
        // 关闭文件流
        fileInputStream.close();
    }

}
```

### SXSSF

- SXSSFWorkbook 来自官方的解释：实现"BigGridDemo” 策略的流式 SXSSFWorkbook 版本，这允许写入非常大的文件而不会耗尽内存，因为任何时候只有可配置的行部分被保存在内存中
- **缺点**:仍然可能会消耗大量内存，这些内存基于你正在使用的功能，例如合并区域，注释只存储在内存中，因此如果广泛使用，可能需要大量内存
- **优点**:可以写非常大的数据量，如 100 万条甚至更多，写数据速度快，占用更少的内存
- **注意**:过程总会产生临时文件，需要清理临时文件，默认由 100 条记录被保存在内存中，则最前面的数据被写入临时文件，如果想要自定义内存中数据的数量，可以使用`new SXSSFWorkbook(数量)`

#### Write

```java
public class Test {

    public void ExcelTest() throws IOException {
        String PATH = "/Users/cian/Downloads";
        // 开始时间
        long begin = System.currentTimeMillis();
        // 创建工作薄
        SXSSFWorkbook workbook = new SXSSFWorkbook();
        // 创建表
        SXSSFSheet sheet = workbook.createSheet();
        // 写入数据
        for (int rowNum = 0; rowNum < 65537; rowNum++) {
            Row row = sheet.createRow(rowNum);
            for (int cellNum = 0; cellNum < 10; cellNum++) {
                Cell cell = row.createCell(cellNum);
                cell.setCellValue(cellNum);
            }
        }
        FileOutputStream fileOutputStream = new FileOutputStream(PATH + "/SXSSFWriteTest.xlsx");
        workbook.write(fileOutputStream);
        fileOutputStream.close();
        // 清除临时文件
        workbook.dispose();
        // 结束时间
        long end = System.currentTimeMillis();
        // 输出所用的时间
        System.out.println((double) (end - begin) / 1000);
    }

}
```

#### Read

```java
public class Test {

    public void ExcelTest() throws IOException {
        String PATH = "/Users/cian/Downloads";
        // 获取文件流
        FileInputStream fileInputStream = new FileInputStream(PATH + "/XSSFWriteTest.xlsx");
        // 根据文件创建一个工作簿对象
        SXSSFWorkbook workbook = new SXSSFWorkbook(fileInputStream);
        // 得到表
        SXSSFSheet sheet = workbook.getSheetAt(0);
        // 得到第一行
        Row row = sheet.getRow(0);
        // 得到第一列
        Cell cell = row.getCell(0);
        System.out.println(cell.getNumericCellValue());
        // 得到第二列
        Cell cell1 = row.getCell(1);
        System.out.println(cell1.getNumericCellValue());
        // 关闭文件流
        fileInputStream.close();
    }

}
```

## EasyExcel

- EasyExcel 是阿里巴巴开源的一个 excel处理框架，以使用简单，节省内存著称
- EasyExcel 能大大减少内存占用的主要原因是在解析 Excel 时没有将文件数据一次性全部加载到内存中，而是从磁盘上一行行读取数据，逐个解析

![](https://raw.githubusercontent.com/LuShan123888/Files/main/Pictures/2021-02-06-resize,w_746.png)

### pom.xml

```xml
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>easyexcel</artifactId>
    <version>2.2.7</version>
</dependency>
```

### Write

**实体类**

- `DemoData.java`

```java
@Data
public class DemoData {
    @ExcelProperty("字符串标题")
    private String string;
    @ExcelProperty("日期标题")
    private Date date;
    @ExcelProperty("数字标题")
    private Double doubleData;
    /**
     * 忽略这个字段
     */
    @ExcelIgnore
    private String ignore;
}
```

**测试写入数据**

```java
public class Test {

    // 初始化测试对象集合
    private List<DemoData> data() {
        List<DemoData> list = new ArrayList<DemoData>();
        for (int i = 0; i < 10; i++) {
            DemoData data = new DemoData();
            data.setString("字符串" + i);
            data.setDate(new Date());
            data.setDoubleData(0.56);
            list.add(data);
        }
        return list;
    }

    // 根据list 写入 Excel
    public void EasyExcelTest() {
        String PATH = "/Users/cian/Downloads";
        // 写法1
        String fileName = PATH + "EasyExcel.xlsx";
        // 如果这里想使用2003版本则传入excelType参数即可
        EasyExcel.write(fileName, DemoData.class).sheet("模板").doWrite(data());

        // 写法2
        String fileName = PATH + "EasyExcel.xlsx";
        ExcelWriter excelWriter = null;
        try {
            excelWriter = EasyExcel.write(fileName, DemoData.class).build();
            WriteSheet writeSheet = EasyExcel.writerSheet("模板").build();
            excelWriter.write(data(), writeSheet);
        } finally {
            if (excelWriter != null) {
                excelWriter.finish();
            }
        }
    }

}
```

### Read

**监听器**

- `DemoDataListener.java`

```java
public class DemoDataListener extends AnalysisEventListener<DemoData> {

    // 每隔5条存储数据库，实际使用中可以3000条，然后清理list,方便内存回收
    private static final int BATCH_COUNT = 5;
    private List<DemoData> list = new ArrayList<DemoData>();
    private DemoDAO demoDAO;

    @Override
    public void invoke(DemoData data, AnalysisContext context) {
        list.add(data);
        // 达到BATCH_COUNT了，需要去存储一次数据库，防止数据几万条数据在内存，容易OOM
        if (list.size() >= BATCH_COUNT) {
            this.saveData();
            // 存储完成清理 list
            list.clear();
        }
    }

    /**
     * 所有数据解析完成了都会来调用
     */
    @Override
    public void doAfterAllAnalysed(AnalysisContext context) {
        // 这里也要保存数据，确保最后遗留的数据也存储到数据库
        saveData();
    }

    /**
     * 加上存储数据库
     */
    private void saveData() {
        demoDAO.save(list);
    }
}
```

**测试读取数据**

```java
public class Test {

    public void EasyExcelTest() {
        // 写法1:
        String fileName = PATH + "EasyExcel.xlsx";
        // 这里需要指定读用哪个class去读，然后读取第一个sheet 文件流会自动关闭
        EasyExcel.read(fileName, DemoData.class, new DemoDataListener()).sheet().doRead();

        // 写法2:
        String fileName = PATH + "EasyExcel.xlsx";
        ExcelReader excelReader = null;
        try {
            excelReader = EasyExcel.read(fileName, DemoData.class, new DemoDataListener()).build();
            ReadSheet readSheet = EasyExcel.readSheet(0).build();
            excelReader.read(readSheet);
        } finally {
            if (excelReader != null) {
                excelReader.finish();
            }
        }
    }

}
```
