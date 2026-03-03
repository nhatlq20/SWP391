<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Thêm danh mục</title>
    <!-- Đồng bộ Bootstrap và FontAwesome với trang list -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/medicine-dashboard.css">
</head>
<body class="bg-light">
    <jsp:include page="/view/common/header.jsp" />
    <jsp:include page="/view/common/sidebar.jsp" />

    <div class="main-content">
        <h2 class="page-title"> <i class="fas fa-plus text-primary"></i>Thêm danh mục</h2>

        <div class="form-card" style="max-width: 1500px; margin: 0 auto; width: 100%; padding: 32px 36px; box-shadow: 0 2px 16px rgba(59,130,246,0.08); border-radius: 16px; background: #fff;">
            <!-- Hiển thị thông báo lỗi nếu có -->
     
            <form action="${pageContext.request.contextPath}/category" method="post">
                <input type="hidden" name="action" value="insert" />

                <div class="mb-4">
                    <label class="form-label" for="categoryCode">Mã mục</label>
                    <input type="text" id="categoryCode" name="categoryCode" class="form-control form-control-lg"
                        value="${nextCategoryCode}" readonly />
                </div>

                <div class="mb-4">
                    <label class="form-label" for="categoryName">Tên danh mục</label>
                    <input type="text" id="categoryName" name="categoryName" class="form-control form-control-lg"
                        placeholder="Nhập tên danh mục" required />
                </div>

                <div class="btn-row">
                    <button type="submit" class="btn btn-primary btn-pill"><i
                            class="fas fa-plus me-1"></i>Thêm</button>
                    <a href="${pageContext.request.contextPath}/category?action=list"
                        class="btn btn-secondary btn-pill">Hủy</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>