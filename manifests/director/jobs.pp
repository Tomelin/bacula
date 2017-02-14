template


<% pools.each do |pool| -%>

Pool {
  Name = <%= pool['name'] %>
  Pool Type = B<%= pool['poolType'] %>
  Recycle = <%= pool['recycle'] %>
  AutoPrune = <%= pool['autoPrune'] %>
  Volume Retention = <%= pool['volumeRetention'] %>
  Maximum Volume Bytes = <%= pool['maximumVolumeBytes'] %> 
  Maximum Volumes = <%= pool['maximumVolumes'] %>
  Label Format = <%= pool['labelFormat'] %>
}
<% end -%>
