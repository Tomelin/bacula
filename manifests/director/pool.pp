class bacula::director::pool {


$rotas = [
        {
        id => '100',
        name => 'link1',
        },
        {
        id => '200',
        name => 'link2',
        }
        ]



template
<% rotas.each do |rota| -%>
<%= rota['id'] %> <%= rota['name'] %>
<% end -%>



}
