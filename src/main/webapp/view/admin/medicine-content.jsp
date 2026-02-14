<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<link href="<c:url value='/assets/css/product.css'/>" rel="stylesheet">
<style>
  /* Page layout */
  .product-page-wrapper {
    margin: 0;
    padding: 0;
  }
  
  /* Blue theme header */
  :root { --blue-600:#2a60e8; --blue-500:#3b82f6; --blue-400:#60a5fa; }
  
  .product-header {
    background: linear-gradient(90deg, var(--blue-600), var(--blue-400));
    color: #fff;
    padding: 20px 30px;
    border-radius: 12px;
    margin-bottom: 20px;
    box-shadow: 0 4px 12px rgba(42, 96, 232, 0.15);
  }
  
  .product-header-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  
  .product-header h2 {
    margin: 0;
    font-size: 1.75rem;
    font-weight: 600;
  }
  
  .product-header-content .btn-add {
    background: #fff;
    color: #2a60e8;
    border: none;
    border-radius: 8px;
    padding: 10px 20px;
    font-weight: 600;
    transition: all 0.3s ease;
  }
  
  .product-header-content .btn-add:hover {
    background: #e0eaff;
    color: #1c4fd6;
    transform: translateY(-2px);
  }
  
  /* Statistics section */
  .stats-section {
    margin-bottom: 20px;
  }
  
  .stats-card {
    border: 1px solid rgba(42,96,232,0.12);
    box-shadow: 0 4px 18px rgba(42,96,232,0.08);
    background: #fff;
    border-radius: 12px;
    padding: 20px;
    text-align: center;
  }
  
  .stats-number {
    font-size: 2.5rem;
    font-weight: 700;
    color: #667eea;
  }
  
  .stats-label {
    color: #3556a8;
    font-size: 0.95rem;
    margin-top: 8px;
  }
  
  /* Product list centered */
  .product-list-wrapper {
    display: flex;
    justify-content: center;
    margin-bottom: 20px;
  }
  
  .product-list-card {
    width: 100%;
    max-width: 100%;
  }
  
  .card {
    border: none;
    border-radius: 12px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.08);
    overflow: hidden;
  }
  
  .card-body {
    padding: 0;
  }
  
  /* Table styles */
  .table thead th {
    background: linear-gradient(90deg, #eef3ff, #e6f0ff);
    color: #243b8a;
    border-bottom: none;
    font-weight: 600;
    padding: 15px;
  }
  
  .table tbody tr:hover {
    background-color: #f8f9fa;
  }
  
  .badge.badge-stock { background-color: #16a34a; }
  .badge.badge-low { background-color: #fbbf24; color: #0f172a; }
  .badge.badge-out { background-color: #ef4444; }
  
  .product-name { font-weight: 600; }
  td .text-muted {
    display: -webkit-box;
    -webkit-line-clamp: 2;
    line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
    max-width: 700px;
  }
  
  .btn-action.btn-edit {
    background-color: #ffc107 !important;
    color: #000 !important;
  }
  
  .btn-action.btn-edit:hover {
    background-color: #e0a800 !important;
  }
  
  .btn-action.btn-delete {
    background-color: #dc3545 !important;
    color: white !important;
  }
  
  .btn-action.btn-delete:hover {
    background-color: #c82333 !important;
  }
  
  .price {
    font-weight: 700;
    color: #28a745;
    font-size: 1.1rem;
  }
</style>

<div class="product-page-wrapper" style="margin-top: 20px;">
    <!-- Blue Header Section -->
    <div class="product-header">
        <div class="product-header-content">
            <h2><i class="fas fa-tags me-2"></i>Quản lý sản phẩm</h2>
            <button class="btn btn-add" onclick="location.href='${pageContext.request.contextPath}/product?action=add'">
                <i class="fas fa-plus me-2"></i>Thêm Sản Phẩm
            </button>
        </div>
    </div>
    
    <!-- Statistics Section -->
    <div class="stats-section">
        <div class="row">
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-number">${medicines.size()}</div>
                    <div class="stats-label">Tổng Sản Phẩm</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-number" style="color: #28a745;">
                        <c:set var="inStockCount" value="0" />
                        <c:forEach var="med" items="${medicines}">
                            <c:if test="${med.remainingQuantity > 0}">
                                <c:set var="inStockCount" value="${inStockCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${inStockCount}
                    </div>
                    <div class="stats-label">Còn Hàng</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-number" style="color: #dc3545;">
                        <c:set var="outStockCount" value="0" />
                        <c:forEach var="med" items="${medicines}">
                            <c:if test="${med.remainingQuantity <= 0}">
                                <c:set var="outStockCount" value="${outStockCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${outStockCount}
                    </div>
                    <div class="stats-label">Hết Hàng</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-number" style="color: #ffc107;">
                        <c:set var="lowStockCount" value="0" />
                        <c:forEach var="med" items="${medicines}">
                            <c:if test="${med.remainingQuantity > 0 && med.remainingQuantity < 20}">
                                <c:set var="lowStockCount" value="${lowStockCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${lowStockCount}
                    </div>
                    <div class="stats-label">Sắp Hết Hàng</div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Product List Centered -->
    <div class="product-list-wrapper">
        <div class="product-list-card">
            <div class="card">
                <div class="card-body p-0">
                    <div class="table-container">
                        <c:choose>
                            <c:when test="${empty medicines}">
                                <div class="empty-state">
                                    <i class="fas fa-inbox"></i>
                                    <h3>Chưa có sản phẩm nào</h3>
                                    <p>Hãy thêm sản phẩm đầu tiên của bạn</p>
                                    <button class="btn btn-add mt-3">
                                        <i class="fas fa-plus me-2"></i>Thêm Sản Phẩm
                                    </button>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <table class="table table-hover mb-0 align-middle">
                                    <thead>
                                        <tr>
                                            <th style="width:80px">Mã</th>
                                            <th style="width:70px">Ảnh</th>
                                            <th>Tên sản phẩm</th>
                                            <th style="width:120px">Giá</th>
                                            <th style="width:80px">Đơn vị</th>
                                            <th style="width:130px">Danh mục</th>
                                            <th style="width:95px">Tồn kho</th>
                                            <th style="width:110px">Trạng thái</th>
                                            <th style="width:150px">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="medicine" items="${medicines}">
                                            <tr>
                                                <td><strong>${medicine.medicineID}</strong></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty medicine.imageUrl}">
                                                            <c:set var="imageUrlTrimmed" value="${fn:trim(medicine.imageUrl)}"/>
                                                            <c:set var="imgSrc" value=""/>
                                                            
                                                            <%-- Debug: Hiển thị imageUrl để kiểm tra (có thể bỏ comment để debug) --%>
                                                            <%-- 
                                                            <small style="display:block;font-size:8px;color:red;">URL: ${imgSrc}</small>
                                                            --%>
                                                            
                                                            <c:choose>
                                                                <c:when test="${fn:startsWith(imageUrlTrimmed, 'http://') or fn:startsWith(imageUrlTrimmed, 'https://')}">
                                                                    <%-- imageUrl là URL đầy đủ --%>
                                                                    <c:set var="imgSrc" value="${imageUrlTrimmed}"/>
                                                                </c:when>
                                                                <c:when test="${fn:startsWith(imageUrlTrimmed, '/')}">
                                                                    <%-- imageUrl bắt đầu bằng /, cần thêm context path --%>
                                                                    <c:set var="imgSrc" value="${pageContext.request.contextPath}${imageUrlTrimmed}"/>
                                                                </c:when>
                                                                <c:when test="${fn:contains(imageUrlTrimmed, 'assets/img')}">
                                                                    <%-- imageUrl chứa assets/img nhưng chưa có context path --%>
                                                                    <c:choose>
                                                                        <c:when test="${fn:startsWith(imageUrlTrimmed, 'assets/img')}">
                                                                            <c:set var="imgSrc" value="${pageContext.request.contextPath}/${imageUrlTrimmed}"/>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <c:set var="imgSrc" value="${pageContext.request.contextPath}/${imageUrlTrimmed}"/>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <%-- imageUrl chỉ là tên file hoặc đường dẫn tương đối, cần thêm đường dẫn --%>
                                                                    <c:set var="imgSrc" value="${pageContext.request.contextPath}/assets/img/${imageUrlTrimmed}"/>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            
                                                            <img src="<c:out value='${imgSrc}'/>" 
                                                                 alt="<c:out value='${medicine.medicineName}'/>" 
                                                                 style="width:48px;height:48px;object-fit:cover;border-radius:6px;background:#f0f0f0;"
                                                                 onerror="console.error('Image load error:', this.src); this.onerror=null; var parent=this.parentElement; var div=document.createElement('div'); div.style.cssText='width:48px;height:48px;border-radius:6px;background:#eef2ff;display:flex;align-items:center;justify-content:center;color:#64748b;font-size:10px;'; div.textContent='N/A'; parent.innerHTML=''; parent.appendChild(div);"
                                                                 onload="this.style.background='transparent'; console.log('Image loaded:', this.src);"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div style="width:48px;height:48px;border-radius:6px;background:#eef2ff;display:flex;align-items:center;justify-content:center;color:#64748b;font-size:10px;">N/A</div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="product-name">${medicine.medicineName}</div>
                                                    <small class="text-muted">${medicine.packDescription}</small>
                                                </td>
                                                <td>
                                                    <span class="price">
                                                        <c:if test="${medicine.sellingPrice != null}">
                                                            <fmt:formatNumber value="${medicine.sellingPrice}" type="number" groupingUsed="true" />₫
                                                        </c:if>
                                                        <c:if test="${medicine.sellingPrice == null}">N/A</c:if>
                                                    </span>
                                                </td>
                                                <td>${medicine.unit}</td>
                                                <td>${medicine.categoryID}</td>
                                                <td>
                                                    <strong>${medicine.remainingQuantity}</strong>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${medicine.remainingQuantity > 20}">
                                                            <span class="badge badge-stock">Còn Hàng</span>
                                                        </c:when>
                                                        <c:when test="${medicine.remainingQuantity > 0}">
                                                            <span class="badge badge-low">Sắp Hết</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-out">Hết Hàng</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <button class="btn btn-action btn-edit" onclick="editProduct('${medicine.medicineID}')">
                                                        <i class="fas fa-edit"></i> Sửa
                                                    </button>
                                                    <button class="btn btn-action btn-delete" onclick="confirmDelete('${medicine.medicineID}', '${medicine.medicineName}')">
                                                        <i class="fas fa-trash"></i> Xóa
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function confirmDelete(id, name) {
        if (confirm('Bạn có chắc chắn muốn xóa sản phẩm "' + name + '"?')) {
            window.location.href = 'product?action=delete&id=' + id;
        }
    }
    function editProduct(id) {
        window.location.href = '${pageContext.request.contextPath}/product?action=edit&id=' + encodeURIComponent(id);
    }
</script>


