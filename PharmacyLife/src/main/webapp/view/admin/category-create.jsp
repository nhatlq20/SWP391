<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Thêm danh mục</title>
    <!-- Sử dụng Bootstrap, FontAwesome và CSS dashboard đồng bộ -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/category-create.css">
</head>
<body class="bg-light">
    <jsp:include page="/view/common/header.jsp" />
    <jsp:include page="/view/common/sidebar.jsp" />

    <div class="main-content" style="background: #f5f6fa; min-height: 80vh;">
        <h2 class="page-title"> <i class="fas fa-plus text-primary"></i>Thêm danh mục</h2>
        <div class="form-card shadow-lg p-4 bg-white rounded-4" style="max-width: 1200px; width: 100%;">
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

                <div class="d-flex gap-3">
                    <button type="submit" class="btn btn-primary btn-lg px-4"><i
                            class="fas fa-plus me-1"></i>Thêm</button>
                    <a href="${pageContext.request.contextPath}/category?action=list"
                        class="btn btn-secondary btn-lg px-4">Hủy</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>