public class SearchAccountPageController {
	public Account acc {get;set;}   
    public ApexPages.StandardSetController con{get; set;} 
    public SearchAccountPageController (){
       acc = new Account();
       lstAccount = new List<Account>();
    }
    public List<Account> lstAccount{  
        get{  
            if(con != null)  
                return (List<Account>)con.getRecords();  
            else  
                return null ;  
        }  
        set;
    }  
    public PageReference Search(){
         String mainFilter = '';
         String query = '';
        List<String> filterList = new List<String>(3);
        if (acc.Name != null && acc.Name.length() != 0) {
            filterList.add(0, ' Name like \'%' + acc.Name + '%\' ');
        }
        if (acc.Type != null && acc.Type.length() != 0) {
            filterList.add(1, ' Type like \'%' + acc.Type + '%\' ');
        }
        if (acc.Rating != null && acc.Rating.length() != 0) {
            filterList.add(2, ' Rating like \'%' + acc.Rating + '%\' ');
        }
        
        if (filterList.size() != 0) {
            if (filterList.get(0) != null && filterList.get(0).length() != 0) {
                mainFilter += filterList.get(0);
            }
            if (filterList.get(1) != null && filterList.get(1).length() != 0) {
                if (mainFilter.length() != 0) {
                mainFilter += ' and ' + filterList.get(1);
                } else {
                    mainFilter += filterList.get(1);
                }
            }
            if (filterList.get(2) != null && filterList.get(2).length() != 0) {
                if (mainFilter.length() != 0) {
                mainFilter += ' and ' + filterList.get(2);
                } else {
                    mainFilter += filterList.get(2);
                }
            }
            if (mainFilter.length() != 0) {
                mainFilter = 'where ' + mainFilter;
            }
        }
        query = 'Select name ,id, type, Rating from Account '+mainFilter+ ' limit 1000';
        con = new ApexPages.StandardSetController(Database.getQueryLocator(query)); 
            con.setPageSize(10);
       return null;
    }
    public Boolean hasNext{  
        get{  
            return con.getHasNext();  
        }  
        set;  
    }  
    public Boolean hasPrevious{  
        get{  
            return con.getHasPrevious();  
        }  
        set;  
    }  
    public Integer pageNumber{  
        get{  
            return con.getPageNumber();  
        }  
        set;  
    }
    public Integer pageSize{
        get{
            return con.getPageSize();
        }
        set;
    }
    public void previous(){  
        con.previous();  
    }  
    public void next(){  
        con.next();  
    }
}