<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="card" style="border:0;border-radius:14px;box-shadow:0 6px 24px rgba(0,0,0,.08);">
  <div class="card-header d-flex justify-content-between align-items-center" style="border:0;border-top-left-radius:14px;border-top-right-radius:14px;">
    <h3 class="m-0"><i class="fas fa-edit me-2"></i>Cập nhật sản phẩm</h3>
    <a class="btn btn-outline-light" href="${pageContext.request.contextPath}/product">Quay lại</a>
  </div>
  <div class="card-body">
    <c:if test="${not empty errorMessage}">
      <div class="alert alert-danger">${errorMessage}</div>
    </c:if>
    <form method="post" action="${pageContext.request.contextPath}/product?action=update">
      <div class="row g-3">
        <div class="col-md-4">
          <label class="form-label">Mã SP</label>
          <input name="medicineID" class="form-control" value="${medicine.medicineID}" readonly />
        </div>
        <div class="col-md-8">
          <label class="form-label">Tên sản phẩm</label>
          <input name="medicineName" class="form-control" value="${medicine.medicineName}" required />
        </div>
        <div class="col-md-4">
          <label class="form-label">Giá bán (đ)</label>
          <input name="sellingPrice" type="number" step="0.01" min="0" class="form-control" value="${medicine.sellingPrice}" />
        </div>
        <div class="col-md-4">
          <label class="form-label">Đơn vị</label>
          <input name="unit" class="form-control" value="${medicine.unit}" />
        </div>
        <div class="col-md-4">
          <label class="form-label">Tồn kho</label>
          <input name="remainingQuantity" type="number" min="0" class="form-control" value="${medicine.remainingQuantity}" />
        </div>
        <div class="col-md-6">
          <label class="form-label">Danh mục</label>
          <input name="categoryID" list="categoryList" class="form-control" value="${medicine.categoryID}" />
          <datalist id="categoryList">
            <c:forEach var="c" items="${categories}">
              <option value="${c.categoryID}">${c.categoryName}</option>
            </c:forEach>
          </datalist>
        </div>
        <div class="col-md-6">
          <label class="form-label">Ảnh (URL)</label>
          <input name="imageUrl" class="form-control" value="${medicine.imageUrl}" />
        </div>
        <div class="col-12">
          <label class="form-label">Quy cách đóng gói</label>
          <input name="packDescription" class="form-control" value="${medicine.packDescription}" />
        </div>
        <div class="col-12">
          <label class="form-label">Mô tả ngắn</label>
          <textarea name="shortDescription" rows="3" class="form-control">${medicine.shortDescription}</textarea>
        </div>
      </div>
      <div class="mt-3 d-flex gap-2">
        <button class="btn btn-primary" type="submit">Cập nhật</button>
        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/product">Hủy</a>
      </div>
    </form>
  </div>
</div>


